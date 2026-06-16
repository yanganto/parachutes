{
  perSystem =
    {
      config,
      lib,
      pkgs,
      system,
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
        PS1='\[\e[33m\][$DEVSHELL] \w $(_git_ps1) \$\[\e[0m\] '
      '';
    in
    {
      devShells = {
        default = config.devShells.middle;
        middle = import ./middle.nix { inherit lib pkgs PROMPT; };
        nettest = import ./nettest.nix { inherit lib pkgs PROMPT; };
      };
      formatter = pkgs.nixfmt-rfc-style;
    };
}
