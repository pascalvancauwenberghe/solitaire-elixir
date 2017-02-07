defmodule FoundationTest do
  use ExUnit.Case
  doctest Solitaire.Foundation

  alias Solitaire.Foundation, as: Foundation

  test "A new Foundation is empty" do
    foundation = Foundation.new

    assert length(Foundation.up(foundation)) == 0
  end

  test "Can drop an Ace on an empty Foundation" do
    foundation = Foundation.new

    assert Foundation.can_drop?(foundation,Solitaire.Cards.new(:hearts,1))
  end
end
