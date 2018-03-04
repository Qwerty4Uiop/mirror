defmodule Mirror.UserTest do
  use Mirror.DataCase

  alias Mirror.Currency

  @valid_attrs %{symbol: "UBTC", rate: 12345.678}

  test "changeset with valid attributes" do
    changeset = Currency.changeset(%Currency{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with all attributes missed" do
    changeset = Currency.changeset(%Currency{}, %{})
    refute changeset.valid?
  end

  test "changeset with PK attribute missed" do
    changeset = Currency.changeset(%Currency{}, %{rate: 1234.56})
    refute changeset.valid?
  end

  test "changeset with nullable but required attribute missed" do
    changeset = Currency.changeset(%Currency{}, %{symbol: "UBTC"})
    refute changeset.valid?
  end

  test "changeset with non-float value as rate" do
    changeset = Currency.changeset(%Currency{}, %{symbol: "UBTC", rate: "qwe"})
    refute changeset.valid?
  end

  test "changeset with non-string value as symbol" do
    changeset = Currency.changeset(%Currency{}, %{symbol: 123, rate: "qwe"})
    refute changeset.valid?
  end

end