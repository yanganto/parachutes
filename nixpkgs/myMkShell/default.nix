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

  extractDescription = script:
    let
      scriptPath = "${script}/bin/${script.name}";
      content = builtins.readFile scriptPath;
      lines = lib.splitString "\n" content;
      findDescription = lines: idx:
        if idx >= builtins.length lines then
          null
        else
          let
            line = builtins.elemAt lines idx;
            hasContent = lib.hasPrefix "#" (lib.removePrefix " " (lib.removePrefix "\t" line));
            notShebang = !lib.hasPrefix "#!" line;
          in
          if hasContent && notShebang then
            let
              trimmed = lib.removePrefix "#" (lib.removePrefix " " (lib.removePrefix "\t" line));
            in
            lib.removePrefix " " trimmed
          else
            findDescription lines (idx + 1);
    in
    findDescription lines 0;

  formatScript = script:
    let
      desc = extractDescription script;
      escapedDesc = if desc != null then
        builtins.replaceStrings ["\"" "\\"] ["\\\"" "\\\\"] desc
      else
        null;
    in
    if escapedDesc != null then
      "echo \"  ${script.name} - ${escapedDesc}\""
    else
      "echo \"  ${script.name}\"";
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
        ${builtins.concatStringsSep "\n" (map formatScript myScripts)}
      '';
    }
  )
