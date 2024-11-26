status is-interactive || exit

if command -q eza
    alias ls="eza"
    alias ll="eza -lah --git --group-directories-first"
    alias la="eza -a"
    alias lt="eza -Ta --group-directories-first"
end

alias mntrw="sudo mount -o rw,gid=users,fmask=113,dmask=002" # device mount_point
alias mntro="sudo mount -o ro,gid=users,fmask=333,dmask=222" # device mount_point
alias unmnt="sudo umount" # mount_point
