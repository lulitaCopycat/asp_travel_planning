%create destination pairs:
{first_destination(D): dest(_,_,D)}=1.
{travel_to(A,B): dest(_,_,B)}=1:- dest(_,_,A).
travel_to(S,B):- start_at(_,_,S), first_destination(B).
last_stop(D):- travel_to(D,L), first_destination(L), dest(_,_,D).
last_journey(L,S):- last_stop(L),start_at(_,_,S).
travel_to(L,S):- last_journey(L,S).


%constraints:
:- travel_to(A,A).
:- travel_to(A,B), travel_to(A,C), B!=C, dest(_,_,B), dest(_,_,C).
:- travel_to(A,C), travel_to(B,C), A!=B, dest(_,_,A), dest(_,_,B).
:- travel_to(A,B), travel_to(B,A), B!=A.
:- not last_journey(_,B), start_at(_,_,B).

%output
#show travel_to/2.
