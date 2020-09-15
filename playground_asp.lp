%simple test for choice rule
%try_get_dest(Y):- dest(_,_,Y,_).
1 { res(Y): dest(_,_,Y,_) } 3.
% :- dest(_,_,Y,_).
count_dest(S):- S=#count{C:res(C)}.

%#show try_get_dest/1.
get_number_of_destinations(@destinations(M, W)):- money(M), weeks(W).
get_m(M):- get_number_of_destinations((M,_)).

#script(python).
import math
def destinations(money, weeks):
    #financial_category, num_dest = classify_wealth(money,weeks)
    return money, weeks

#end.

%#show res/1.
%#show count_dest/1.
#show get_number_of_destinations/1.
#show get_m/1.
