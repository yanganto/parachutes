- Using Rust and Nix for every project, if there is devshell please work with `nix develop -c `.  Please respond in straightforward and in simple English phrases.  
- Investigate read-only first, and never commit unless I ask
- Please do every code change follow the linter, you can do `nix develop -c cargo fmt` or `cargo fmt` to double check on the Rust code. 
- If asking `g msg w body`, that mean I want a git commit message with body in short for the code change.
- Some chars to shorten phrases
  * g: git
  * gc: git commit
  * msg: message
  * w: with
  * w/: without
  * s: staged
  * -s: unstaged
  * cc: cargo check (if there is devshell, then it means `nix develop -c cargo check`)
  * fmt: cargo fmt (if there is devshell, then it means `nix develop -c cargo fmt`)
  * lint: cargo clippy (if there is devshell, then it means `nix develop -c cargo clippy`)
- Do not write test cases that merely re-assert type-system guarantees in Rust
  (exhaustive matches, error-variant classification); the compiler already covers them.
- When providing a g commit hash to me, also copy it into my clipboard
  (`printf '<hash>' | wl-copy`, fallback `xsel -b`).
- When providing a g commit msg to me, please also check if there is any other commit we can fix up to, and copy the hash for me.
