%%%-------------------------------------------------------------------
%% @Module  : src/tools.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 2017年07月02日 星期日 15时40分57秒
%% @doc holtom_game tools
%% @end
%%%-------------------------------------------------------------------
-module(tools).

-include("time.hrl").

-export([
    get_env/3,
    get_today_passed_seconds/0,
    get_today_passed_seconds/1,
    get_next_day_interval/3
]).

%%====================================================================
%% API
%%====================================================================
get_env(App, Key, Default) ->
    case application:get_env(App, Key) of
        {ok, Other} -> Other;
        _ -> Default
    end.

get_today_passed_seconds() ->
    {_, {H, M, S}} = calendar:local_time(),
    H * ?SECONDS_PER_HOUR + M * ?SECONDS_PER_MINUTE + S.

get_today_passed_seconds({H, M, S}) ->
	H * ?SECONDS_PER_HOUR + M * ?SECONDS_PER_MINUTE + S.

get_next_day_interval(H, M, S) ->
    get_today_passed_seconds({H, M, S}) - get_today_passed_seconds() + ?SECONDS_PER_DAY.

%%====================================================================
%% Internal functions
%%====================================================================
