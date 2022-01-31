-module(lesson3_task2).
-export([words/1]).


words(<<>>)->false;
words(Text)->
	lists:reverse(words(Text,<<>>,[])).

   
words(<< $\s, Rest/binary>>, Acc,Acc2)->
	words(Rest,<<>>,[Acc|Acc2]);
words(<<H,Rest/binary>>,Acc,Acc2)->
 	words(Rest,<<Acc/binary,H>>,Acc2);
words(<<>>,Acc,Acc2)->
	[Acc|Acc2].
