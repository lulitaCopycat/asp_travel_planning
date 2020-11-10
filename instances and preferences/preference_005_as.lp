#preference(distance, less(weight)){
  D::total_travelled_distance(D)}.
#preference(num_continent, more(weight)){
  D::count_continents_visited(D)}.
%#preference(visit_ny, subset){
%  connected_to_trip("New York")}.
#preference(visit_ny, more(cardinality)){
  connected_to_trip("New York")}.

#preference(num_visits_asia, more(cardinality)){
    count_desti(S,"Asia")}.


#preference(all_prefs,and){**num_continent; **distance; **visit_ny; **num_visits_asia}.
%#preference(both,pareto){**num_continent; **distance}.

#optimize(all_prefs).
