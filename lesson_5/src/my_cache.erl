-module(my_cache).
-include_lib("stdlib/include/ms_transform.hrl").
-export([create/1,insert/4,lookup/2,delete_obsolete/1]).


create(TableName)->
	ets:new(TableName,[duplicate_bag,named_table]),
	ok.
	
insert(TableName,Key,Value,TTL)->
	ets:insert(TableName,{Key,Value,
	TTL,calendar:time_to_seconds(time())+TTL}),
	ok.
	
lookup(TableName,Find_Key)->
	Cur_time=calendar:time_to_seconds(time()),
	Ms=ets:fun2ms(fun({Key,Value,TTL,Timestamp})
			when  Cur_time <Timestamp   andalso (Find_Key==Key)->
				 {ok,Value}
			end),
	ets:select(TableName,Ms).

delete_obsolete(TableName)->
	Cur_time=calendar:time_to_seconds(time()),
	Delete=ets:select(TableName,ets:fun2ms(fun({Key,Value,TTL,Timestamp}) 
		when Cur_time >Timestamp ->
		{Key,Value,TTL,Timestamp} 
		end)),
	[ets:delete_object(TableName,X)|| X <-Delete ],
	ok.
