/* The go to depot goal */

+!goto_depot
  :  depot(_,DX,DY) & carrying_gold(N) & N > 0
  <- .print("Going to depot to deliver ",N," golds.");
     // announce to others all golds I perceived that are not handled/announced yet
     .findall(gold(X,Y),gold(X,Y)[source(self)],L);
     !announce_not_handled_golds(L);
     !pos(DX,DY);
     !ensure(drop,0);
     !leave_depot;
     !!choose_goal.
-!goto_depot
  <- .print("I can not finish 'go to depot'!");
     !!choose_goal.

+!announce_not_handled_golds([]).
+!announce_not_handled_golds([G|R])
   :  not committed_to(G,_) & not announced(G)
   <- .print("Announcing ",G, ", since I am going to depot and that gold was not handled by me (although I perceived it).");
      .broadcast(tell,G);
      +announced(G);
      !announce_not_handled_golds(R).
+!announce_not_handled_golds([_|R])
   <- !announce_not_handled_golds(R).

+!ensure(drop, N) : carrying_gold(0).
+!ensure(drop, N)
  :  N < 4 & depot(_,X,Y) & pos(X,Y,_)
  <- do(drop);
     !ensure(drop,N+1).


// leave depot: prefer go towards an enemy, so I push it out
// (actions in depot do not fail!!!)

+!leave_depot <- .send(agenti_leader,tell,finished).

