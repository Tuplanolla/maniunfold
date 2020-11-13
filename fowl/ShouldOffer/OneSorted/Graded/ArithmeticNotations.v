From Maniunfold.Offers Require Export
  OneSorted.Graded.Arithmetic.
From Maniunfold.ShouldHave Require Export
  OneSorted.Graded.ArithmeticNotations.

Notation "x '-' y" := (grd_sub _ _ _ _ _ _ _ x y) : grd_ring_scope.
Notation "x '/' y" := (grd_div _ _ _ _ _ _ _ x y) : grd_ring_scope.

Notation "'_-_'" := (grd_sub _ _ _ _ _ _ _) (only parsing) : grd_ring_scope.
Notation "'_/_'" := (grd_div _ _ _ _ _ _ _) (only parsing) : grd_ring_scope.
