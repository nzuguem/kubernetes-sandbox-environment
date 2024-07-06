#!/bin/bash

set -ex

task pre-commit-install

task cluster-kind-deploy

task platform-install