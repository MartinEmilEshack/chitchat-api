FROM ruby:2.6.10

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /chitchat-api

WORKDIR /chitchat-api

COPY Gemfile /chitchat-api/Gemfile
COPY Gemfile.lock /chitchat-api/Gemfile.lock

RUN bundle install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

COPY . /chitchat-api
# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]