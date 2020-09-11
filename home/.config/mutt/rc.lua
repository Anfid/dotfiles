local account = require("dsl.accounts")
local keys = require("dsl.keys")
local option = require("dsl.options")

local cache_dir = os.getenv("XDG_CACHE_HOME") or os.getenv("HOME").."/.cache"
local config_dir = os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME").."/.config/mutt"

option.imap_keepalive = 300
option.mail_check = 120
option.header_cache = cache_dir.."/mutt"

option.sidebar_visible = "yes"

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

--keys.clear()

-- General navigation
keys.bind("index,pager", "e", "next-undeleted")
keys.bind("index,pager", "i", "previous-undeleted")

keys.bind("index,pager", "\\'", "enter-command")

-- Accounts
keys.macro("index,pager", "<F1>", [["<enter-command>lua require('dsl.accounts'):set('mikhail.pogretskiy@gmail.com')<enter>"]])
keys.macro("index,pager", "<F2>", [["<enter-command>lua require('dsl.accounts'):set('pogretzkiy.mihail@gmail.com')<enter>"]])

keys.bind("alias,index,browser,query", "G", "last-entry")
keys.bind("pager", "G", "bottom")

-- Suggested:
-- # Unbind some defaults.
-- bind index <esc>V noop
-- bind index <esc>v noop
-- bind index \Cn noop
-- bind index \Cp noop
-- 
-- bind alias,index,browser,query G last-entry
-- bind pager G bottom
-- 
-- bind alias,index,browser,query gg first-entry
-- bind pager gg top
-- 
-- bind alias,index,pager,browser,query \Cd half-down
-- bind alias,index,pager,browser,query \Cu half-up
-- 
-- bind index <esc><space> collapse-all
-- bind index <space> collapse-thread
-- 
-- bind index n search-next
-- bind index p search-opposite
-- 
-- bind index { previous-thread
-- bind pager { half-up
-- 
-- bind index } next-thread
-- bind pager } half-down
-- 
-- bind index,pager A create-alias
-- bind index,pager a group-reply
-- 
-- # Skip trash when deleting with the delete key.
-- bind index,pager <delete> purge-message
-- 
-- # Readline-like history browsing using up/down keys.
-- bind editor <up> history-up
-- bind editor <down> history-down
-- 
-- # Convenient macros to switch between common folders.  Also tells me what other
-- # folders have new mail once I make a switch.
-- macro index,pager ,d "<change-folder>$postponed<enter><buffy-list>" "open drafts"
-- macro index,pager ,i "<change-folder>$spoolfile<enter><buffy-list>" "open inbox"
-- macro index,pager ,j "<change-folder>+spam<enter><buffy-list>"      "open junk mail (spam)"
-- macro index,pager ,r "<change-folder>^<enter><buffy-list>"          "refresh folder"
-- macro index,pager ,s "<change-folder>$record<enter><buffy-list>"    "open sent mail"
-- macro index,pager ,t "<change-folder>$trash<enter><buffy-list>"     "open trash"
-- 
-- # I use this whenever I know that a folder hook is acting and I just want the
-- # message to go to the default save folder.
-- macro index,pager I "<save-message><enter>" "save message to default folder without confirming"
-- 
-- # Limit messages quickly using ' + key.
-- macro index \'d  "<limit>~D<enter>"       "limit to deleted messages"
-- macro index \'f  "<limit>~F<enter>"       "limit to flagged messages"
-- macro index \'l  "<limit>~=<enter>"       "limit to duplicate messages"
-- macro index \'n  "<limit>~N|~O<enter>"    "limit to new messages"
-- macro index \'p  "<limit>~g|~G<enter>"    "limit to signed or encrypted messages"
-- macro index \'u  "<limit>!~Q<enter>"      "limit to unreplied messages"
-- macro index \'\' "<limit>~A<enter>"       "reset all limits"
-- 
-- # If +spam doesn't exist, mutt will create it for us.
-- macro index S "<save-message>+spam<enter>" "mark message as spam"
-- 
-- # Toggle the mailbox list with "y".
-- macro index,pager y "<change-folder>?<toggle-mailboxes>" "show incoming mailboxes list"
-- bind browser y exit
-- 
-- # Call urlview with Ctrl + B.
-- macro index,pager,attach,compose \cb                                            \
--   "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<Enter>           \
--   <pipe-message>urlview<Enter>                                                  \
--   <enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<Enter>" \
--   "call urlview to extract URLs out of a message"
-- 
-- # Pipe message to pbcopy with Ctrl + Y.  pipe_decode will ensure that
-- # unnecessary headers are removed and the message is processed.
-- macro index,pager,attach,compose \cy                                            \
--   "<enter-command>set my_pipe_decode=\$pipe_decode pipe_decode<Enter>           \
--   <pipe-message>pbcopy<Enter>                                                   \
--   <enter-command>set pipe_decode=\$my_pipe_decode; unset my_pipe_decode<Enter>" \
--   "copy message to clipboard using mutt-pbcopy"
