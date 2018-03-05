use Mix.Config

config :mirror,
  ecto_repos: [Mirror.Repo]

config :mirror, MirrorWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tBJaf9WxfQBmc/cpS6DdLBqIpmE7Ho79jGbpzytPa4+LMVsEFB1ihc49cRYgqrrP",
  render_errors: [view: MirrorWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Mirror.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"
