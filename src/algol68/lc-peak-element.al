PROC solve = ([]INT elements)INT: (
  INT found := -1;
  [1:(UPB elements)+1]INT vs;
  vs[1] := - 999 999 999;
  vs[UPB elements] := - 999 999 999;
  FOR i FROM LWB elements TO UPB elements DO vs[1+i] := elements[i] OD;

  FOR i FROM 2 TO UPB elements DO
    IF vs[i] > vs[i+1] AND vs[i] > vs[i-1] THEN found := i-1 FI
  OD;
  found
);

main:(
  []INT i0 = (1,2,3,1);
  []INT i1 = (1,2,1,3,5,6,4);

  print(("Input #0: ", solve(i0), new line));
  print(("Input #1: ", solve(i1), new line))
)
