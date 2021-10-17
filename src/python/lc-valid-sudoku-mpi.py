import os
import sys

sys.path.insert(0, os.path.dirname(__file__))
import pprint

pp = pprint.PrettyPrinter(indent=4)
import sudoku_9x9
from mpi4py import MPI
import copy
import itertools
import numpy as np

shape = sudoku_9x9.shape()
blksz = sudoku_9x9.blksz()

comm = MPI.COMM_WORLD

def solve(board, comm):
    ar = np.zeros((9, 9, 3), dtype=np.int64)
    work = shape * shape
    chunk = (work + comm.size - 1) // comm.size
    subscripts = (*itertools.product(range(9), range(9)),)
    for i in range(comm.rank * chunk, (comm.rank * chunk)+chunk):
        if i >= work: break
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
    gar = np.zeros((9*9*3,), dtype=np.int64)
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
