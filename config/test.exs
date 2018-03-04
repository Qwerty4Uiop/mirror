use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :mirror, MirrorWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :mirror, Mirror.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DB_ENV_POSTGRES_USER"), #"postgres",
  password: System.get_env("DB_ENV_POSTGRES_PASSWORD"), #"postgres",
  database: "mirror_test",
  hostname: System.get_env("DB_ENV_POSTGRES_HOST"), #"localhost",
  pool: Ecto.Adapters.SQL.Sandbox
