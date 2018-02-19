%%%-------------------------------------------------------------------
%% @Module  : src/web_socket/web_socket_sup.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 日 12/31 22:42:34 2017
%% @doc 
%% @end
%%%-------------------------------------------------------------------
-module(web_socket_sup).

-behavisor(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

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
            {one_for_one, 10, 10},
            [
                {
                    web_socket_connector,
                    {web_socket_connector, start_link, []},
                    transient,
                    2000,
                    worker,
                    [web_socket_connector]
                }
            ]
        }
    }.

%%====================================================================
%% Internal functions
%%====================================================================
