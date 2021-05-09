<img src="/client/public/logo2.png" width="400px">

**Paint Stand 🎨 is an e-commerce platform that lets users create and sell virtual paintings.**

The following project is my <a href="https://docs.google.com/document/d/1ZKRywXQLZWOqVOHC4JkF3LqdpO3Llpfk_CkZPR8bjak/edit">Shopify Fall 2021 Backend Developer Challenge Submission.</a>

<hr>

![CI](https://github.com/MathyouMB/Shopistrate/workflows/Tests/badge.svg) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/MathyouMB/Shopistrate/blob/master/LICENSE) [![Made With Love](https://img.shields.io/badge/Made%20With-Love-orange.svg)](https://github.com/MathyouMB/Shopistrate)

<hr>

<img src="/documentation/screen_home.png" width="800px">

<img src="/documentation/screen_draw.png" width="800px">

<img src="/documentation/screen_purchase.png" width="800px">

## 📋 Table of Contents
- [Features](#-features)
- [Setup](#%EF%B8%8F-setup)
  - [Dependencies](#%EF%B8%8F-setup)
  - [Docker](#-docker-setup)
  - [API](#api-setup)
- [Schema](#schema)
- [API](#%EF%B8%8F-api)
  - [Design](#api-design)
  - [Queries](#queries)
  - [Mutations](#mutations)
  - [Pagination](#pagination)
- [Cache](#cache)
- [Payments](#-payments)
- [Security](#-security)
- [Linting](#-linting)
- [Documentation](#%EF%B8%8F-documentation)
- [Testing](#-testing)
- [Continuous Integration](#continuous-integration)
- [License](#license)

## 💻 Features

For my solution to the Developer Intern Challenge, I have created Shopistrate, a theoretical platform where users can create and sell illustrations. User's can purchase, collect, and re-sell the art of other users for higher prices to climb a global wealth leaderboard.

The following is a list of features the platform supports:

* Users can signup or login using their desired email and password
* Users can upload, update, sell, and delete images
* Users can set and update an image's price
* Users cannot update or delete images they did not upload
* Users can search for images to purchase
* Users can purchase images
* Users can set private viewing permissions on their images
* Users can add tags to their images to improve their search visibility

## 🛠️ Setup

<img src="/documentation/setup_logos.png" width="400px">

To set up and configure this application, you can either install the various dependencies as described below or use the provided dockerfile and `docker-compose.yml`. If you plan to use the Docker, skip to [Docker Setup](#-docker-setup).

This project was built using Ruby on Rails and will require you to have <a href="https://www.ruby-lang.org/en/news/2019/04/17/ruby-2-6-3-released/">Ruby 2.6.3</a> and <a href="https://weblog.rubyonrails.org/2020/6/17/Rails-6-0-3-2-has-been-released/">Ruby on Rails 6.0.3.2</a>. Additionally you will need PostgreSQL and Redis installed.

Once you have installed the aforementioned technologies, clone this repo and modify `config/database.yml` to match your local PostgreSQL credentials.
```ruby
development:
  <<: *default
  database: image_repository_development
  username: YOUR_USERNAME
  password: YOUR_PASSWORD

test:
  <<: *default
  database: image_repository_test
  username: YOUR_USERNAME
  password: YOUR_PASSWORD
```

You will may also need to modify `config/environments/development.rb` and `config/environments/test.rb` to configure redis.

```ruby
  config.cache_store = :redis_store_with_cas, {
    host: 'redis', # Should be 'localhost' if not using docker-compose setup
    port: 6379,
    db: 0,
    namespace: 'cache',
    expires_in: 15.minutes,
    race_condition_ttl: 1
  }
```

After you've properly configured PostgreSQL and Redis run the following commands:
- run `bundle` to install all ruby gems related to the project
- run `rake db:migrate` and `rake db:seed` to migrate the database and seed it with data
- run `rails s` or `rails server`
- View `localhost:3000` and you should see


<img src="/documentation/rails_success.png">

## 🐳 Docker Setup

<img src="/documentation/docker_logo.png" width="200px">

If you would like to run this app using docker, you will need to verify that the database host name, username, and password in `config/database.yml` match the information found in `docker-compose.yml` 'db' container and that the `redis_store` information in `config/environments/development.rb` matches the information in the 'redis' container.

The host name in `config/database.yml` should match the name of the postgres container ('db') and the host name of the redis_store should match the name of the redis container ('redis').

```ruby
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  #host: db #uncomment this if using docker-compose

development:
  <<: *default
  database: image_repository_development
  username: YOUR_USERNAME
  password: YOUR_PASSWORD
```

```ruby
db:
    image: postgres:12-alpine
    environment:
        POSTGRES_USER: YOUR_USERNAME
        POSTGRES_PASSWORD: YOUR_PASSWORD
    networks:
        - imagerepo
```

Once you've verified all the connections with postgres and redis should be properly configured, run:

```bash
docker-compose up
```

## API Setup

<img src="/documentation/altair_logo.png" width="200px">

For using this API, I strongly recommend <a href="https://altair.sirmuel.design/">Altair GraphQL Client</a>. Altair is capable of seamlessly using files as GraphQL parameters and can dynamically generate the body of your GraphQL requests.

The GraphQL API can be utilized using POST `http://localhost:3000/graphql`.

Many of the GraphQL operations will require you to be logged in and submit a valid JWT Token via the `Authentication` header. You can retrieve your JWT Token using the `login` mutation.

You can log in using the credentials:
* **Email**: tester@email.com
* **Password**: tester

<img src="/documentation/screen_login.png" width="600px">

Add the `Authentication` Header:

<img src="/documentation/screen_auth.png" width="600px">

If you do not have a valid JWT token in the Authentication header on specific operations, you will receive this error:

<img src="/documentation/screen_fail.png" width="600px">

## Schema

<img src="/documentation/schema.png" width="800px">

**NOTE:** To store images, I utilized Rails Active Storage. Active Storage uses polymorphic associations. These are represented above using dotted lines.

* **User**: Represents someone who Interacts with the API
  * Relations
    * **Has Many**: Created_Images (Images the user drew)
    * **Has Many**: Owned_Images (Images the user drew or purchased)
    * **Has Many**: Purchases
    * **Has Many**: Sales (Purchase records where the user was the merchant)
  * Attributes
    * **balance (integer)**: Represents the user's currency balance
    * **email (string)**: Represents the user's email
    * **role (string)**: Represents the user's role (admin etc.)
    * **username (string)**: Represents the user's username
    * **password_digest (string)**: Represents the hashed version of the user's password

* **Image**: Represents an uploaded and purchasable image
  * Relations
    * **Belongs To**: Creator (the user who drew this image)
    * **Belongs To**: Owner (the user who currently owns this image)
    * **Has Many**: Tags (Through ImageTags Join)
    * **Belongs To**: Purchases
    * **Has One**: Active Storage Attachment (Image File)
  * Attributes
    * **description (text)**: Represents the image's description.
    * **price (integer)**: Represents how much it costs for a user to purchase
    * **state (string)**: Represents whether the image is viewable by all users or only its creator
    * **title (string)**: Represents the image's title

* **ImageTag**: Join between mage and Tag for associating specific images with a tags that represent their characteristics
  * Relations
    * **Belongs To**: Image
    * **Belongs To**: Tag

* **Tag**: Represents a characteristic of another entity.
  * Relations
    * **Has Many**: ImageTags
    * **Has Many**: Images (Through ImageTags Join)
  * Attributes
    * **name (string)**: Represents the characteristic of a given tag

* **Purchase**: Represents an Image's purchase or sale
  * Relations
    * **Belongs To**: Customer (The User who bought this Image)
    * **Belongs To**: Merchant (The User who sold this Image)
    * **Belongs To**: Image
  * Attributes
    * **cost (integer)**: Represents the cost of the transaction

## ☁️ API

<img src="/documentation/graphql_logo.png" width="200px">

The Shopistrate API is built using GraphQL.

### API Design

In designing this GraphQL API, I choose to follow the <a href="https://github.com/Shopify/graphql-design-tutorial/blob/master/TUTORIAL.md">guidelines</a> created by the Shopify API Patterns Team (<a href="https://youtu.be/2It9NofBWYg">Described in this 2018 GraphQL Conference talk by Leane Shapton</a>).

One of the Shopify API Patterns team's GraphQL guidelines is to <a href="https://youtu.be/2It9NofBWYg?t=329">Not expose implementation detail in your API design</a>. To follow this guideline, I abstracted out the ImageTags join table from Shopistrate's domain model.

Additionally, to improve the performance of my API and remove multiple unnecessary round trips to datastores from nested GraphQL queries (<a href="https://engineering.shopify.com/blogs/engineering/solving-the-n-1-problem-for-graphql-through-batching/">the N+1 query problem</a>), I have defined batch loaders using Shopify's <a href="https://github.com/Shopify/graphql-batch">GraphQL-Batch gem</a>.

<img src="/documentation/erd.png" width="800px">


### Queries

**image:**<br>
A query that returns the information of a specified image.

**imageSearch:**<br>
A query that returns the results of a text-based search for related images.

**imagesListed:**<br>
A query that returns all publicly purchasable images.

**profile:**<br>
A query that returns the profile of the currently logged in user.

**purchase:**<br>
A query that returns the information of a specified purchase.

**user:**<br>
A query that returns the profile of the specified user.

**users:**<br>
A query that returns many users.


### Mutations
**addImageTag:**<br>
A mutation that adds a Tag to a given Image using the provided tag name.

**createImage:** (upload image)<br>
A mutation that creates an Image Entity using the provided information.

**createPurchase:** (purchase image)<br>
A mutation that creates a Purchase entity for the image given with the provided id for the currently logged in user

**deleteImage:**<br>
A mutation that deletes the Image with the provided id.

**login:**<br>
A mutation that logs in the user of the provided email and returns a JWT Token.

**signUp:**<br>
A mutation that creates a new user using the provided information.

**updateImage**<br>
A mutation that updates the image of the provided id

**updateUser**<br>
A mutation that updates the current user using the provided information


### Pagination

Queries that return multiple records have been given pagination using the <a href="https://github.com/RenoFi/graphql-pagination">GraphQL Pagination gem</a>.

```ruby
query imageListed($page: Int!, $limit: Int!){
    imageListed(page: $page, limit: $limit){
        collection{
            attachedImageUrl
            description
            id
            price
            title
        }
        metadata{
            currentPage
            limitValue
            totalCount
            totalPages
        }
    }
}
```

## Cache

<img src="/documentation/redis.png" width="200px">

For caching, I utilized Redis using the "cache-aside" caching strategy. I also utilized <a href="https://github.com/Shopify/identity_cache">Shopify's IdentityCache gem</a> to cache models and their relationships.

## 💰 Payments

All currency in this application is stored as an integer. This is because it is much safer to use integers than deal with the added complexity of floating point numbers.

Additionally all transactions in this application are surrounded in Active Record Transaction blocks to ensure if an error occurs during the transaction, any edited records are rolled back to before the transaction began.

```ruby
 ActiveRecord::Base.transaction do
  ::Purchase.create!(
    cost: image.price,
    customer_id: user.id,
    merchant_id: image.owner.id,
    image_id: image.id
  )

  ...
end
```

## 🔐 Security

All available GraphQL operations have error handling to prevent any internal errors from being exposed to users.

To verify a user's identity, the API uses JWT tokens. A user can receive their JWT Token by using the `login` mutation.

Additionally, all user passwords are hashed using Bcrypt.


## 🧹 Linting

<img src="/documentation/rubocop_logo.png" width="200px">

For this project, I utilized RuboCop to enforce many guidelines outlined in the community <a href="https://rubystyle.guide/">Ruby Style Guide</a>. Additionally, I utilized the Shopify RuboCop config to implement the Shopify Ruby Style guidelines described <a href="https://shopify.github.io/ruby-style-guide/">here.</a>

```ruby
require:
    - rubocop-rails
    - rubocop-faker
    - rubocop-rspec
inherit_gem:
    rubocop-shopify: rubocop.yml

```

## ✏️ Documentation

In addition to this readme, I have documented this project through inline comments and GraphQL client documentation.

<img src="/documentation/screen_docs.png" width="500px">

## 🧪 Testing

Several rspec tests have been written for this project, including unit and integration tests for all models, queries, and mutaions. According to the code coverage report generated by the ```simplecov``` gem, this project has ***99.61%*** code coverage.

<img src="/documentation/simplecov.png">

Simply run:

```ruby
rspec
```

to run all provided tests and generate a simplecov code coverage report.

## Continuous Integration

<img src="/documentation/github_actions.png" width="200px">

Using Github Actions, this repository has been configured to run all rspec tests and rubocop linting on all commits and pull requests. Futher information about the Github Actions continuous integration configuration can be viewed <a href="https://github.com/MathyouMB/Shopistrate/actions">here</a>.

## License

MIT. See <a href="https://github.com/MathyouMB/Shopistrate/blob/master/LICENSE">LICENSE</a> for more details.
