Set Warnings "-notation-overridden".

From Coq Require Extraction Setoid ZArith.

Module Classes.

Export Setoid Morphisms.

(* Definition relation (A : Type) : Type :=
  A -> A -> Prop.

Definition respectful {A B : Type}
  (R : relation A) (S : relation B) (f g : A -> B) : Prop :=
  forall x y : A, R x y -> S (f x) (g y).

Definition Proper {A : Type} (R : relation A) (x : A) : Prop :=
  R x x.

Reserved Notation "R '==>' S" (at level 55, right associativity).
Notation "R '==>' S" := (respectful R S). *)
Reserved Notation "x '::>' R" (at level 60, right associativity).
Notation "x '::>' R" := (Proper R x).

Class Eqv (A : Type) : Type := eqv : A -> A -> Prop.
Class Opr (A : Type) : Type := opr : A -> A -> A.
Class Idn (A : Type) : Type := idn : A.
Class Inv (A : Type) : Type := inv : A -> A.

Reserved Notation "x '==' y" (at level 70, no associativity).
Notation "x '==' y" := (eqv x y).
Notation "x '+' y" := (opr x y).
Notation "'0'" := idn.
Notation "'-' x" := (inv x).
Notation "x '-' y" := (x + (- y)).

Class Setoid (A : Type) {eqv : Eqv A} : Prop := {
  ref : forall x : A, x == x;
  sym : forall x y : A, x == y -> y == x;
  tra : forall x y z : A, x == y -> y == z -> x == z;
}.

Class Semigroup (A : Type) {eqv : Eqv A} {opr : Opr A} : Prop := {
  setoid :> Setoid A;
  opr_pro : opr ::> eqv ==> eqv ==> eqv;
  ass : forall x y z : A, (x + y) + z == x + (y + z);
}.

Class Monoid (A : Type) {eqv : Eqv A} {opr : Opr A} {idn : Idn A} : Prop := {
  semigroup :> Semigroup A;
  idn_l : forall x : A, 0 + x == x;
  idn_r : forall x : A, x + 0 == x;
}.

Class Group (A : Type) {eqv : Eqv A}
  {opr : Opr A} {idn : Idn A} {inv : Inv A} : Prop := {
  monoid :> Monoid A;
  inv_pro : inv ::> eqv ==> eqv;
  inv_l : forall x : A, (- x) + x == 0;
  inv_r : forall x : A, x + (- x) == 0;
}.

Add Parametric Relation {A : Type} {eqv' : Eqv A}
  {std' : Setoid A} : A eqv
  reflexivity proved by ref
  symmetry proved by sym
  transitivity proved by tra
  as eqv_relation.

Add Parametric Morphism {A : Type} {eqv' : Eqv A}
  {opr' : Opr A} {sgr' : Semigroup A} : opr
  with signature eqv ==> eqv ==> eqv
  as eqv_opr_morphism.
Proof.
  intros x y p z w q.
  destruct sgr' as [_ opr_pro _].
  cbv in opr_pro. apply opr_pro.
  - apply p.
  - apply q. Qed.

Add Parametric Morphism {A : Type} {eqv' : Eqv A}
  {opr' : Opr A} {idn' : Idn A} {inv' : Inv A} {grp' : Group A} : inv
  with signature eqv ==> eqv
  as eqv_inv_morphism.
Proof.
  intros x y p.
  destruct grp' as [_ inv_pro _ _].
  cbv in inv_pro. apply inv_pro. apply p. Qed.

End Classes.

Module Properties.

Import Classes.

Theorem ivl : forall {A : Type} {eqv : Eqv A}
  {opr : Opr A} {idn : Idn A} {inv : Inv A} {grp : Group A},
  forall x : A, - (- x) == x.
Proof.
  intros A eqv opr idn inv grp x.
  destruct grp as [[[ps pop pa] pnl pnr] pvp pvl pvr] eqn : pg.
  rewrite <- (pnr (- (- x))). rewrite <- (pvl x).
  rewrite <- (pa (- (- x)) (- x) x). rewrite (pvl (- x)). rewrite (pnl x).
  reflexivity. Qed.

Lemma inj_l : forall {A : Type} {eqv : Eqv A}
  {opr : Opr A} {idn : Idn A} {inv : Inv A} {grp : Group A},
  forall x y z : A, z + x == z + y -> x == y.
Proof.
  intros A eqv opr idn inv grp x y z p.
  destruct grp as [[[ps pop pa] pnl pnr] pvp pvl pvr] eqn : pg.
  rewrite <- (pnl x). rewrite <- (pvl z). rewrite (pa (- z) z x).
  rewrite p. rewrite <- (pa (- z) z y). rewrite (pvl z). rewrite (pnl y).
  reflexivity. Qed.

Lemma inj_r : forall {A : Type} {eqv : Eqv A}
  {opr : Opr A} {idn : Idn A} {inv : Inv A} {grp : Group A},
  forall x y z : A, x + z == y + z -> x == y.
Proof.
  intros A eqv opr idn inv grp x y z p.
  destruct grp as [[[ps pop pa] pnl pnr] pvp pvl pvr] eqn : pg.
  rewrite <- (pnr x). rewrite <- (pvr z). rewrite <- (pa x z (- z)).
  rewrite p. rewrite (pa y z (- z)). rewrite (pvr z). rewrite (pnr y).
  reflexivity. Qed.

Theorem dis : forall {A : Type} {eqv : Eqv A}
  {opr : Opr A} {idn : Idn A} {inv : Inv A} {grp : Group A},
  forall x y : A, - (y + x) == (- x) + (- y).
Proof.
  intros A eqv opr idn inv grp x y.
  apply (inj_l (- (y + x)) ((- x) + (- y)) (y + x)).
  destruct grp as [[[ps pop pa] pnl pnr] pvp pvl pvr] eqn : pg.
  rewrite (pvr (y + x)). rewrite <- (pa (y + x) (- x) (- y)).
  rewrite (pa y x (- x)). rewrite (pvr x). rewrite (pnr y). rewrite (pvr y).
  reflexivity. Qed.

End Properties.

Module Instances.

Import ZArith Z Classes.

Open Scope Z_scope.

Instance Z_Eqv : Eqv Z := fun x y : Z => x = y.

Instance Z_Setoid : Setoid Z := {
  ref := _;
  sym := _;
  tra := _;
}.
Proof.
  all: cbv [eqv].
  all: cbv [Z_Eqv].
  - apply eq_refl.
  - apply eq_sym.
  - apply eq_trans. Qed.

Instance Z_Opr : Opr Z := fun x y : Z => x + y.

Instance Z_Semigroup : Semigroup Z := {
  opr_pro := _;
  ass := _;
}.
Proof.
  all: cbv [eqv opr].
  all: cbv [Z_Eqv Z_Opr].
  - apply add_wd.
  - intros x y z. rewrite add_assoc. reflexivity. Qed.

Instance Z_Idn : Idn Z := 0.

Instance Z_Monoid : Monoid Z := {
  idn_l := _; idn_r := _;
}.
Proof.
  all: cbv [eqv opr idn].
  all: cbv [Z_Eqv Z_Opr Z_Idn].
  - intros x. rewrite add_0_l. reflexivity.
  - intros x. rewrite add_0_r. reflexivity. Qed.

Instance Z_Inv : Inv Z := fun x => - x.

Instance Z_Group : Group Z := {
  inv_pro := _;
  inv_l := _; inv_r := _;
}.
Proof.
  all: cbv [eqv opr idn inv].
  all: cbv [Z_Eqv Z_Opr Z_Idn Z_Inv].
  - apply opp_wd.
  - intros x. rewrite add_opp_diag_l. reflexivity.
  - intros x. rewrite add_opp_diag_r. reflexivity. Qed.

End Instances.

Module Computations.

Section Input.

Import ZArith Z.

Open Scope Z_scope.

Definition meaning := 42.
Definition luck := 13.

End Input.

Section Output.

Import Classes.

Example fate := meaning - luck.

End Output.

Section Test.

Import ZArith Z.

Open Scope Z_scope.

Compute if eq_dec fate 29 then true else false.

End Test.

End Computations.

Extraction "example.ml" Classes Properties Instances Computations.
