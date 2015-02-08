datatype transactions =
         Withdraw of int | Deposit of int | Check_balance

exception wrongPassword
exception overDrawn of int

fun make_protected_account(opening_balance:int, password:string) =
    let
        val balance = ref opening_balance
        val passwd = password
    in
     let
         val acc = fn(pass, trns) => 
            if not(pass = passwd) then raise wrongPassword
            else let fun helper(Withdraw(x)) = if (!balance < x) then raise overDrawn(!balance)
                                                else (balance := !balance - x; print("The new balance is "^Int.toString(!balance)^"\n") )
                        |helper(Deposit(x)) =  (balance := !balance + x; print("The new balance is "^Int.toString(!balance)^"\n") )
                        |helper(Check_balance) = print("The balance is "^Int.toString(!balance)^"\n")
                    in helper(trns) end
         (* deleted code *)

     in
         fn (pw:string, t: transactions) =>
            (acc(pw,t)
             handle wrongPassword => print("wrong Password.\n")
                  | (overDrawn n) =>
                    print
                        ("Insufficient funds for this transaction. The balance is "^Int.toString(n)^"\n"))
     end
    end