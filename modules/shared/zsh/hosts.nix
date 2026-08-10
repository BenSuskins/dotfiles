# Homelab hosts. Mirrors the ansible inventory at
# github.com/BenSuskins/homelab-ansible-plays. Hosts without a `user` get an
# IP session variable but no ssh alias.
{
  media = {
    ip = "192.168.0.201";
    user = "mediaserver";
  };

  docker = {
    ip = "192.168.0.202";
    user = "docker";
  };

  monitor = {
    ip = "192.168.0.203";
    user = "monitor";
  };

  development = {
    ip = "192.168.0.204";
    user = "development";
  };

  bumblebee = {
    ip = "192.168.0.200";
    user = "bumblebee";
  };

  ai = {
    ip = "192.168.0.206";
    user = "ai";
  };

  game = {
    ip = "192.168.0.103";
    user = "gameserver";
  };

  nas = {
    ip = "192.168.0.100";
    user = null;
  };
}
