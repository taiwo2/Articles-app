#!/usr/bin/env bash
# exit on error
set -0 errexit 

bundle install
bundle exc rake assets:precompile
bundle exc rake assets:clean
bundle exc rake assets:migrate