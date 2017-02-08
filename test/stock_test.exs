defmodule StockTest do
  use ExUnit.Case
  doctest Solitaire.Stock

  test "The initial card contains all down, no up cards" do
    deck = Solitaire.Deck.new
    stock = Solitaire.Stock.new(deck)

    assert length(Solitaire.Stock.down(stock)) == 52
    assert length(Solitaire.Stock.up(stock)) == 0
  end

  test "Turning cards moves them from down to up section" do
    deck = Solitaire.Deck.new
    stock = Solitaire.Stock.new(deck)
    top = List.first(Solitaire.Stock.down(stock))

    stock = Solitaire.Stock.turn(stock)
    assert length(Solitaire.Stock.down(stock)) == 51
    assert length(Solitaire.Stock.up(stock)) == 1
    assert List.first(Solitaire.Stock.up(stock)) == top
  end
end