%%%-------------------------------------------------------------------
%% @Module  : src/player/player_worker.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 2017年06月30日 星期五 22时12分48秒
%% @doc holtom_game player worker
%% @end
%%%-------------------------------------------------------------------
-module(player_worker).

-behaviour(gen_server).

-include("log.hrl").
-include("player.hrl").

-export([
    start_link/1,
    on_clocking_job/1
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {
    socket
 }).

%%====================================================================
%% API
%%====================================================================
start_link(Socket) ->
    % {ok, {IpAddress, Port}} = inet:peername(Socket),
    % ok = inet:setopts(Socket, [binary, {nodelay, true}, {packet, 2}, {active, true}]),
    gen_server:start_link(?MODULE, Socket, []).

on_clocking_job({H, M, S}) ->
    gen_server:cast(?MODULE, {'ON_CLOCKING_JOB', {H, M, S}}).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init(Socket) -> % when is_port(Socket) ->
    ?DEBUG("player_worker start...~p", [Socket]),
    process_flag(trap_exit, true),
    rand:seed(exs1024, os:timestamp()),
    {ok, #state{socket = Socket}}.

handle_call(Msg, _From, State) ->
    ?ERROR("receive an unknown call msg: ~p", [Msg]),
    {reply, ok, State}.

handle_cast({'ON_CLOCKING_JOB', {H, M, S}}, State) ->
    lists:foreach(fun(Mod) -> Mod:on_clocking_job({H, M, S}) end, ?PLAYER_MODS),
    {noreply, State};
handle_cast(Msg, State) ->
    ?ERROR("receive an unknown cast msg: ~p", [Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    case Info of
        {tcp, _Socket, _Data} ->
            {stop, normal, State};
        {tcp_closed, _Socket} ->
            {stop, normal, State};
        {tcp_error, _Socket, _Reason} ->
            {noreply, State};
        timeout ->
            {stop, normal, State};
        {'EXIT', _Pid, _R} ->
            {stop, normal, State};
        _ ->
            ?ERROR("receive an unknown info mag: ~p", [Info]),
            {noreply, State}
    end.

terminate(Reason, _State) ->
    ?DEBUG("player process terminate, reason:~p", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================
