# Dotfiles

Init script can be used to apply my dotfiles on ubuntu. Type ./init.sh -h for details.

On other distros init.sh can be used as a list of used packages. Dependencies may vary on different distributions. Proper installation can be specified on each project's github page.

## Reminders
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
* Add .scripts to PATH. Put kitty launch script to .scripts
* mps-youtube. Read details on configuration
* Store preferences in file, so desired behavior can be changed whenever desired
* Create proper script to start everything (conky, polybar, etc...)

