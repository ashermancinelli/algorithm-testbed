# cmake-format: off
set(GOOD_ONLINE
  2 9 4  8 6 3  5 1 7
  7 1 5  4 2 9  6 3 8
  8 6 3  7 5 1  4 9 2
  
  1 5 2  9 4 7  8 6 3
  4 7 9  3 8 6  2 5 1
  6 3 8  5 1 2  9 7 4
  
  9 8 6  1 3 4  7 2 5
  5 2 1  6 7 8  3 4 9
  3 4 7  2 9 5  1 8 6
  )

set(BAD_ONLINE 
  2 9 4  8 6 3  5 1 7
  7 1 5  4 2 9  6 3 8
  8 6 3  7 5 1  4 9 2
  
  1 5 2  9 4 7  8 6 3
  4 7 9  3 8 6  2 5 1
  6 3 8  5 1 2  9 7 4
  
  9 8 6  1 3 4  7 2 5
  5 2 1  6 7 8  3 4 9
  3 1 7  2 9 5  1 8 6
  )

set(GOOD
  5 3 0  0 7 0  0 0 0
  6 0 0  1 9 5  0 0 0
  0 9 8  0 0 0  0 6 0

  8 0 0  0 6 0  0 0 3
  4 0 0  8 0 3  0 0 1
  7 0 0  0 2 0  0 0 6

  0 6 0  0 0 0  2 8 0
  0 0 0  4 1 9  0 0 5
  0 0 0  0 8 0  0 7 9
  )

set(BADR
  5 3 0  0 7 0  0 5 0
  6 0 0  1 9 5  0 0 0
  0 9 8  0 0 0  0 6 0

  8 0 0  0 6 0  0 0 3
  4 0 0  8 0 3  0 0 1
  7 0 0  0 2 0  0 0 6

  0 6 0  0 0 0  2 8 0
  0 0 0  4 1 9  0 0 5
  0 0 0  0 8 0  0 7 9
  )

set(BADC
  5 3 0  0 7 0  0 5 0
  6 0 0  1 9 5  0 0 0
  0 9 8  0 0 0  0 6 0

  8 0 0  0 6 0  0 0 3
  4 0 0  8 0 3  0 0 1
  7 0 0  0 2 0  0 0 6

  0 6 0  0 0 0  2 8 0
  5 0 0  4 1 9  0 0 5
  0 0 0  0 8 0  0 7 9
  )

set(BADB
  8 3 0  0 7 0  0 0 0
  6 0 0  1 9 5  0 0 0
  0 9 8  0 0 0  0 6 0

  8 0 0  0 6 0  0 0 3
  4 0 0  8 0 3  0 0 1
  7 0 0  0 2 0  0 0 6

  0 6 0  0 0 0  2 8 0
  0 0 0  4 1 9  0 0 5
  0 0 0  0 8 0  0 7 9
  )
# cmake-format: on

set(SHAPE 9)
set(BLKSZ 3)

function(idx2 R C RET)
  math(EXPR _RET "(${R} * ${SHAPE}) + ${C}")
  set(${RET} ${_RET} PARENT_SCOPE)
endfunction()

function(idx3 R C T RET)
  math(EXPR _RET "(((${R} * ${SHAPE}) + ${C}) * ${BLKSZ}) + ${T}")
  set(${RET} ${_RET} PARENT_SCOPE)
endfunction()

function(tl R RET)
  math(EXPR _RET "${R} - ${R} % ${BLKSZ}")
  set(${RET} ${_RET} PARENT_SCOPE)
endfunction()

function(blockidx R C RET)
  math(EXPR _RET "(${R} / ${BLKSZ}) * ${BLKSZ} + (${C} / ${BLKSZ})")
  set(${RET} ${_RET} PARENT_SCOPE)
endfunction()

function(incr_at AR IDX RET)
  list(GET AR ${IDX} VAL)
  math(EXPR VAL "${VAL}+1")
  list(REMOVE_AT AR ${IDX})
  list(INSERT AR ${IDX} ${VAL})
  set(${RET} ${AR} PARENT_SCOPE)
endfunction()
