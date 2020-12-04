start_at("53.53167", "13.381777", "Berlin", "Europe").
#preference(distance, less(weight)){
   D::total_travelled_distance(D)}.
#preference(num_continent, less(weight)){
   D::count_continents_visited(D)}.
#preference(num_visits_europe, less(cardinality)){
  count_desti(S,"Europe")}.
#preference(num_visits_asia, more(cardinality)){
  count_desti(S,"Asia")}.
#preference(all_prefs,pareto){
  **num_continent; **distance; **num_visits_europe; **num_visits_asia}.
#optimize(all_prefs).
