From Maniunfold.Has Require Export
  OneSorted.BinaryOperation TwoSorted.LeftAction.
From Maniunfold.Is Require Export
  OneSortedly.Semigroup TwoSortedly.LeftMagmaAction TwoSortedly.LeftCompatible.

Class IsLSgrpAct {A B : Type}
  (A_has_bin_op : HasBinOp A) (A_B_has_l_act : HasLAct A B) : Prop := {
  A_bin_op_is_sgrp :> IsSgrp (A := A) bin_op;
  A_B_bin_op_l_act_is_l_sgrp_act :> IsLMagAct (A := A) (B := B) bin_op l_act;
  A_B_bin_op_l_act_is_l_compat :> IsLCompat (A := A) (B := B) bin_op l_act;
}.
