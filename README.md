# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
# Article Search

A Ruby on Rails application for searching articles and indexing and providing statistics of these searches and theirs results.

The app aims performance and organization, so the searches are asynchronously indexed in background.

## Features

- Article CRUD.
- Article search by title.
- Background statistics generation with cron jobs.
  - Statistics generation algorithm is improved to filter only the real (final) searche

## Relevant Technologies

- **Ruby 2.7.6**
- **Ruby on Rails 7**
- **PostgreSQL**: Because we are going to deploy on Heroku.
- **Sidekiq**: Used to asynchronously run search indexing as background tasks.
- **sidekiq-scheduler**: Used to schedule background tasks runs every minute (this interval can be changed).
- **Redis**: All the searches made by users are stored in Redis, so it is used as a queue of search terms to be posteriorly processed at a background task.
- **Other**: Webpacker, Bootstrap, FontAwesome, simple_form, faker, axios and Underscore.js.

## Installing and running

Clone the project:

```bash
git clone https://github.com/taiwo2/Articles-app.git
cd article-search
```

Update frontend dependencies with Yarn:

```bash
# You will need Yarn pre-installed
yarn install
```

Uptade the gems:

```bash
bundle install
```

Run migrations (PostgreSQL):

```bash
# Your PostgreSQL database must exist
rails db:migrate
```

This app is made with Ruby on Rails 6 that uses webpacker and Yarn for frontend dependency management. So you can keep `webpack-dev-server` alive:

```bash
bin/webpack-dev-server
```

And the app also uses Sidekiq for running background tasks. So you need to keep it alive too:

```bash
bundle exec sidekiq
```

Run the development web server:

```bash
rails server -b 0.0.0.0 -p 3000
```


## Search indexing logic

Every search that hits the server is stored on a queue for processing. It does not matter if it is a complete or a parcial search.

So, imagine user typing:

```
1. Ho
2. How do
3. How do I canc
```

At first, all these five terms are stored for the user's IP address.

But we only want keep final search terms. If we consider the example above, it would be: *How do I cancel my subscription*.

Every minute (it can be less frequent if necessary) a background cron job consumes the search queue and tries to extract the best search terms, aiming at only get final search terms. Its result is stores in DB for future visualization.