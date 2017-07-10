%%%-------------------------------------------------------------------
%% @doc holtom_game public API
%% @end
%%%-------------------------------------------------------------------
-module(holtom_game_app).

-behaviour(application).

-include("log.hrl").

%% Application callbacks
-export([
    start/2,
    start_phase/3,
    stop/1
]).

%%====================================================================
%% API
%%====================================================================
start(_StartType, _StartArgs) ->
    holtom_game_sup:start_link().

start_phase(_Arg, _Type, []) ->
    ?DEBUG("start phase Arg:~p", [_Arg]),
    ok.

stop(_State) ->
    ?WARNING("=================server stop================="),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
