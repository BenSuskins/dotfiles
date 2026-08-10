{ name, email }:

{
  enable = true;
  ignores = [
    "*.swp"
    ".envrc"
    ".claude"
    "**/.claude/settings.local.json"
    "CLAUDE.md"
    "DESIGN.md"
    "plans/"
  ];
  signing.format = null;
  settings = {
    alias = {
      # Status & Info
      st = "status";
      ss = "status -s";
      di = "diff";
      dc = "diff --cached";
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      lo = "log --oneline -20";
      last = "log -1 HEAD --stat";

      # Branching
      br = "branch";
      bra = "branch -a";
      co = "checkout";
      cob = "checkout -b";
      sw = "switch";
      swc = "switch -c";

      # Committing
      ci = "commit";
      cia = "commit --amend";
      cian = "commit --amend --no-edit";

      # Staging
      aa = "add --all";
      ap = "add -p";
      unstage = "reset HEAD --";

      # Stashing
      sta = "stash";
      stap = "stash pop";
      stal = "stash list";

      # Remote
      pu = "push";
      puf = "push --force-with-lease";
      pl = "pull";
      fe = "fetch --all --prune";

      # Rebase
      rb = "rebase";
      rbi = "rebase -i";
      rba = "rebase --abort";
      rbc = "rebase --continue";
      rum = "rebase main@{u}";

      # Cleanup
      gone = "!git fetch -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D";
    };
    user = {
      name = name;
      email = email;
    };
    init.defaultBranch = "main";
    core.autocrlf = "input";
    pull.rebase = true;
    pull.ff = "only";
    rebase.autoStash = true;
    push.default = "simple";
    push.autoSetupRemote = true;
    fetch.prune = true;
    merge.ff = "only";
    color.ui = "auto";
    user.signingkey = "~/.ssh/signing_key";
    gpg.format = "ssh";
    commit.gpgsign = true;
    gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
  };
  lfs = {
    enable = true;
  };
}
