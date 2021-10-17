import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import pprint

pp = pprint.PrettyPrinter(indent=4)
import sudoku_9x9

shape = sudoku_9x9.shape()
blksz = sudoku_9x9.blksz()


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
