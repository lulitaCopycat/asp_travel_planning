%calculate how much money the traveller can approximately spent evenly over during the travel period
calculate_money_time_ratio(@classify_wealth(M, W)):- money(M), weeks(W).
get_number_of_destinations(@destinations(M, W)):- money(M), weeks(W).

threshold(T):- get_number_of_destinations((T,_)).
lower_(@lower_limit_function(T)):- threshold(T).
int_lower(@return_as_int(I)):- lower_((I)).
%max_possible_number(T):- get_number_of_destinations((T,_)).
%int_instance(@return_as_int(I)):- est_nr_destinations(I).
int_program(@return_as_int(I)):- get_number_of_destinations((I,_)).

%get_delta_estimation_destination_number(D):- |A-B|=D, int_instance(A), int_program(B).

{first_destination(D): dest(_,_,D,_)}=1.
%{first_destination(D): dest(_,_,D,_), near(D) }=1.
trip_destination(D) :- first_destination(D).
{ travel_to(A,B) : dest(_,_,B,_) } 1 :- trip_destination(A).
%L{travel_to(A,B): dest(_,_,B,_)}U:- int_program(U), int_lower(L), trip_destination(A).
%Original from sol.lp
%L{travel_destination(LONG,LAT,D,C): dest(LONG,LAT,D,C)}U:- int_program(U), int_lower(L).
trip_destination(B) :- travel_to(A,B).

count_dest(S):- S=#count{C:travel_to(_,C)}.
%3{travel_Destination(LONG,LAT,D,C): dest(LONG,LAT,D,C)}T:- threshold(T).
:- count_dest(S), int_lower(L), S<L.
:- count_dest(S), int_program(U), S>U.


%{first_destination(D): trip_destination(_,_,D,_)}=1.
%{travel_to(A,B): trip_destination(_,_,B,_)}=1:- trip_destination(_,_,A,_).
%travel_to(S,B):- start_at(_,_,S,_), first_destination(B).
%last_stop(D):- travel_to(D,L), first_destination(L), trip_destination(_,_,D,_).
last_stop(D):- travel_to(D,L), first_destination(L), trip_destination(D).

last_journey_alt(D,S):- travel_to(D,L), first_destination(L), trip_destination(D), first_destination(S).
%start_at(S):- first_destination(S).
last_journey(L,S):- last_stop(L),first_destination(S).
travel_to(A,B):- last_journey(A,B).
%travel_to(L,S):- last_journey(L,S).

%display_connection(F,T):- travel_to(F,T), trip_destination(_,_,F,_),trip_destination(_,_,T,_), not first_destination(T).
%display_connection(F,T):- travel_to(F,T), start_at(_,_,F,_),first_destination(T).
%display_connection(F,T):- last_journey(F,T).

connected_to_trip(D):- last_journey(D,_).
connected_to_trip(D):- first_destination(D).
%connected_to_trip(D):- last_journey(F,_), travel_to(D,F).
%connected_to_trip(D):- travel_to(D,F), connected_to_trip(F), trip_destination(_,_,D,_).
%connected_to_trip(D):- travel_to(F,D), connected_to_trip(F), trip_destination(_,_,D,_).
connected_to_trip(D):- travel_to(D,F), connected_to_trip(F), trip_destination(D).
%connected_to_trip(D):- travel_to(F,D), connected_to_trip(F), trip_destination(D).

visited_continents(C):- connected_to_trip(D), dest(_,_,D,C).
visited_destinations_in_continent(C,D):- connected_to_trip(D), dest(_,_,D,C).

%long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), travel_Destination(LAT_F,LONG_F,F,_),travel_Destination(LAT_T,LONG_T,T,_).
%long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), start_at(LAT_F,LONG_F,F,_),travel_Destination(LAT_T,LONG_T,T,_).
%long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), travel_Destination(LAT_F,LONG_F,F,_),start_at(LAT_T,LONG_T,T,_).

long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), trip_destination(F),trip_destination(T), dest(LAT_T,LONG_T,T,_), dest(LAT_F,LONG_F,F,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), first_destination(F),dest(LAT_F,LONG_F,F,_), trip_destination(T), dest(LAT_T,LONG_T,T,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- travel_to(F,T), trip_destination(F), dest(LAT_F,LONG_F,F,_), first_destination(T), dest(LAT_T,LONG_T,T,_).


#script(python).
import math

def get_length(f_lat,f_long, t_lat,t_long):
    if (f_long>0 and t_long>0) or (f_long<0 and t_long<0):
        longi = abs(f_long-t_long)
    elif f_long>0 and t_long<0:
        res = f_long+abs(t_long)
        longi = res if res<=180 else 360-res
    elif f_long<0 and t_long>0:
        res = t_long+abs(f_long)
        longi = res if res<=180 else 360-res
    if (f_lat<0 and t_lat<0) or (f_lat>=0 and t_lat>=0):
        lati = abs(f_lat-t_lat)
    elif f_lat<0 and t_lat>=0:
        lati = abs(f_lat)+t_lat
    elif f_lat>=0 and t_lat<0:
        lati = f_lat+abs(t_lat)
    return longi, lati

def get_distance(f_lat,f_long,f, t_lat,t_long, t):
    formatted_f_lat = float(f_lat.string)
    formatted_f_long = float(f_long.string)
    formatted_t_lat = float(t_lat.string)
    formatted_t_long = float(t_long.string)
    longi, lati = get_length(formatted_f_lat,formatted_f_long, formatted_t_lat,formatted_t_long)
    c=math.sqrt(math.pow(longi,2)+math.pow(lati,2))
    return int(round(c,0))


def return_as_int(factor):
    return int(factor.string)

def delta_expactations_destination_number(E,R):
    return abs(E-R)

def destinations(money, weeks):
    financial_category, num_dest = classify_wealth(money,weeks)
    return str(int(num_dest)), financial_category

def lower_limit_function(d):
    a = float(d.string)
    subtract = round((math.log(a,1/2)),0)
    lower = a + subtract
    return str(int(lower))

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

distances(@get_distance(LAT_F,LONG_F,F, LAT_T,LONG_T,T), F,T):- long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T).

total_travelled_distance(S):- S = #sum{D : distances(D,_,_)}.
%#minimize{SUM_DIST: total_travelled_distance(SUM_DIST)}.


count_cont_with_count(S):- S=#count{C:visited_continents(C)}.
%count_dest_per_cont(S,C):- S=#count{D:visited_destinations_in_continent(C,D)}.
%count_desti(S,C):- S=#count{D,C:visited_destinations_in_continent(C,D)}, visited_continents(C).
count_desti(S,C):- S=#count{D:visited_destinations_in_continent(C,D)},visited_continents(C).

%preferences:

calculate_money_time_ratio(@classify_wealth(M, W)):- money(M), weeks(W).
%get_number_of_destinations(@destinations(M, W, "python")):- money(M), weeks(W).

%get_weeks(@weeks(W)):- weeks(W).

%constraints:
%forbid to travel from destination A to destination A:
:- travel_to(A,A).


:- not 3{ trip_destination(A) }T, threshold(T).

%forbid more than one subsequent destination:
:- travel_to(A,B), travel_to(A,C), B!=C, trip_destination(B), trip_destination(C).
%forbid more than 1 previous destination
:- travel_to(A,C), travel_to(B,C), A!=B, trip_destination(A), trip_destination(B).
% forbid "Ping pong" travelling among two destinations:
:- travel_to(A,B), travel_to(B,A), B!=A.

%:- not last_journey(_,B), start_at(_,_,B,_).
%first of all not allowing any destinations that are not included in the trip:
%:- not connected_to_trip(D), travel_Destination(_,_,D,_).
:- count_cont_with_count(S), S<3.


%#show travel_to/2.
#show connected_to_trip/1.
%#show count_cont_with_count/1.
%#show visited_continents/1.
%#show count_dest/1.
%#show visited_destinations_in_continent/2.
#show count_desti/2.
%#show count_dest_per_cont/2.
