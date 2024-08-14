FROM ruby:3.3.0

WORKDIR /app

RUN apt-get update && \
    apt-get install -y curl gnupg2 build-essential libpq-dev nodejs yarn apt-transport-https ca-certificates && \
    curl -sSL https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable chromium-driver && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

EXPOSE 3000

CMD ["bundle", "exec", "rackup", "./config/config.ru", "-o", "0.0.0.0", "-p", "3000"]