# aoc2022
Advent of Code 2022, in the Nix expression language...

> The Nix expression language is a pure, lazy, functional language. ... The language is not a full-featured, general purpose language. Its main job is to describe packages, compositions of packages, and the variability within packages.

To evaluate an expression
```
$ nix-instantiate --eval --strict ./day1/day1.nix --show-trace
{ part1 = 68467; part2 = 203420; }
```

I've been using `nixfmt` as a formatter

```bash
nix-shell -p pkgs.nixfmt
nixfmt ./day1/day1.nix
```