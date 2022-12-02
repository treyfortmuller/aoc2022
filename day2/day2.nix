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

   Rock > Scissors
   Rock < Paper

   Scissors > Paper
   Scissors < Rock

   Paper > Rock
   Paper < Scissors
*/

# (rock, paper)

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

  # input = builtins.readFile ./example.txt;
  input = builtins.readFile ./input.txt;
  letterPairs = lib.splitString "\n" input;
  versus = builtins.map (lib.splitString " ") letterPairs;

  generateMoves = versus: {
    them = moveLookup.${builtins.elemAt versus 0};
    us = moveLookup.${builtins.elemAt versus 1};
  };

  moves = builtins.map generateMoves versus;

  # { them = "rock"; us = "paper"; } -> points tally for us
  pointsForHand = moves: movePoints.${moves.us}.points;
  pointsForMatch = moves:
    if movePoints.${moves.us}.beats == moves.them then
      resultsPoints.win
    else if moves.us == moves.them then
      resultsPoints.draw
    else
      resultsPoints.lose;
in listSum (builtins.map (x: (pointsForHand x + pointsForMatch x)) moves)
