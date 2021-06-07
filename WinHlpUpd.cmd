Rem das Oeffnen von HLP-Dateien ermoeglichen, Administrator-Rechte erforderlich
Rem
Call :REDIRECT %* 1>"%TEMP%\Setup_WinHelp32.Out" 2>"%TEMP%\Setup_WinHelp32.err"
@echo off
echo.
if errorlevel 9 goto error
echo Fertig!
Exit /B

:error
echo Fehler beim Download!
Exit /B

:REDIRECT
Rem %CMDCMDLINE%
Rem %DATE% %TIME%
for /F "usebackq tokens=4 delims=. " %%i IN (`ver`) DO (set OSVersion=%%i)
if %OSVersion%==10 goto Windows10

start https://support.microsoft.com/kb/917607
exit /b

:Windows10
set arch=x64
if %PROCESSOR_ARCHITECTURE%==x86 set arch=x86
for /f "tokens=3" %%a in ('reg.exe QUERY "HKCU\Control Panel\International" /v LocaleName ') do set LocaleName=%%a
%SystemRoot%\system32\curl.exe -o Windows8-RT-KB917607-%arch%.msu https://download.microsoft.com/download/2/0/0/200C7BAF-48D7-4C0A-9C12-088CBA3DB13B/Windows8-RT-KB917607-%arch%.msu
if not exist Windows8-RT-KB917607-%arch%.msu exit /b 9

md msu_unpacked
%SystemRoot%\system32\expand.exe Windows8-RT-KB917607-%arch%.msu /F:* msu_unpacked
cd msu_unpacked
%SystemRoot%\system32\expand.exe Windows8-RT-KB917607-%arch%.cab /F:* .
%SystemRoot%\system32\takeown.exe /f "%SystemRoot%\%LocaleName%\winhlp32.exe.mui"
%SystemRoot%\system32\icacls.exe "%SystemRoot%\%LocaleName%\winhlp32.exe.mui" /grant "%UserName%":F
ren %SystemRoot%\%LocaleName%\winhlp32.exe.mui winhlp32.exe.mui.w10
for /f "tokens=4" %%a in ('dir /ad %PROCESSOR_ARCHITECTURE%*%LocaleName%* ^| find "DIR"') do cd %%a
copy winhlp32.exe.mui %SystemRoot%\%LocaleName%\winhlp32.exe.mui
cd ..
%SystemRoot%\system32\takeown.exe /f "%SystemRoot%\winhlp32.exe"
%SystemRoot%\system32\icacls.exe "%SystemRoot%\winhlp32.exe" /grant "%UserName%":F
ren %SystemRoot%\winhlp32.exe winhlp32.exe.w10
for /f "tokens=4" %%a in ('dir /ad %PROCESSOR_ARCHITECTURE%*none* ^| find "DIR"') do cd %%a
copy winhlp32.exe %SystemRoot%\winhlp32.exe 
cd ..\..
rd /s /q msu_unpacked
exit /b
