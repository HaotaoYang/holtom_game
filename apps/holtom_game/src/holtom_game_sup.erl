%%%-------------------------------------------------------------------
%% @doc holtom_game top level supervisor.
%% @end
%%%-------------------------------------------------------------------
-module(holtom_game_sup).

-behaviour(supervisor).

-include("log.hrl").

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
    clock_service_sup:start_link(),
    player_sup:start_link(),
    {ok, {{one_for_all, 0, 1}, []}}.

%%====================================================================
%% Internal functions
%%====================================================================
