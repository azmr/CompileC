None of these are intended for public use as is, but the following info is provided in case you want to adapt them for yourself.

# shell[64|32].bat
If using MSVC's cl compiler (or devenv) from the command line, you have to run their batch file each time you open the shell.
I have a cmd window shortcut in the taskbar with the target:
``` cmd
%windir%\system32\cmd.exe /k  C:\WINDOWS\System32\cmd.exe /k E:\Documents\Coding\C\shell64.bat
```
So when cmd opens, it automatically calls my batch file, which calls MSVC's and sets up the path.

# builder.bat
## Background
Following Casey Muratori's lead (from his Handmade Hero series), I use a .bat file to compile my C files.
I have Vim set up to call the batch file with <F6> with the following statements in my .vimrc:
``` VimL
augroup c_win
    autocmd!
	" Match the error format to cl's output
    autocmd FileType c setlocal errorformat=%f(%l):%m
	" Set the make program to call our build file (in the working directory)
    autocmd FileType c setlocal makeprg=build.bat
	" <F6> => call make, which calls build.bat, compiling with preferred settings
	"	   => open QuickFix window at the bottom of the screen (4 lines high) with compilation errors/warnings
    autocmd FileType c nnoremap <buffer> <F6> :w \| make!<cr>:copen<cr><cr><c-w>J<c-w><c-p><c-w>_3<c-w>-
    ...
augroup END
```

## Script Description
This creates a file called `build.bat` in the working directory, which, when called,
calls `shell64.bat` (in `ShellDirectory`) then compiles a C file to a build directory. (You'll probably want to change the build directory if you use this.)

## Usage
From the command line, with the working directory wherever you want your build file to be, use the command:
```
path/to/builder.bat name
```
where *name* is your project name, without any file extensions.
e.g.:
```
../builder.bat gfx
```
This will make a `build.bat` file to compile a `gfx.c` file from `SourceDirectory/gfx` into the `BuildDirectory`.

## Other notes

 - There is also a `HeaderDirectory`, for wherever you keep your project-independent header files.

 - You'll want to change the *Directory locations for your own setup before running `builder.bat`.

 - `builder.bat` assumes you are using my [timethis](https://github.com/azmr/timethis) application,
which will print the time taken to compile to stdout (and so to Vim's QuickFix window).
If not, just search for and remove the one use of "timethis".

 - The time that compilation finishes is also printed to stdout (and QuickFix).
