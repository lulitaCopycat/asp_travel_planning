#preference(distance, less(weight)){
  D::total_travelled_distance(D)}.
#preference(num_continent, less(weight)){
  D::count_continents_visited(D)}.
#preference(visit_ny, more(cardinality)){
  connected_to_trip("New York")}.

#preference(num_visits_asia, more(cardinality)){
    count_desti(S,"Asia")}.


#preference(all_prefs,and){**num_continent; **distance; **visit_ny; **num_visits_asia}.

#optimize(all_prefs).
