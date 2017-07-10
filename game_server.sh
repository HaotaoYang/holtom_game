#!/usr/bin/env bash

case $1 in
    'start')
        _build/default/rel/holtom_game/bin/holtom_game start;;
    'console')
        _build/default/rel/holtom_game/bin/holtom_game console;;
    'remote_console')
        _build/default/rel/holtom_game/bin/holtom_game remote_console;;
    'stop')
        _build/default/rel/holtom_game/bin/holtom_game stop;;
    *)
        show_info;;
esac
