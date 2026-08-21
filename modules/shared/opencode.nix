{ hostRole, agents }:

{
  enable = hostRole == "personal";

  context = agents.context.opencode;

  skills = agents.skills;
}
