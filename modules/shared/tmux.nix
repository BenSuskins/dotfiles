{ pkgs }:

let
  snazzy = {
    background = "#282a36";
    foreground = "#eff0eb";
    selection = "#3e4451";
    comment = "#686868";
    red = "#ff5c57";
    green = "#5af78e";
    yellow = "#f3f99d";
    blue = "#57c7ff";
    magenta = "#ff6ac1";
    cyan = "#9aedfe";
  };
in
{
  enable = true;

  prefix = "C-a";
  baseIndex = 1;
  mouse = true;
  keyMode = "vi";
  escapeTime = 0;
  historyLimit = 50000;
  focusEvents = true;
  disableConfirmationPrompt = true;
  terminal = "tmux-256color";

  plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator
  ];

  extraConfig = ''
    set -ag terminal-overrides ",xterm-ghostty:RGB,xterm-256color:RGB"
    set -g set-clipboard on
    set -g renumber-windows on
    set -g allow-rename off
    set -g status-interval 5

    set -g visual-activity off
    set -g visual-bell off
    set -g visual-silence off
    set -g bell-action none
    setw -g monitor-activity off

    # Splits — mirrors ghostty cmd+d / cmd+shift+d
    unbind '"'
    unbind %
    bind | split-window -h -c "#{pane_current_path}"
    bind - split-window -v -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"

    # Pane navigation — ghostty cmd+alt+arrows
    bind -n M-Left select-pane -L
    bind -n M-Right select-pane -R
    bind -n M-Up select-pane -U
    bind -n M-Down select-pane -D

    # Pane resize — ghostty cmd+ctrl+arrows
    bind -r C-Left resize-pane -L 5
    bind -r C-Right resize-pane -R 5
    bind -r C-Up resize-pane -U 5
    bind -r C-Down resize-pane -D 5
    bind = select-layout tiled

    # Zoom — ghostty cmd+shift+enter
    bind Enter resize-pane -Z

    # Windows — ghostty cmd+shift+left / cmd+shift+right
    bind -n S-Left previous-window
    bind -n S-Right next-window

    bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux.conf reloaded"

    # Copy mode
    bind -T copy-mode-vi v send-keys -X begin-selection
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "pbcopy"

    # Snazzy
    set -g pane-border-style 'fg=${snazzy.selection}'
    set -g pane-active-border-style 'fg=${snazzy.magenta}'
    set -g message-style 'fg=${snazzy.background} bg=${snazzy.cyan} bold'
    setw -g mode-style 'fg=${snazzy.background} bg=${snazzy.cyan}'
    setw -g clock-mode-colour '${snazzy.cyan}'

    set -g status-position bottom
    set -g status-justify left
    set -g status-style 'fg=${snazzy.foreground} bg=${snazzy.background}'
    set -g status-left-length 30
    set -g status-left ' #[fg=${snazzy.green} bold]#S #[fg=${snazzy.comment}]| '
    set -g status-right-length 50
    set -g status-right '#[fg=${snazzy.comment}]#{?client_prefix,#[fg=${snazzy.magenta}]PREFIX ,}#[fg=${snazzy.blue}]%a %d %b #[fg=${snazzy.yellow}]%H:%M '
    setw -g window-status-format ' #[fg=${snazzy.comment}]#I #[fg=${snazzy.foreground}]#W#[fg=${snazzy.red}]#F '
    setw -g window-status-current-format ' #[fg=${snazzy.magenta} bold]#I #[fg=${snazzy.cyan} bold]#W#[fg=${snazzy.red}]#F '
    setw -g window-status-separator ""
  '';
}
