#!/usr/bin/env bash

# name of this project
project="name"
modules="m1 m2"

# -- do not change --

# for each module
for m in ${modules} ; do
  echo creating module ${m}
  mkdir -p modules/${m}
  pushd modules/${m}
  touch variables.tf main.tf
  
  # create a null resource in the module
  tee main.tf <<EOF
# null resource ${m}
resource null_resource "${m}" {
}
EOF
  terraform fmt
  popd
  touch ${m}.tf

  # call the module
  tee ${m}.tf <<EOF
module "${m}" {
  source = "./modules/${m}/"
}
EOF
done

touch provider.tf main.tf variables.tf terraform.tfvars
mkdir -p example
pushd example
touch provider.tf main.tf variables.tf terraform.tfvars
tee main.tf <<EOF
module "${project}" {
  source = "../"
}
EOF
terraform fmt

# testing
touch .kitchen.yml Gemfile README.md
tee README.md <<EOF
#
## how to test
- install bundle
- install kitchen-test
\`\`\`
bundle install --path vendor/bundle
\`\`\`
- test
\`\`\`
bundle exec kitchen converge
bundle exec kitchen verify
bundle exec kitchen destroy
\`\`\`
EOF

tee Gemfile <<EOF
source "https://rubygems.org/" do
  gem "kitchen-terraform", "~> 4.0"
end
EOF

tee .kitchen.yml <<EOF
---
driver:
  name: terraform
  parallelism: 1

provisioner:
  name: terraform

verifier:
  name: terraform
  systems:
    - name: basic
      backend: local

platforms:
  - name: terraform

suites:
  - name: default
EOF

mkdir -p test/integration/default
tee test/integration/default/check_state.rb <<EOF
describe command('terraform state list') do
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end
EOF
popd


tree -a
