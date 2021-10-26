         dim i0(1 to 4) as integer ''{ 1, 2, 3, 1 }
         i0(1) = 1
         i0(2) = 2
         i0(3) = 3
         i0(4) = 1

         dim i1(1 to 7) as integer
         i1(1) = 1
         i1(2) = 2
         i1(3) = 1
         i1(4) = 3
         i1(5) = 5
         i1(6) = 6
         i1(7) = 4

         function solve(prob() as integer) as integer
             dim vals(1 to ubound(prob)+2) as integer
             vals(1) = -9999999
             vals(ubound(prob)+1) = -9999999
             for i as integer = 1 to ubound(prob)
                 vals(i) = prob(i)
                 if (vals(i)>vals(i+1) and vals(i)>vals(i-1)) then solve=i-1
             next
         end function

         print solve(i0())
         print solve(i1())
