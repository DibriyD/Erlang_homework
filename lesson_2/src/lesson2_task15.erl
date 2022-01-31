-module(lesson2_task15).
-import(lesson2_task05,[reverse/1]).
-export([replicate/2]).

replicate(H,N) when N =< 0 -> 
	replicate(H,[],1,1);
replicate(H,N)-> 
	replicate(H,[],N,N).

replicate([_|T],Acc,N,0)->
	replicate(T,Acc,N,N);
replicate([H|T],Acc,N,Count)->
	replicate([H|T],[H|Acc],N,Count-1);
replicate([],Acc,_,_)->
	reverse(Acc).




