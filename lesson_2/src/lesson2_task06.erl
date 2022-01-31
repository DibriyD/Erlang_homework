-module(lesson2_task06).
-export([palindrome/1]).

palindrome(H)->
	H=:=reverse(H).
	
reverse([H|T])->
	reverse([H|T],[]);
reverse([])-> false.

reverse([H|T],Acc)->
	reverse(T,[H|Acc]);
reverse([],Acc)->
	Acc.
