-module(lesson3_task1).
-export([first_word/1]).

first_word(<<>>)->false;
first_word(Text)->
	first_word(Text,<<>>).
first_word(<< $\s, _/binary>>, Acc)->
	io:format("~ts~n",[Acc]);
first_word(<<H/utf8,Rest/binary>>,Acc)->
 	first_word(Rest,<<Acc/binary,H/utf8>>).

