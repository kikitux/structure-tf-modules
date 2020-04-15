#!/usr/bin/env bash

# name of this project
project="name"
modules="m1 m2"
files="provider.tf main.tf variables.tf terraform.tfvars"

# -- do not change --

function add_example_readme_test(){
mkdir -p example
pushd example
touch ${files}
tee main.tf <<EOF
module "${1}" {
  source = "../"
}
EOF

# testing
touch .kitchen.yml Gemfile README.md
tee README.md <<EOF
#
## how to test
- install bundle
- install kitchen-test
\`\`\`
# local path
bundle install --path vendor/bundle

# global path
bundle install
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
}

# for each module
for m in ${modules} ; do
  echo creating module ${m}
  mkdir -p modules/${m}
  pushd modules/${m}
  touch ${files}
  add_example_readme_test ${m}
  
  # create a null resource in the module
  tee main.tf <<EOF
# null resource ${m}
resource null_resource "${m}" {
}
EOF

  popd
  touch ${m}.tf

  # call the module
  tee ${m}.tf <<EOF
module "${m}" {
  source = "./modules/${m}/"
}
EOF
done

touch ${files}


add_example_readme_test ${project}

tree -a
