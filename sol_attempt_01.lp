%start(N):- start_at(_,_,N).

%{travel_to(A,B)}=1:- start(A), dest(_,_,B).
{first_destination(D): dest(_,_,D)}=1.
last_stop(D):- travel_to(D,L), first_destination(L), dest(_,_,D).
%travel_to(S,D):- start_at(_,_,S), dest(_,_,D).
{travel_to(A,B): dest(_,_,A)}=1:- dest(_,_,B).
travel_to(S,B):- first_destination(B), start_at(_,_,S).
last_journey(L,S):- last_stop(L),start_at(_,_,S).
travel_to(L,S):- last_journey(L,S).
travel_to(L,S):- last_stop(L),start_at(_,_,S).

%constraints:
% set abs values for calculation of distances
:- travel_to(A,A).
:- travel_to(A,B), travel_to(A,C), B!=C, dest(_,_,B), dest(_,_,C).
:- travel_to(A,C), travel_to(B,C), A!=B, dest(_,_,A), dest(_,_,B).
:- travel_to(A,B), travel_to(B,A), B!=A.
:- not last_journey(_,B), start_at(_,_,B).

%:- last_journey(A,B), start_at(_,_,B), dest(_,_,A), travel_to(A,C), dest(_,_,C).
%, start_at(_,_,B), dest(_,_,A).
%:- travel_to(A,C), travel_to(B,C), A!=B, dest(_,_,A), start_at(_,_,B).


%output
%#show first_destination/1.
%#show last_stop/1.
#show travel_to/2.

%#show connection/2.
%#show travel_to/2.
