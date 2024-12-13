-- Utility functions such as list rearrangement
local a = vim.api
local M = {}

-- Move element eid in list to end of list and swap ids
M.move_last = function(list, eid)
    list[eid], list[#list] = list[#list], list[eid]

    if list[eid].id ~= nil then
        list[eid].id, list[#list].id = #list, eid
    end
end

M.get_last = function(list)
    return list[#list]
end

M.get_last_open = function(list)
    local last = nil
    for _, t in ipairs(list) do
        if t.wid ~= nil then
            last = t
        end
    end

    return last
end

-- Opens a window for the given buffer then returns the window id
M.win_open = function(bid)
    if bid == nil then return end

    local wid = a.nvim_open_win(bid, true, {
        split = 'below',
        win =  -1 -- top-level split
    })
    if wid == 0 then return end

    a.nvim_set_option_value('number', false, { win = wid })
    a.nvim_set_option_value('relativenumber', false, { win = wid })

    return wid
end

-- Hides window of the given window id
M.win_hide = function(wid)
    if wid == nil then return end

    a.nvim_win_hide(wid)
end

-- Create a new terminal buffer, returns the buffer id
M.buf_new = function()
    local bid = a.nvim_create_buf(true, false)
    if bid == 0 then return nil end

    return bid
end

-- Deletes the buffer of the given buffer id
M.buf_del = function(bid)
    -- TODO: check if terminal
    if not a.nvim_buf_is_valid then return false end

    a.nvim_buf_delete(bid)
end

M.term_del = function(term)
    M.win_hide(term.wid)
    M.buf_del(term.bid)
end

return M
