FROM ruby:3.3.0

RUN apt-get update && apt-get install -y postgresql-client

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 4567

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

#CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "--port", "4567", "config/config.ru"]