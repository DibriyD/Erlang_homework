-module(lesson2_task02).
-export([but_last/1]).

but_last([H,K]) ->
 [H,K];
but_last([_|T]) ->
   but_last(T).

