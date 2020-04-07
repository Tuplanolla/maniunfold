From Maniunfold.Has Require Export
  OneSorted.BinaryOperation ThreeSorted.Graded.BinaryFunction.
From Maniunfold.ShouldHave Require Import
  OneSorted.AdditiveNotations.

(** Graded action; left chirality.
    See [Has.OneSorted.LeftAction]. *)

Class HasGrdRAct {A : Type} (P Q : A -> Type)
  {A_has_bin_op : HasBinOp A} : Type :=
  grd_r_act : forall i j : A, Q i -> P j -> Q (i + j).

Typeclasses Transparent HasGrdRAct.

Section Context.

Context {A : Type} {P Q : A -> Type} `{P_Q_has_grd_r_act : HasGrdRAct A P Q}.

Global Instance Q_P_Q_has_grd_bin_fn : HasGrdBinFn Q P Q := grd_r_act.

End Context.
