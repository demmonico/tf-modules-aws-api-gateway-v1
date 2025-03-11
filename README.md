[![License](https://img.shields.io/github/license/demmonico/terraform-app-template)](LICENSE)
[![Tests](https://github.com/demmonico/terraform-app-template/actions/workflows/tests.yml/badge.svg)](https://github.com/demmonico/terraform-app-template/actions/workflows/tests.yml)
![GitHub Tag](https://img.shields.io/github/v/tag/demmonico/terraform-app-template)

# Terraform Modules Template

Bootstraps a new Terraform module repo.

## Usage

TODO add examples here

## Development

Steps:
- fork this repo (see [clone the repo](#clone-the-repo))
- replace README.md file with our own, tune other files if needed
- run `make init` to initialize the repo and hooks (see [Initialize the repo](#initialize-the-repo) section)

### Clone the repo

#### for Anyone

- fork this repo
- replace README.md file with our own
- put new repo URL in badges
- start coding

#### for Me

- clone repo to a new local and set upstream (as I cannot just fork my own repo in Github :/)
  ```shell
    # just run Make command
    make git-clone-tf-module
    
    # or do it manually
    NEW_REPO_NAME=REPLACE_WITH_YOUR_REPO_NAME_WITHOUT_GIT_EXTENSION && \
    git clone git@github.com:demmonico/terraform-app-template.git $NEW_REPO_NAME && \
    cd $NEW_REPO_NAME && \
    git remote set-url origin git@github.com:demmonico/$NEW_REPO_NAME.git && \
    git remote add upstream git@github.com:demmonico/terraform-app-template.git && \
    git push -u origin master && git push --all
    
    # so later you can be synced with the original repo
    git fetch upstream && \
    git merge upstream/master
  ```
  More details [here](https://stackoverflow.com/a/10966784/8148333)
- replace README.md file with our own
- put new repo URL in badges
- start coding

### Initialize the repo

```shell
make init
```


### Run tests

It triggers git pre-commit hooks

```shell
make test
```


# Auto-generated specs

You have to add following block to your README.md file to generate specs
```md
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
```
