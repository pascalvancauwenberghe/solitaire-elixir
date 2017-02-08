defmodule StockTest do
  use ExUnit.Case
  doctest Solitaire.Stock

  test "The initial card contains all down, no up cards" do
    deck = Solitaire.Deck.new
    stock = Solitaire.Stock.new(deck)

    assert length(Solitaire.Stock.down(stock)) == 52
    assert length(Solitaire.Stock.up(stock)) == 0
  end
end