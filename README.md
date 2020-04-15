# structure-tf-modules
sample shell script to create tf code structure - modules and test

## What this does

this script will create an structure for code with modules and test.

sample structure:

```
.
├── example
│   └── test
│       └── integration
│           └── default
└── modules
    ├── m1
    │   └── example
    │       └── test
    │           └── integration
    │               └── default
    └── m2
        └── example
            └── test
                └── integration
                    └── default
```

## How to use

- edit `structure.sh` and update the variables on top
- project, is the name of the project, ie `ecommerce`
- modules, are the list of modules you want to include, ie `s3 db r53 vpc`
- files, the list of files each project should have, ie `provider.tf main.tf variables.tf terraform.tfvars`

```
#!/usr/bin/env bash

# name of this project
project="ecommerce"
modules="s3 db r53 vpc"
files="provider.tf main.tf variables.tf terraform.tfvars"
```

- run `./structure.sh`

- review the structure 

```
.
├── example
│   └── test
│       └── integration
│           └── default
└── modules
    ├── db
    │   └── example
    │       └── test
    │           └── integration
    │               └── default
    ├── r53
    │   └── example
    │       └── test
    │           └── integration
    │               └── default
    ├── s3
    │   └── example
    │       └── test
    │           └── integration
    │               └── default
    └── vpc
        └── example
            └── test
                └── integration
                    └── default
```
