% structure: dest(lat, long, name)
dest("54", "28", "Minsk", "Europe").
dest("56", "92", "Krasnoyarsk", "Europe").
dest("-37","174", "Auckland", "Australia").
%dest(-55, -68, "Ushuaia", "South America").
%dest(-9,	13, "Luanda", "Africa").
%dest(25,	47, "Riyadh", "Africa").
%dest(14,	101, "Bangkok", "Asia").

start_at("53", "13", "Berlin", "Europe").

%preferences of the traveller:
%**should contain:
budget, time, reason to travel, goals
**%
money(10000).
time(10).
est_nr_destinations(20).

travel_reason("Adventure and Action").

food_finding("Cook in accomodation").
surrounding(("Nature",8),("city",2)).
transport_mode("no preferences").
contact_to_locals(("yes",8),("no",2)).


%*
dest(-34, 18, "Cape Town").
dest(24,	90, "Dhaka").
dest(-4,	-39, "Fortaleza").
dest(-13,	-38, "Salvador").
dest(31, 114, "Wuhan").
dest(36,	51, "Tehran").
*%


%dest(35	,69, "Kabul").
%dest(37		,3,"Algiers").
%dest(-35,	-58, "Buenos Aires").
%dest(46,	-74, "Montréal").
%dest(25,	67, "Karachi").
%dest(32,	74, "Lahore").
