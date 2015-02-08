open Real

fun sumlist [] = 0.0
  | sumlist (x::xs) = x + sumlist(xs)

fun squarelist [] = []
  | squarelist ((x:real)::xs) = (x*x)::(squarelist(xs))

(* The following functions assume that the list in not empty.*)
fun mean l = sumlist(l)/(fromInt(length(l)))

(*This function will make a list of the difference between each member of a list and the mean*)
fun meanDiff ([], (m:real)) = [] 
	| meanDiff  (x::xs, (m:real)) = (x-m)::(meanDiff(xs, m))


fun variance l = sumlist(squarelist(meanDiff(l, mean(l))))/(fromInt(length(l)))
