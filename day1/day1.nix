let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  input = builtins.readFile ./input.txt;
  listSum = lib.foldr (l: r: l + r) 0;
  elfPortions = lib.splitString "\n\n";
  elfIntCalories = builtins.map (lib.splitString "\n");
  listToInt = builtins.map (builtins.map lib.toInt);
  elemSums = builtins.map (listSum);

  sortedCounts = (builtins.sort (a: b: a > b)
    (elemSums (listToInt (elfIntCalories (elfPortions input)))));
in {
  part1 = builtins.elemAt sortedCounts 0;
  part2 = listSum (lib.take 3 sortedCounts);
}
