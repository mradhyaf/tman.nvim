local a = vim.api
local util = require "tman.util"
local M = {}
local terminals = {
    list = {}
    -- last = {term} -- last open terminal
    -- {term_id} = {
    --     bid = {buf_id}
    --     tid = {term_id}
    -- }
}

M.new = function()
    local term = {}
    term.bid = util.buf_new()
    term.wid = util.win_open(term.bid)

    local cid = vim.fn.termopen(vim.o.shell)
    if cid == nil then
        util.term_del(term)
        return
    end

    term.tid = #terminals.list + 1
    terminals[term.tid] = term

    return term
end

M.show = function()
    local term = terminals.last or util.get_last_open(terminals.list) or M.new()
    if term == nil then return end

    if term.wid == nil then
        util.win_open(term.bid)
    end
    terminals.last = term

    return term.tid
end

M.list = function()
end

M.hide = function()
    local term = terminals.last
    if term == nil then return end

    util.win_hide(term.wid)
    term.wid = nil
end

M.close = function()
end

-- API: CRUD on terminals
-- M.new(): create a new terminal
-- M.open(): open the last opened terminal or create and open
-- M.list(): list open terminals
-- M.close(): close selected terminal
return M
