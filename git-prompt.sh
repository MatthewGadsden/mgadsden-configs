# # Custom prompt settings

function print_insert() {
    git check-ignore -q . 2>/dev/null; if [ "$?" -ne "1" ];
    then return
    else
    local insert=$(git diff --stat | grep -oP '\d+(?= insertion)')
    local staged_insert=$(git diff --cached --stat | grep -oP '\d+(?= insertion)')
    printf -- "+$insert($staged_insert) "
    fi
}

function print_del() {
    git check-ignore -q . 2>/dev/null; if [ "$?" -ne "1" ];
    then return
    else
    local del=$(git diff --stat | grep -oP '\d+(?= deletion)')
    local staged_del=$(git diff --cached --stat | grep -oP '\d+(?= deletion)')
    printf -- "-$del($staged_del) "
    fi
}

function print_files() {
    git check-ignore -q . 2>/dev/null; if [ "$?" -ne "1" ];
    then return
    else
    local file=$(git diff --stat | grep -oP '\d+(?= file change)')
    local files=$(git diff --stat | grep -oP '\d+(?= files change)')
    local stages_file=$(git diff --cached --stat | grep -oP '\d+(?= file change)')
    local stages_files=$(git diff --cached --stat | grep -oP '\d+(?= files change)')
    printf -- " 📑 $file$files($stages_file$stages_files) "
    fi
}

function print_space() {
    git check-ignore -q . 2>/dev/null; if [ "$?" -ne "1" ];
    then return
    else
    printf -- " "
    fi
}

function node_prompt_version() {
    if which node &> /dev/null; then
        local nodev=$(node.exe -v)
        printf -- "[";
        printf -- "\\033[38;5;78m";
        printf -- "$nodev";
        printf -- "\\033[0m";
        printf -- "]";
    fi
}

PROMPT_DIRTRIM=4                         # Shorten deep paths in the prompt
PS1='\[\033]0;Git | Bash v\v | \W\007\]' # set window title
PS1="$PS1"'\n'                           # new line
PS1="$PS1"'\[\033[\e[38;5;0m\e[48;5;209m\] [\A] '        # black text, magenta, 24h time
PS1="$PS1"'\[\033[\e[38;5;0m\e[48;5;221m\] \u '          # black text, green, user
#PS1="$PS1"'\[\033[97;42m\]@\h '          # black text, green, @host
PS1="$PS1"'\[\033[\e[38;5;0m\e[48;5;231m\] \w '          # black text, yellow, working director
if test -z "$WINELOADERNOEXEC"
then
    GIT_EXEC_PATH="$(git --exec-path 2>/dev/null)"
    COMPLETION_PATH="${GIT_EXEC_PATH%/libexec/git-core}"
    COMPLETION_PATH="${COMPLETION_PATH%/lib/git-core}"
    COMPLETION_PATH="$COMPLETION_PATH/share/git/completion"
    if test -f "$COMPLETION_PATH/git-prompt.sh"
    then
        . "$COMPLETION_PATH/git-completion.bash"
        . "$COMPLETION_PATH/git-prompt.sh"
        PS1="$PS1"'\[\033[38;5;231;48;5;132m\]'     # white text, cyan
        PS1="$PS1"'`__git_ps1`'                     # bash function
    fi
fi
PS1="$PS1"'`print_space`'
PS1="$PS1"'\[\033[0m\]'                 # default colour
PS1="$PS1"'\[\033[\e[38;5;231m\]'       # white text
PS1="$PS1"'`print_files`'               # no. files changed
PS1="$PS1"'\[\033[\e[38;5;155m\]'       # green text
PS1="$PS1"'`print_insert`'              # git adds
PS1="$PS1"'\[\033[\e[38;5;167m\]'       # red text
PS1="$PS1"'`print_del`'                 # git removed
PS1="$PS1"'\[\033[0m\]'                 # default colour
PS1="$PS1"'`node_prompt_version`'       # node version
PS1="$PS1"'\n'                          # new line
PS1="$PS1"'>> '                         # prompt: always >>

# Git status options
# Shows * or + for unstaged and staged changes, respectively.
export GIT_PS1_SHOWSTASHSTATE=true

# shows $ if there are any stashes.
export GIT_PS1_SHOWDIRTYSTATE=true

# Shows % if there are any untracked files.
export GIT_PS1_SHOWUNTRACKEDFILES=true

# shows <, >, <>, or = when your branch is behind, ahead, diverged from,
# or in sync with the upstream branch, respectively.
export GIT_PS1_SHOWUPSTREAM="auto"
