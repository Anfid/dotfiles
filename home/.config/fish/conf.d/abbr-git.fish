status is-interactive || exit

function git_main_branch --description "Check if main exists and use instead of master"
    command git rev-parse --git-dir &>/dev/null || return
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}
        if command git show-ref -q --verify $ref
            basename $ref
            return 0
        end
    end

    # If no main branch was found, fall back to master but return error
    echo master
    return 1
end

function git_develop_branch
    command git rev-parse --git-dir &>/dev/null || return
    for branch in dev devel develop development
        if command git show-ref -q --verify refs/heads/$branch
            echo $branch
            return 0
        end
    end

    echo develop
    return 1
end

# branch
abbr gb  'git branch'
abbr gba 'git branch --all'
abbr gbd 'git branch --delete'
abbr gbD 'git branch --delete --force'
abbr gbm 'git branch --move'

# checkout
abbr gco "git checkout"
abbr gcb "git checkout -b"
abbr gcd "git checkout (git_develop_branch)"
abbr gcm "git checkout (git_main_branch)"

# commits
abbr gaa   "git add --all"
abbr gcam  'git commit --all --message'
abbr gcmsg "git commit --message"
abbr gcn!  "git commit --verbose --no-edit --amend"

# diff
abbr gd   'git diff'
abbr gdca 'git diff --cached'
abbr gdcw 'git diff --cached --word-diff'
abbr gds  'git diff --staged'
abbr gdw  'git diff --word-diff'

# log
abbr glgg  'git log --graph'
abbr glo   'git log --oneline --decorate'
abbr glog  'git log --oneline --decorate --graph'
abbr gloga 'git log --oneline --decorate --graph --all'
abbr glg   'git log --stat'
abbr glgp  'git log --stat --patch'

# merge
abbr gm   'git merge'
abbr gma  'git merge --abort'
abbr gmc  'git merge --continue'
abbr gms  "git merge --squash"
abbr gmff "git merge --ff-only"
abbr gmom 'git merge origin/(git_main_branch)'
abbr gmum 'git merge upstream/(git_main_branch)'

# pull
abbr gl  'git pull'
abbr gpr 'git pull --rebase'

# push
abbr gp "git push"

# rebase
abbr grb  'git rebase'
abbr grba 'git rebase --abort'
abbr grbc 'git rebase --continue'
abbr grbi 'git rebase --interactive'
abbr grbd 'git rebase (git_develop_branch)'
abbr grbm 'git rebase (git_main_branch)'

# stash
abbr gsta "git stash push"
abbr gstp "git stash pop"
abbr gsts "git stash show --patch"

# other
abbr gsh "git show"
abbr gst "git status"
abbr glg "git log --stat"
abbr gr  "git remote"
