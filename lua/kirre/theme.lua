local tokyonight = require 'tokyonight'
local colorizer = require 'colorizer'
local gitsigns = require 'gitsigns'
local lualine = require 'lualine'
local noice = require 'noice'

local function init()
    tokyonight.setup({
        flavour = "Storm",
        integrations = {
            gitsigns = true,
            --indent_blankline = { enabled = true },
            native_lsp = {
                enabled = true,
            },
            telescope = true,
            treesitter = true,
        },
        term_colors = true,
        transparent_background = true,
    })

    colorizer.setup {}

    gitsigns.setup {}

    lualine.setup {
        options = {
            component_separators = { left = '', right = '' },
            extensions = { "fzf", "quickfix" },
            icons_enabled = false,
            section_separators = { left = '', right = '' },
            theme = "tokyonight"
        },
        sections = {
            lualine_x = {
                {
                    noice.api.status.message.get_hl,
                    cond = noice.api.status.message.has,
                },
                {
                    noice.api.status.command.get,
                    cond = noice.api.status.command.has,
                    color = { fg = "#EED49F" },
                },
                {
                    noice.api.status.mode.get,
                    cond = noice.api.status.mode.has,
                    color = { fg = "#EED49F" },
                },
                {
                    noice.api.status.search.get,
                    cond = noice.api.status.search.has,
                    color = { fg = "#EED49F" },
                },
            },
        }
    }

    vim.cmd.colorscheme "tokyonight"
end

return {
    init = init,
}
