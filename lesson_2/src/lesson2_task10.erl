-module(lesson2_task10).
-import(lesson2_task05,[reverse/1]).
-export([encode/1]).


encode([])->false;
encode(H)-> encode(H,[],1).


encode([H,H|T],Acc,N)->
	encode([H|T],Acc,N+1);
encode([H,K|T],Acc,N)->
	encode([K|T],[{N,H}|Acc],1);
encode([H],Acc,N)->
	reverse([{N,H}|Acc]).



