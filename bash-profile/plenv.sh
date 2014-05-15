if [ -z "$PLENV_ROOT" ]; then
    export PLENV_ROOT="/opt/plenv"
fi
PLENV=$( which plenv )
if [ -z "$PLENV" ]; then
    export PATH="$PLENV_ROOT/bin:$PATH"
    PLENV="$PLENV_ROOT/bin/plenv"
fi
eval "$(sudo $PLENV init -)"
