-module(lesson2_task07).
-export([flatten/1]).
-import(lesson2_task05,[reverse/1]).

flatten(L)->
	reverse(flatten(L,[])).

flatten([[]|T],Acc)->
	flatten(T,Acc);
flatten([[_|_]=H|T],Acc)->
	flatten(T,flatten(H,Acc));
flatten([H|T],Acc)->
	flatten(T,[H|Acc]);
flatten([],Acc)->
	Acc.
