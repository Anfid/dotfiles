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
| Meta+X            | Execute shell command. Can also be used to run applications. Utilizes rofi |
| Meta+S            | Run application. Utilizes rofi                                             |
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

In move mode press `<direction>` to move floating window in corresponding direction. Press `Shift+<direction>` to move faster
In resize mode press J to make window bigger and K to make window smaller vertically. In resize mode press L to make window bigger and H to make window smaller horizontally. Press `Shift+<direction>` to resize faster
All modes can be escaped with Q, Esc or Enter

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

### Desktop
TODO. Xresources

## To do:
* make blurme script work on multimonitor setups
* Create proper script to start everything (conky, polybar, etc...)
* Store preferences in file, so desired behavior can be changed whenever desired
* Add .scripts to PATH
* mps-youtube. Read details on configuration
