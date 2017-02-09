#Separate test modules for each test so that they're run in parallel

defmodule PerformanceTest1 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 1..2000" do
    score = Player.play_games(1..2000)

    assert score == 11763
  end
end

defmodule PerformanceTest2 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 2001..4000" do
    score = Player.play_games(2001..4000)

    assert score == 11746
  end
end

defmodule PerformanceTest3 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 4001..6000" do
    score = Player.play_games(4001..6000)

    assert score == 11980
  end
end

defmodule PerformanceTest4 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 6001..8000" do
    score = Player.play_games(6001..8000)

    assert score == 11798
  end
end

defmodule PerformanceTest5 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 8001..10000" do
    score = Player.play_games(8001..10000)

    assert score == 11910
  end
end

defmodule PerformanceTest6 do
  use ExUnit.Case, async: true

  @tag :performance
  test "Run a complete game to check no scoring regressions 10001..12000" do
    score = Player.play_games(10001..12000)

    assert score == 11574
  end
end