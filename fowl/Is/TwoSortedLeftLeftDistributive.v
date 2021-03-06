(* bad *)
From Maniunfold.Has Require Export
  Addition Action.
From Maniunfold.ShouldHave Require Import
  OneSortedArithmeticNotations TwoSortedMultiplicativeNotations.

Local Open Scope ring_scope.
Local Open Scope l_mod_scope.

Class IsTwoLDistrL (A B : Type)
  `(HasAdd B) `(HasActL A B) : Prop :=
  two_l_distr_l : forall (a : A) (x y : B), a * (x + y) = a * x + a * y.
