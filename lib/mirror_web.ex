defmodule MirrorWeb do
  def controller do
    quote do
      use Phoenix.Controller, namespace: MirrorWeb
      import Plug.Conn
      import MirrorWeb.Router.Helpers
      import MirrorWeb.Gettext
    end
  end

  def view do
    quote do
      use Phoenix.View, root: "lib/mirror_web/templates",
                        namespace: MirrorWeb

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import MirrorWeb.Router.Helpers
      import MirrorWeb.ErrorHelpers
      import MirrorWeb.Gettext
    end
  end

  def router do
    quote do
      use Phoenix.Router
      import Plug.Conn
      import Phoenix.Controller
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
      import MirrorWeb.Gettext
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
