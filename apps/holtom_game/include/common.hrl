-ifndef(__COMMON_HRL__).
-define(__COMMON_HRL__, true).

-include("player.hrl").

-include_lib("lager_daily_rotation_file_backend/include/log.hrl").

-define(TIMESTAMP,          erlang:system_time(second)).
-define(MILLI_TIMESTAMP,    erlang:system_time(millisecond)).
-define(MICRO_TIMESTAMP,    erlang:system_time(microsecond)).

-define(SECONDS_PER_MINUTE, 60).
-define(SECONDS_PER_HOUR,   3600).
-define(SECONDS_PER_DAY,    86400).

-define(APP_NAME, holtom_game).

-endif.
