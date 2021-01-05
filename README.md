# Route Planning with ASP
This repo contains a logic program to create multi-stop routes around the world. It uses the Answer Set Programming (ASP) paradigm to solve the TSP problem and python to create a visual output of the route.
<br>Before using it, make sure that you have installed clingo and python
<br>There are two different ways to use the program:
<p>
  1. Using the GUI
<br>The logic program can be called using python script which creates a GUI. It shows a preselection of numbers of weeks and money available for travelling, as well as a starting point (city). 
<br>To use the GUI, download the folder "asp_route_planner", open a terminal and direct to the folder and then call "route_planner.py". After hitting submit, the program evaluates the input and attempts to find stable models, which represent routes. The first stable model to be found is then used to create a visual presentation of the route. 
</p>
<p>
  2. Call the program by hand
<br>To execute the programm manually, download the folder "instances and preferences". It contains four different components: 
<br>the actual logic program "solution.lp",
<br>the file "_base_instance.lp" containing a range of destinations on all continents,
<br>different files that stating a "traveller profile", with tha naming pattern: traveler00X.lp and
<br>different files stating preferences, called according to the naming pattern preference_00X.lp and preference_as_00X.lp 

The reason for the two different naming patterns of the preference-files are the two solution approaches for the preferences. One approach makes use of simple maximize- and minimize-statements, which can be read in clingo. The other approach includes statements from the asprin-library. (When calling the program with the GUI, the clingo-variant of the first preference statement-lp will be selected.)
</p>
In order to use the preference statesments that do not require asprin, go to the folder "instances and preferences" and call:
<p>
<b>clingo _base_instance.lp traveller00X.lp preference_00X.lp solution.lp [0]</b>
<br>for the preference-lp-files _001,_002,_003.
 
For using the asprin-library preference statements, call:
<p>
<b>asprin _base_instance.lp traveller00X.lp preference_as_00X.lp solution.lp [0]</b>
<br>for the preference-lp-files -004_as,-005_as,-006_as
</p>
</p>

