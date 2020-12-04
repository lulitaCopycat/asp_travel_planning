start_at("53.53167", "13.381777", "Berlin", "Europe").
#preference(distance, less(weight)){
  D::total_travelled_distance(D)
}.
#preference(num_continents, more(weight)){
  D::count_continents_visited(D)
}.
#preference(both,pareto){**num_continents; **distance}.
#optimize(both).
