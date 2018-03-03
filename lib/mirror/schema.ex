defmodule Mirror.Schema do
  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      @primary_key {:symbol, :string, autogenerate: false}
    end
  end
end