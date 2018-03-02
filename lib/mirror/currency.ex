defmodule Mirror.Currency do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mirror.Currency


  schema "currencies" do
    field :rate, :float
    field :symbol, :string

    timestamps()
  end

  @doc false
  def changeset(%Currency{} = currency, attrs) do
    currency
    |> cast(attrs, [:symbol, :rate])
    |> validate_required([:symbol, :rate])
  end
end
