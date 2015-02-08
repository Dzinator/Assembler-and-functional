(* Yanis Hattab - 260535922 *)
(* Assignment 6 *)





(* basic definitions and the "take" function. *)
datatype 'a susp = Susp of (unit -> 'a)

fun delay f = Susp f

fun force (Susp f) = f ()

datatype 'a str = Str of {hd: 'a, tl : ('a str) susp} 


 (* Inspect a stream up to n elements *)
fun take n (Str s) = case n of 
   0 => []
  | n => (#hd s) :: take (n-1) (force (#tl s))


(*Things needed to implement the primes stream by sieve of Erasthosthenes *)
fun find_hd p (Str s) = 
  if  p ((#hd s)) then ((#hd s), (#tl s))
  else find_hd p (force (#tl s))

fun filter p (x as Str s) = 
	let val (h,t) = find_hd p x in 
		Str{hd = h,
 			tl = Susp (fn () => filter p (force t))} end

fun nats_from n = Str{hd = n, tl = Susp (fn () => nats_from (n+1))}

(* A utility to print part of a stream; it prints the first n elements of s. *)
fun printIntStr s n = List.app (fn x => print ((Int.toString x)^" ")) (take n s)

(* Just a few lines of code, 3 or 4, will do it. *)



(* Question 1 *)

fun infiniteDecimal a b = let val x = floor(real(a)/real(b)) in
								let val y = ((a-(x*b))*10) in
									Str{hd = x, 
									tl = Susp(fn () => infiniteDecimal y b)}
								end
							end

(* Testing )
val oneHalf = infiniteDecimal 1 2;
take 5 oneHalf;
val threeSeventh = infiniteDecimal 3 7;
take 10 threeSeventh;
( End of testing*)




(* Question 2 *)

fun divisible (x,y) = ((y mod x) = 0)

fun sieve (Str s) = let fun divBy z = not(divisible((#hd s),z)) in
							 Str{hd = (#hd s), 
							 tl = Susp (fn () => sieve (filter divBy (force(#tl s))))}
						end

val primes = sieve (nats_from 2);

(* Testing )
printIntStr primes 25;
( End of testing*)


