# aoc2022
Advent of Code 2022, in the Nix expression language...

> The Nix expression language is a pure, lazy, functional language. [...] The language is not a full-featured, general purpose language. Its main job is to describe packages, compositions of packages, and the variability within packages.

So this is kind of like fitting a square peg into a round hole. 

To evaluate an expression
```
$ nix-instantiate --eval --strict ./day1/day1.nix --show-trace
{ part1 = 68467; part2 = 203420; }
```

I've been using `nixfmt` as a formatter

```bash
$ nix-shell -p pkgs.nixfmt
$ nixfmt ./day1/day1.nix
```

## How to make this reasonable

```nix
nix-repl> builtins.map (lib.splitString " ") matches    
[ [ ... ] [ ... ] [ ... ] ]

nix-repl> :p builtins.map (lib.splitString " ") matches
[ [ "A" "Y" ] [ "B" "X" ] [ "C" "Z" ] ]
```

pipe to `nixfmt` directly to pretty print the output of `nix-instantiate` for attrsets, lists, etc. 

```
nix-instantiate --eval --strict ./day3.nix --show-trace | nixfmt
```

You can get docs directly in the REPL (seemingly only for `builtins` though)

```
nix-repl> :doc builtins.map 
Synopsis: builtins.map f list

    Apply the function f to each element in the list list. For example,

    | map (x: "foo" + x) [ "bar" "bla" "abc" ]

    evaluates to [ "foobar" "foobla" "fooabc" ].
```

Naively trying to write down a recursive function in the REPL you run into

```
nix-repl> factorial = x: if x == 0 then 1 else x * factorial (x - 1)      
error: undefined variable 'factorial'

       at «string»:1:31:

            1|  x: if x == 0 then 1 else x * factorial (x - 1)
             |                               ^
```

But you can actual use a `let` expression to delay evaluation, this works

```
nix-repl> let factorial = x: if x == 0 then 1 else x * factorial (x - 1);
          in factorial 5
120
```