#!/usr/bin/env bash

export RELX_REPLACE_OS_VARS=true

case $1 in
    'start')
        NODE_NAME_SUFFIX=127.0.0.1 _build/default/rel/holtom_game/bin/holtom_game start;;
        # NODE_NAME_SUFFIX=127.0.0.1 _build/prod/rel/holtom_game/bin/holtom_game start;;
    'console')
        NODE_NAME_SUFFIX=127.0.0.1 _build/default/rel/holtom_game/bin/holtom_game console;;
    'remote_console')
        _build/default/rel/holtom_game/bin/holtom_game remote_console;;
    'stop')
        _build/default/rel/holtom_game/bin/holtom_game stop;;
    *)
        show_info;;
esac
