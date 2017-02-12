ExUnit.start(exclude: [:skip,:performance])

defmodule Player do

  alias Solitaire.Game, as: Game
  alias Solitaire.Deck, as: Deck

  @log 0

  def play_games(range) do
     games = for nb <- range do
       #IO.inspect {:Playing , nb }
       deck = Deck.shuffle(Deck.new,nb)
       game = Game.new(deck)
       moves = Game.possible_moves(game)
       game = play(game,moves)
       #score = Game.score(game)
       #if score == 52 do
       #  IO.inspect { nb , score , game }
       #end
       game
    end
    Enum.reduce(games,0,fn(game,score) -> score + Game.score(game) end)
  end

  def play(game,[]) do
    if Game.exhausted?(game) do
      if @log > 0 do
        show("Final Game::")
         Game.Debug.pretty_print(game) 
      end
      game
    else
      show("Turning over a card")
      game = Game.turn(game)
      moves = Game.possible_moves(game)
      play(game,moves)
    end
  end

  def play(game,[move|_rest]=moves) do
    show(game,moves) 
    game = Game.perform(game,move)
    moves = Game.possible_moves(game)
    game = play(game,moves)
    errors = Game.validate(game)
    if errors != [] do
      IO.inspect { game,errors }
    end
    game
  end

  defp show(game,moves) do
    if length(moves) > 0 && @log > 0 do
      show("Game::")
      Game.Debug.pretty_print(game)
      IO.inspect(moves,label: "Moves")      
    end
  end

  defp show(message) do
    if @log > 0 && String.length(message) > 0, do: IO.puts message
  end

end

