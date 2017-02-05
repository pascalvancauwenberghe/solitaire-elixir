defmodule SolitaireTest do
  use ExUnit.Case
  doctest Solitaire

  test "there are four suits" do
    assert length(Solitaire.Cards.suits) == 4
  end

  test "there are 13 values" do
    assert length(Solitaire.Cards.values) == 13
  end
end
