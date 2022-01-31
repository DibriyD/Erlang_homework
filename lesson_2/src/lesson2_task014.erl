-module(lesson2_task014).
-import(lesson2_task05,[reverse/1]).
-export([duplicate/1]).

duplicate(H)-> duplicate(H,[]).


duplicate([H|T],Acc)->
	duplicate(T,[H,H|Acc]);
duplicate([],Acc)->
	reverse(Acc).



