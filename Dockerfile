FROM elixir:latest

RUN mix local.hex --force

RUN mix archive.install --force https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez

RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get

RUN mix deps.compile

COPY . .

RUN mix compile

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

RUN apt-get install -y inotify-tools