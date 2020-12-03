# Route Planning with ASP
This repo contains a logic program to create multi-stop routes around the world. It uses the Answer Set Programming (ASP) paradigm to solve the TSP problem and python to create a visual output of the route.
<br>Before using it, make sure that you have installed clingo
<br>There are two different ways to use the program:
<p>
## 1. Using the GUI
<br>The logic program can be called using python script which creates a GUI with a preselected number of weeks and money available for travelling and a starting point. 
<br>To use the GUI, download the folder "asp_route_planner", open a terminal and direct to the folder and then call "route_planner.py".
</p>
<p>
## 2. Call the program by hand
<br>To call the program by hand, download the folder "instances and preferences". It contains four different components: 
<br>the actual logic program "solution.lp",
<br>the file "_base_instance.lp" containing a range of destinations on all continents,
<br>different files that stating a "traveller profile", with tha naming pattern: traveller00X.lp and
<br>different files stating preferences, called according to the naming pattern preference_00X.lp and preference_00X_as.lp 

The reason for the two different naming patterns of the preference-files are the two solution approaches for the preferences. One approach makes use of simple maximize- and minimize-statements, which can be read in clingo. The other approach includes statements from the asprin-library. 
</p>
In order to use the preference statesments that do not require clingo, go to the folder "instances and preferences" and call:
<p>
<b>clingo _base_instance.lp traveller00X.lp preference_00X.lp solution.lp [0]</b>
<br>for the preference-lp-files _001,_002,_003.
 
For using the asprin-library preference statements, call:
<p>
<b>asprin _base_instance.lp traveller00X.lp preference_00X_as.lp solution.lp [0]</b>
<br>for the preference-lp-files -004_as,-005_as,-006_as
</p>
</p>

