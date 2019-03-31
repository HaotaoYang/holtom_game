-module(web_socket_handler).

-include("common.hrl").

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
-export([terminate/3]).


init(Req, _Opts) ->
    #{peer := {Ip, _Port}} = Req,
    State = #{
        ip => Ip
    },
    {cowboy_websocket, Req, State}.

websocket_init(State) ->
    player_sup:start_child(self()),
    {ok, State}.

websocket_handle({text, _Msg}, State) ->
    % case Msg of
    %     <<"1">> ->
    %         websocket_parse:encode_proto(#loginReq{});
    %     <<"2">> ->
    %         websocket_parse:encode_proto(#balancePush{balance = 4})
    % end,
    % websocket_handle({binary, Msg}, State),
    {reply, {text, list_to_binary("aaa")}, State};
websocket_handle({binary, Msg}, State) ->
    <<Cmd:16, _Bin/binary>> = Msg,
    #{ip := _Ip, login := Login, user_pid := _UserPid} = State,
    ?DEBUG("Clinet Cmd:~p, login stata:~p~n", [Cmd, Login]),
    {ok, State};
    % case Login of
    %     ?LOGOUT ->
    %         {ReplyBin, Pid, Flag} = login:game_login(Cmd, Bin, self(), Ip),
    %         case Flag of
    %             ?LOGOUT ->
    %                 {reply, {binary, ReplyBin}, State#{login => Flag, user_pid => Pid}};
    %             ?LOGIN ->
    %                 {ok, State#{login => Flag, user_pid => Pid}}
    %         end;
    %     ?LOGIN ->
    %         ?INFO_LOG("Clinet Cmd:~p, bbbbbbbbbbbbbbin:~p~n", [Cmd, Bin]),
    %         websocket_parse:do_parse_packet(Cmd, Bin, UserPid),
    %         {ok, State}
    % end;
websocket_handle(_Data, State) ->
    {ok, State}.

websocket_info({timeout, Msg}, State) ->
    {reply, {text, Msg}, State};

websocket_info({send_text, Msg}, State) ->
    {reply, {text, Msg}, State};

websocket_info({send_binary, Msg}, State) ->
    {reply, {binary, Msg}, State};

websocket_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _Req, #{user_pid := UserPid}) ->
    login:login_lost(UserPid, quit),
    ok.
