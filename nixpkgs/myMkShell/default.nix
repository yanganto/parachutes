{
  lib,
  mkShell,
  ...
}:
let
  PROMPT = ''
    _git_ps1() {
        git rev-parse --is-inside-work-tree &>/dev/null || return
        local branch dirty
        branch=$(git symbolic-ref --short HEAD 2>/dev/null)
        [[ -n $(git status --porcelain) ]] && dirty='*'
        echo "<$branch$dirty>"
    }
    export PS1='\[\e[33m\][$DEVSHELL] \w $(_git_ps1) \$\[\e[0m\] '
    export PS4=$'\033[31m ⊙ \033[0m'
  '';
in
attrs:
if !attrs ? name then
  throw "myMkShell: 'name' is required (exported as DEVSHELL and shown in the prompt)"
else
  let
    myScripts = attrs.myScripts or [ ];
  in
  mkShell (
    (builtins.removeAttrs attrs [ "myScripts" ])
    // {
      buildInputs = (attrs.buildInputs or [ ]) ++ myScripts;
      shellHook = ''
        export DEVSHELL=${lib.escapeShellArg attrs.name}
        ${PROMPT}
        ${attrs.shellHook or ""}
      ''
      + lib.optionalString (myScripts != [ ]) ''
        echo "Scripts:"
        ${builtins.concatStringsSep "\n" (map (s: "echo \"  ${s.name}\"") myScripts)}
      '';
    }
  )
