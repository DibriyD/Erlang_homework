-module(lesson2_task11).
-import(lesson2_task05,[reverse/1]).
-export([encode_modified/1]).


encode_modified([])->false;
encode_modified(H)-> encode_modified(H,[],1).


encode_modified([H,H|T],Acc,N)->
	encode_modified([H|T], Acc,N+1);
encode_modified([H,K|T],Acc,1)->
	encode_modified([K|T],[H|Acc],1);
encode_modified([H,K|T],Acc,N) ->
	encode_modified([K|T],[{N,H}|Acc],1);

	
encode_modified([H],Acc,N)->
	reverse([{N,H}|Acc]).


