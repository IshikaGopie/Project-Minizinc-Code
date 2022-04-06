include "globals.mzn";   

int: num_tasks = 6;
int: num_slots = 10;
int: num_days = 7;

set of int: slots = 1..num_slots;
set of int: tasks = 1..num_tasks+1;
set of int: days  = 1..num_days;

array[slots,days] of var tasks: schedule;


                               %Tasks  1 2 3 4 5 6 7
array[tasks] of var int: duration =   [5,3,7,4,1,6,_]; 
array[tasks] of var int: priority =   [5,1,4,2,1,3,0]; 
array[tasks] of     int: start_date = [1,2,4,5,3,3,0];
array[tasks] of     int: end_date =   [3,4,7,7,5,6,0];

var int: total_time = sum([duration[i] | i in 1..num_tasks]);
var int: available_slots = num_slots * num_days;
var int: remainder_slots = available_slots - total_time;

constraint if total_time < available_slots then duration[num_tasks + 1] = remainder_slots else duration[num_tasks + 1] = 0 endif;

% Returns the number of occurrences of y in x .
function int: count(array[$X] of int: x, int: y);

constraint count(schedule,num_tasks + 1) = duration[num_tasks + 1];

constraint forall(c in 1..num_tasks)(count([schedule[i,j] | i in slots, j in days where j >= start_date[c] /\ j < end_date[c]], c) = duration[c]);

var set of tasks: s;
s = array2set(array1d(schedule));
var int: cost = sum([priority[i] |  i in s]);

solve maximize cost;

output[show2d(schedule)];
