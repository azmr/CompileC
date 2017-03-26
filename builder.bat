@echo off

setlocal

set BuildDirectory=E:\Documents\Coding\C\build
set SourceDirectory=E:\Documents\Coding\C
set ShellDirectory=E:\Documents\Coding\C
set HeaderDirectory=E:\Documents\Coding\C\h

>build.bat (
	for %%L in (
		"@echo off"
		""
		"set CommonCompilerFlags=-nologo -MTd -fp:fast -Gm- -GR- -EHa -WX -Oi -W4 -FC -wd4201 -wd4204 -I%HeaderDirectory% -DINTERNAL=1 -DDEBUG_PREFIX=Main"
		"set DebugCompilerFlags=-Od -Z7"
		"set CommonLinkerFlags=-incremental:no -opt:ref"
		"REM user32.lib gdi32.lib"
		""
		"IF NOT EXIST %BuildDirectory% mkdir %BuildDirectory%"
		"pushd %BuildDirectory%"
		""
		"call %ShellDirectory%\shell64.bat"
		""
		"del *.pdb > NUL 2> NUL"
		"echo WAITING FOR PDB > lock.tmp"
		""
		"timethis cl %%CommonCompilerFlags%% %%DebugCompilerFlags%% %SourceDirectory%\%1\%1.c -Fm%1.map -LD /link %%CommonLinkerFlags%% -PDB:%1_%%random%%.pdb -EXPORT:UpdateAndRender"
		"del lock.tmp"
		""
		"timethis cl %%CommonCompilerFlags%% %%DebugCompilerFlags%% %SourceDirectory%\%1\win32_%1.c -Fmwin32_%1.map /link %%CommonLinkerFlags%%"
		""
		"echo Finished at %%time%%"
		"REM ./win32_%1.exe"
		"popd"
		""
		""
		"REM Flag Meanings:"
		"REM =============="
		"REM"
		"REM -nologo	- no Microsoft logo at the beginning of compilation"
		"REM -Od		- no optimisation of code at all"
		"REM -Oi		- use intrinsic version of function if exists"
		"REM -Z7		- compatible debug info for debugger (replaced -Zi)"
		"REM -GR-		- turn off runtime type info (C++)"
		"REM -EHa-		- turn off exception handling (C++)"
		"REM -W4		- 4th level of warnings"
		"REM -WX 		- treat warnings as errors"
		"REM -wd#### 	- remove warning ####"
		"REM -D#####	- #define #### (=1)"
		"REM -Gm-		- turn off 'minimal rebuild' - no incremental build"
		"REM -Fm####	- provides location for compiler to put a .map file"
		"REM -I####		- search for include files at ####"
		"REM"
		"REM -MTd		- use (d => debug version of) static CRT library - needed for running on XP"
		"REM /link -subsystem:windows,5.1 - ONLY FOR 32-BIT BUILDS!!! - needed for running on XP"
		""
		"REM Warnings Removed:"
		"REM ================="
		"REM"
		"REM C4201: nonstandard extension used: nameless struct/union"
		"REM C4100: unreferenced formal parameter"
		"REM C4189: local variable is initialized but not referenced"
		"REM C4204: nonstandard extension used: non-constant aggregate initializer"
	) do echo. %%~L
)

>taghl_config.txt (
	for %%L in (
		"IncludeLocals:False"
		"UserLibraries:E:\Documents\Coding\C\windowskit_types_c.taghl,E:\Documents\Coding\C\h\types_c.taghl"
	) do echo. %%~L
)
endlocal
