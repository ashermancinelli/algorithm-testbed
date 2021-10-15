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


This solution introduces a way to think about the problem that I'll carry through the rest of the solutions for the most part. I create an array thrice the size of the grid. Note that this is not as space (or time) efficient as many of the solutions that you can find on the discussion page for the leetcode problem, but it is much easier to parallelize and that's really the point of this video.

You can think of the array as a three dimensional matrix, where the rows represent the index into the type of vlidity we are checking for, the columns represent the integer value of the cell in the sudoku board, and the length three cells indicate the type of check we are performing,
where 0 is for checking rows, 1 is for checking columns, and two is for checking blocks.
For example, say the sudoku board has value 7 in row 2 column 3. Checking the sudoku board at row 2 column 3 against other values in the same row would increment the value at row 2, column 7, element 2 in our answer array.

If any value in our final array is greater than one, then we know we have at least one duplicate in at least one row, column, or block.
```fortran
subroutine isgood(board, ret)
  integer, dimension(0:(shape*shape)-1), intent(in) :: board
  logical, intent(out) :: ret

  integer, dimension(0:(shape * shape * 3)-1) :: bits
  integer :: v, row, col, i, j, dx, dy

  bits = 0

  do row = 0, shape-1
    do col = 0, shape-1
      v = board(idx2(row, col))
      if (v .eq. 0) cycle
      j = 0
      do i = 0, shape-1
        call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(row, i))))
      end do
      j = 1
      do i = 0, shape-1
        call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(i, col))))
      end do
      j = 2
      do dx = 0, blksz-1
        do dy = 0, blksz-1
          call pe(bits(idx3(row, col, j)), (v .eq. board(idx2(tl(row) + dy, tl(col) + dx))))
        end do
      end do
    end do
  end do
  
  v = maxval(bits) - 1

  ret = (v .lt. 1)
end subroutine
```
