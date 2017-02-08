defmodule StockTest do
  use ExUnit.Case
  doctest Solitaire.Stock

  alias Solitaire.Stock, as: Stock
  alias Solitaire.Deck, as: Deck
  alias Solitaire.Cards, as: Cards

  test "The initial card contains all down, no up cards" do
    deck = Deck.new
    stock = Stock.new(deck)

    assert length(Stock.down(stock)) == 52
    assert length(Stock.up(stock)) == 0
  end

  test "Turning cards moves them from down to up section" do
    deck = Deck.new
    stock = Stock.new(deck)
    top = List.first(Stock.down(stock))

    stock = Stock.turn(stock)
    assert length(Stock.down(stock)) == 51
    assert length(Stock.up(stock)) == 1
    assert List.first(Stock.up(stock)) == top
  end

  test "The stock is exhausted when all cards are turned over" do
    deck = Deck.new
    stock = Stock.new(deck)

    stock = keep_turning(stock)
    assert length(Stock.down(stock)) == 0
    assert length(Stock.up(stock)) == 52
    assert Stock.exhausted?(stock)
  end

  defp keep_turning(stock) do
    if length(Stock.down(stock)) > 0 do
      keep_turning(Stock.turn(stock))
    else
      stock
    end
  end
end
