FROM elixir:latest

ENV HOME /opt/mirror
WORKDIR $HOME

ENV MIX_ENV prod

ENV PORT ${PORT:-4000}
EXPOSE $PORT

RUN mix local.hex --force

RUN mix local.rebar --force

COPY mix.* ./

RUN mix deps.get --only prod

RUN mix deps.compile

COPY . .

RUN mix compile

CMD mix do ecto.create, ecto.migrate, phx.server
