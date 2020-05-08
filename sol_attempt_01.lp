

start(N):- start_at(_,_,N).

%{travel_to(A,B)}=1:- start(A), dest(_,_,B).
{travel_to(A,B): dest(_,_,A)}=1:- dest(_,_,B).
%next_dest(D):- dest(_,_,D), not visited(D).
%next_dest(D):- dest(_,_,D).
%visited(D):- travel_to(_,D), dest(_,_,B) .

%hop(N, D):- start(N), dest(D).
%hop(N, D):- visited(N), next_dest(D).

%constraints:
% set abs values for calculation of distances
%:- not visited(D), dest(_,_,D).
:- travel_to(A,A).
%output
#show start/1.
%#show visited/1.
%#show next_dest/1.
#show travel_to/2.
