local mutt = _G.mutt

local keys = {}

function keys.clear()
    mutt.command.unbind("*")
end

-- Modes:
-- * alias   - alias menu displaying suggested aliases
-- * browser - file/directory browser
-- * editor  - single line editor for 'To:', 'Subject:' prompts.
-- * index   - the main menu showing messages in a folder
-- * pager   - where the contents of the message are displayed
-- * query   - menu displaying results of query command
function keys.bind(modes, key, func)
    mutt.command.bind(modes, key, func)
end

function keys.macro(modes, key, seq)
    mutt.command.macro(modes, key, seq)
end

return keys
