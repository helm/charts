/*
Copyright 2017 The Kubernetes Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package main

import (
	"encoding/xml"
	"fmt"
	"log"
	"math/rand"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"syscall"
	"time"
)

type testCase struct {
	XMLName   xml.Name `xml:"testcase"`
	ClassName string   `xml:"classname,attr"`
	Name      string   `xml:"name,attr"`
	Time      float64  `xml:"time,attr"`
	Failure   string   `xml:"failure,omitempty"`
}

type TestSuite struct {
	XMLName  xml.Name `xml:"testsuite"`
	Failures int      `xml:"failures,attr"`
	Tests    int      `xml:"tests,attr"`
	Time     float64  `xml:"time,attr"`
	Cases    []testCase
}

// append(errs, err) if err != nil
func appendError(errs []error, err error) []error {
	if err != nil {
		return append(errs, err)
	}
	return errs
}

func writeXML(dump string, start time.Time) {
	suite.Time = time.Since(start).Seconds()
	out, err := xml.MarshalIndent(&suite, "", "    ")
	if err != nil {
		log.Fatalf("Could not marshal XML: %s", err)
	}
	path := filepath.Join(dump, "junit_runner.xml")
	f, err := os.Create(path)
	if err != nil {
		log.Fatalf("Could not create file: %s", err)
	}
	defer f.Close()
	if _, err := f.WriteString(xml.Header); err != nil {
		log.Fatalf("Error writing XML header: %s", err)
	}
	if _, err := f.Write(out); err != nil {
		log.Fatalf("Error writing XML data: %s", err)
	}
	log.Printf("Saved XML output to %s.", path)
}

// return f(), adding junit xml testcase result for name
func xmlWrap(name string, f func() error) error {
	start := time.Now()
	err := f()
	duration := time.Since(start)
	c := testCase{
		Name:      name,
		ClassName: "e2e.go",
		Time:      duration.Seconds(),
	}
	if err != nil {
		c.Failure = err.Error()
		suite.Failures++
	}
	suite.Cases = append(suite.Cases, c)
	suite.Tests++
	return err
}

var (
	interruptTimeout = time.Duration(10 * time.Minute)
	terminateTimeout = time.Duration(5 * time.Minute) // terminate 5 minutes after SIGINT is sent.

	interrupt = time.NewTimer(interruptTimeout) // interrupt testing at this time.
	terminate = time.NewTimer(time.Duration(0)) // terminate testing at this time.

	suite TestSuite
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

var letterRunes = []rune("abcdefghijklmnopqrstuvwxyz")

// return cmd.Output(), potentially timing out in the process.
func output(cmd *exec.Cmd) ([]byte, error) {
	interrupt.Reset(interruptTimeout)
	stepName := strings.Join(cmd.Args, " ")
	cmd.Stderr = os.Stderr

	log.Printf("Running: %v", stepName)
	defer func(start time.Time) {
		log.Printf("Step '%s' finished in %s", stepName, time.Since(start))
	}(time.Now())

	cmd.SysProcAttr = &syscall.SysProcAttr{Setpgid: true}
	type result struct {
		bytes []byte
		err   error
	}
	finished := make(chan result)
	go func() {
		b, err := cmd.Output()
		finished <- result{b, err}
	}()
	for {
		select {
		case <-terminate.C:
			terminate.Reset(time.Duration(0)) // Kill subsequent processes immediately.
			syscall.Kill(-cmd.Process.Pid, syscall.SIGKILL)
			cmd.Process.Kill()
			return nil, fmt.Errorf("Terminate testing after 15m after %s timeout during %s", interruptTimeout, stepName)
		case <-interrupt.C:
			log.Printf("Interrupt testing after %s timeout. Will terminate in another %s", interruptTimeout, terminateTimeout)
			terminate.Reset(terminateTimeout)
			if err := syscall.Kill(-cmd.Process.Pid, syscall.SIGINT); err != nil {
				log.Printf("Failed to interrupt %v. Will terminate immediately: %v", stepName, err)
				syscall.Kill(-cmd.Process.Pid, syscall.SIGTERM)
				cmd.Process.Kill()
			}
		case fin := <-finished:
			return fin.bytes, fin.err
		}
	}
}

func randStringRunes(n int) string {
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

func main() {
	matches, err := filepath.Glob("stable/*")
	defer writeXML("/workspace/_artifacts", time.Now())
	if !terminate.Stop() {
		<-terminate.C // Drain the value if necessary.
	}

	if !interrupt.Stop() {
		<-interrupt.C // Drain value
	}

	if err != nil {
		fmt.Println(err)
		return
	}

	for _, dir := range matches {
		ns := randStringRunes(10)
		rel := randStringRunes(3)

		xmlWrap(fmt.Sprintf("lint %s", dir), func() error {
			_, execErr := output(exec.Command("linux-amd64/helm", "lint", dir))
			return execErr
		})

		xmlWrap(fmt.Sprintf("install %s", dir), func() error {
			o, execErr := output(exec.Command("linux-amd64/helm", "install", dir, "--namespace", ns, "--name", rel, "--wait"))
			if execErr != nil {
				return fmt.Errorf("%s Command output: %s", execErr, string(o[:]))
			}
			return nil
		})

		xmlWrap(fmt.Sprintf("test %s", dir), func() error {
			o, execErr := output(exec.Command("linux-amd64/helm", "test", rel))
			if execErr != nil {
				return fmt.Errorf("%s Command output: %s", execErr, string(o[:]))
			}
			return nil
		})

		xmlWrap(fmt.Sprintf("purge %s", dir), func() error {
			o, execErr := output(exec.Command("linux-amd64/helm", "delete", rel, "--purge"))
			if execErr != nil {
				return fmt.Errorf("%s Command output: %s", execErr, string(o[:]))
			}
			return nil
		})
	}
}
