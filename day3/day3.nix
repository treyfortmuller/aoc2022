let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  inherit (builtins) readFile substring stringLength map elemAt filter length;

  listSum = lib.foldr (l: r: l + r) 0;

  alphabetSoup = lib.stringToCharacters
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
  indices = builtins.genList (x: x + 1) (length alphabetSoup);
  priorityLookup = lib.zipLists indices alphabetSoup;
  getPriority = l: (builtins.head (filter (x: x.snd == l) priorityLookup)).fst;

  # input = readFile ./example.txt;
  input = readFile ./input.txt;

  rucksacks = lib.splitString "\n" input;

  # Helper function to return the length of a string divded by two
  halfLen = s: stringLength s / 2;

  # Given a string representation of the contents of one rucksack, split
  # the string into halves in an attrset
  compartmentSplit = c: {
    first = lib.stringToCharacters (substring 0 (halfLen c) c);
    second = lib.stringToCharacters (substring (halfLen c) (stringLength c) c);
  };

  compartmentContentLists = map compartmentSplit rucksacks;

  sharedContents = map (x: builtins.head (lib.intersectLists x.first x.second))
    compartmentContentLists;

in listSum (map getPriority sharedContents)

# in {
#   part1 = 0;
#   part2 = 0;
# }
