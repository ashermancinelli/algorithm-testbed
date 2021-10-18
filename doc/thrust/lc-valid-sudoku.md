## Intro

### Problem

[Link to problem.](https://leetcode.com/problems/valid-sudoku/)

Our problem is to determine if a 9 x 9 Sudoku board is valid, but not necessarily solvable.

* Each row must have the digits 1-9 without repetition.
* Each column must have the digits 1-9.
* Each of the nine 3 x 3 sub-boxes of the grid must have the digits 1-9.

## Solutions

Order:
1. BQN
1. Python
1. Python & MPI
1. Fortran
1. Fortran & MPI
1. C++
1. C++ & MPI
1. C++ & CUDA
1. C++ & CUDA & MPI
1. CMake

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


## Approach


Before we move on to the Python solution, I'd like to talk about our approach to this solution in the rest of the languages, because they will all be pretty similar.

Just like in the BQN solution, we have three collections which represent the validity of the rows, another for the columns, and a third for the blocks.

In our procedural languages, we'll create an array thrice the size of the grid to hold these values.
Note that this is not as space (or time) efficient as many of the solutions that you can find on the discussion page for the leetcode problem, but it is much easier to parallelize and that's really the point of this video.

Here we have three matrices, one for the rows, columns, and blocks, and below we have our sudoku board.

Let's now start at the second row and first column of our sudoku board for example, which relates to the second row of our "row matrix."

Because we're looking at our row matrix, we'll take the row index in our sudoku board as the row for our row matrix, and we'll take the value in the cell, in this case 6, as the column in our row matrix.
We'll increment the value at this location in our row matrix, or in the first layer of our 3-d sum matrix that we'll use to get our final answer.

Let's move on to check the first row and second column of our sudoku board for our column matrix.
Because we're looking at our column matrix, or the second layer of our final sum array, we'll use the column index as the row index in our column matrix, and the value in that cell for the column index in our column matrix.

We'll increment the value at this location in our column matrix, or in the second layer of our 3-d sum matrix that we'll use to get our final answer.

Finally, let's look at the first block in our sudoku board, which corresponds to the first row in our block matrix, and let's look at the first cell in that block.
The value in the first cell in the first block is 8, so we'll increment the first row and eighth column in our block matrix.

If we then perform these three operations for every cell in the sudoku board, we'll have a final matrix that indicates all the row-column-block-value combinations that we have, and if any cell in that final matrix has a value greater than one, then our board is invalid.

If we were then to check the final cell in the first block of our board, we would find that the eighth element of the first row of our block matrix would be incremented again, which would mean we have an invalid board!

If any value in our final array is greater than one, then we know we have at least one duplicate in at least one row, column, or block.

What's neat about this solution is that no single operation depends on any other operation as long as we perform our operations atomically.
This way, our work can be performed on multiple machines or different devices, and as long as we synchronize at the end, our solution will be the same.

Now that we've talked strategy, let's see what this looks like in our Python solution.

## Python

Here's our simple Python solution:
```python
shape = 9
blksz = 3
def solve(board):
    ar = [[[0 for j in range(3)] for i in range(shape)] for k in range(shape)]
    for r in range(shape):
        for c in range(shape):
            v = board[r][c]
            if 0 == v:
                continue
            ar[r][v - 1][0] += 1
            ar[c][v - 1][1] += 1

            bx = r // blksz
            by = c // blksz
            bi = bx * blksz + by
            ar[bi][v - 1][2] += 1
    return max(max(i) for j in ar for i in j) < 2

if __name__ == "__main__":
    for b in sudoku_9x9.boards():
        print(solve(b))
```

You can see here that we increment the value in the first layer of our full 3D matrix according to the row and the value in the cell currently being examined:
```python
            ar[r][v - 1][0] += 1
```

We do the same for our column matrix:
```python
            ar[c][v - 1][1] += 1
```

And finally for our block matrix, it just takes a little bit of math to figure out what our block index is.
```python
            bx = r // blksz
            by = c // blksz
            bi = bx * blksz + by
            ar[bi][v - 1][2] += 1
```

We run our example with two valid boards and two invalid boards and get the answers we expect:
```console
$ python ./src/python/lc-valid-sudoku.py
True
True
False
False
```

## Python & MPI

Now we'll look at another python example, but this time one that uses MPI to distribute the calculations:
```python
import numpy as np
from mpi4py import MPI
shape = 9
blksz = 3
comm = MPI.COMM_WORLD
def solve(board, comm):
    ar = np.zeros((9, 9, 3), dtype=np.int64)
    work = shape * shape
    chunk = (work + comm.size - 1) // comm.size
    subscripts = (*itertools.product(range(9), range(9)),)
    for i in range(comm.rank * chunk, (comm.rank * chunk) + chunk):
        if i >= work:
            break
        r, c = subscripts[i]
        v = board[r][c]
        if 0 == v:
            continue
        ar[r][v - 1][0] += 1
        ar[c][v - 1][1] += 1
        bx = r // blksz
        by = c // blksz
        bi = bx * blksz + by
        ar[bi][v - 1][2] += 1
    gar = np.zeros((9 * 9 * 3,), dtype=np.int64)
    comm.Reduce([ar.flatten(), MPI.INT], [gar, MPI.INT], op=MPI.SUM, root=0)
    comm.Barrier()
    return max(gar.flatten()) < 2 if 0 == comm.rank else False

if __name__ == "__main__":
    if 0 == comm.rank:
        print("Running with size {0}".format(comm.size))

    for b in sudoku_9x9.boards():
        comm.Barrier()
        if 0 == comm.rank:
            ret = solve(b, comm)
            print(ret)
        else:
            solve(b, comm)
```

MPI provides a lot of infrastructure for distributed computing: using the `mpirun` command spawns N processes, each of which knows how many processes were spawned, what its unique process ID is, and some other relevant information.
These processes may be spawned on multiple machines even, and MPI gives us the tools to communicate between these processes.
We'll take advantage of this infrastructure to perform our calculations on multiple processes.

Here we chunk our work up based on how many processes we have:
```python
    work = shape * shape
    chunk = (work + comm.size - 1) // comm.size
```

Say we're given 5 processes and we have 81 cells to check (because that's the size of our sudoku board).
The calculation would look something like this:
```console
>>> work = 81
>>> size = 5
>>> chunk = (work + size - 1) // size
>>> chunk
17
>>> chunk * size
85
```

`chunk` is then the smallest amount of work for each process such that all the work that needs to be done is performed.
This is a common calculation that needs to be done in parallel computing.
Our final process may exit early if the work is not evenly divisible by the chunk size.

We then generate all the possible combinations of rows and columns, and iterate over only the elements that fall within the chunk of work that belongs to our current MPI process.
```python
    subscripts = (*itertools.product(range(9), range(9)),)
    for i in range(comm.rank * chunk, (comm.rank * chunk) + chunk):
        if i >= work:
            break
        r, c = subscripts[i]
```

The rest of this code is exactly the same as our serial implementation:
```python
        v = board[r][c]
        if 0 == v:
            continue
        ar[r][v - 1][0] += 1
        ar[c][v - 1][1] += 1
        bx = r // blksz
        by = c // blksz
        bi = bx * blksz + by
        ar[bi][v - 1][2] += 1
```

This next bit is more interesting.
We create a global array with the size we need to hold our final sum matrix, and we use the MPI function `Reduce`.
This function will perform the operation `op`, in this case `MPI.SUM`, to join the arrays `ar` and `gar` together on rank 0 specified by the `root` argument.
This means that our final summed matrix for all components of the solution is on the MPI process with rank 0.
We can then check if we have any cells with values greater than one, and return that value if we're on rank 0.
Otherwise, we can just return false since no other rank has the final array.
```python
    gar = np.zeros((9 * 9 * 3,), dtype=np.int64)
    comm.Reduce([ar.flatten(), MPI.INT], [gar, MPI.INT], op=MPI.SUM, root=0)
    comm.Barrier()
    return max(gar.flatten()) < 2 if 0 == comm.rank else False
```

Here I run the example on 5 processes, and we see we get the same solution as with our serial example.
```console
$ mpirun -n 5 python ./src/python/lc-valid-sudoku-mpi.py
Running with size 5
True
True
False
False
```

## Fortran

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
