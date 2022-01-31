-module(lesson2_task08_).
-export([compress/1]).


compress(H)-> compress(H,[]).

compress([H,H|T],Acc)->
 	compress([H|T],Acc);
compress([H,K|T],Acc)->
	compress([K|T],[H|Acc]);
compress([H],Acc)->[H|Acc].



