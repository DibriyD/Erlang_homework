-module(cache_SUITE).
-include_lib("common_test/include/ct.hrl").
-export([all/0,groups/0,init_per_group/2,end_per_group/2]).
-export([insert/1,lookup/1,lookup_by_date/1,drop/1]).

all() -> [{group,tests}].

groups()-> 
    [{tests,[sequense],
    [insert,lookup,lookup_by_date,drop]}].

init_per_group(tests,Config)->
    Table_name=table,
    Drop_interval=10,
    cache_server:start_link(Table_name,	
    [{drop_interval,Drop_interval}]),

    [{table,Table_name},
    {drop_interval,Drop_interval}|Config].
    
end_per_group(tests,_Config)->
    cache_server:stop().
    
insert(Config)->
    Table_name= ?config(table,Config),
    ok=cache_server:insert(Table_name,1,v1,2),
    ok=cache_server:insert(Table_name,2,v2,3).
   
   
lookup(Config)->
    Table_name= ?config(table,Config),
    timer:sleep(2000),
    [] =cache_server:lookup(Table_name,1),
    [{ok,v2}] =cache_server:lookup(Table_name,2).
  
lookup_by_date(Config)->
    Table_name= ?config(table,Config),
    A=calendar:local_time(),
    timer:sleep(1000),
    cache_server:insert(Table_name,1,v1,5),
    cache_server:insert(Table_name,2,v2,1),
    cache_server:insert(Table_name,3,v3,4),
    timer:sleep(3000),
    B=calendar:local_time(),
    {ok,[v1,v3]}=cache_server:lookup_by_date(Table_name,A,B).
     

drop(Config)->
    Table_name= ?config(table,Config),
    Drop_interval= ?config(drop_interval,Config),
    cache_server:insert(Table_name,1,v1,3),
    cache_server:insert(Table_name,2,v2,(Drop_interval*2000)+1000),
    timer:sleep(Drop_interval*2000),
    [v2]=cache_server:get_all(Table_name).
    
