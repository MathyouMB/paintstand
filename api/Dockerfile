FROM ruby:2.6.3-slim-buster

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
	build-essential \
	libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app
COPY Gemfile* ./
RUN gem install bundler:2.1.4
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]