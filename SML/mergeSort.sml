
fun split [] = ([],[])
    | split [x] = ([x],[])
    | split (x::y::xs) = 
      let val (A,B) = split(xs) in
	  (x::A, y::B)
	  end

fun merge ([], []) = []
     | merge (l1, []) = l1
     | merge ([], l2) = l2
     | merge (x::xs, y::ys) = if (x < y) then x::merge(xs, y::ys) else y::merge(x::xs, ys)


fun mergesort [] = []
     | mergesort [x] = [x]
     | mergesort [x,y] = if (x < y) then [x,y] else [y,x]
     | mergesort l =
       let val (A,B) = split(l) in merge(mergesort(A), mergesort(B)) end
