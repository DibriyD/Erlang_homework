-module(cache_server).
-include_lib("stdlib/include/ms_transform.hrl").
-export([insert/4,lookup/2,lookup_by_date/3,stop/0]).
-export([get_all/1,clear/1]).
-export([start_link/2,init/1,handle_call/3,
	handle_cast/2,handle_info/2,terminate/2]).
-behavior(gen_server).

-record(row,{key,value,ttl,creation_date}).

start_link(TableName,Args)->
    gen_server:start_link({local,?MODULE},?MODULE,[TableName,Args],[]).
   
init([TableName,[{drop_interval,Clean_after}]])->
    ets:new(TableName,[set,named_table,{keypos,#row.key}]),
    timer:send_interval(Clean_after*1000,?MODULE,{clean,TableName}),
    {ok,[]}.
    
insert(TableName,Key,Value,Ttl)->
    gen_server:cast(?MODULE,{insert,TableName,Key,Value,Ttl}).

lookup(TableName,Key)->
    gen_server:call(?MODULE,{lookup,TableName,Key}).

lookup_by_date(TableName,DateFrom,DateTo)->
    gen_server:call(?MODULE,{lookup_date,TableName,DateFrom,DateTo}).
 
stop()->
    gen_server:stop(?MODULE).

get_all(Table_name)->
    ets:select(Table_name,ets:fun2ms(
        fun(#row{value=V})-> V end)).
 
clear(Table_name)->
    ets:delete_all_objects(Table_name).
    
handle_call({lookup,TableName,Key},_From,State)->
    Cur_time=calendar:time_to_seconds(time()),            
    Ms=ets:fun2ms(fun(#row{key=Row_key,ttl=Ttl,value=V}) 
        when Cur_time < Ttl andalso Key==Row_key->
    	    V
        end),
    Msg=ets:select(TableName,Ms),
    {reply,Msg,State};
	
handle_call({lookup_date,TableName,DateFrom,DateTo},_From,State)->
    Cur_time=calendar:time_to_seconds(time()),   
    Ms=ets:fun2ms(fun(#row{key=Row_key,value=V,ttl=Ttl,creation_date=Cd})
	   when DateFrom =< Cd andalso Cd =< DateTo andalso Ttl>Cur_time ->
	      {Row_key,V} 
	   end),
    Msg=ets:select(TableName,Ms),
    {reply,Msg,State}.
        
handle_cast({insert,TableName,Key,Value,Ttl},State)->
    ets:insert(TableName,
    [#row{key=Key,value=Value,
    ttl=calendar:time_to_seconds(time())+Ttl,
    creation_date=calendar:local_time()}]),
    {noreply,State}.
        
handle_info({clean,TableName},State)->
    Cur_time=calendar:time_to_seconds(time()),     
        Delete=ets:select(TableName,ets:fun2ms(fun(Row=#row{ttl=Ttl}) 
        when Cur_time > Ttl ->
            Row
        end)),
        [ets:delete_object(TableName,X)|| X <-Delete],
        %io:format("cleaned~n"),
        {noreply,State};
handle_info(Msg,State)->
    io:format("Unknown message: ~p~n",[Msg]),
    {noreply,State}.
    
terminate(normal,_State)->
    ok.
           
           

     

