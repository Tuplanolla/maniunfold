From Maniunfold.Has Require Export
  OneSorted.Addition OneSorted.Zero OneSorted.Negation
  OneSorted.Multiplication OneSorted.One
  TwoSorted.LeftAction TwoSorted.RightAction.
From Maniunfold.Is Require Export
  OneSorted.Ring TwoSorted.Bimodule TwoSorted.BilinearOperator.

(** Noncommutative nonunital nonassociative algebra over a noncommutative ring.
    The ring is carried by [A] and the algebra by [B].
    Informally, this is the magma of algebralike structures. *)

Class IsAlg (A B : Type)
  `(HasAdd A) `(HasZero A) `(HasNeg A)
  `(HasMul A) `(HasOne A)
  `(HasAdd B) `(HasZero B) `(HasNeg B)
  `(HasMul B)
  `(HasLAct A B) `(HasRAct A B) : Prop := {
  A_add_zero_neg_mul_one_is_ring :> IsRing A add zero neg mul one;
  A_B_add_zero_neg_mul_one_add_zero_neg_l_act_r_act_is_two_bimod :>
    IsTwoBimod A B add zero neg mul one add zero neg l_act r_act;
  A_B_add_zero_neg_mul_one_add_zero_neg_mul_l_act_r_act_is_bilin_op :>
    IsBilinOp A B add zero neg mul one add zero neg l_act r_act mul;
}.
