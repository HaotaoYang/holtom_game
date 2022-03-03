%%%-------------------------------------------------------------------
%% @doc holtom_game top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(holtom_game_sup).

-behaviour(supervisor).

-include("common.hrl").

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
    SupFlags = #{strategy => one_for_one, intensity => 5, period => 10},
    Children = [
        #{
            id => web_socket_sup, start => {web_socket_sup, start_link, []},
            modules => [web_socket_sup], restart => permanent,
            shutdown => infinity, type => supervisor
        },
        #{
            id => clock_service_sup, start => {clock_service_sup, start_link, []},
            modules => [clock_service_sup], restart => permanent,
            shutdown => infinity, type => supervisor
        },
        #{
            id => player_sup, start => {player_sup, start_link, []},
            modules => [player_sup], restart => permanent,
            shutdown => infinity, type => supervisor
        },
        #{
            id => etcd_srv, start => {etcd_srv, start_link, []},
            modules => [etcd_srv], restart => permanent,
            shutdown => 5000, type => worker
        }
    ],
    {ok, {SupFlags, Children}}.

%%====================================================================
%% Internal functions
%%====================================================================
