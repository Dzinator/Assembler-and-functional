(*Q2*)
fun member (m, []) = false
    | member (m, x::xs) = ((m = x) orelse (member(m, xs)))

fun remove (m, []) = []
    | remove (m, x::xs) = if (m = x) then remove(m, xs) else x::(remove(m, xs))

 
(*Q3*) 
fun isolate [] = []
    | isolate (x::xs) = if member(x, xs) then x::isolate(remove(x, xs)) else x::isolate(xs)


(*Q4*)
fun common ([], []) = []
    | common (l1, []) = []
    | common ([], l2) = []
    | common (l1, l2) = let val x::xs = isolate(l1) in
			    if member(x, l2) then x::common(xs, l2)  else common(xs, l2)
			end



