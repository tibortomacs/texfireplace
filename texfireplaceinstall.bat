@echo off
chcp 65001 >nul

if "%1"=="" (
echo This batch file is used by texfireplace.exe, do not run it independently!
pause
exit /b
)

set "perlsystem=no"
if "%1"=="tlperl" set "perlsystem=tlperl"
if "%1"=="strawberry" set "perlsystem=strawberry"

set "python=no"
if "%2"=="yes" set "python=yes"

set "writepathin=txsini"
if "%3"=="reg" set "writepathin=reg"
if "%3"=="txsvbs" set "writepathin=txsvbs"

set "texdir=%localappdata%\TeXfireplace"
set "tempdir=%temp%\texfireplace%random%"

set "exit_code=0"
mkdir "%tempdir%"
chdir /d "%tempdir%"

echo texdir=%texdir% > "%temp%\texfireplaceinstall.log"
echo tempdir=%tempdir% >> "%temp%\texfireplaceinstall.log"

:: Remove old TeXfireplace

if not exist "%texdir%" goto endoldinst
echo Remove old TeXfireplace >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-remove.txt"
reg delete "HKCU\Software\Classes\.tex" /f
reg delete "HKCU\Software\Classes\texfile" /f
rmdir /s /q "%appdata%\Microsoft\Windows\Start Menu\Programs\TeXfireplace"
del "%userprofile%\Desktop\TeXstudio.lnk"
rmdir /s /q "%texdir%"
for /f "tokens=2,*" %%i in ('reg query HKCU\Environment /v PATH') do set userpath=%%j
if "%userpath%"=="" goto endoldinst
call set "userpath=%%userpath:%texdir%\python\Scripts;=%%"
call set "userpath=%%userpath:%texdir%\python;=%%"
call set "userpath=%%userpath:%texdir%\perl\bin;=%%"
call set "userpath=%%userpath:%texdir%\texmfs\install\miktex\bin\x64;=%%"
setx path "%userpath%"
reg delete "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace" /f
:endoldinst

:: MikTeX

echo MiKTeX >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-miktex.txt"
curl -s -f -L -o miktex.zip https://miktex.org/download/win/miktexsetup-x64.zip
tar -xf miktex.zip
if not exist miktexsetup_standalone.exe set "exit_code=1" & echo ERROR: miktexsetup_standalone.exe >> "%temp%\texfireplaceinstall.log" & goto endinstall
miktexsetup_standalone --local-package-repository="%tempdir%\miktexinst" --package-set=basic download
miktexsetup_standalone --local-package-repository="%tempdir%\miktexinst" --portable="%texdir%" --package-set=basic install
if not exist "%texdir%\texmfs\install\miktex\bin\x64" set "exit_code=1" & echo ERROR: %texdir%\texmfs\install\miktex\bin\x64 >> "%temp%\texfireplaceinstall.log" & goto endinstall
"%texdir%\texmfs\install\miktex\bin\x64\initexmf" --set-config-value [MPM]AutoInstall=1
"%texdir%\texmfs\install\miktex\bin\x64\miktex" packages install cm-super
"%texdir%\texmfs\install\miktex\bin\x64\miktex" packages install latexmk
"%texdir%\texmfs\install\miktex\bin\x64\miktex" packages update
del "%texdir%\texmfs\config\miktex\config\issues.json"
del "%texdir%\miktex-portable.cmd"

:: Strawberry Perl

if not "%perlsystem%"=="strawberry" goto endstrawberry
echo Strawberry Perl >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-perl.txt"
curl -s -f -L -o strawberryperl.html https://strawberryperl.com/releases.html
for /f "tokens=1 delims=" %%a in ('findstr "portable.zip" "%tempdir%\strawberryperl.html"') do set "perlurl=%%a" & goto perlnextstep
:perlnextstep
for /f tokens^=2^ delims^=^" %%a in ('echo "%perlurl%"') do set "perlurl=%%a"
curl -s -f -L -o perl.zip %perlurl%
if not exist "%tempdir%\perl.zip" curl -s -f -L -o perl.zip https://github.com/StrawberryPerl/Perl-Dist-Strawberry/releases/download/SP_53822_64bit/strawberry-perl-5.38.2.2-64bit-portable.zip
mkdir "%tempdir%\perl"
tar -xf "%tempdir%\perl.zip" -C "%tempdir%\perl"
if not exist "%tempdir%\perl\perl" set "exit_code=1" & echo ERROR: %tempdir%\perl\perl >> "%temp%\texfireplaceinstall.log" & goto endinstall
move /y "%tempdir%\perl\perl" "%texdir%\perl"
:endstrawberry

:: TLPerl

if not "%perlsystem%"=="tlperl" goto endtlperl
echo TLPerl >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-perl.txt"
curl -s -f -L -o install-tl.zip https://mirror.ctan.org/systems/texlive/tlnet/install-tl.zip
if not exist "%tempdir%\install-tl.zip" curl -s -f -L -o install-tl.zip https://ctan.math.washington.edu/tex-archive/systems/texlive/tlnet/install-tl.zip
mkdir "%tempdir%\tl"
tar -xf "%tempdir%\install-tl.zip" -C "%tempdir%\tl"
dir /B /A:D "%tempdir%\tl" > "%tempdir%\tlinfo.txt"
set /p tldir=<"%tempdir%\tlinfo.txt"
if not exist "%tempdir%\tl\%tldir%\tlpkg\tlperl" set "exit_code=1" & echo ERROR: %tempdir%\tl\%tldir%\tlpkg\tlperl >> "%temp%\texfireplaceinstall.log" & goto endinstall
move /y "%tempdir%\tl\%tldir%\tlpkg\tlperl" "%texdir%\perl"
:endtlperl

:: Python

if not "%python%"=="yes" goto endpython
echo Python >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-python.txt"
curl -s -f -L -o python.html https://docs.python.org/
for /f "usebackq tokens=5,6" %%i in ("%tempdir%\python.html") do if "%%j"=="Documentation</title><meta" set "pythonver=%%i"
set "pythonver=%pythonver:<= %"
set "pythonver=%pythonver:>= %"
for /f "tokens=3" %%i in ('echo %pythonver%') do set "pythonver=%%i"
curl -s -f -L -o python.zip https://www.python.org/ftp/python/%pythonver%/python-%pythonver%-embed-amd64.zip
if not exist "%tempdir%\python.zip" curl -s -f -L -o python.zip https://www.python.org/ftp/python/3.12.2/python-3.12.2-embed-amd64.zip
mkdir "%texdir%\python"
tar -xf "%tempdir%\python.zip" -C "%texdir%\python"
if not exist "%texdir%\python\*._pth" set "exit_code=1" & echo ERROR: %texdir%\python >> "%temp%\texfireplaceinstall.log" & goto endinstall
rename "%texdir%\python\*._pth" "*.pth"
curl -s -f -L -o get-pip.py https://bootstrap.pypa.io/get-pip.py
if not exist "%tempdir%\get-pip.py" set "exit_code=1" & echo ERROR: get-pip.py >> "%temp%\texfireplaceinstall.log" & goto endinstall
"%texdir%\python\python.exe" "%tempdir%\get-pip.py"
if not exist "%texdir%\python\Scripts\pip.exe" set "exit_code=1" & echo ERROR: %texdir%\python\Scripts\pip.exe >> "%temp%\texfireplaceinstall.log" & goto endinstall
"%texdir%\python\python.exe" -m pip install latexminted
if not exist "%texdir%\python\Scripts\latexminted.exe" set "exit_code=1" & echo ERROR: %texdir%\python\Scripts\latexminted.exe >> "%temp%\texfireplaceinstall.log" & goto endinstall
if not exist "%texdir%\python\Scripts\pygmentize.exe" set "exit_code=1" & echo ERROR: %texdir%\python\Scripts\pygmentize.exe >> "%temp%\texfireplaceinstall.log" & goto endinstall
:endpython

:: TeXstudio

echo TeXstudio >> "%temp%\texfireplaceinstall.log"
echo. > "%temp%\texfireplaceinstall-texstudio.txt"
curl -s -f -L -o texstudio.html https://www.texstudio.org/
for /f "tokens=1 delims=" %%a in ('findstr "win-portable-qt6.zip" "%tempdir%\texstudio.html"') do set "txsurl=%%a" & goto texstudionextstep
:texstudionextstep
for /f tokens^=4^ delims^=^" %%a in ('echo "%txsurl%"') do set "txsurl=%%a"
for /f "tokens=3 delims=-" %%a in ('echo "%txsurl%"') do set "txsver=%%a"
curl -s -f -L -o texstudio.zip %txsurl%
if not exist "%tempdir%\texstudio.zip" curl -s -f -L -o texstudio.zip https://github.com/texstudio-org/texstudio/releases/download/4.8.4/texstudio-4.8.4-win-portable-qt6.zip
mkdir "%texdir%\texstudio"
tar -xf "%tempdir%\texstudio.zip" -C "%texdir%\texstudio"
if not exist "%texdir%\texstudio\texstudio.exe" set "exit_code=1" & echo ERROR: %texdir%\texstudio\texstudio.exe >> "%temp%\texfireplaceinstall.log" & goto endinstall

:: Completion of the installation

echo. > "%temp%\texfireplaceinstall-completion.txt"

:: texstudio version information file

echo %txsver%> "%texdir%\texstudio\version.inf"

:: texstudio.ini

curl -s -f -L -o texstudio.ini --output-dir "%texdir%\texstudio\config" https://tibortomacs.github.io/texfireplace/texstudio.ini
if not exist "%texdir%\texstudio\config\texstudio.ini" set "exit_code=1" & echo ERROR: %texdir%\texstudio\config\texstudio.ini >> "%temp%\texfireplaceinstall.log" & goto endinstall
if not "%writepathin%"=="txsini" goto endtxsini
set "userpath="
if "%python%"=="yes" set "userpath=;%texdir%\python;%texdir%\python\Scripts"
if not "%perl%"=="no" set "userpath=;%texdir%\perl\bin%userpath%"
set "userpath=%texdir%\texmfs\install\miktex\bin\x64%userpath%"
set "userpath=%userpath:\=\\%"
(
echo Tools\Search%%20Paths="%userpath%"
echo Tools\Commands\terminal-external="cmd /k set path=%userpath%;%%path%%"
) >> "%texdir%\texstudio\config\texstudio.ini"
:endtxsini

:: texstudio.vbs

if not "%writepathin%"=="txsvbs" goto endtxsvbs
(
echo Set oShell = CreateObject("Wscript.Shell"^)
echo Set FSO = CreateObject("Scripting.FileSystemObject"^)
echo Set objFile = FSO.GetFile(Wscript.ScriptFullName^)
echo TeXfireplaceFolder = FSO.GetParentFolderName(objFile^)
echo strArgs = "cmd /c set path="
echo strArgs = strArgs + TeXfireplaceFolder + "\texmfs\install\miktex\bin\x64;"
if not "%perl%"=="no" echo strArgs = strArgs + TeXfireplaceFolder + "\perl\bin;"
if "%python%"=="yes" echo strArgs = strArgs + TeXfireplaceFolder + "\python;" + TeXfireplaceFolder + "\python\Scripts;"
echo strArgs = strArgs + "%%path%% "
echo strArgs = strArgs + "& call """ + TeXfireplaceFolder + "\texstudio\texstudio.exe"""
echo If WScript.Arguments.Count ^> 0 Then strArgs = strArgs + " """ + WScript.Arguments.Item(0^) + """"
echo oShell.Run strArgs, 0, false
) > "%texdir%\texstudio.vbs"
:endtxsvbs

:: miktex-console.vbs

if "%writepathin%"=="reg" goto endconsolevbs
(
echo Set oShell = CreateObject("Wscript.Shell"^)
echo Set FSO = CreateObject("Scripting.FileSystemObject"^)
echo Set objFile = FSO.GetFile(Wscript.ScriptFullName^)
echo TeXfireplaceFolder = FSO.GetParentFolderName(objFile^)
echo strArgs = "cmd /c set path=" + TeXfireplaceFolder + "\texmfs\install\miktex\bin\x64;%%path%% & call miktex-console.exe"
echo oShell.Run strArgs, 0, false
) > "%texdir%\miktex-console.vbs"
:endconsolevbs

:: update.bat

(
echo @echo off
echo chcp 65001^> nul
echo title Updating TeXfireplace
echo set /p ^< nul = "Press any key to update TeXfireplace . . ."
echo pause ^> nul
echo cls
echo echo ---------------
echo echo Updating MiKTeX
echo echo ---------------
echo echo.
echo "%%~dp0texmfs\install\miktex\bin\x64\miktex" packages update
echo echo.
echo echo -----------------------------
echo echo Updating Pygments/latexminted
echo echo -----------------------------
echo echo.
echo if exist "%%~dp0python\Scripts\pygmentize.exe" "%%~dp0python\python.exe" -m pip install --upgrade Pygments
echo if exist "%%~dp0python\Scripts\latexminted.exe" "%%~dp0python\python.exe" -m pip install --upgrade latexminted
echo echo.
echo echo ------------------
echo echo Updating TeXstudio
echo echo ------------------
echo echo.
echo set "status=completed"
echo curl -s -f -L -o texstudio.html https://www.texstudio.org/
echo for /f "tokens=1 delims=" %%%%a in ('findstr "win-portable-qt6.zip" "%%~dp0texstudio.html"'^) do set "txsurl=%%%%a" ^& goto texstudionextstep
echo :texstudionextstep
echo del "%%~dp0texstudio.html"
echo for /f tokens^^=4^^ delims^^=^^" %%%%a in ('echo "%%txsurl%%"') do set "txsurl=%%%%a"
echo for /f "tokens=3 delims=-" %%%%a in ('echo "%%txsurl%%"'^) do set "txsver=%%%%a"
echo set /p actualtxsver=^<"%%~dp0texstudio\version.inf"
echo if [%%actualtxsver%%]==[%%txsver%%] echo There are currently no updates available. ^& goto endupdate
echo curl -s -f -L -o texstudio.zip %%txsurl%%
echo mkdir "%%~dp0texstudio-new"
echo tar -xf "%%~dp0texstudio.zip" -C "%%~dp0texstudio-new"
echo del "%%~dp0texstudio.zip"
echo if not exist "%%~dp0texstudio-new\texstudio.exe" set "status=failed" ^& rmdir /s /q "%%~dp0texstudio-new" ^& goto endupdate
echo xcopy /e /i "%%~dp0texstudio\config" "%%~dp0texstudio-new\config"^>nul
echo echo %%txsver%%^> "%%~dp0texstudio-new\version.inf"
echo rmdir /s /q "%%~dp0texstudio"
echo rename "%%~dp0texstudio-new" texstudio
echo echo Updated the TeXstudio to the latest version %%txsver%%.
echo :endupdate
echo echo.
echo echo -------------------
echo echo Updating %%status%%
echo echo -------------------
echo echo.
echo pause
) > "%texdir%\update.bat"

:: uninstall.bat

(
echo @echo off
echo chcp 65001^> nul
echo title Uninstalling TeXfireplace
echo set /p ^< nul = "Press any key to uninstall TeXfireplace . . ."
echo pause ^> nul
echo cls
) > "%texdir%\uninstall.bat"
if not "%writepathin%"=="reg" goto uninstallnextstep
(
echo for /f "tokens=2,*" %%%%i in ('reg query HKCU\Environment /v PATH'^) do set userpath=%%%%j
echo if "%%userpath%%"=="" goto nextstep
echo set "userpath=%%userpath:%texdir%\python\Scripts;=%%"
echo set "userpath=%%userpath:%texdir%\python;=%%"
echo set "userpath=%%userpath:%texdir%\perl\bin;=%%"
echo set "userpath=%%userpath:%texdir%\texmfs\install\miktex\bin\x64;=%%"
echo setx path "%%userpath%%"
echo :nextstep
) >> "%texdir%\uninstall.bat"
:uninstallnextstep
(
echo reg delete "HKCU\Software\Classes\.tex" /f
echo reg delete "HKCU\Software\Classes\texfile" /f
echo rmdir /s /q "%%appdata%%\Microsoft\Windows\Start Menu\Programs\TeXfireplace"
echo del "%%userprofile%%\Desktop\TeXstudio.lnk"
echo reg delete "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace" /f
echo cls
echo echo Please wait . . .
echo chdir /d %%localappdata%%
echo rmdir /s /q "%texdir%"
echo cls
echo echo ------------------------
echo echo Uninstallation completed
echo echo ------------------------
echo echo.
echo pause
) >> "%texdir%\uninstall.bat"

:: texfireplace.ico

curl -s -f -L -o texfireplace.ico --output-dir "%texdir%" https://tibortomacs.github.io/texfireplace/texfireplace.ico
if not exist "%texdir%\texfireplace.ico" set "exit_code=1" & echo ERROR: %texdir%\texfireplace.ico >> "%temp%\texfireplaceinstall.log" & goto endinstall

:: Uninstall in registry

reg add "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace"
reg add "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace" /v DisplayName /t REG_SZ /d "TeXfireplace"
reg add "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace" /v DisplayIcon /t REG_SZ /d "\"%texdir%\texfireplace.ico\""
reg add "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\TeXfireplace" /v UninstallString /t REG_SZ /d "\"%texdir%\uninstall.bat\""

:: TeX file association

reg add "HKCU\Software\Classes\.tex" /ve /d "texfile" /f
if "%writepathin%"=="txsvbs" reg add "HKCU\Software\Classes\texfile\shell\open\command" /ve /d "WScript.exe \"%texdir%\texstudio.vbs\" \"%%1\"" /f
if not "%writepathin%"=="txsvbs" reg add "HKCU\Software\Classes\texfile\shell\open\command" /ve /d "\"%texdir%\texstudio\texstudio.exe\" \"%%1\"" /f
reg add "HKCU\Software\Classes\texfile\DefaultIcon" /ve /d "%texdir%\texstudio\texstudio.exe,0" /f

:: Setting path

if not "%writepathin%"=="reg" goto endpathtoreg
for /f "tokens=2,*" %%i in ('reg query HKCU\Environment /v PATH') do set userpath=%%j
if "%userpath%"=="" goto pathnextstep
call set "userpath=%%userpath:%texdir%\python\Scripts;=%%"
call set "userpath=%%userpath:%texdir%\python;=%%"
call set "userpath=%%userpath:%texdir%\perl\bin;=%%"
call set "userpath=%%userpath:%texdir%\texmfs\install\miktex\bin\x64;=%%"
:pathnextstep
if "%python%"=="yes" set "userpath=%texdir%\python;%texdir%\python\Scripts;%userpath%"
if not "%perl%"=="no" set "userpath=%texdir%\perl\bin;%userpath%"
set "userpath=%texdir%\texmfs\install\miktex\bin\x64;%userpath%"
setx path "%userpath%"
:endpathtoreg

:: readme.txt

(
echo TeXfireplace components:
echo.
echo   - MikTeX (basic version + cm-super + latexmk^)
echo   - TeXstudio
if "%perlsystem%"=="strawberry" echo   - Strawberry Perl
if "%perlsystem%"=="tlperl"     echo   - TLPerl
if "%python%"=="yes"            echo   - Python
echo.
if "%writepathin%"=="reg"       echo PATH is written in the registry
if "%writepathin%"=="txsvbs"    echo PATH is written in the texstudio.vbs
if "%writepathin%"=="txsini"    echo PATH is written in the texstudio.ini
echo.
echo Path: %texdir% 
echo Date of installation: %date% (%time%^)
) > "%texdir%\readme.txt"

:: Shortcuts

(
echo Set WshShell = CreateObject("Wscript.shell"^)
echo Set FSO = CreateObject("Scripting.FileSystemObject"^)
echo Set objFile = FSO.GetFile(Wscript.ScriptFullName^)
echo TeXfireplaceFolder = FSO.GetParentFolderName(objFile^)
echo MiKTeXStartMenuFolder = WshShell.SpecialFolders("StartMenu"^) + "\Programs\TeXfireplace"
echo TeXstudioDesktopLink = WshShell.SpecialFolders("Desktop"^) + "\TeXstudio.lnk"
echo If FSO.FolderExists(MiKTeXStartMenuFolder^) Then FSO.DeleteFolder MiKTeXStartMenuFolder, True
echo If FSO.FileExists(TeXstudioDesktopLink^) Then FSO.DeleteFile TeXstudioDesktopLink, True
echo FSO.CreateFolder(MiKTeXStartMenuFolder^)
echo Set TeXstudioMenuShortcut = WshShell.CreateShortcut(MiKTeXStartMenuFolder + "\TeXstudio.lnk"^)
if "%writepathin%"=="txsvbs" echo TeXstudioMenuShortcut.TargetPath = TeXfireplaceFolder + "\texstudio.vbs"
if not "%writepathin%"=="txsvbs" echo TeXstudioMenuShortcut.TargetPath = TeXfireplaceFolder + "\texstudio\texstudio.exe"
echo TeXstudioMenuShortcut.IconLocation = TeXfireplaceFolder + "\texstudio\texstudio.exe"
echo TeXstudioMenuShortcut.WorkingDirectory = TeXfireplaceFolder
echo TeXstudioMenuShortcut.Save
echo Set MiKTeXconsoleMenuShortcut = WshShell.CreateShortcut(MiKTeXStartMenuFolder + "\MiKTeX console.lnk"^)
if "%writepathin%"=="reg" echo MiKTeXconsoleMenuShortcut.TargetPath = TeXfireplaceFolder + "\texmfs\install\miktex\bin\x64\miktex-console.exe"
if not "%writepathin%"=="reg" echo MiKTeXconsoleMenuShortcut.TargetPath = TeXfireplaceFolder + "\miktex-console.vbs"
echo MiKTeXconsoleMenuShortcut.IconLocation = TeXfireplaceFolder + "\texmfs\install\miktex\bin\x64\miktex-console.exe"
echo MiKTeXconsoleMenuShortcut.WorkingDirectory = TeXfireplaceFolder + "\texmfs\install\miktex\bin\x64"
echo MiKTeXconsoleMenuShortcut.Save
echo Set UpdateMenuShortcut = WshShell.CreateShortcut(MiKTeXStartMenuFolder + "\TeXfireplace update.lnk"^)
echo UpdateMenuShortcut.TargetPath = TeXfireplaceFolder + "\update.bat"
echo UpdateMenuShortcut.IconLocation = TeXfireplaceFolder + "\texfireplace.ico"
echo UpdateMenuShortcut.WorkingDirectory = TeXfireplaceFolder
echo UpdateMenuShortcut.Save
echo Set ReadmeMenuShortcut = WshShell.CreateShortcut(MiKTeXStartMenuFolder + "\Readme.lnk"^)
echo ReadmeMenuShortcut.TargetPath = TeXfireplaceFolder + "\readme.txt"
echo ReadmeMenuShortcut.WorkingDirectory = TeXfireplaceFolder
echo ReadmeMenuShortcut.Save
echo Set TeXstudioDesktopShortcut = WshShell.CreateShortcut(TeXstudioDesktopLink^)
if "%writepathin%"=="txsvbs" echo TeXstudioDesktopShortcut.TargetPath = TeXfireplaceFolder + "\texstudio.vbs"
if not "%writepathin%"=="txsvbs" echo TeXstudioDesktopShortcut.TargetPath = TeXfireplaceFolder + "\texstudio\texstudio.exe"
echo TeXstudioDesktopShortcut.IconLocation = TeXfireplaceFolder + "\texstudio\texstudio.exe"
echo TeXstudioDesktopShortcut.WorkingDirectory = TeXfireplaceFolder
echo TeXstudioDesktopShortcut.Save
) > "%texdir%\makeshortcut.vbs"
cscript /nologo "%texdir%\makeshortcut.vbs"
del "%texdir%\makeshortcut.vbs"

:: End of installation

:endinstall
chdir /d "%localappdata%"
rmdir /s /q "%tempdir%"
if "%exit_code%"=="0" del "%temp%\texfireplaceinstall.log"
if "%exit_code%"=="1" rmdir /s /q "%texdir%"
exit /b %exit_code%