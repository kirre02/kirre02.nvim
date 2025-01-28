local blink = require 'blink.cmp'

local function init()
    blink.setup({
        keymap = {
            preset = 'default', -- Adjust this if you prefer 'super-tab' or 'enter'
            mappings = {
                ["<Tab>"] = "select_next_item",
                ["<S-Tab>"] = "select_prev_item",
                ["<C-p>"] = "select_prev_item",
                ["<C-n>"] = "select_next_item",
                ["<C-d>"] = "scroll_docs_up",
                ["<C-f>"] = "scroll_docs_down",
                ["<C-Space>"] = "complete",
                ["<C-e>"] = "close",
                ["<CR>"] = "confirm_replace", -- Replace the existing text on confirmation
            },
        },
        appearance = {
            use_nvim_cmp_as_default = true,
            nerd_font_variant = 'mono',
        },
        sources = {
            default = { 'lsp', 'snippets', 'buffer', 'lua', 'path' },
        },
   })
end

return {
    init = init,
}
