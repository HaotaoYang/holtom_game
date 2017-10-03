-ifndef(__TIME_HRL__).
-define(__TIME_HRL__, true).

-define(TIMESTAMP,          erlang:system_time(second)).
-define(MILLI_TIMESTAMP,    erlang:system_time(millisecond)).
-define(MICRO_TIMESTAMP,    erlang:system_time(microsecond)).

-define(SECONDS_PER_MINUTE, 60).
-define(SECONDS_PER_HOUR,   3600).
-define(SECONDS_PER_DAY,    86400).

-endif.
