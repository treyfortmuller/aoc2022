let
  pkgs = import <nixpkgs> { };
  lib = pkgs.lib;

  inherit (builtins)
    readFile substring stringLength map elem elemAt filter length mapAttrs head
    genList;

  listSum = lib.foldr (l: r: l + r) 0;

  getPriority = l:
    let
      alphabetSoup = lib.stringToCharacters
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      indices = genList (x: x + 1) (length alphabetSoup);
      priorityLookup = lib.zipLists indices alphabetSoup;
    in (head (filter (x: x.snd == l) priorityLookup)).fst;

  # input = readFile ./example.txt;
  input = readFile ./input.txt;
  rucksacks = lib.splitString "\n" input;

  # Given a string representation of the contents of one rucksack, split
  # the string into halves in an attrset
  compartmentSplit = c:
    let halfLen = s: stringLength s / 2;
    in {
      first = lib.stringToCharacters (substring 0 (halfLen c) c);
      second =
        lib.stringToCharacters (substring (halfLen c) (stringLength c) c);
    };

  # Part 2
  compartmentContentLists = map compartmentSplit rucksacks;

  sharedContents =
    map (x: head (lib.intersectLists x.first x.second)) compartmentContentLists;

  tripleAttr = l: {
    first = elemAt l 0;
    second = elemAt l 1;
    third = elemAt l 2;
  };

  chunksOfThree = l:
    if (length l == 0) then
      [ ]
    else
      lib.singleton (tripleAttr (lib.take 3 l)) ++ chunksOfThree (lib.drop 3 l);

  # Given a three-element attrset of strings representing the contents of a group of rucksack, 
  # find the shared element of all 3 sacks.
  findShared = attrset:
    let
      chared = stringsToChars attrset;
      elemMulti = x: l1: l2: elem x l1 && elem x l2;
      stringsToChars = l: mapAttrs (_: v: lib.stringToCharacters v) l;
    in lib.findFirst (e: elemMulti e chared.second chared.third)
    (throw "no shared contents") chared.first;
in {
  part1 = listSum (map getPriority sharedContents);
  part2 = listSum (map getPriority (map findShared (chunksOfThree rucksacks)));
}
