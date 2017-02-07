defmodule FoundationTest do
  use ExUnit.Case
  doctest Solitaire.Foundation

  alias Solitaire.Foundation, as: Foundation
  alias Solitaire.Cards, as: Cards

  test "A new Foundation is empty" do
    foundation = Foundation.new

    assert length(Foundation.up(foundation)) == 0
  end

  test "Can drop an Ace on an empty Foundation" do
    foundation = Foundation.new

    for suit <- Cards.suits do
      assert Foundation.can_drop?(foundation,Cards.new(suit,1))
    end
  end
end
