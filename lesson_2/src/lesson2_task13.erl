-module(lesson2_task13).
-import(lesson2_task05,[reverse/1]).
-export([decode/1]).

decode([])->false;
decode(H)->
	decode(H,[],0).

decode([{X,_}|T],Acc,X)->
	decode(T,Acc,0);
decode([{X,Y}|T],Acc,N)->
	decode([{X,Y}|T],[Y|Acc],N+1);

decode([],Acc,_)-> 
	reverse(Acc).
