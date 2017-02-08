defmodule StockTest do
  use ExUnit.Case
  doctest Solitaire.Stock

  alias Solitaire.Stock, as: Stock
  alias Solitaire.Deck, as: Deck

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

  test "The stock cards are the combination of up and down pile" do
    deck = Deck.new
    stock = Stock.new(deck)

    stock = Stock.turn(stock)
    stock = Stock.turn(stock)
    stock = Stock.turn(stock)

    assert length(Stock.cards(stock)) == 52
  end

  test "When no up cards, the top card is nil" do
    deck = Deck.new
    stock = Stock.new(deck)

    assert Stock.top_card(stock) == nil
  end

  test "When a card is turned over it becomes the top card" do
    deck = Deck.new
    stock = Stock.new(deck)
    top = List.first(Stock.down(stock))

    stock = Stock.turn(stock)
    assert Stock.top_card(stock) == top
  end

  test "When a card is taken, the card below it becomes the top card" do
    deck = Deck.new
    stock = Stock.new(deck)
    top = List.first(Stock.down(stock))

    stock = Stock.turn(stock)
    stock = Stock.turn(stock)
    stock = Stock.take(stock)
    assert Stock.top_card(stock) == top
  end

end
