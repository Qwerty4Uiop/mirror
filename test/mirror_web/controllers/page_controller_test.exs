defmodule MirrorWeb.PageControllerTest do
  use MirrorWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "BTC"
  end
end
