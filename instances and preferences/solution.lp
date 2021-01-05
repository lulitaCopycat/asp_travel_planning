%calculate how much money the traveler can approximately spend evenly over the travel period
get_number_of_destinations(@destinations(M, W)):- money(M), weeks(W).

%get the maximum number of destinations that can be included in the trip
threshold(T):- get_number_of_destinations((T,_)).
%obtain a reasonable minimum number of destinations included in the trip
lower_(@lower_limit_function(T)):- threshold(T).
%use python code to rewrite the limits to integers - s.t. it is possible to use them for calculations
int_lower(@return_as_int(I)):- lower_((I)).
int_upper(@return_as_int(I)):- get_number_of_destinations((I,_)).
%* the lower and upper limit are later used to make sure that the number of num_destinations
represents a reasonable amount of destinations*%
% pick exactly one destination to be the first
{first_destination(D): dest(_,_,D,_)}=1.

%defining the first destination as a destination included in the trip
trip_destination(D) :- first_destination(D).
%picking more destinations one by one to follow and thus build a chain of destinations
{ travel_to(A,B) : dest(_,_,B,_) } 1 :- trip_destination(A).
trip_destination(B) :- travel_to(A,B).

%count the number of destinations
count_dest(S):- S=#count{C:travel_to(_,C)}.

%the journey from the last stop to the starting point is included as a trip
travel_to(S,B):- start_at(_,_,S,_), first_destination(B).
last_stop(D):- travel_to(D,L), first_destination(L), trip_destination(D).
last_journey(L,S):- last_stop(L),first_destination(S).
last_trip_home(L,S):- last_stop(L),start_at(_,_,S,_).

%defining that travelled destinations are connected to the trip
connected_to_trip(D):- last_journey(D,_).
connected_to_trip(D):- first_destination(D).
connected_to_trip(D):- travel_to(D,F), connected_to_trip(F), trip_destination(D).

%collecting all the visited continents and the destinations visited per continent
visited_continents(C):- connected_to_trip(D), dest(_,_,D,C).
visited_destinations_in_continent(C,D):- connected_to_trip(D), dest(_,_,D,C).

%obtaining the coordinates of travel destinations pairwise
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), trip_destination(F),trip_destination(T), dest(LAT_T,LONG_T,T,_), dest(LAT_F,LONG_F,F,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), first_destination(F),dest(LAT_F,LONG_F,F,_), trip_destination(T), dest(LAT_T,LONG_T,T,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), trip_destination(F), dest(LAT_F,LONG_F,F,_), first_destination(T), dest(LAT_T,LONG_T,T,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- last_trip_home(F,T), start_at(LAT_T,LONG_T,T,_), last_stop(F), dest(LAT_F,LONG_F,F,_).

%gathering geographic coordinates of the travel destinations pairwise
geo_data(F,FC,FLONG,FLAT, T,TC,TLONG,TLAT):- travel_to(F,T), dest(FLAT,FLONG,F,FC),dest(TLAT,TLONG,T,TC), not last_stop(F).
geo_data(F,FC,FLONG,FLAT, T,TC,TLONG,TLAT):- last_trip_home(F,T), last_stop(F),dest(FLAT,FLONG,F,FC),start_at(TLAT,TLONG,T,TC).
geo_data(F,FC,FLONG,FLAT, T,TC,TLONG,TLAT):- start_at(FLAT,FLONG,F,FC), first_destination(T), dest(TLAT,TLONG,T,TC).

%rewriting it to a shorter variant:
geo_travels(F,T):- geo_data(F,FC,FLONG,FLAT, T,TC,TLONG,TLAT).


#script(python).
import math

#calculate the distance between travel destinations pairwise
#differentiating between eastern and western, northern and southern hemisphere
def get_length(f_lat,f_long, t_lat,t_long):
    #longitudes on the same hemisphere
    if (f_long>0 and t_long>0) or (f_long<0 and t_long<0):
        longi = abs(f_long-t_long)
    #longitudes on different hemispheres
    elif f_long>0 and t_long<0:
        res = f_long+abs(t_long)
        longi = res if res<=180 else 360-res
    elif f_long<0 and t_long>0:
        res = t_long+abs(f_long)
        longi = res if res<=180 else 360-res

    #latitudes on the same hemisphere:
    if (f_lat<0 and t_lat<0) or (f_lat>=0 and t_lat>=0):
        lati = abs(f_lat-t_lat)
    #latitudes on different hemispheres:
    elif f_lat<0 and t_lat>=0:
        lati = abs(f_lat)+t_lat
    elif f_lat>=0 and t_lat<0:
        lati = f_lat+abs(t_lat)
    return longi, lati

#calculation of the total travelled distance
def get_distance(f_lat,f_long,f, t_lat,t_long, t):
    formatted_f_lat = float(f_lat.string)
    formatted_f_long = float(f_long.string)
    formatted_t_lat = float(t_lat.string)
    formatted_t_long = float(t_long.string)
    longi, lati = get_length(formatted_f_lat,formatted_f_long, formatted_t_lat,formatted_t_long)
    c=math.sqrt(math.pow(longi,2)+math.pow(lati,2))
    return int(round(c,0))

#function to return real number values (=integer) which can be used for calculations
def return_as_int(factor):
    return int(factor.string)

#support function to obtain the maximum number of destinations that can be included in the trip
def destinations(money, weeks):
    financial_category, num_dest = classify_wealth(money,weeks)
    return str(int(num_dest)), financial_category

#function to calculate a reasonable lower limit of destinations for the traveler specific journey
def lower_limit_function(upper_limit):
    max_num_destinations = float(upper_limit.string)
    if max_num_destinations<3:
      return str(int(1))
      #use logarithmic function to find a reasonable minimum number of destinations
      # e.g. if the upper_limit = 10(i.e. max. number of destinations with given money + time), the log of 10 with base 1/2 is "-3"
    else:
      subtract = round((math.log(max_num_destinations,1/2)),0)
        #by adding the 10 (upper_limit) and the -3, we get 7 as a minimum number of destinations to travel
      lower = max_num_destinations + subtract
      if lower<4:
        return str(3)
      else:
        return str(int(lower))

#function to classify how wealthy the traveler is based on the ratio of time and money available
#for the journey and to return the maximum number of destinations the traveler can visit (= upper limit)
def classify_wealth(total_amount, weeks):
    money = float(total_amount.string)
    time = float(weeks.string)
    num_days = time*7
    if money<3000:
        answer = "not realistic"

# the number of 21.7 comes from a calculation of the amount of money spent on transfer in long term journeys on averages
    available_amount = (money - ((21.7*money)/100))/time
    if available_amount <173 :
        answer = "not realistic"
        num_destinations = 0
    elif 173<available_amount<220:
        answer = "S"
        num_destinations = num_days/12
    elif 220<available_amount<350:
        answer = "M"
        num_destinations = num_days/9
    elif 350<available_amount<400:
        answer = "L"
        num_destinations = num_days/7
    else:
        num_destinations = num_days/3.5
        answer = "XL"

    return answer, str(int(num_destinations))
#end.

%calculate the distances between travel destinations pairwise using a python function "get_distance"
distances(@get_distance(LAT_F,LONG_F,F, LAT_T,LONG_T,T), F,T):- long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T).

%total traveled distance
total_travelled_distance(S):- S = #sum{D : distances(D,_,_)}.

% count the number of visited continents and the number of destinations per continent
count_continents_visited(S):- S=#count{C:visited_continents(C)}.
count_desti(S,C):- S=#count{D:visited_destinations_in_continent(C,D)},visited_continents(C).

%constraints:
%forbid to travel from destination A to destination A:
:- travel_to(A,A).
%forbid more than one subsequent destination:
:- travel_to(A,B), travel_to(A,C), B!=C, trip_destination(B), trip_destination(C).
%forbid more than 1 previous destination
:- travel_to(A,C), travel_to(B,C), A!=B, trip_destination(A), trip_destination(B).
% forbid "Ping pong" travelling among two destinations:
:- travel_to(A,B), travel_to(B,A), B!=A.
%allowing any destinations that are not included in the trip:
:- count_continents_visited(S), S<=3.
%make sure that journeys from one destination to the exact same destination are excluded
:- geo_travels(F,T), F==T.
%* and assure that the number tops the lower limit, and is smaller than the upper limit.
 Also, it cannot be the case that the number is not between "3" and the upper limit.
Travelling less than 3 destinations implies that the goal of travelling destinations
on three different continents cannot be reached.*%
:- count_dest(S), int_lower(L), S<=L.
:- count_dest(S), int_upper(U), S>=U.
:- not 3{ trip_destination(A) }T, threshold(T).

%#show travel_to/2.
%#show last_trip_home/2.
%#show geo_data/8.
#show geo_travels/2.
%#show connected_to_trip/1.
%#show count_continents_visited/1.
%#show visited_continents/1.
%#show count_dest/1.
