local terminals = require "tman.terminals"
local ucmd = vim.api.nvim_create_user_command

ucmd("Term",
function()
    terminals.show()
end,
{})

ucmd("THide",
function()
    terminals.hide()
end,
{})
