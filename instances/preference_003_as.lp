money("4000").
weeks("11").
#preference(distance, less(weight)){
  D::total_travelled_distance(D)
%D :: travel (X ,Y), road (X ,Y ,D)
}.
#preference(num_continent, more(weight)){
  D::count_cont_with_count(D)
%D :: travel (X ,Y), road (X ,Y ,D)
}.
#preference(both,pareto){**num_continent; **distance}.
#optimize(both).
