COMMENT
this is a multiline comment
COMMENT

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

[]INT i0 = (1,2,3,1);
[]INT i1 = (1,2,1,3,5,6,4);

main:(
  print(("Input #0: ", solve(i0), new line));
  print(("Input #1: ", solve(i1), new line))
)
