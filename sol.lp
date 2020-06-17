
threshold(5).
3{travel_Destination(LONG,LAT,D,C): dest(LONG,LAT,D,C)}T:- threshold(T).
{first_destination(D): travel_Destination(_,_,D,_)}=1.
{travel_to(A,B): travel_Destination(_,_,B,_)}=1:- travel_Destination(_,_,A,_).
travel_to(S,B):- start_at(_,_,S,_), first_destination(B).
last_stop(D):- travel_to(D,L), first_destination(L), travel_Destination(_,_,D,_).
last_journey(L,S):- last_stop(L),start_at(_,_,S,_).
travel_to(L,S):- last_journey(L,S).

display_connection(F,T):- travel_to(F,T), travel_Destination(_,_,F,_),travel_Destination(_,_,T,_), not first_destination(T).
display_connection(F,T):- travel_to(F,T), start_at(_,_,F,_),first_destination(T).
display_connection(F,T):- last_journey(F,T).

connected_to_trip(D):- last_journey(D,_).
connected_to_trip(D):- first_destination(D).
%connected_to_trip(D):- last_journey(F,_), travel_to(D,F).
connected_to_trip(D):- travel_to(D,F), connected_to_trip(F), travel_Destination(_,_,D,_).
connected_to_trip(D):- travel_to(F,D), connected_to_trip(F), travel_Destination(_,_,D,_).

visited_continents(C):- connected_to_trip(D), travel_Destination(_,_,D,C).


long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), travel_Destination(LAT_F,LONG_F,F,_),travel_Destination(LAT_T,LONG_T,T,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), start_at(LAT_F,LONG_F,F,_),travel_Destination(LAT_T,LONG_T,T,_).
long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T):- display_connection(F,T), travel_Destination(LAT_F,LONG_F,F,_),start_at(LAT_T,LONG_T,T,_).

%greater_than(Y):- contact_to_locals((_,Y),(_,_)), Y>5.
%greater_than(N):- contact_to_locals((_,Y),(_,N)), Y<5.
%test_div(R):- R=2-3.
%left("3").
%right("2").
%c("4").

#script(python).
import math
#def division(A,B):
#  return str(float(A.string) / float(B.string))

#get the lengths:
#def get_length(f_lat,f_long,t_lat,t_long):

#pythagoras for calculating the real distance
#def pythagoras(A,B):
#    c=math.sqrt(math.pow(float(A.string),2)+math.pow(float(B.string),2))
#    return str(c)


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


def destinations(money, weeks, caller):
    financial_category, destinations = classify_wealth(money,weeks, caller)
#    we = float(w.string)
    return str(destinations)

def classify_wealth(total_amount, weeks, caller):
    money = float(total_amount.string)
    time = float(weeks.string)
    num_days = time*7

    if money<3000:
        answer = "not realistic"
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

    if caller.string == 'prog':
        return answer
    else:
        return answer, num_destinations
#end.

distances(@get_distance(LAT_F,LONG_F,F, LAT_T,LONG_T,T), F,T):- long_lat_vals(LAT_F,LONG_F,F, LAT_T,LONG_T,T).

total_travelled_distance(S):- S = #sum{D : distances(D,_,_)}.
#minimize{SUM_DIST: total_travelled_distance(SUM_DIST)}.



count_cont_with_count(S):- S=#count{C:visited_continents(C)}.

%preferences:

calculate_money_time_ratio(@classify_wealth(M, W, "prog")):- money(M), weeks(W).
get_number_of_destinations(@destinations(M, W, "python")):- money(M), weeks(W).
%get_weeks(@weeks(W)):- weeks(W).

%constraints:
%forbid to travel from destination A to destination A:
:- travel_to(A,A).
%forbid more than one subsequent destination:
:- travel_to(A,B), travel_to(A,C), B!=C, travel_Destination(_,_,B,_), travel_Destination(_,_,C,_).
%forbid more than 1 previous destination
:- travel_to(A,C), travel_to(B,C), A!=B, travel_Destination(_,_,A,_), travel_Destination(_,_,B,_).
% forbid "Ping pong" travelling among two destinations:
:- travel_to(A,B), travel_to(B,A), B!=A.

:- not last_journey(_,B), start_at(_,_,B,_).
%first of all not allowing any destinations that are not included in the trip:
%:- not connected_to_trip(D), travel_Destination(_,_,D,_).
% :- S = #count{C: visited_continents(C)}, S<3.
:- count_cont_with_count(S), S<3.


%#show continent/1.
%#show distances/3.
%#show visited_continents/1.
%#show connected_to_trip/1.
%#show travel_to/2.
%#show travel_Destination/4.
#show calculate_money_time_ratio/1.
#show weeks/1.
%#show get_weeks/1

#show get_number_of_destinations/1.

%#show count_cont_with_count/1.
%#show count_cont_with_sum/1.
%#show total_travelled_distance/1.
