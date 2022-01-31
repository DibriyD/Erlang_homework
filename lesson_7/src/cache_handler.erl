-module(cache_handler).

-export([init/2]).


init(Req0,Opts)->
    Method= cowboy_req:method(Req0),
    Body=cowboy_req:has_body(Req0),  
    Req=ask(Method,Body,Req0),
    {ok, Req, Opts}.
    
ask(<<"POST">>,_Echo,Req)->
    {ok, Data, _Req0} = cowboy_req:read_body(Req),
    {Decoded_data}=jiffy:decode(Data),
    Ans= jiffy:encode({[{<<"result">>,check_action_type(Decoded_data)}]}),
    cowboy_req:reply(200, #{
		<<"content-type">> => <<"application/json; charset=utf-8">>
	        }, <<"\n",Ans/binary,"\n">>, Req);
         

ask(<<"GET">>, undefined, Req) ->
    cowboy_req:reply(400, #{}, <<"Missing echo parameter.">>, Req);
ask(<<"GET">>, _Echo, Req) ->
    cowboy_req:reply(200, #{
	<<"content-type">> => <<"text/plain; charset=utf-8">>
	}, "text", Req);
ask(_, _, Req) ->
    cowboy_req:reply(405, Req).


check_action_type(Decoded_data)->
    Action_v=proplists:get_value(<<"action">>,Decoded_data),
    Ans= case Action_v of 
         <<"insert">> -> [_,{_,Key},{_,Value}]=Decoded_data,
         		  cache_server:insert(table,Key,
         		  Value,60);
         <<"lookup">> -> [_,{_,Key}]=Decoded_data,
             		   cache_server:lookup(table,Key);
         <<"lookup_by_date">> -> [_,{_,Date_from},{_,Date_to}]=Decoded_data,
          		        Date_from_formatted= convert_date:convert(binary_to_list(Date_from)),
          		        Date_to_formatted=convert_date:convert(binary_to_list(Date_to)),	        
{cache_server:lookup_by_date(table,Date_from_formatted,Date_to_formatted)}
 	  end,	  
 	 Ans.



% curl -H "Content-Type:application/json" -X POST -d '{"action":"insert","key": "some key", "value":"value"}'  http://localhost:8080/
	
%	curl -H "Content-Type:application/json" -X POST -d '{"action":"insert","key":"another key", "value":[1,2,3]}'  http://localhost:8080/
%    curl -H "Content-Type:application/json" -X POST -d '{"action":"lookup","key":"some key"}'  http://localhost:8080/
% curl -H "Content-Type:application/json" -X POST -d '{"action":"lookup","key":"another key"}'  http://localhost:8080/
 
%curl -H "Content-Type:application/json" -X POST -d '{"action":"lookup_by_date","date_from":"2015/1/1 00:00:00","date_to":"2022/3/3 00:00:00"}'  http://localhost:8080/




