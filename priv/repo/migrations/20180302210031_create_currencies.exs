defmodule Mirror.Repo.Migrations.CreateCurrencies do
  use Ecto.Migration

  def change do
  	drop_if_exists table(:currencies)

    create table(:currencies, primary_key: false) do
      add :symbol, :string, primary_key: true
      add :rate, :float
    end

  end
end
