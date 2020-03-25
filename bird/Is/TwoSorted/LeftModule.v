From Maniunfold.Has Require Export
  EquivalenceRelation Addition Zero Negation Multiplication One
  BinaryOperation NullaryOperation UnaryOperation LeftAction.
From Maniunfold.Is Require Export
  OneSorted.Ring TwoSorted.LeftRightDistributive TwoSorted.LeftCompatible
  OneSorted.AbelianGroup TwoSorted.LeftLeftDistributive TwoSorted.LeftUnital.

(** This is a unital left module. *)

Class IsLMod {A B : Type}
  (A_has_add : HasAdd A) (A_has_zero : HasZero A) (A_has_neg : HasNeg A)
  (A_has_mul : HasMul A) (A_has_one : HasOne A)
  (B_has_add : HasAdd B) (B_has_zero : HasZero B) (B_has_neg : HasNeg B)
  (A_B_has_l_act : HasLAct A B) : Prop := {
  add_zero_neg_mul_one_is_ring :> IsRing (A := A) add zero neg mul one;
  add_zero_neg_is_ab_grp :> IsAbGrp (A := B) add zero neg;
  add_add_l_act_is_two_l_r_distr :>
    IsTwoLRDistr (A := A) (B := B) add add l_act;
  mul_l_act_is_l_compat :> IsLCompat (A := A) (B := B) mul l_act;
  zero_l_act_is_two_l_unl :> IsTwoLUnl (A := A) (B := B) zero l_act;
  add_l_act_is_two_l_l_distr :> IsTwoLLDistr (A := A) (B := B) add l_act;
}.