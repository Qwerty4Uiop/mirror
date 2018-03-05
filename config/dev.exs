use Mix.Config

config :mirror, MirrorWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [node: ["node_modules/brunch/bin/brunch", "watch", "--stdin",
                    cd: Path.expand("../assets", __DIR__)]]

config :mirror, MirrorWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/mirror_web/views/.*(ex)$},
      ~r{lib/mirror_web/templates/.*(eex)$}
    ]
  ]

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :mirror, Mirror.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres", #System.get_env("DB_ENV_POSTGRES_USER"), #"postgres",
  password: "postgres", #System.get_env("DB_ENV_POSTGRES_PASSWORD"), #"postgres",
  database: "mirror_dev",
  hostname: "localhost", #System.get_env("DB_ENV_POSTGRES_HOST"), #"localhost",
  pool_size: 10
