@echo off
chcp 65001> nul
title Updating TeXfireplace

if not exist "%~dp0texmfs" exit /b

set /p < nul = "Press any key to update TeXfireplace . . ."
pause > nul

:startupdate
cls
tasklist /fi "ImageName eq texstudio.exe" /fo csv 2>nul | find /I "texstudio.exe">nul
if not "%errorlevel%"=="0" goto update
echo TeXstudio is running!
set /p < nul = "To update, close TeXstudio and then press any key . . ."
pause > nul
goto startupdate
:update

set "status=completed"

echo ---------------
echo Updating MiKTeX
echo ---------------
echo.

"%~dp0texmfs\install\miktex\bin\x64\miktex" packages update

echo.
echo -----------------------------
echo Updating Pygments/latexminted
echo -----------------------------
echo.

if exist "%~dp0python\Scripts\pygmentize.exe" "%~dp0python\python.exe" -m pip install --upgrade Pygments
if exist "%~dp0python\Scripts\latexminted.exe" "%~dp0python\python.exe" -m pip install --upgrade latexminted

echo.
echo ------------------
echo Updating TeXstudio
echo ------------------
echo.

curl -s -f -L -o texstudio.html https://www.texstudio.org
if not exist "%~dp0texstudio.html" set "status=failed" & goto endupdate
for /f "tokens=1 delims=" %%a in ('findstr "win-portable-qt6.zip" "%~dp0texstudio.html"') do set "txsurl=%%a" & goto texstudionextstep
:texstudionextstep
del "%~dp0texstudio.html"
for /f tokens^=4^ delims^=^" %%a in ('echo "%txsurl%"') do set "txsurl=%%a"
for /f "tokens=3 delims=-" %%a in ('echo "%txsurl%"') do set "txsver=%%a"
set /p actualtxsver=<"%~dp0texstudio\version.inf"
if [%actualtxsver%]==[%txsver%] echo There are currently no updates available. & goto endupdate
curl -s -f -L -o texstudio.zip %txsurl%
mkdir "%~dp0texstudio-new"
tar -xf "%~dp0texstudio.zip" -C "%~dp0texstudio-new"
del "%~dp0texstudio.zip"
if not exist "%~dp0texstudio-new\texstudio.exe" set "status=failed" & rmdir /s /q "%~dp0texstudio-new" & goto endupdate
xcopy /e /i "%~dp0texstudio\config" "%~dp0texstudio-new\config">nul
echo %txsver%> "%~dp0texstudio-new\version.inf"
rmdir /s /q "%~dp0texstudio"
rename "%~dp0texstudio-new" texstudio
echo Updated the TeXstudio to the latest version %txsver%.

:endupdate
echo.
echo -------------------
echo Updating %status%
echo -------------------
echo.
pause
