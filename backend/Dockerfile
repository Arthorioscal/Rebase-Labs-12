FROM ruby:3.3.0

RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

COPY db/persistence/import.rb /app/import.rb

COPY db/persistence/data.csv /app/backend/db/persistence/data.csv

CMD ["ruby", "/app/import.rb"]