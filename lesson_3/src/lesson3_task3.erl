-module(lesson3_task3).
-import(lesson2_task05,[reverse/1]).
-export([split/2]).


split(H,Sp)->	
	split(H,Sp,Sp,[],<<>>).

	
split(<<H,Rest/binary>>,Sp,<<H,Rest2/binary>>,Acc,Acc2)-> %% если есть совпадение добавить в Асс2
	split(Rest,Sp,Rest2,Acc,<<Acc2/binary,H>>);
	
split(H,Sp,<<>>, Acc,_)->    %% если Sp2 закончился обновить
	split(H,Sp,Sp,Acc,<<>>);

split(<<H,S,Rest/binary>>,Sp,<<S,_/binary>>,Acc,Acc2)-> %% если дальше совпадение передать Асс2 в Асс1 и очистить его
	split(<<S,Rest/binary>>,Sp,Sp,[<<Acc2/binary,H>>|Acc],<<>>);	
	
split(<<H,Rest/binary>>,Sp,_, Acc,Acc2)->%% если текущий и след символ не совпадение с сепаратором то передать в Асс2
	split(Rest,Sp,Sp,Acc,<<Acc2/binary,H>>);

	
split(<<>>,_,_,Acc,Acc2)->
	reverse([Acc2|Acc]).
