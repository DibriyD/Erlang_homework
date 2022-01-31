-module(lesson_7_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = {one_for_one,1,5},
    ChildSpecs = [{cache_server, {cache_server, start_link, [table,[{drop_interval,3600}]]},
                 permanent,1000,worker,[cache_server]}], 
                 {ok,{SupFlags,ChildSpecs}}.
