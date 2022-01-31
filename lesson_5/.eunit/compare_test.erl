-module(compare_test).
-export([test/2]).
-export([create_map/2,change_map/2,find_map/2,fun_find_map/2]).
-export([create_proplist/2,change_proplist/2,find_proplist/2,find_fun_proplist/2]).
-export([create_dict/2,change_dict/2,find_dict/2,find_fun_dict/2]).
-export([create_pr_dict/1,change_pr_dict/1,find_pr_dict/1,find_fun_pr_dict/1]).
-export([create_ets/1,change_ets/1,find_ets/1,find_fun_ets/1]).


test(Iterations,Amount_of_elem) when Iterations>0 , Amount_of_elem>1 ->
   test(Iterations-1,Amount_of_elem,{Iterations,create(Amount_of_elem)});
test(Iterations,Amount_of_elem) when Iterations =< 0 ; Amount_of_elem =< 1 -> 
    "Improper input amount".  
add([],[],Temp)->
    Temp;
add([{Type,X1,X2,X3,X4}|T1],[{Type,Y1,Y2,Y3,Y4}|T2],Temp)->
    add(T1,T2,[{Type,X1+Y1,X2+Y2,X3+Y3,X4+Y4}|Temp]).
      
test(0,_,{I,Res})->
    print([{Type,X1 div I,X2 div I,X3 div I,X4 div I}||{Type,X1,X2,X3,X4}<-Res]);
test(Iterations,Elem,{I,Res})->
    test(Iterations-1,Elem,
     {I,lists:reverse(add(Res,create(Elem),[]))}).
   
print([])->
    ok;
print([{Type,X1,X2,X3,X4}|T])->
    io:format("Type: ~p~n",[Type]),
    io:format("Create(Add): ~p~n",[X1]),
    io:format("Change: ~p~n",[X2]),
    io:format("Find: ~p~n",[X3]),
    io:format("Find using function: ~p~n",[X4]),
     io:format("~n",[]),
    print(T).
create(N)->
	{C_map,Map}=timer:tc(compare_test,create_map,[N,maps:new()]),
	{Ch_map,_}=timer:tc(compare_test,change_map,[(N div 2)+1,Map]),
	{Find_map,_}=timer:tc(compare_test,find_map,[(N div 2)+1,maps:iterator(Map)]),
	{Find_fun_map,_}=timer:tc(compare_test,fun_find_map,[(N div 2)+1,Map]),
	
	{C_prop,Prop}=timer:tc(compare_test,create_proplist,[N-1,[{N,N}]]),
	{Ch_prop,_}=timer:tc(compare_test,change_proplist,[(N div 2)+1,Prop]),
	{Find_proplist,_}=timer:tc(compare_test,find_proplist,[(N div 2)+1,Prop]),
	{Find_fun_prop,_}=timer:tc(compare_test,find_fun_proplist,[(N div 2)+1,Prop]),
	
	{C_dict,Dict}=timer:tc(compare_test,create_dict,[N,dict:new()]),
	{Ch_dict,_}=timer:tc(compare_test,change_dict,[(N div 2),Dict]),
	{Find_dict,_}=timer:tc(compare_test,find_dict,[(N div 2),Dict]),
	{Find_fun_dict,_}=timer:tc(compare_test,find_fun_dict,[(N div 2),Dict]),
	 
	{C_pr_dict,_}=timer:tc(compare_test,create_pr_dict,[N]),
	{Ch_pr_dict,_}=timer:tc(compare_test,change_pr_dict,[(N div 2)]),
	{Find_pr_dict,_}=timer:tc(compare_test,find_pr_dict,[(N div 2)]),
	{Find_fun_pr_dict,_}=timer:tc(compare_test,find_fun_pr_dict,[(N div 2)]),
	erase(),
	ets:new(table,[named_table,set]),
	{C_ets,_}=timer:tc(compare_test,create_ets,[N]),
	{Ch_ets,_}=timer:tc(compare_test,change_ets,[(N div 2)]),
	{Find_ets,_}=timer:tc(compare_test,find_ets,[(N div 2)]),
	{Find_fun_ets,_}=timer:tc(compare_test,find_fun_ets,[(N div 2)]),
	ets:delete(table),
	[{"Map",C_map,Ch_map,Find_map,Find_fun_map},
	 {"Proplist",C_prop,Ch_prop,Find_proplist,Find_fun_prop},
	 {"Dictionary",C_dict,Ch_dict,Find_dict,Find_fun_dict},
	 {"Process dictionary",C_pr_dict,Ch_pr_dict,Find_pr_dict,Find_fun_pr_dict},
	 {"Ets",C_ets,Ch_ets,Find_ets,Find_fun_ets}].
	 


create_map(0,Map)->
	Map;
create_map(N,Map)->
	create_map(N-1,maps:put(N, N+1,Map)).
	
change_map(N,Map)->
    maps:update(N,changed,Map),ok.
    
find_map(N,{N,_,_})->
    ok;
find_map(N,{_,_,Next})->
    find_map(N,maps:next(Next));
find_map(N,I)->
    find_map(N,maps:next(I)).

fun_find_map(N,Map)->
    maps:find(N,Map),ok.
    

create_proplist(0,Prop)->
    Prop;
create_proplist(N,[H|T])->
    create_proplist(N-1,[H,{N,N+1}|T]). 

change_proplist(N,Prop)->
    change_proplist(N,Prop,[]).
change_proplist(N,[{N,_}|T],Temp)->
    lists:append(lists:reverse([{N,changed}|Temp]),T);
change_proplist(N,[{K,V}|T],Temp)->
    change_proplist(N,T,[{K,V}|Temp]).


find_proplist(N,[{N,V}|_])->
    V;
find_proplist(N,[{_,_}|T])->
    find_proplist(N,T);
find_proplist(_,[_])->
    none.

find_fun_proplist(N,Prop)->
    proplists:lookup(N,Prop),ok.
    

create_dict(0,Dict)->
    Dict;
create_dict(N,Dict)->
    create_dict(N-1,dict:store(N,N+1,Dict)).
	
change_dict(N,Dict)->
    dict:update(N,fun(_)-> changed end,Dict).
    
find_dict(N,Dict)->
     find_proplist(N,dict:to_list(Dict)).
find_fun_dict(N,Dict)->
    dict:find(N,Dict).

create_pr_dict(0)->
    get();
create_pr_dict(N)->
    put(N-1,N),
    create_pr_dict(N-1).

change_pr_dict(N)->
    put(N,changed).

find_pr_dict(N)->
     find_proplist(N,get()),ok.
     
find_fun_pr_dict(N)->
    get(N).


create_ets(0)->
	ok;
create_ets(N)->
	ets:insert(table,{N,N+1}),
	create_ets(N-1).

change_ets(N)->
    ets:update_element(table,N,{2,changed}).

find_ets(N)->
 %  Ms=ets:fun2ms(fun({K,V}) when K==N -> V end),
 Ms=[{{'$1','$2'},[{'==','$1',{const,N}}],['$2']}],
   ets:select(table,Ms).
find_fun_ets(N)->
    ets:lookup(table,N).





