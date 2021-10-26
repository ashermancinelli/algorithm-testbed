;i0 ← 1‿2‿3‿1
;i1 ← ⟨1,2,1,3,5,6,4⟩
;i2 ← 2‿1‿2‿3‿1
;F ← ({0∾((2-˜≠𝕩)⥊1)∾0}∧(«<⊢)∧(⊢>»))⊐(1˙)
;F ¨ i0‿i1‿i2

(define shl
  (lambda (v l)
    (reverse (cons v (reverse (cdr l))))))

(define shr
  (lambda (v l)
    (cons v (reverse (cdr (reverse l))))))

(define solve
  (lambda (input)
    (reduce max 0
            (map
              (lambda (a b)
                (if a b -1))
              (map >
                   input
                   (map max
                        (shl -99999 input)
                        (shr -99999 input)))
              (iota (length input)))))))

(for-each
  (lambda (l)
    (newline)
    (display (solve l))
    (newline))
  (list
    '(1 2 3 1)
    '(1 2 1 3 5 6 4)
    '(2 1 2 3 2 1)))
