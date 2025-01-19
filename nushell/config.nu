# ------------------------
# Environment
# ------------------------

$env.EDITOR = "hx"
$env.WORDCHARS = r#'~*-_.!?#$%^&()[]{}<>'"`'#
$env.BAT_THEME = "base16"

use std/util "path add"

let extra_path = [
  "~/.local/bin"
  "~/.cargo/bin"
  "~/.ghcup/bin"
]

$extra_path
  | path expand
  | where {path exists}
  | where {$in not-in $env.PATH}
  | if ($in | is-not-empty) {path add $in}

if (which rustc | is-not-empty) {
  let rust_src_path_components = [(rustc --print sysroot) lib rustlib src rust library]
  $env.RUST_SRC_PATH = $rust_src_path_components | path join
}

# ------------------------
# History-related settings
# ------------------------
# $env.config.history.*

# History file format, either "sqlite" or "plaintext"
$env.config.history.file_format = "sqlite"

# The maximum number of entries allowed in the history
$env.config.history.max_size = 5_000_000

# For SQLite-backed history, isolate currently open session from other sessions
$env.config.history.isolation = true

# ----------------------
# Miscellaneous Settings
# ----------------------

# Disable the welcome banner at startup
$env.config.show_banner = false

# Move files to trash by default on `rm`. Override with `rm --permanent`
$env.config.rm.always_trash = true

# --------------------
# Completions Behavior
# --------------------

# algorithm (string): Either "prefix" or "fuzzy"
$env.config.completions.algorithm = "fuzzy"

# ----------------------
# Error Display Settings
# ----------------------

# display_errors.exit_code (bool):
# true: Display a Nushell error when an external command returns a non-zero exit code
# false: Display only the error information printed by the external command itself
# Note: Core dump errors are always printed; SIGPIPE never triggers an error
$env.config.display_errors.exit_code = false

# -------------
# Table Display
# -------------

# footer_mode (string or int): Either "always", "never", "auto" or (int)
$env.config.footer_mode = "auto"

# index_mode (string) - One of:
# "never": never show the index column in a table or list
# "always": always show the index column in tables and lists
# "auto": show the column only when there is an explicit "index" column in the table
# Can be overridden by passing a table to `| table --index/-i`
$env.config.table.index_mode = "auto"

# ----------------
# Datetime Display
# ----------------
# datetime_format.* (string or nothing):
# Format strings that will be used for datetime values.
# When set to `null`, the default behavior is to "humanize" the value (e.g., "now" or "a day ago")

# datetime_format.normal (string or nothing):
# The format string (or `null`) that will be used to display a datetime value when it appears as
# a raw value.
$env.config.datetime_format.normal = "%F %I:%M:%S%p"

# ------------------------
# Aliases
# ------------------------

alias e = hx
alias md = mkdir
alias rd = rmdir
alias q = exit

# ------------------------
# Git aliases
# ------------------------

def git-main-branch [] {
  if ((^git rev-parse --git-dir o+e>| complete | get exit_code) != 0) { return }
  "refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}" | str expand
    | filter {|ref| (^git show-ref -q --verify $ref | complete | get exit_code) == 0 }
    | first
    | basename $in
    | default "master"
}

def git-develop-branch [] {
  if ((^git rev-parse --git-dir o+e>| complete | get exit_code) != 0) { return null }
  [dev devel develop development]
    | filter {|branch| (^git show-ref -q --verify $"refs/heads/($branch)" | complete | get exit_code) == 0}
    | first
    | default "develop"
}

# branch
alias gb =  git branch
alias gba = git branch --all
alias gbd = git branch --delete
alias gbD = git branch --delete --force
alias gbm = git branch --move

# checkout
alias gco = git checkout
alias gcb = git checkout -b
alias gcd = git checkout (git-develop-branch)
alias gcm = git checkout (git-main-branch)

# commits
alias gaa =   git add --all
alias gcam =  git commit --all --message
alias gcmsg = git commit --message
alias gcn! =  git commit --verbose --no-edit --amend

# diff
alias gd =   git diff
alias gdca = git diff --cached
alias gdcw = git diff --cached --word-diff
alias gds =  git diff --staged
alias gdw =  git diff --word-diff

# log
alias glgg =  git log --graph
alias glo =   git log --oneline --decorate
alias glog =  git log --oneline --decorate --graph
alias gloga = git log --oneline --decorate --graph --all
alias glg =   git log --stat
alias glgp =  git log --stat --patch

# merge
alias gm =   git merge
alias gma =  git merge --abort
alias gmc =  git merge --continue
alias gms =  git merge --squash
alias gmff = git merge --ff-only
alias gmom = git merge origin/(git-main-branch)
alias gmum = git merge upstream/(git-main-branch)

# pull
alias gl =  git pull
alias gpr = git pull --rebase

# push
alias gp = git push

# rebase
alias grb =  git rebase
alias grba = git rebase --abort
alias grbc = git rebase --continue
alias grbi = git rebase --interactive
alias grbd = git rebase (git-develop-branch)
alias grbm = git rebase (git-main-branch)

# stash
alias gsta = git stash push
alias gstp = git stash pop
alias gsts = git stash show --patch

# other
alias gsh = git show
alias gst = git status
alias glg = git log --stat
alias gr =  git remote
