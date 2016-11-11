defmodule Inventory.BucketsViewTest do
  use Inventory.ConnCase, async: true

  import Phoenix.View

  test "renders index.html" do
    assert render_to_string(Inventory.BucketsView, "index.html", buckets: []) =~ "Buckets"
  end
end
