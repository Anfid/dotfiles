local option = require("dsl.options")
local account = require("dsl.accounts")

local config_dir = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME").."/.config/mutt"
local cache_dir = os.getenv("XDG_CACHE_HOME") or os.getenv("HOME").."/.cache"

mutt.command.unset("imap_passive")

option.imap_keepalive = 300
option.mail_check = 120
option.header_cache = cache_dir.."/mutt"

account:add {
    email = "mikhail.pogretskiy@gmail.com",
    name = "Mikhail Pogretskiy",
    imap = "imap.gmail.com:993",
    smtp = "smtp.gmail.com:465",
}
account:add {
    email = "pogretzkiy.mihail@gmail.com",
    name = "Mikhail Pogretskiy",
    imap = "imap.gmail.com:993",
    smtp = "smtp.gmail.com:465",
}
account:set("mikhail.pogretskiy@gmail.com")
