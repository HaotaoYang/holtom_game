%%%-------------------------------------------------------------------
%% @Module  : src/clock_service/clock_service.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 2017年07月02日 星期日 21时24分38秒
%% @doc holtom_game clock_service
%% @end
%%%-------------------------------------------------------------------
-module(clock_service).

-behaviour(gen_server).

-include("log.hrl").
-include("time.hrl").

-export([
    start_link/0
]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {}).

-define(DEFAULT_CLOCK, [
    {0, 0, 0}, {6, 0, 0}, {12, 0, 0}, {18, 0, 0}
]).

%%====================================================================
%% API
%%====================================================================
start_link() ->
    gen_server:start_link(?MODULE, [], []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
    ?DEBUG("clock serivce start..."),
    process_flag(trap_exit, true),
    lists:foreach(
        fun({H, M, S}) ->
            ClockInterval = tools:get_today_passed_seconds({H, M, S}) - tools:get_today_passed_seconds(),
            ?DEBUG("ClockInterval:~p", [ClockInterval]),
            case ClockInterval > 0 of
                true ->
                    erlang:send_after(ClockInterval * 1000, self(), {'ON_CLOCKING_JOB', {H, M, S}});
                _ ->
                    erlang:send_after((?SECONDS_PER_DAY + ClockInterval) * 1000, self(), {'ON_CLOCKING_JOB', {H, M, S}})
            end
        end,
        ?DEFAULT_CLOCK
    ),
    {ok, #state{}}.

handle_call(Msg, _From, State) ->
    ?ERROR("receive an unknown call msg: ~p", [Msg]),
    {reply, ok, State}.

handle_cast(Msg, State) ->
    ?ERROR("receive an unknown cast msg: ~p", [Msg]),
    {noreply, State}.

handle_info({'ON_CLOCKING_JOB', {H, M, S}}, State) ->
    ?DEBUG("clock ~p is triggered...", [{H, M, S}]),
    handle_clocking_job({H, M, S}),
    ClockInterval = tools:get_next_day_interval(H, M, S),
    erlang:send_after(ClockInterval * 1000, self(), {'ON_CLOCKING_JOB', {H, M, S}}),
    {noreply, State};
handle_info(Info, State) ->
    ?ERROR("receive an unknown info mag: ~p", [Info]),
    {noreply, State}.

terminate(Reason, _State) ->
    ?DEBUG("clock_service process terminate, reason:~p", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================
handle_clocking_job({H, M, S}) ->
    player_worker:on_clocking_job({H, M, S}),
    ok.
