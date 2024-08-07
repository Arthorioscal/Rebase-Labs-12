FROM ruby:3.3.0

# Install dependencies
RUN apt-get update && apt-get install -y postgresql-client

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install the gems
RUN bundle install

# Copy the application code
COPY . .

# Ensure the import.rb file is copied to the correct location
COPY db/persistence/import.rb /app/import.rb

# Copy the data.csv file to the correct location
COPY db/persistence/data.csv /app/backend/db/persistence/data.csv

# List the contents of the /app directory for debugging
RUN ls -la /app

# Command to execute the script
CMD ["ruby", "/app/import.rb"]