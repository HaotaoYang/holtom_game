%%%-------------------------------------------------------------------
%% @Module  : src/player/player_sup.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 2017年06月30日 星期日 21时30分12秒
%% @doc holtom_game player supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(player_sup).

-behavisor(supervisor).

%% API
-export(
   [
      start_link/0,
      start_child/1
   ]
).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

start_child(Args) ->
    supervisor:start_child(?SERVER, [Args]).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
    {
        ok,
        {
            {simple_one_for_one, 0, 1},
            [
                {
                    player_worker,
                    {player_worker, start_link, []},
                    temporary,  %% 不重启
                    5000,
                    worker,
                    [player_worker]
                }
            ]
        }
    }.

%%====================================================================
%% Internal functions
%%====================================================================
