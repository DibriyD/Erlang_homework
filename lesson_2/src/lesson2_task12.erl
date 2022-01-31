-module(lesson2_task12).
-import(lesson2_task05,[reverse/1]).
-export([decode_modified/1]).

decode_modified([])->false;
decode_modified(H)->
	decode_modified(H,[],0).


decode_modified([{X,_}|T],Acc,X)->
	decode_modified(T,Acc,0);
decode_modified([{X,Y}|T],Acc,N)->
	decode_modified([{X,Y}|T],[Y|Acc],N+1);
decode_modified([H|T],Acc,_)->
	decode_modified(T,[H|Acc],0);
	
decode_modified([],Acc,_)-> 
	reverse(Acc).




