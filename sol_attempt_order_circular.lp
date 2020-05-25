%create destination pairs:
{first_destination(D): dest(_,_,D)}=1.
{travel_to(A,B): dest(_,_,B)}=1:- dest(_,_,A).
travel_to(S,B):- start_at(_,_,S), first_destination(B).
last_stop(D):- travel_to(D,L), first_destination(L), dest(_,_,D).
last_journey(L,S):- last_stop(L),start_at(_,_,S).
travel_to(L,S):- last_journey(L,S).

%introduce an other variable to eliminate the trip from the last destination back to the first destination,
% which is part of travel_to(_,_).
display_connection(F,T):- travel_to(F,T), dest(_,_,F),dest(_,_,T), not first_destination(T).
display_connection(F,T):- travel_to(F,T), start_at(_,_,F),first_destination(T).
display_connection(F,T):- last_journey(F,T).


connected_to_trip(D):- last_journey(D,_).
connected_to_trip(D):- first_destination(D).
connected_to_trip(D):- last_journey(F,_), travel_to(D,F).
connected_to_trip(D):- travel_to(D,F), connected_to_trip(F).
connected_to_trip(D):- travel_to(F,D), connected_to_trip(F).

%collect the values relevant for distance calculation in a single atom:
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), dest(LAT_F,LONG_F,F),dest(LAT_T,LONG_T,T).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), start_at(LAT_F,LONG_F,F),dest(LAT_T,LONG_T,T).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), dest(LAT_F,LONG_F,F),start_at(LAT_T,LONG_T,T).


%for the calculation of longitude we need to distinguish the cases where both values are positive,negative or different:
%both values are pos:
long_distances(S, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F>0, LONG_T>0, S=|LONG_F-LONG_T|.
%both values are negative:
long_distances(S, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F<0, LONG_T<0, S=|LONG_F-LONG_T|.
%one value is positive, the other is negative:
%because of the negative values with min -180, we also need to consider whether the sum is smaller or bigger than 180
long_distances(S, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F>0, LONG_T<0, S=LONG_F+|LONG_T|, S<=180.
long_distances(S, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F<0, LONG_T>0, S=|LONG_F|+LONG_T, S<=180.
%if the sum is bigger than 180, we would go "the other way round", since this would be shorter:
long_distances(SM, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F>0, LONG_T<0, S=LONG_F+|LONG_T|, S>180, SM=360-S.
long_distances(SM, F,T, LONG_F, LONG_T):- long_lat_vals(_,LONG_F,F,_,LONG_T,T), LONG_F<0, LONG_T>0, S=|LONG_F|+LONG_T, S>180, SM=360-S.

%for the latitude we do not worry about the possible distance crossing Antarctica, because Airlines do not offer that
% we only distinguish between
%both values positive:
lat_distance(S, F,T, LAT_F, LAT_T):- long_lat_vals(LAT_F,_,F, LAT_T,_,T), LAT_F>=0, LAT_T>=0, S=|LAT_F-LAT_T|.
%both different:
lat_distance(S, F,T, LAT_F, LAT_T):- long_lat_vals(LAT_F,_,F, LAT_T,_,T), LAT_F<0, LAT_T>=0, S=|LAT_F|+LAT_T.
lat_distance(S, F,T, LAT_F, LAT_T):- long_lat_vals(LAT_F,_,F, LAT_T,_,T), LAT_F>=0, LAT_T<0, S=LAT_F+|LAT_T|.
% both negative:
lat_distance(S, F,T, LAT_F, LAT_T):- long_lat_vals(LAT_F,_,F, LAT_T,_,T), LAT_F<0, LAT_T<0, S=|LAT_F-LAT_T|.

distances_lat_long(F,T, LAT_DIST, LONG_DIST):- lat_distance(LAT_DIST,F,T,_,_), long_distances(LONG_DIST,F,T,_,_).
%calculate the sum of squarred longitude and latitude distances
% no possibility to get the square root in ASP, but the principle is the same as in pythagoras
sum_AB(SUM_AB,F,T):- distances_lat_long(F,T,A,B), A_COMP = A*A, B_COMP = B*B, SUM_AB = B_COMP+A_COMP.

%searching for the sequence of destinations with the smallest sum regarding the single distances between the destinations:
#minimize{SUM_AB: sum_AB(SUM_AB,_,_)}.

%constraints:
%forbid to travel from destination A to destination A:
:- travel_to(A,A).
%forbid more than one subsequent destination:
:- travel_to(A,B), travel_to(A,C), B!=C, dest(_,_,B), dest(_,_,C).
%forbid more than 1 previous destination
:- travel_to(A,C), travel_to(B,C), A!=B, dest(_,_,A), dest(_,_,B).
% forbid "Ping pong" travelling among two destinations:
:- travel_to(A,B), travel_to(B,A), B!=A.

:- not connected_to_trip(D), dest(_,_,D).
% it cannot be the case that we are not travelling back to our starting point:
:- not last_journey(_,B), start_at(_,_,B).

%output
%#show sum_AB/3.
#show display_connection/2.

%#show minimized_v/1.
