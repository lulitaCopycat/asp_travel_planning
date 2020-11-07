#preference(distance, less(weight)){
  D::total_travelled_distance(D)
}.
#preference(num_continent, more(weight)){
  D::count_cont_with_count(D)
}.
#preference(both,pareto){**num_continent; **distance}.
#optimize(both).
