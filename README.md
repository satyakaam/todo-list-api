# TODO list API

## Install

### Clone the repository

```shell
git clone git@github.com:satyakaam/todo-list-api.git
cd todo-list-api
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 2.6.3`

If not, install the right ruby version using [rvm](https://rvm.io/) (it could take a while):

```shell
rvm install 2.6.3
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler):

```shell
bundle
```

### Initialize the database

```shell
rails db:create db:migrate db:seed
```

### Run test cases

```shell
bundle exec rspec
```

## Server

```shell
rails s
```
