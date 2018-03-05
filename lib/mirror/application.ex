defmodule Mirror.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Mirror.Repo, []),
      supervisor(MirrorWeb.Endpoint, []),
      worker(Mirror.Scheduler, [])
    ]

    opts = [strategy: :one_for_one, name: Mirror.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    MirrorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
