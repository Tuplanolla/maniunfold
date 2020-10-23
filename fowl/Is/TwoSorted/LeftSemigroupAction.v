(* bad *)
From Maniunfold.Has Require Export
  OneSorted.BinaryOperation TwoSorted.LeftAction.
From Maniunfold.Is Require Export
  OneSorted.Semigroup TwoSorted.LeftMagmaAction TwoSorted.LeftCompatible.

Class IsLSgrpAct (A B : Type)
  `(HasBinOp A) `(HasLAct A B) : Prop := {
  A_bin_op_is_sgrp :> IsSgrp (bin_op (A := A));
  A_B_bin_op_l_act_is_l_sgrp_act :> IsLMagAct bin_op l_act;
  A_B_bin_op_l_act_is_l_compat :> IsLCompat bin_op l_act;
}.
