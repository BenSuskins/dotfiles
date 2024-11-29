bootstrap:
	echo "Installing Nix..."
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

rebuild:
	echo "Rebuilding Nix..."
	darwin-rebuild switch --flake .

update:
	echo "Updating Nix Flake..."
	nix flake update