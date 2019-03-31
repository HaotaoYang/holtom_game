%%%-------------------------------------------------------------------
%% @doc holtom_game public API
%% @end
%%%-------------------------------------------------------------------
-module(holtom_game_app).

-behaviour(application).

-include("common.hrl").

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
    ok = pre_start(),
    case holtom_game_sup:start_link() of
        {ok, Pid} ->
            ok = post_start(),
            {ok, Pid};
        Error ->
            ?ERROR("start application error, Error:~p", [Error]),
            ok
    end.

start_phase(_Arg, _Type, []) ->
    ?DEBUG("start phase Arg:~p", [_Arg]),
    ok.

stop(_State) ->
    ?WARNING("=================server stop================="),
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
pre_start() -> ok.

post_start() -> ok.
