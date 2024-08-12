FROM ruby:3.3.0

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "./config/config.ru", "-o", "0.0.0.0", "-p", "3000"]