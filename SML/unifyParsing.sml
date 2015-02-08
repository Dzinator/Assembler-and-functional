(* Yanis Hattab - 260535922 *)



exception OccursCheck
exception Error of string

exception NotDone

datatype tp = Int | Bool | List of tp |
  			  Arrow of tp * tp | Cross of tp * tp | TVar of (tp option) ref


(* occursCheck: (tp option) ref * tp -> unit *)
fun occursCheck (r, TVar(r' as ref(NONE))) = 
   if (r = r') then raise OccursCheck
     else 
       ()
  | occursCheck (r, TVar(r' as ref(SOME(t)))) =  occursCheck(r, t)
   | occursCheck (r, Int) = () 
   | occursCheck (r, Bool) = () 
   | occursCheck (r, Arrow(t1, t2)) = (occursCheck(r, t1); occursCheck(r, t2)) 
   | occursCheck (r, Cross(t1, t2)) = (occursCheck(r, t1); occursCheck(r, t2))
   | occursCheck (r, List(t)) = occursCheck(r, t)


(* unifiable: tp * tp -> unit *)
fun unifiable(Int, Int) = ()
  | unifiable(Bool, Bool) = ()
  | unifiable(List(t), List(s)) = unifiable(t,s)
  | unifiable(Arrow(t1, t2), Arrow(s1, s2)) =  (unifiable(t1,s1); unifiable(t2,s2))
  | unifiable(Cross(t1, t2), Cross(s1, s2)) =  (unifiable(t1,s1); unifiable(t2,s2))

  (* order of the next clauses is important *)
  | unifiable(TVar(r as ref(SOME(t))), s) = 
    unifiable(t, s) 

  | unifiable(s, TVar(r as ref(SOME(t)))) = 
    unifiable(s,t)

  | unifiable(TVar(r as ref(NONE)), TVar(s as ref(NONE))) = if r=s then ()
                                                            else r := SOME (TVar(s))

  | unifiable(TVar(r as ref(NONE)), s) = ((occursCheck(r, s); r := SOME s) handle OccursCheck => raise Error "OccursCheck")

  | unifiable(s, TVar(r as ref(NONE))) = ((occursCheck(r, s); r := SOME s) handle OccursCheck => raise Error "OccursCheck")
  | unifiable(_, _) = raise Error "Constructors do not match\n"


fun unify(t1, t2) = 
 (unifiable(t1, t2))
  handle Error msg => print (msg ^ "\n")



(* TESTING *)
(* Here are some examples to test. All the a's are just type variables. *)
val a1 : (tp option) ref = ref(NONE);
val a2 : (tp option) ref = ref(NONE);

val a3 : (tp option) ref = ref(NONE);
val a4 : (tp option) ref = ref(NONE);

val a5 : (tp option) ref = ref(NONE);
val a6 : (tp option) ref = ref(NONE);

val a7 : (tp option) ref = ref(NONE);
val a8 : (tp option) ref = ref(NONE);

(* These are the types, we will try to unify the pairs shown. *)
val t1 = Arrow(List(TVar(a1)), TVar(a2));
val t2 = Arrow(List(Int), TVar(a1));

val t3 = Arrow(List(TVar(a3)), TVar(a4));
val t4 = Arrow(List(TVar(a4)), TVar(a3));

val t5 = Arrow(List(TVar(a5)), TVar(a6));
val t6 = Arrow(List(TVar(a6)), List(TVar(a5)));

