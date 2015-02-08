datatype Exptree =
Const of int |
Var of string |
Add of Exptree * Exptree |
Mul of Exptree * Exptree;

type Bindings = (string * int) list


fun lookup("",BDG as (x,y)::bdg) = NONE 
| lookup(_,[])= NONE
| lookup (s,BDG as (x,y)::bdg) = 
  if (x = s) then SOME y
	     else lookup(s,bdg);

fun eval3(Const x,bdg) = SOME x
| eval3(Var s,bdg) = lookup(s,bdg)           
| eval3(Add (l,r),bdg) = SOME (valOf(eval3(l,bdg)) + valOf(eval3(r,bdg)))
| eval3(Mul (l,r),bdg) = SOME (valOf(eval3(l,bdg)) * valOf(eval3(r,bdg)));



fun insert(a,b,[]) = [(a,b)]
| insert(a,b,((c,d)::q):Bindings) = if (a <= c) then ([(a,b)] @ [(c,d)] @ q) 
				    else ([(c,d)] @ insert(a,b,q)) 

		




