# programs.neovim is deliberately not used. Enabling it makes home-manager
# generate its own ~/.config/nvim/init.lua, which collides with the symlink in
# files.nix that points the whole directory at programs/neovim in this repo.
#
# So neovim comes from packages.nix, the aliases come from zsh/aliases.nix, and
# the provider flags this module used to emit now live in
# programs/neovim/lua/config/options.lua, next to every other option.
{ }
