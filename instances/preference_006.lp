money("4000").
weeks("11").

#minimize{SUM_DIST: total_travelled_distance(SUM_DIST)}.
#minimize{SUM_CONTINENTS: count_cont_with_count(SUM_CONTINENTS)}.
%#minimize{S: count_desti(S,C), C="Europe"}.
#maximize{S: count_desti(S,C), C="Asia"}.
#maximize{S: connected_to_trip(S), S="New York"}.
