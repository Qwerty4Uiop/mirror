defmodule MirrorWeb.ErrorViewTest do
  use MirrorWeb.ConnCase, async: true

  import Phoenix.View

  test "renders 404.html" do
    assert render_to_string(MirrorWeb.ErrorView, "404.html", []) ==
           "Page not found"
  end

  test "render 500.html" do
    assert render_to_string(MirrorWeb.ErrorView, "500.html", []) ==
           "Internal server error"
  end

  test "render any other" do
    assert render_to_string(MirrorWeb.ErrorView, "505.html", []) ==
           "Internal server error"
  end
end
