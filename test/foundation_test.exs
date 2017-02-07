defmodule FoundationTest do
  use ExUnit.Case
  doctest Solitaire.Foundation

  alias Solitaire.Foundation, as: Foundation

  test "A new Foundation is empty" do
    foundation = Foundation.new

    assert length(Foundation.up(foundation)) == 0
  end
end
