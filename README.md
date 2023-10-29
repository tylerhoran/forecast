# Project

[forecast-apple-tyler.herokuapp.com](https://forecast-apple-tyler.herokuapp.com)

## Install

### Clone the repository

```shell
git clone git@github.com:tylerhoran/forecast.git
cd forecast
```

### Check your Ruby version

```shell
ruby -v
```

The ouput should start with something like `ruby 3.2.2`

If not, install the right ruby version using [rbenv](https://github.com/rbenv/rbenv) (it could take a while):

```shell
rbenv install 3.2.2
```

### Install dependencies

Using [Bundler](https://github.com/bundler/bundler)

```shell
bundle
```

### Set environment variables

Using [Dotenv](https://github.com/bkeepers/dotenv)

Copy `.sample.env` to `.env` and fill in the api key.

### Initialize the database

```shell
rails db:create db:migrate
```

## Serve

```shell
rails s
```

## Deploy

Push to Heroku remote:

```shell
git push heroku main
```

## Test

```shell
rails test
```
