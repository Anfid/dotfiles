local option = require("dsl.options")

account = {
    accounts = {}
}

-- user: table
-- * email - Email address
-- * name - Full name
-- * imap - IMAP server address and port
-- * smtp - SMTP server address and port
function account.add(self, user)
    if user.email and user.name and user.imap and user.smtp then
        self.accounts[user.email] = user
    else
        error("Could not add user. One of the following fields were not found: email, name, imap, smtp")
    end
end

function account.set(self, email)
    local user = self.accounts[email]

    option.imap_user = user.email
    option.folder = "imaps://"..user.email.."@"..user.imap
    option.smtp_url = "smtps://"..user.email.."@"..user.smtp
    option.from = user.email
    option.realname = user.name

    option.spoolfile = "+INBOX"
    option.postponed = "+[Gmail]/Drafts"
    mutt.command.mailboxes("+INBOX")
end

return account
