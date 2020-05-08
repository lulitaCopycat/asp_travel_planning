start(N):- start_at(_,_,N).

%{travel_to(A,B)}=1:- start(A), dest(_,_,B).
%{first_destination(D): dest(_,_,D)}=1.
{travel_to(A,B): dest(_,_,A)}=1:- dest(_,_,B).


%constraints:
% set abs values for calculation of distances
:- travel_to(A,A).
:- travel_to(A,B), travel_to(A,C), B!=C.
:- travel_to(A,C), travel_to(B,C), A!=B.
:- travel_to(A,B), travel_to(B,A), B!=A.

%output

#show travel_to/2.
