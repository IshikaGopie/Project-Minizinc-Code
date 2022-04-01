include "globals.mzn";   

int: num_tasks = 6;
int: num_slots = 25; % each slot is one hour

set of int: slots = 1..num_slots;
set of int: tasks = 1..num_tasks+1;

array[slots] of var tasks: schedule;

                            % TASKS  1,2,3,4,5,6,7
array[tasks] of var int: duration = [5,3,2,4,1,6,0]; % 21 total hours means that all tasks would take up 21 slots
array[tasks] of var int: priority = [5,1,4,3,1,2,0]; 

% Returns the number of occurrences of y in x .
function int: count(array[$X] of int: x, int: y);

var int: total_time = sum ([duration[i] | i in tasks]);
var int: t = total_time + 1;

constraint if total_time < num_slots then forall (i in 1..total_time)(count(schedule,schedule[i]) = duration[schedule[i]]) endif;
constraint if total_time < num_slots then forall (i in t..num_slots)(schedule[i] = num_tasks+1) endif;

constraint if total_time > num_slots then forall (i in slots)(count(schedule,schedule[i]) = duration[schedule[i]]) endif;

%var set of tasks: s;
%s = array2set(schedule);
%var int: set_size = card(s);
%array[1..3] of var tasks: s2 = s;

var int: cost; %= sum ([priority[schedule[i]] | i in slots]);
var int: total_priority = sum([duration[i]*priority[i] | i in tasks]);

constraint if total_time > num_slots then cost = sum ([priority[schedule[i]] | i in slots]) else cost = total_priority endif;
solve maximize cost; 


output["Schedule: ", show(schedule), "\n",
       "Cost: ", show(cost)]; 



%output[show(schedule), "\n",
%       show(s)];