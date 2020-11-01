money("4000").
weeks("11").
est_nr_destinations("10").
#minimize{SUM_DIST: total_travelled_distance(SUM_DIST)}.
#minimize{SUM_CONTINENTS: count_cont_with_count(SUM_CONTINENTS)}.
