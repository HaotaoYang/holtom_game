%%%-------------------------------------------------------------------
%% @Module  : src/web_socket/web_socket_connector.erl
%% @Author  : Holtom
%% @Email   : 520023290@qq.com
%% @Created : 日 12/31 23:14:41 2017
%% @doc 
%% @end
%%%-------------------------------------------------------------------
-module(web_socket_connector).

-behaviour(gen_server).

-include("log.hrl").
-include("player.hrl").

-export([start_link/0]).

-export([
    init/1,
    handle_call/3,
    handle_cast/2,
    handle_info/2,
    terminate/2,
    code_change/3
]).

-record(state, {}).

-define(SERVER, ?MODULE).
-define(WEB_SOCKET_PORT, 8000).
-define(WEB_SOCKET_HANDLER, web_socket_handler).

%%====================================================================
%% API
%%====================================================================
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
init([]) ->
    Routes = [
        {
            '_',
            [
                {"/", web_socket_handler, []}
            ]
        }
    ],
    Dispatch = cowboy_router:compile(Routes),
    TransOpts = [{port, ?WEB_SOCKET_PORT}],
    ProtoOpts = #{
      env => #{dispatch => Dispatch}
    },
    {ok, _Pid} = cowboy:start_clear(web_socket, TransOpts, ProtoOpts),
    ?DEBUG("web_socket_connector start..."),
    {ok, #state{}}.

handle_call(Msg, _From, State) ->
    ?ERROR("receive an unknown call msg: ~p", [Msg]),
    {reply, ok, State}.

handle_cast(Msg, State) ->
    ?ERROR("receive an unknown cast msg: ~p", [Msg]),
    {noreply, State}.

handle_info(Info, State) ->
    ?ERROR("receive an unknown info mag: ~p", [Info]),
    {noreply, State}.

terminate(Reason, _State) ->
    ?DEBUG("player process terminate, reason:~p", [Reason]),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%====================================================================
%% Internal functions
%%====================================================================
