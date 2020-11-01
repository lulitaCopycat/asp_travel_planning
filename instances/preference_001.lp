money("4000").
weeks("11").
#minimize{SUM_DIST: total_travelled_distance(SUM_DIST)}.
#maximize{SUM_CONTINENTS: count_cont_with_count(SUM_CONTINENTS)}.
