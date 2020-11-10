#preference(distance, less(weight)){
  D::total_travelled_distance(D)}.

#preference(num_continent, more(weight)){
  D::count_continents_visited(D)}.
#preference(num_visits_europe, less(cardinality)){
  count_desti(S,"Europe")}.

#preference(num_visits_asia, more(cardinality)){
    count_desti(S,"Asia")}.


#preference(all_prefs,pareto){**num_continent; **distance; **num_visits_europe; **num_visits_asia}.
%#preference(both,pareto){**num_continent; **distance}.

#optimize(all_prefs).
