From Maniunfold.Has Require Export
  Addition Zero Negation
  Multiplication One.
From Maniunfold.Is Require Export
  OneSortedRing Commutative.

(** Commutative ring. *)

Class IsCommRing (A : Type)
  `(HasAdd A) `(HasZero A) `(HasNeg A)
  `(HasMul A) `(HasOne A) : Prop := {
  A_add_zero_neg_mul_one_is_ring :> IsRing add zero neg mul one;
  A_mul_is_comm :> IsComm mul;
}.
