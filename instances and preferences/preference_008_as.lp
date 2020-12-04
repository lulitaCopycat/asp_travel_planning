#preference(distance, less(weight)){
    D::total_travelled_distance(D)}.
#preference(num_continent, less(weight)){
    D::count_continents_visited(D)}.

#preference(visit_ny, more(cardinality)){
    connected_to_trip("New York")}.
#preference(num_visits_asia, more(weight)){
      S::count_desti(S,"Asia")}.

#preference(num_visits_europe, less(weight)){
      S::count_desti(S,"Europe")}.


#preference(all_prefs,pareto){**num_continent; **distance; **visit_ny; **num_visits_asia; **num_visits_europe}.

  #optimize(all_prefs).
