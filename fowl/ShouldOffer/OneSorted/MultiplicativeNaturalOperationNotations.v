From Maniunfold.Offers Require Export
  OneSorted.NaturalOperations.
From Maniunfold.ShouldHave Require Export
  OneSorted.MultiplicativeNotations.

Notation "x '^' n" := (nat_op bin_op null_op n x) : nat_scope.
Notation "x '^' n" := (n_op bin_op null_op n x) : N_scope.

Notation "'_^_'" := (flip (nat_op bin_op null_op)) (only parsing) : nat_scope.
Notation "'_^_'" := (flip (n_op bin_op null_op)) (only parsing) : N_scope.
