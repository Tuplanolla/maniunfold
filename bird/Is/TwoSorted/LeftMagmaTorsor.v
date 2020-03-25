From Maniunfold.Has Require Export
  EquivalenceRelation BinaryOperation
  LeftAction LeftTorsion.
From Maniunfold.Is Require Export
  Magma LeftGroupAction LeftUnique.

Class IsLMagTor {A B : Type}
  (A_has_bin_op : HasBinOp A)
  (A_B_has_l_act : HasLAct A B) (A_B_has_l_tor : HasLTor A B) : Prop := {
  bin_op_l_act_is_l_mag_act :> IsLMagAct bin_op l_act;
  l_act_l_tor_left_uniq :> IsLNullUniq l_act l_tor;
}.