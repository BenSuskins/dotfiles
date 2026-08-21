-- Invariant, vendored in colors/invariant.vim. Colour says what a symbol is:
-- pink keywords, cyan types, green functions, blue parameters, purple numbers.
--
-- The syntax is loud on purpose, so the furniture around it stays quiet. The
-- scheme ships a Monokai-era chrome — olive cursor line, gold selection — that
-- fights the calm statusline in lualine.lua. Everything below either quiets
-- that chrome or paints a plugin the scheme never covered.
--
-- Greys come from the two surfaces Invariant declares (#191a1c editor,
-- #27282b popups, #393a3c splits) plus one step interpolated between them.
local palette = {
  background = "#191a1c",
  surface = "#1f2023", -- cursor line, the step between editor and popup
  popup = "#27282b",
  border = "#393a3c",
  dim = "#7b7468", -- whitespace, indent guides
  comment = "#8a8578", -- Invariant paints comments pure white; too loud to read past
  muted = "#999999", -- line numbers, secondary text
  foreground = "#cfbfad",
  bright = "#efefef",

  keyword = "#ff007f",
  type = "#52e3f6",
  fn = "#a7ec21",
  parameter = "#79abff",
  typeParameter = "#fd971f",
  string = "#ece47e",
  number = "#c48cff",
  signature = "#bed6ff",

  error = "#ff6b68",
  warn = "#be9117",
  info = "#589df6",
  hint = "#659c6b",
}

local function overrides()
  local p = palette

  return {
    -- Quiet the chrome the scheme inherited from Monokai.
    CursorLine = { bg = p.surface },
    CursorLineNr = { fg = p.foreground, bg = p.surface, bold = true },
    Visual = { bg = p.border },
    StatusLine = { fg = p.muted, bg = p.background },
    StatusLineNC = { fg = p.dim, bg = p.background },
    ColorColumn = { bg = p.surface },
    Folded = { fg = p.muted, bg = p.surface },
    WinSeparator = { fg = p.border, bg = p.background },
    Comment = { fg = p.comment },

    -- Floats. The scheme only ever styled Pmenu.
    NormalFloat = { fg = p.foreground, bg = p.popup },
    FloatBorder = { fg = p.border, bg = p.popup },
    FloatTitle = { fg = p.foreground, bg = p.popup, bold = true },
    Pmenu = { fg = p.foreground, bg = p.popup },
    PmenuSel = { fg = p.bright, bg = p.border },
    PmenuSbar = { bg = p.popup },
    PmenuThumb = { bg = p.border },

    -- Diagnostics carry colour in the gutter only; virtual text is off.
    DiagnosticError = { fg = p.error },
    DiagnosticWarn = { fg = p.warn },
    DiagnosticInfo = { fg = p.info },
    DiagnosticHint = { fg = p.hint },
    DiagnosticUnderlineError = { undercurl = true, sp = p.error },
    DiagnosticUnderlineWarn = { undercurl = true, sp = p.warn },
    DiagnosticUnderlineInfo = { undercurl = true, sp = p.info },
    DiagnosticUnderlineHint = { undercurl = true, sp = p.hint },

    Whitespace = { fg = p.surface },
    NonText = { fg = p.surface },
    SnacksIndent = { fg = p.surface },
    SnacksIndentScope = { fg = p.border },

    -- snacks: the picker and the explorer, which the scheme never touched.
    SnacksNormal = { fg = p.foreground, bg = p.popup },
    SnacksNormalNC = { fg = p.muted, bg = p.popup },
    SnacksWinBar = { fg = p.foreground, bg = p.popup, bold = true },
    SnacksWinBarNC = { fg = p.muted, bg = p.popup },
    SnacksPicker = { fg = p.foreground, bg = p.popup },
    SnacksPickerBorder = { fg = p.border, bg = p.popup },
    SnacksPickerTitle = { fg = p.fn, bg = p.popup, bold = true },
    SnacksPickerPrompt = { fg = p.keyword, bg = p.popup },
    SnacksPickerInput = { fg = p.foreground, bg = p.popup },
    SnacksPickerInputBorder = { fg = p.border, bg = p.popup },
    SnacksPickerInputSearch = { fg = p.keyword, bg = p.popup },
    SnacksPickerList = { fg = p.foreground, bg = p.popup },
    SnacksPickerListCursorLine = { bg = p.border },
    SnacksPickerPreview = { fg = p.foreground, bg = p.background },
    SnacksPickerPreviewBorder = { fg = p.border, bg = p.background },
    SnacksPickerPreviewCursorLine = { bg = p.surface },
    SnacksPickerMatch = { fg = p.fn, bold = true },
    SnacksPickerSelected = { fg = p.typeParameter },
    SnacksPickerDir = { fg = p.dim },
    SnacksPickerDirectory = { fg = p.parameter },
    SnacksPickerFile = { fg = p.foreground },
    SnacksPickerPathHidden = { fg = p.dim },
    SnacksPickerPathIgnored = { fg = p.surface },
    SnacksPickerDimmed = { fg = p.dim },
    SnacksPickerTree = { fg = p.border },
    SnacksPickerGitBranchCurrent = { fg = p.fn },
    SnacksPickerTotals = { fg = p.muted },
    SnacksInputNormal = { fg = p.foreground, bg = p.popup },
    SnacksInputBorder = { fg = p.border, bg = p.popup },
    SnacksInputTitle = { fg = p.fn, bg = p.popup, bold = true },
    SnacksInputIcon = { fg = p.keyword },
    SnacksDashboardHeader = { fg = p.keyword, bold = true },
    SnacksDashboardIcon = { fg = p.type },
    SnacksDashboardDesc = { fg = p.foreground },
    SnacksDashboardKey = { fg = p.typeParameter },
    SnacksDashboardFooter = { fg = p.dim },

    -- blink.cmp
    BlinkCmpMenu = { fg = p.foreground, bg = p.popup },
    BlinkCmpMenuBorder = { fg = p.border, bg = p.popup },
    BlinkCmpMenuSelection = { bg = p.border },
    BlinkCmpLabel = { fg = p.foreground },
    BlinkCmpLabelMatch = { fg = p.fn, bold = true },
    BlinkCmpLabelDescription = { fg = p.dim },
    BlinkCmpLabelDetail = { fg = p.dim },
    BlinkCmpLabelDeprecated = { fg = p.dim, strikethrough = true },
    BlinkCmpKind = { fg = p.signature },
    BlinkCmpKindFunction = { fg = p.fn },
    BlinkCmpKindMethod = { fg = p.fn },
    BlinkCmpKindClass = { fg = p.type },
    BlinkCmpKindInterface = { fg = p.type },
    BlinkCmpKindStruct = { fg = p.type },
    BlinkCmpKindVariable = { fg = p.foreground },
    BlinkCmpKindField = { fg = p.foreground },
    BlinkCmpKindProperty = { fg = p.foreground },
    BlinkCmpKindKeyword = { fg = p.keyword },
    BlinkCmpKindSnippet = { fg = p.typeParameter },
    BlinkCmpDoc = { fg = p.foreground, bg = p.popup },
    BlinkCmpDocBorder = { fg = p.border, bg = p.popup },
    BlinkCmpDocSeparator = { fg = p.border, bg = p.popup },
    BlinkCmpGhostText = { fg = p.dim },
    BlinkCmpSignatureHelp = { fg = p.foreground, bg = p.popup },
    BlinkCmpSignatureHelpBorder = { fg = p.border, bg = p.popup },
    BlinkCmpSignatureHelpActiveParameter = { fg = p.parameter, bold = true },

    -- noice
    NoiceCmdline = { fg = p.foreground, bg = p.popup },
    NoiceCmdlinePopup = { fg = p.foreground, bg = p.popup },
    NoiceCmdlinePopupBorder = { fg = p.border, bg = p.popup },
    NoiceCmdlinePopupTitle = { fg = p.fn, bg = p.popup, bold = true },
    NoiceCmdlineIcon = { fg = p.keyword },
    NoiceCmdlineIconSearch = { fg = p.typeParameter },
    NoiceCmdlinePopupBorderSearch = { fg = p.border, bg = p.popup },
    NoiceConfirm = { fg = p.foreground, bg = p.popup },
    NoiceConfirmBorder = { fg = p.border, bg = p.popup },
    NoiceMini = { fg = p.muted, bg = p.background },

    -- which-key
    WhichKey = { fg = p.typeParameter },
    WhichKeyGroup = { fg = p.type },
    WhichKeyDesc = { fg = p.foreground },
    WhichKeySeparator = { fg = p.border },
    WhichKeyNormal = { fg = p.foreground, bg = p.popup },
    WhichKeyBorder = { fg = p.border, bg = p.popup },
    WhichKeyTitle = { fg = p.fn, bg = p.popup, bold = true },
    WhichKeyValue = { fg = p.dim },

    -- gitsigns
    GitSignsAdd = { fg = p.fn },
    GitSignsChange = { fg = p.info },
    GitSignsDelete = { fg = p.error },
    GitSignsAddInline = { bg = "#294436" },
    GitSignsChangeInline = { bg = "#374752" },
    GitSignsDeleteInline = { bg = "#484a4a" },

    -- trouble, where gr now sends its references
    TroubleNormal = { fg = p.foreground, bg = p.background },
    TroubleNormalNC = { fg = p.foreground, bg = p.background },
    TroubleText = { fg = p.foreground },
    TroubleCount = { fg = p.number, bold = true },
    TroubleFilename = { fg = p.type },
    TroublePos = { fg = p.dim },
    TroubleIndent = { fg = p.border },

    -- treesitter-context
    TreesitterContext = { bg = p.surface },
    TreesitterContextLineNumber = { fg = p.dim, bg = p.surface },
    TreesitterContextBottom = { underline = true, sp = p.border },

    -- todo-comments
    TodoFgTODO = { fg = p.info },
    TodoFgFIX = { fg = p.error },
    TodoFgHACK = { fg = p.warn },
    TodoFgNOTE = { fg = p.fn },

    -- render-markdown: headings as coloured text, no filled bars.
    RenderMarkdownH1 = { fg = p.keyword, bold = true },
    RenderMarkdownH2 = { fg = p.fn, bold = true },
    RenderMarkdownH3 = { fg = p.type, bold = true },
    RenderMarkdownH4 = { fg = p.parameter, bold = true },
    RenderMarkdownH5 = { fg = p.typeParameter, bold = true },
    RenderMarkdownH6 = { fg = p.signature, bold = true },
    RenderMarkdownH1Bg = { fg = p.keyword, bold = true },
    RenderMarkdownH2Bg = { fg = p.fn, bold = true },
    RenderMarkdownH3Bg = { fg = p.type, bold = true },
    RenderMarkdownH4Bg = { fg = p.parameter, bold = true },
    RenderMarkdownH5Bg = { fg = p.typeParameter, bold = true },
    RenderMarkdownH6Bg = { fg = p.signature, bold = true },
    RenderMarkdownCode = { bg = p.surface },
    RenderMarkdownCodeInfo = { fg = p.dim },
    RenderMarkdownCodeInline = { fg = p.string, bg = p.surface },
    RenderMarkdownBullet = { fg = p.keyword },
    RenderMarkdownDash = { fg = p.border },
    RenderMarkdownQuote = { fg = p.border },
    RenderMarkdownLink = { fg = p.type, underline = true },
    RenderMarkdownWikiLink = { fg = p.type, underline = true },
    RenderMarkdownChecked = { fg = p.fn },
    RenderMarkdownUnchecked = { fg = p.muted },
    RenderMarkdownTodo = { fg = p.typeParameter },
    RenderMarkdownTableHead = { fg = p.parameter },
    RenderMarkdownTableRow = { fg = p.dim },
    RenderMarkdownIndent = { fg = p.surface },
    RenderMarkdownSuccess = { fg = p.fn },
    RenderMarkdownInfo = { fg = p.info },
    RenderMarkdownWarn = { fg = p.warn },
    RenderMarkdownError = { fg = p.error },
    RenderMarkdownHint = { fg = p.hint },
  }
end

-- Hang the overrides off ColorScheme rather than applying them inline, so they
-- survive a `:colorscheme invariant` typed by hand or a plugin reloading it.
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "invariant",
  callback = function()
    for group, opts in pairs(overrides()) do
      vim.api.nvim_set_hl(0, group, opts)
    end
  end,
})

return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme("invariant")
      end,
    },
  },
}
