-module(lesson2_task04).
-export([len/1]).

len([])->0;
len([H|T]) ->
   len([H|T],0).
len([_|T],N)->len(T,N+1);  
len([],N)-> N.
