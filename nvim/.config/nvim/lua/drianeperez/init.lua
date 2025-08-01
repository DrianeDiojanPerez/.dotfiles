require("drianeperez.remap")
require("drianeperez.set")
require("drianeperez.lazy_init")

-- -- Create highlight groups
-- vim.api.nvim_set_hl(0, "PropertyTag", { fg = "#98c379", bold = true })  -- Green color for @property
-- vim.api.nvim_set_hl(0, "PropertyType", { fg = "#61afef" })              -- Blue color for type
-- vim.api.nvim_set_hl(0, "PropertyVar", { fg = "#e5c07b" })               -- Yellow color for variable

-- -- Create pattern matching for the property tags
-- local pattern_group = vim.api.nvim_create_augroup("PropertyHighlight", { clear = true })
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--     group = pattern_group,
--     pattern = {"*.php"},  -- Adjust file types as needed
--     callback = function()
--         -- Highlight @property
--         vim.fn.matchadd("PropertyTag", "@property")
--         -- Highlight the type (word after @property)
--         vim.fn.matchadd("PropertyType", "\\(@property\\s\\+\\)\\@<=\\w\\+")
--         -- Highlight the variable (word after $)
--         vim.fn.matchadd("PropertyVar", "\\$\\w\\+")
--     end,
-- })

local augroup = vim.api.nvim_create_augroup
local DrianePerezGroup = augroup('DrianePerez', {})


local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)

end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd("TextYankPost",{
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end
})

autocmd({"BufWritePre"},{
    group = DrianePerezGroup,
    pattern = '*',
    command = [[%s/\s\+$//e]],

})

autocmd('LspAttach',{
    group = DrianePerezGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    end

})


vim.g.netrw_browse_split= 0
vim.g.netrw_banner= 0
vim.g.netrw_winsize= 25

