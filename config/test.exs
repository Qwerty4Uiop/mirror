use Mix.Config

config :mirror, MirrorWeb.Endpoint,
  http: [port: 4001],
  server: false

config :logger, level: :warn

config :mirror, Mirror.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_ENV_POSTGRES_USER"), #"postgres",
  password: System.get_env("DB_ENV_POSTGRES_PASSWORD"), #"postgres",
  database: "mirror_test",
  hostname: System.get_env("DB_ENV_POSTGRES_HOST"), #"localhost",
  pool: Ecto.Adapters.SQL.Sandbox
