# Helm Chart Repository

This repository contains Charts for Helm, the Kubernetes Package Manager.
Visit the [Helm repository](https://github.com/deis/helm) to learn more.

[![Build Status](https://travis-ci.org/deis/charts.svg?branch=master)](https://travis-ci.org/deis/charts)

## Work in Progress

![Deis Graphic](https://s3-us-west-2.amazonaws.com/get-deis/deis-graphic-small.png)

`helm` is changing quickly. Your feedback and participation are more than welcome, but be aware that this project is considered a work in progress.

## Contributing

Helm charts are developed as part of a community effort.  To contribute:

1. Fork this repository
2. `helm create foo && helm edit foo`
3. `cd ~/.helm/cache && git checkout -b foo`
4. `git add foo && git commit && git push`
5. Submit a Pull Request

## License

Copyright 2015 Engine Yard, Inc.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at <http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
