%%%-------------------------------------------------------------------
%%% @doc
%%% etcd 的使用封装
%%% @end
%%%-------------------------------------------------------------------
-module(etcd_srv).

-include("common.hrl").
-include_lib("eetcd/include/eetcd.hrl").

-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).
-export([
    start_link/0,
    create/2,
    update/2,
    fetch_all_keys/0,
    fetch_all/0,
    fetch/1,
    fetch_range/2,
    watch/2,
    watch_range/3,
    re_fetch_data/0
]).

-record(state, {
    watch_pid
}).

-define(ETCD_TYPE_PUT, 'PUT').
-define(ETCD_TYPE_DELETE, 'DELETE').
-define(ETCD_KEY_PREFIX, "/game_server/").
-define(RANGE_END, "/h").

%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%% 创建kv数据
create(Key, Value) ->
    eetcd_kv:put(#'Etcd.PutRequest'{key = Key, value = Value}).

%% 更新kv数据
update(Key, Value) ->
    eetcd_kv:put(#'Etcd.PutRequest'{key = Key, value = Value}).

%% 拉取所有的key值
fetch_all_keys() ->
    eetcd_kv:range(#'Etcd.RangeRequest'{
        key = "\0", range_end = "\0", sort_target = 'KEY', sort_order = 'ASCEND', keys_only = true
    }).

%% 拉取所有kv值
fetch_all() ->
    eetcd_kv:range(#'Etcd.RangeRequest'{key = "\0", range_end = "\0", sort_target = 'KEY', sort_order = 'ASCEND'}).

%% 拉取某个key的数据
fetch(Key) ->
    eetcd_kv:range(#'Etcd.RangeRequest'{key = Key}).

%% 拉取某个key包括之后到range_end范围内所有key的数据, 如果range_end为"\0", 则是到最后key的所有数据
fetch_range(Key, RangeEnd) ->
    eetcd_kv:range(#'Etcd.RangeRequest'{key = Key, range_end = RangeEnd}).

%% 监听某个key值的数据
watch(Key, Callback) ->
    eetcd:watch(#'Etcd.WatchCreateRequest'{key = Key}, Callback).

%% 监听某个key值包括之后到range_end范围内所有key的数据, 如果range_end为"\0", 则是到最后key的所有数据
watch_range(Key, RangeEnd, Callback) ->
    eetcd:watch(#'Etcd.WatchCreateRequest'{key = Key, range_end = RangeEnd}, Callback).

re_fetch_data() ->
    gen_server:cast(?MODULE, ?FUNCTION_NAME).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    {ok, fetch_data()}.

handle_call(Request, _From, State) ->
    ?WARNING("unknow call:~p", [Request]),
    {reply, ok, State}.

%% @doc 重新获取数据
handle_cast(re_fetch_data, _State) ->
    {noreply, fetch_data()};
handle_cast(Request, State) ->
    ?WARNING("unknow cast:~p", [Request]),
    {noreply, State}.

handle_info(Info, State) ->
    ?WARNING("unknow info:~p", [Info]),
    {noreply, State}.

terminate(_Reason, #state{watch_pid = WatchPid}) ->
    case is_pid(WatchPid) of
        true -> eetcd:unwatch(WatchPid);
        _ -> skip
    end,
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% @doc 获取数据
fetch_data() ->
    case application:get_env(?APP_NAME, etcd, false) of
        true ->
            KvList = case fetch_range(?ETCD_KEY_PREFIX, ?RANGE_END) of
                         {ok, #'Etcd.RangeResponse'{kvs = Kvs}} -> Kvs;
                         Other ->
                             ?WARNING("etcd fetch_range return = ~p", [Other]),
                             []
                     end,
            [handle_etcd_kv(?ETCD_TYPE_PUT, Key, Value) || #'mvccpb.KeyValue'{key = Key, value = Value} <- KvList],
            CallBack = fun(Res) ->
                case Res of
                    #'Etcd.WatchResponse'{events = Events} ->
                        [
                            begin
                                #'mvccpb.Event'{type = Type, kv = #'mvccpb.KeyValue'{key = NewKey, value = NewValue}} = Event,
                                handle_etcd_kv(Type, NewKey, NewValue)
                            end || Event <- Events
                        ];
                    _ ->
                        ?WARNING("etcd watch result:~p", [Res]),
                        skip
                end
            end,
            {ok, WatchPid} = watch_range(?ETCD_KEY_PREFIX, ?RANGE_END, CallBack),
            #state{watch_pid = WatchPid};
        _ ->
            #state{}
    end.

%% @doc 接收更新或删除方法
handle_etcd_kv(?ETCD_TYPE_PUT, Key, Value) ->
    handle_etcd_kv_put(Key, Value);
handle_etcd_kv(?ETCD_TYPE_DELETE, Key, Value) ->
    handle_etcd_kv_delete(Key, Value).

%% @doc 更新
handle_etcd_kv_put(_Key, _Value) -> ok.

%% @doc 删除
handle_etcd_kv_delete(_Key, _Value) -> ok.
