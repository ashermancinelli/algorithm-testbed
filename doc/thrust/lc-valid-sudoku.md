## Intro

### Problem

[Link to problem.](https://leetcode.com/problems/valid-sudoku/)

Our problem is to determine if a 9 x 9 Sudoku board is valid, but not necessarily solvable.

* Each row must have the digits 1-9 without repetition.
* Each column must have the digits 1-9.
* Each of the nine 3 x 3 sub-boxes of the grid must have the digits 1-9.

### 

## Solutions

Order:
1. BQN
1. Fortran
1. Fortran & MPI
1. C++
1. C++ & MPI
1. C++ & CUDA
1. C++ & CUDA & MPI

## BQN

```
# two 8s in the first block
bad ← ⟨8, 3, 0, 0, 7, 0, 0, 0, 0
       6, 0, 0, 1, 9, 5, 0, 0, 0
       0, 9, 8, 0, 0, 0, 0, 6, 0
       8, 0, 0, 0, 6, 0, 0, 0, 3
       4, 0, 0, 8, 0, 3, 0, 0, 1
       7, 0, 0, 0, 2, 0, 0, 0, 6
       0, 6, 0, 0, 0, 0, 2, 8, 0
       0, 0, 0, 4, 1, 9, 0, 0, 5
       0, 0, 0, 0, 8, 0, 0, 7, 9⟩

# valid sudoku
good ← ⟨5, 3, 0, 0, 7, 0, 0, 0, 0
        6, 0, 0, 1, 9, 5, 0, 0, 0
        0, 9, 8, 0, 0, 0, 0, 6, 0
        8, 0, 0, 0, 6, 0, 0, 0, 3
        4, 0, 0, 8, 0, 3, 0, 0, 1
        7, 0, 0, 0, 2, 0, 0, 0, 6
        0, 6, 0, 0, 0, 0, 2, 8, 0
        0, 0, 0, 4, 1, 9, 0, 0, 5
        0, 0, 0, 0, 8, 0, 0, 7, 9⟩

F ← {𝕊𝕩:
  Fl ← 0⊸≠⊸/                       # Filter 0s out
  Dup ← (∨´∾´)¬∘∊¨                 # Are there any duplicates?

  rs ← Dup Fl¨(9/↕9)⊔𝕩             # Check rows
  cs ← Dup Fl¨(81⥊↕9)⊔𝕩            # Check columns

  bi ← 27⥊3/↕3
  bs ← Dup Fl¨(bi∾(3+bi)∾(6+bi))⊔𝕩 # Check blocks

  (bs ∨ rs ∨ cs)⊑"true"‿"false"
}
•Show F good
•Show F bad
```

This solution has been broken down into a few different lines, which is a bit uncommon in BQN solutions since APL folks love to get their solutions into one-liners.
This solution will also be the basis for our later solutions.

This first line is a function to filter out any 0s:
```
   Fl ← 0⊸≠⊸/
   Fl ⟨5, 3, 0, 0, 7, 0, 0, 0, 0⟩
⟨ 5 3 7 ⟩
```

Here we have another utility function to return an integer indicating whether any duplicates were found in any sublists:
```
   Dup ← (∨´∾´)¬∘∊¨
   Dup ⟨⟨5, 3, 7⟩, ⟨1, 2, 3⟩⟩
0
   Dup ⟨⟨5, 3, 7⟩, ⟨1, 2, 2⟩⟩
1
```

Next we check for duplicates in all the filtered rows and columns:
```
   rs ← Dup Fl¨(9/↕9)⊔𝕩
   cs ← Dup Fl¨(81⥊↕9)⊔𝕩
```

These ranges are used to create indices for grouping the values in X.
I'll show a trimmed down version of their output here to give you an idea:
```
   3‿3⥊(3/↕3) # For the rows
┌─       
╵ 0 0 0  
  1 1 1  
  2 2 2  
        ┘
   3‿3⥊(9⥊↕3) # For the columns
┌─       
╵ 0 1 2  
  0 1 2  
  0 1 2  
        ┘
```

Next I do something similar to get the indices for the boxes.
```
   bi ← 27⥊3/↕3
   3‿9⥊bi
┌─                   
╵ 0 0 0 1 1 1 2 2 2  
  0 0 0 1 1 1 2 2 2  
  0 0 0 1 1 1 2 2 2  
                    ┘
```

This creats indices for the first three boxes, and you can probably imagine how to extend this to get the indices for all the boxes. I just add three to the previous indices, and then add six, and then append them all together. Here's the second layer:
```
   3‿9⥊bi+3
┌─                   
╵ 3 3 3 4 4 4 5 5 5  
  3 3 3 4 4 4 5 5 5  
  3 3 3 4 4 4 5 5 5  
                    ┘
```

And the final layer:
```
   3‿9⥊bi+6
┌─                   
╵ 6 6 6 7 7 7 8 8 8  
  6 6 6 7 7 7 8 8 8  
  6 6 6 7 7 7 8 8 8  
                    ┘
```

And all three layers of indices stacked on top of each other:
```
   9‿9⥊(bi∾(3+bi)∾(6+bi))
┌─                   
╵ 0 0 0 1 1 1 2 2 2  
  0 0 0 1 1 1 2 2 2  
  0 0 0 1 1 1 2 2 2  
  3 3 3 4 4 4 5 5 5  
  3 3 3 4 4 4 5 5 5  
  3 3 3 4 4 4 5 5 5  
  6 6 6 7 7 7 8 8 8  
  6 6 6 7 7 7 8 8 8  
  6 6 6 7 7 7 8 8 8  
                    ┘
```

Using these indices, I group all the elements of the input, and then check all of them for duplicates:
```
   bs ← Dup Fl¨(bi∾(3+bi)∾(6+bi))⊔𝕩 # Check blocks
```

And in the end I check if there were duplicates in the blocks, in the rows, or in the columns, and use that to index into our strings that indicate whether our sudoku board is valid or not.
```
   (bs ∨ rs ∨ cs)⊑"true"‿"false"
```

## Fortran
