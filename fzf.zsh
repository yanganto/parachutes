fb() {
    if [ $# -gt 0 ]; then
        find $1 -not -path '*/\.*' | fzf  --ansi --preview-window 'right:80%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'
    else
        find . -not -path '*/\.*' | fzf  --ansi --preview-window 'right:80%' --preview 'bat --color=always --style=header,grid --line-range :300 {}'
    fi
}

fh() {
    print -z $( history | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

fl() {
    local out shas sha q k
    while out=$(
        git log --graph --color=always \
          --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
        fzf --ansi --multi --no-sort --reverse --query="$q" \
          --print-query --expect=ctrl-d --toggle-sort=\`); do
        q=$(head -1 <<< "$out")
        k=$(head -2 <<< "$out" | tail -1)
        shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')

        [ -z "$shas" ] && continue

        if [ "$k" = ctrl-d ]; then
            git diff --color=always $shas | less -R
        else
            for sha in $shas; do
            git show --color=always $sha | less -R
            done
        fi
    done
}
