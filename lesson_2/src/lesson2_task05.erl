-module(lesson2_task05).
-export([reverse/1]).

reverse([H|T])->
	reverse([H|T],[]);
reverse([])-> false.

reverse([H|T],Acc)->
	reverse(T,[H|Acc]);
reverse([],Acc)->
	Acc.


	
