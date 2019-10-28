# Dotfiles

## How to
Clone this repository to the directory of your choice. Init script can be used to apply dotfiles on Manjaro and Ubuntu. Type ./init.sh -h for details.
On other distros init.sh can be used as a guideline. Dependencies may vary on different distributions. Proper installation of compiled applications can be specified on each project's github page.

Local preferences for zsh can be kept at ~/.zshrclocal. If this file exists, .zshrc will load it.
Local scripts can be stored in ~/.scripts/local. Git will ignore them.

## Reminders

### Keybindings

#### rofi
| Key               | Function                                                                   |
|-------------------|----------------------------------------------------------------------------|
| Alt+(N\|O)        | Switch to previous\|next modi                                              |
| Ctrl+[Shift+]Tab  | See above                                                                  |
| Shift+(Left\|Right)| See above                                                                 |
| Alt+(E\|I)        | Switch to next\|previous line                                              |
| (Down\|Up)        | See above                                                                  |
| [Shift+]Tab       | Switch to previous\|next line. Tab autoselects entry if only one is left.  |
| Ctrl+V            | Paste from clipboard                                                       |
| Ctrl+S            | Paste from primary selection                                               |

Only main keys are listed. Others are default. Use `rofi -show keys` to get list of current key bindings

#### dunst (notification daemon)
| Key               | Function                                                                   |
|-------------------|----------------------------------------------------------------------------|
| Meta+Tab          | Open context menu                                                          |
| Meta+\`           | Show previous notification                                                 |
| Meta+Esc          | Close notification                                                         |
| Meta+Ctrl+Esc     | Close all notifications                                                    |

### VimWiki
VimWiki is set up to use markdown syntax.
Intended to work with rclone to sync with gdrive. Rclone has to be installed first.
Proposed directory structure:
* `~/vimwiki` - global wiki, that is synchronized with gdrive
   * `vimwiki/index.md` - global index page, must link local wiki
   * `vimwiki/local` - symbolic link to `~/.wiki`
* `~/.wiki` - local wiki, does not synchronize with gdrive

First rclone remote has to be set up. To sync use the following command:
* `rclone sync <source> <destinaton>`
where:
* `<source>` - source with newer files
* `<destinaton>` - destinaton with files to be updated
Rclone remote directory have the following syntax: `<remote>:<path/to/dir>`.
Note: only destinaton files are updated.

### zsh
Zsh can handle both zsh and bash completions, but they should be kept separately. To add completions to zsh you have to generate them and write into proper directory.
* local zsh completions
  `<echo completion> > $HOME/.zsh.compl.d/_<command>`
* local bash completions
  `<echo completion> > $HOME/.bash.compl.d/_<command>`
* global zsh completions
  `<echo completion> > $ZDOTDIR/zsh.compl.d/_<command>`
* global bash completions
  `<echo completion> > $ZDOTDIR/bash.compl.d/_<command>`

### Projects

#### C++
Following options may need to be changed from default on some projects.
Add them to project's root directory

* Set include path with -I flag. Eg:
`let g:ale_cpp_clang_options = '-std=c++14 -Wall -I /home/anfid/Documents/dotfiles/'`
Note: Assigning value with += seems to break something. List all includes in one line.

* Proved useful setting absolute tags path instead of relative
`set tags=/abs/path/to/.tags`

* Set proper ALE linters. Defaults:
`let g:ale_linters = {'cpp': ['clang', 'cppcheck']}`
See help for other options.

* Cppcheck setup:
`let g:ale_cpp_cppcheck_options = '<>'`
    * -j<n> (use n jobs, balance performance and resources)
    * --enable='<>,<>' (enable following messages)
        * error (on by default)
        * performance,portability,warning,style (self explanatory)
        * unusedFunction (do not use in libraries)
    * --inconclusive (More warnings. May result in false warnings)
    * --project=<compile\_commands.json | \*.vsxproj | \*.sln>
* Use the following flag with cmake to generate compile\_commands.json `-DCMAKE_EXPORT_COMPILE_COMMANDS=ON`. Alternatively, put in CMakeLists.txt
`set(CMAKE_EXPORT_COMPILE_COMMANDS ON)`
If this is not possible, create `.clang_complete` file with compilation flags in the project root

### Desktop
TODO. Xresources

## To do:
* Store wallpapers on different host. Consider google drive or dropbox
* Store preferences in file, so desired behavior can be changed at will
