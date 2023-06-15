-module(game_default_config).

-include("common.hrl").

%% API
-export([
    init_config/0,
    list_all/0,
    get/1,
    insert_config/2,
    insert_config/1
]).

init_config() ->
    List = application:get_all_env(),
    game_mochiglobal:create(game_default_config_helper, List).

list_all() ->
    game_default_config_helper:all().

get(Key) ->
    game_default_config_helper:term(Key).

insert_config(Key, Value) ->
    insert_config([{Key, Value}]).

insert_config(List) ->
    ConfigList = list_all(),
    game_mochiglobal:create(game_default_config_helper, ConfigList ++ List).
