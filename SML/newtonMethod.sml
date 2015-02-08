fun abs (x:real) = if (x < 0.0) then ~x else x
fun close (x:real,y:real,tol) = (abs(x-y) < tol)
exception DivZero
exception Diverge
fun deriv (f, dx:real) = fn x => ((f(x + dx) - f(x))/dx)

(* In order to avoid divde-by-zero situations we raise an exception. *)
fun improve(guess:real,f,tol) = 
  let
      val den = deriv(f,tol)(guess)
  in
    if (close(den,0.0,tol)) then raise DivZero
    else 
	guess - (f(guess) / den)
  end

(* In order to avoid divergence, we abort the computation if it takes more
than 10000 steps. *)

fun newton (f,guess:real,tol:real) =
  let
    fun helper (f,guess:real,tol:real,counter:int) =
      if (counter = 0) then raise Diverge
      else
	  let val xn = improve(guess,f,tol) in 
	      if abs(f(xn)) < tol then xn
	      else helper(f, xn, tol, (counter-1)) 
	end
  in
    helper(f,guess,tol,10000)
  end
