%#preference(distance, less(cardinality)){
%    total_travelled_distance(D)}.
%#preference(num_continent, less(cardinality)){
%    count_continents_visited(D)}.
start_at("53.53167", "13.381777", "Berlin", "Europe").
#preference(distance, less(weight)){
    D::total_travelled_distance(D)}.
#preference(num_continent, less(weight)){
    D::count_continents_visited(D)}.

#preference(visit_ny, more(cardinality)){
    connected_to_trip("New York")}.
#preference(num_visits_asia, more(weight)){
      S::count_desti(S,"Asia")}.

%#preference(visit_ny, more(cardinality)){
%    connected_to_trip("New York")}.
%#preference(num_visits_asia, more(cardinality)){
%      count_desti(S,"Asia")}.
%#preference(num_visits_europe, less(cardinality)){
%      count_desti(S,"Europe")}.
#preference(num_visits_europe, less(weight)){
      S::count_desti(S,"Europe")}.


%#preference(all_prefs,lexico){4::**num_continent; 5::**distance; 3::**visit_ny; 2::**num_visits_asia; 1::**num_visits_europe}.
#preference(all_prefs,pareto){**num_continent; **distance; **visit_ny; **num_visits_asia; **num_visits_europe}.

  #optimize(all_prefs).
