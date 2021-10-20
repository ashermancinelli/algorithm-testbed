## Leetcode Problem in the Most Popular Programming Languages of 1965

Today we'll be solving a leetcode problem in the most popular programming languages of the year 1965!

Most of these langauges have changed so so much since 1965, so the way I'm using these languages won't be *exactly* the same as they were used back then.
For example, I couldn't find a way to compile and/or run an ALGOL50 program, so I'll have to use Algol68, a later standard of the language.
Similarly, the first APLs were intended for use on a blackboard, and the first actual implementations were all proprietary, so I'll be using GNU APL for this post.

Along with my solution for each language, I'll give a little bit of history.

## Problem

We have to find the peak element that is greater than both neighbors.
[link](https://leetcode.com/problems/find-peak-element/)

## Content

1. [Lisp](#lisp)
1. [APL](#apl)
1. [BASIC](#basic)
1. [Assembler](#assembler)
1. [ALGOL](#algol)
1. [COBOL](#cobol)
1. [Fortran](#fortran)

### [Lisp](#content)

I used Scheme for my Lisp.

### [APL](#content)

I used the BQN language as my APL of choice.

### [BASIC](#content)

I used FreeBASIC for this example.

### [Assembler](#content)

I wrote this in x86 64-bit assembly on linux with a GNU compiler.

### [ALGOL](#content)

I'm using the Algol68 Genie compiler-interpreter for this code.

```algol
PROC solve = ([]INT elements)INT: (
  INT found := -1;
  FOR i FROM 1+(LWB elements) TO (UPB elements)-1
  DO
    IF elements[i] > elements[i+1] AND elements[i] > elements[i-1]
      THEN
        found := i-1
      FI
  OD;
  found 
);
```

### [COBOL](#content)

I use the GNUCobol compiler for this example.

### [Fortran](#content)

I used the GNU gfortran compiler in fixed-form mode for this.
