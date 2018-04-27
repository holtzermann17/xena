import data.equiv
#check equiv.refl 

universes u v w

class transportable (f : Type u → Type v) :=
(on_equiv : Π {α β : Type u} (e : equiv α β), equiv (f α) (f β))
(on_refl  : Π (α : Type u), on_equiv (equiv.refl α) = equiv.refl (f α))
(on_trans : Π {α β γ : Type u} (d : equiv α β) (e : equiv β γ), on_equiv (equiv.trans d e) = equiv.trans (on_equiv d) (on_equiv e))

-- Our goal is an automagic proof of the following (level 20)
theorem group.transportable : transportable group := sorry

-- These we might need to define and prove by hand
def Const : Type u → Type v := λ α, punit
def Fun : Type u → Type v → Type (max u v) := λ α β, α → β
def Prod : Type u → Type v → Type (max u v) := λ α β, α × β
def Swap : Type u → Type v → Type (max u v) := λ α β, β × α

-- level 1
lemma Const.transportable : (transportable Const) := { 
  on_equiv := λ α β H,⟨λ _,punit.star,λ _,punit.star,λ α,begin cases α,simp end,λ α,begin cases α,simp end⟩,
  --I was repeating myself in that last line.
  on_refl := λ α,begin 
  congr,
  { funext s,cases s,refl},
  { funext s,cases s,refl} -- I just wrote this
  end,
  on_trans := λ α β γ Hαβ Hβγ,by congr
  }  
lemma Fun.transportable (α : Type u) : (transportable (Fun α)) := sorry
lemma Prod.transportable (α : Type u) : (transportable (Prod α)) := sorry
lemma Swap.transportable (α : Type u) : (transportable (Swap α)) := sorry


-- And then we can define
def Hom1 (α : Type u) : Type v → Type (max u v) := λ β, α → β
def Hom2 (β : Type v) : Type u → Type (max u v) := λ α, α → β
def Aut : Type u → Type u := λ α, α → α

-- And hopefully automagically derive
lemma Hom1.transportable (α : Type u) : (transportable (Hom1 α)) := sorry
lemma Hom2.transportable (β : Type v) : (transportable (Hom1 β)) := sorry
lemma Aut.transportable (α : Type u) : (transportable Aut) := sorry

-- If we have all these in place...
-- A bit of magic might actually be able to derive `group.transportable` on line 11.
-- After all, a group just is a type plus some functions... and we can now transport functions.