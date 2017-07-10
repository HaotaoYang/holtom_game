%%%-------------------------------------------------------------------
%% @Module  : src/clock_service/clock_service_sup.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 2017年07月02日 星期日 21时18分12秒
%% @doc holtom_game clock_service_sup
%% @end
%%%-------------------------------------------------------------------
-module(clock_service_sup).

-behaviour(supervisor).

-export([
    start_link/0
]).

-export([
    init/1
]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API
%%====================================================================
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
    {
        ok,
        {
            {one_for_one, 10, 100},
            [
                {clock_service, {clock_service, start_link, []}, permanent, 1000 * 2, worker, [clock_service]}
            ]
        }
    }.

%%====================================================================
%% Internal functions
%%====================================================================
