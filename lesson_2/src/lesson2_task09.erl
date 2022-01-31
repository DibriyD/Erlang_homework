-module(lesson2_task09).
-import(lesson2_task05,[reverse/1]).
-export([pack/1]).

pack(H)-> pack(H,[],[]).

pack([H,H|T],Acc,Acc2)->
	pack([H|T],Acc,[H|Acc2]);
pack([H|T],Acc,Acc2)->
	pack(T,[[H|Acc2]|Acc],[]);
pack([],Acc,_)->
	reverse(Acc).



