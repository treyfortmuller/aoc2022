/* The winner of the whole tournament is the player with the highest score.
      Your total score is the sum of your scores for each round. The score for
      a single round is the score for the shape you selected:
      - 1 for Rock
      - 2 for Paper
      - 3 for Scissors

      Plus the score for the outcome of the round:
      - 0 if you lost
      - 3 if the round was a draw
      - 6 if you won

      Key:
      A / X -> Rock, 1
      B / Y -> Paper, 2
      C / Z -> Scissors, 3
*/

let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  listSum = lib.foldr (l: r: l + r) 0;

  resultsPoints = {
    win = 6;
    draw = 3;
    lose = 0;
  };

  moveLookup = rec {
    A = "rock";
    X = A;
    B = "paper";
    Y = B;
    C = "scissors";
    Z = C;
  };

  movePoints = {
    rock = {
      beats = "scissors";
      points = 1;
    };
    paper = {
      beats = "rock";
      points = 2;
    };
    scissors = {
      beats = "paper";
      points = 3;
    };
  };

  partTwoStrat = rec {
    X = "lose";
    Y = "draw";
    Z = "win";
  };

  # input = builtins.readFile ./example.txt;
  input = builtins.readFile ./input.txt;
  letterPairs = lib.splitString "\n" input;
  versus = builtins.map (lib.splitString " ") letterPairs;

  # Part 1
  generateMoves = versus: {
    them = moveLookup.${builtins.elemAt versus 0};
    us = moveLookup.${builtins.elemAt versus 1};
  };

  moves = builtins.map generateMoves versus;

  # { them = "rock"; us = "paper"; } -> points tally for us
  pointsForHand = m: (movePoints.${m.us}).points;
  pointsForMatch = m:
    if movePoints.${m.us}.beats == m.them then
      resultsPoints.win
    else if m.us == m.them then
      resultsPoints.draw
    else
      resultsPoints.lose;

  # Part 2
  # Given a hand you need to win against, return the points won for playing the appropriate hand.
  winAgainstAttr = y:
    builtins.filter (x: x.beats == y) (builtins.attrValues movePoints);
  pointsToWinAgainst = x: (builtins.elemAt (winAgainstAttr x) 0)."points";

  loseAgainstAttr = y:
    lib.filterAttrs (n: v: n != y && v.beats != y) movePoints;
  pointsToLoseAgainst = x:
    (builtins.elemAt (builtins.attrValues (loseAgainstAttr x)) 0)."points";

  generateStrat = versus: {
    them = moveLookup.${builtins.elemAt versus 0};
    us = partTwoStrat.${builtins.elemAt versus 1};
  };

  strats = builtins.map generateStrat versus;
  pointsForResult = strats: resultsPoints.${strats.us};
  pointsForStrat = strats:
    if strats.us == "win" then
      pointsToWinAgainst strats.them
    else if strats.us == "draw" then
      (movePoints.${strats.them}).points
    else
      pointsToLoseAgainst strats.them;
in {
  part1 =
    listSum (builtins.map (x: (pointsForHand x + pointsForMatch x)) moves);
  part2 =
    listSum (builtins.map (x: (pointsForResult x + pointsForStrat x)) strats);
}
