dry-run:
	helm install my ./ --dry-run --debug

install:
	helm install my ./

uninstall:
	helm uninstall my

test: test_success test_fail

test_success:
	@echo "Creating an example pod that waits to be scheduled. After applying scheduler pod should start."
	@kubectl apply -f example/example_pod.yaml
	@sleep 15
	@helm install test-scheduler ./
	@sleep 15

	@RESULT=`kubectl get pods | grep example-scheduled-pod`; \
	if [[ $$RESULT == *"1/1"* ]]; then \
		echo "RESULT: Test succeeded! Scheduler works."; \
	else \
		echo "RESULT: Test failed! Scheduler does not work."; \
	fi
	@kubectl delete -f example/example_pod.yaml
	@helm uninstall test-scheduler
	@echo "done\n\n"

test_fail:
	@echo "Creating an example pod that waits to be scheduled but cannot because of mistyped scheduler name. After applying scheduler pod should not(!) start."
	@kubectl apply -f example/example_pod_fail.yaml
	@sleep 15
	@helm install test-scheduler ./
	@sleep 15

	@RESULT=`kubectl get pods | grep example-scheduled-pod`; \
	if [[ $$RESULT == *"1/1"* ]]; then \
		echo "RESULT: Test failed! Scheduler should not have worked."; \
	else \
		echo "RESULT: Test succeeded! Scheduler did not apply to the mistyped example pod"; \
	fi
	@kubectl delete -f example/example_pod_fail.yaml
	@helm uninstall test-scheduler
	@echo "done\n\n"