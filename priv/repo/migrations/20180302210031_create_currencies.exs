defmodule Mirror.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
    create table(:currencies) do
      add :symbol, :string
      add :rate, :float

      timestamps()
    end

  end
end
