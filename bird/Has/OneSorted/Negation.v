From Maniunfold.Has Require Export
  OneSorted.UnaryOperation.

Class HasNeg (A : Type) : Type := neg : A -> A.

Typeclasses Transparent HasNeg.

Section Context.

Context {A : Type} `{A_has_neg : HasNeg A}.

Global Instance A_has_un_op : HasUnOp A := neg.

End Context.
