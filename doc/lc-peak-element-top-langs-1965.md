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
1. [ALGOL](#algol)
1. [COBOL](#cobol)
1. [Fortran](#fortran)

### [Lisp](#content)

I used MIT Scheme for my Lisp since it seems like the oldest lisp implementation that I can still install.

### [APL](#content)

I used the BQN language as my APL of choice.

APL solution:
```
i0 ← 1‿2‿3‿1
i1 ← ⟨1,2,1,3,5,6,4⟩
i2 ← 2‿1‿2‿3‿1
F ← ({0∾((2-˜≠𝕩)⥊1)∾0}∧(«<⊢)∧(⊢>»))⊐(1˙)
F ¨ i0‿i1‿i2
```

![Diagram of my BQN solution](./img/lc-peak-element/bqn.png)

### [BASIC](#content)

I used FreeBASIC for this example.

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

```cobol
       ID DIVISION.
       PROGRAM-ID. ARRAYTEST.
       ENVIRONMENT DIVISION.
       DATA DIVISION. 
       WORKING-STORAGE SECTION.
      * Store both problems and their sizes and answers in one
      * structure
       01 SIZES PIC 9(3) OCCURS 2 TIMES VALUE 0.
       01 OFFSETS PIC 9(3) OCCURS 2 TIMES VALUE 0.
       01 PROBLEMS PIC 9(3) OCCURS 12 TIMES VALUE 0.
       01 CURRENT-PROBLEM PIC 9(3) VALUE 0.
       01 TMP PIC 9(3) VALUE 0.
       01 IDX PIC 9(3) VALUE 1.
       01 NPROBLEMS PIC 9(3) VALUE 2.
       01 ANSWERS PIC S9(3) OCCURS 2 TIMES VALUE -1.
       PROCEDURE DIVISION.

       100-MAIN.

      *    Set up problem [1,2,3,1]
           MOVE 4 TO SIZES(1).
           MOVE 0 TO OFFSETS(1).

           MOVE 1 TO PROBLEMS(1).
           MOVE 2 TO PROBLEMS(2).
           MOVE 3 TO PROBLEMS(3).
           MOVE 1 TO PROBLEMS(4).

      *    Set up problem [1,2,1,3,5,6,4]
           MOVE 7 TO SIZES(2).
           MOVE 4 TO OFFSETS(2).

           MOVE 1 TO PROBLEMS(5).
           MOVE 2 TO PROBLEMS(6).
           MOVE 1 TO PROBLEMS(7).
           MOVE 3 TO PROBLEMS(8).
           MOVE 5 TO PROBLEMS(9).
           MOVE 6 TO PROBLEMS(10).
           MOVE 4 TO PROBLEMS(11).

      *    Run solve procedure on both problems
           PERFORM VARYING CURRENT-PROBLEM FROM 1 BY 1 UNTIL CURRENT-PRO
      -BLEM > NPROBLEMS
             MOVE OFFSETS(CURRENT-PROBLEM) TO IDX
             PERFORM SOLVE
             DISPLAY ANSWERS(CURRENT-PROBLEM) END-DISPLAY
           END-PERFORM.

           STOP RUN.

       SOLVE.
           PERFORM VARYING IDX FROM 2 BY 1 UNTIL IDX>SIZES(CURRENT-PROBL
      -EM)
             COMPUTE TMP = IDX + OFFSETS(CURRENT-PROBLEM) END-COMPUTE
             IF PROBLEMS(TMP) > PROBLEMS(TMP - 1)
      -AND PROBLEMS(TMP) > PROBLEMS(TMP + 1)
               COMPUTE TMP = IDX - 1 END-COMPUTE
               MOVE TMP TO ANSWERS(CURRENT-PROBLEM)
             END-IF
           END-PERFORM.

       PRINT-AR.
           DISPLAY "IDX=" IDX " VALUE=" PROBLEMS(IDX) END-DISPLAY.
```

### [Fortran](#content)

I used the GNU gfortran compiler in fixed-form F77 mode for this.

The name "Fortran" is derived from [FORmula TRANslation](#ref-ftn-start).

## References

* <a name="ref-ftn-start">[Fortran history](https://en.wikipedia.org/wiki/Fortran#History)</a>
