defmodule MirrorWeb.CalaControllerTest do
  use MirrorWeb.ConnCase

  test "GET /calc", %{conn: conn} do
    conn = get conn, "/calc?date=2018-03-03&time=10:00&amount=123&currency=BTC"
    assert html_response(conn, 302) =~ "redirected"
  end

  test "GET /calc/:currency", %{conn: conn} do
    conn = get conn, "/calc/BCH?amount=123&timestamp=1520191120"
    assert html_response(conn, 200) =~ "BCH"
  end

end
