-- The popup is a reference, not a lesson. Twenty-five entries appear the
-- moment you press <leader>, and the default sort puts the eleven groups
-- *last*, scattered behind two dozen single keys.
--
-- Sorting groups first makes the panel read top-down as "here are the areas",
-- then "here are the loose keys". It is still long. The document you learn
-- from is <leader>K in cheatsheet.lua.
return {
  {
    "folke/which-key.nvim",
    opts = {
      -- Sorters are key functions; the list is a tie-breaking chain and lower
      -- sorts first. The built-in "group" sorter returns 1 for groups, which
      -- is what pushes them to the bottom. This one inverts it.
      sort = {
        "local",
        "order",
        function(item)
          return item.group and 0 or 1
        end,
        "alphanum",
        "mod",
      },
    },
  },
}
