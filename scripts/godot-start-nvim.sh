#!/bin/sh

TERM_EXEC="kitty"
TMUX_SESSION="nvim_session"

if [ $# -ne 4 ]; then
    echo "USAGE: $0 <socket> <file> <line> <column>"
    exit 1
fi

SOCKET="$1"
FILE="$2"
LINE="$3"
COL="$4"

# Function to check if a Neovim instance is already running with the given socket
is_nvim_running() {
    pgrep -f "nvim.*--listen $SOCKET" > /dev/null
}

if [ -S "$SOCKET" ]; then
    # Connect to running nvim server if socket exists
    nvim --server "$SOCKET" --remote-send ":n +call\ cursor($LINE,$COL) $FILE<CR>"
else
    # Check if a Neovim instance is already running with the specified socket
    if is_nvim_running; then
        nvim --server "$SOCKET" --remote-send ":n +call\ cursor($LINE,$COL) $FILE<CR>"
    else
        # Ensure `kitty` opens `tmux` and keeps it running
        if tty -s; then
            if tmux has-session -t "$TMUX_SESSION" 2>/dev/null; then
                $TERM_EXEC tmux attach-session -t "$TMUX_SESSION"
            else
                $TERM_EXEC tmux new-session -s "$TMUX_SESSION" -d
                $TERM_EXEC tmux send-keys -t "$TMUX_SESSION" "nvim --listen \"$SOCKET\" +\"call cursor($LINE,$COL)\" \"$FILE\"" C-m
                $TERM_EXEC tmux attach-session -t "$TMUX_SESSION"
            fi
        else
            # Fallback to non-GUI mode
            nvim --listen "$SOCKET" +"call cursor($LINE,$COL)" "$FILE"
        fi
    fi
fi

