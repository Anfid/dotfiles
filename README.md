# Dotfiles
## How to
Clone this repository to the directory of your choise. Init script can be used to apply dotfiles on ubuntu. Type ./init.sh -h for details.
On other distros init.sh can be used as a guideline. Dependencies may vary on different distributions. Proper installation of compiled applications can be specified on each project's github page.

Local preferences for zsh can be kept at ~/.zshrclocal. If this file exists, .zshrc will load it.
Local scripts can be stored in ~/.scripts/local. Git will ignore them.
Preferences file is yet to be created

## Reminders
### Keybindings
#### i3-gaps
| Key               | Function                                                                   |
|-------------------|----------------------------------------------------------------------------|
| Meta+Enter        | Open new terminal window                                                   |
| Meta+Q            | Close focused window                                                       |
| Meta+\<direction> | Focus window to the \<direction> of the focused one                        |
| Meta+Shift+\<direction> | Move focused window to the \<direction>                              |
| Meta+Shift+\<n>   | Move focused window to workspace #\<n>                                     |
| Meta+\<n>         | Focus workspace #\<n>                                                      |
| Meta+Space        | Toggle floating window focus                                               |
| Meta+W > D        | Choose default layout                                                      |
| Meta+W > T        | Choose tab layout                                                          |
| Meta+W > S        | Choose stack layout                                                        |
| Meta+W > Space    | Toggle window floating                                                     |
| Meta+W > G        | Enable gaps                                                                |
| Meta+W > E        | Disable gaps (mnemonic - efficient layout)                                 |
| Meta+W > M        | Enter move mode                                                            |
| Meta+W > R        | Enter resize mode                                                          |
| Meta+G > I        | Enter inner gaps mode                                                      |
| Meta+G > O        | Enter outer gaps mode                                                      |
| Meta+X            | Execute shell command. Can also be used to run applications. Utilizes rofi |
| Meta+S            | Select window or run ssh. Very likely to be changed                        |
| Ctrl+Alt+L        | Lock screen. Enter password to unlock                                      |

Where:
* `+` - Press keys simultaneously
* `>` - Press keys consequently
* `Meta` - aka Windows, Super etc.
* `<n>` - number from 0 to 9
* `<direction>` - vim-like direction key. Arrow keys also work
  h - left
  j - down
  k - up
  l - right

In move mode press `<direction>` to move floating window in corresponding direction. Press `Shift+<direction>` to move faster. Resize mode can be accessed by `R`.
In resize mode press `J` to make window bigger and `K` to make window smaller vertically. Press `L` to make window bigger and `H` to make window smaller horizontally. Press `Shift+<direction>` to resize faster. Move mode can be accessed by `M`.
In gaps mode press `J` to increase gaps and `K` to decrease them. Add `Shift` to only change local gaps. Outer gaps mode can be accessed from Inner gaps by `O`, and Inner gaps from Outer gaps by `I`
All modes can be escaped with `Q`, `Esc` or `Enter`.

#### rofi
| Key               | Function                                                                   |
|-------------------|----------------------------------------------------------------------------|
| Alt+(H\|L)        | Switch to previous|next modi                                               |
| Ctrl+[Shift+]Tab  | See above                                                                  |
| Shift+(Left\|Right)| See above                                                                 |
| Alt+(J\|K)        | Switch to next|previous line                                               |
| (Down\|Up)        | See above                                                                  |
| [Shift+]Tab       | Switch to previous|next line. Tab autoselects entry if only one is left.   |
| Ctrl+V            | Paste from clipboard                                                       |
| Ctrl+S            | Paste from primary selection                                               |

Only main keys are listed. Others are default. Use `rofi -show keys` to get list of current key bindings

#### neovim
List will be to big. See .config/nvim/init.vim. Will be restructured one day for better readability

### Project
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
* Write own snippets instead of provided by plugin
* Store wallpapers on different host. Consider google drive or dropbox
* Set up cava conky to work on all monitors on multimonitor setups
* Create proper script to start everything (conky, polybar, etc...)
* Store preferences in file, so desired behavior can be changed whenever desired
