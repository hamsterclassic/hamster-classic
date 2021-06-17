@echo off
REM Hamster Classic Installation
REM Erstellen einer EXE-Installationsdatei aus dem CAB-Archiv
md ~~hamster~~
%systemroot%\system32\expand.exe hamster*.cab -F:*.* ~~hamster~~\
call :create_sed
echo %%SystemRoot%%\System32\INFDEFAULTINSTALL.EXE "%%programfiles%%\hc_instl\Hamster-Setup.inf"> ~~hamster~~\runsetup.cmd
echo rd /s /q "%%programfiles%%\hc_instl">> ~~hamster~~\runsetup.cmd

%systemroot%\system32\iexpress.exe /N hamster.sed
::entpackt nach C:\Users\Administrator\AppData\Local\Temp\IXP000.TMP\Hamster-Setup.inf und löscht sofort wieder
rd /S /Q ~~hamster~~
del hamster.sed
echo Fertig, Datei hamsterclassic.exe erstellt.
echo.
pause
goto :eof

:create_sed
echo [Version] > hamster.sed
echo Class=IEXPRESS >> hamster.sed
echo SEDVersion=3 >> hamster.sed
echo [Options] >> hamster.sed
echo PackagePurpose=InstallApp >> hamster.sed
echo ShowInstallProgramWindow=0 >> hamster.sed
echo HideExtractAnimation=0 >> hamster.sed
echo UseLongFileName=1 >> hamster.sed
echo InsideCompressed=0 >> hamster.sed
echo CAB_FixedSize=0 >> hamster.sed
echo CAB_ResvCodeSigning=0 >> hamster.sed
echo RebootMode=N >> hamster.sed
echo InstallPrompt=%%InstallPrompt%% >> hamster.sed
echo DisplayLicense=%%DisplayLicense%% >> hamster.sed
echo FinishMessage=%%FinishMessage%% >> hamster.sed
echo TargetName=%%TargetName%% >> hamster.sed
echo FriendlyName=%%FriendlyName%% >> hamster.sed
echo AppLaunched=%%AppLaunched%% >> hamster.sed
echo PostInstallCmd=%%PostInstallCmd%% >> hamster.sed
echo AdminQuietInstCmd=%%AdminQuietInstCmd%% >> hamster.sed
echo UserQuietInstCmd=%%UserQuietInstCmd%% >> hamster.sed
echo CheckAdminRights=1 >> hamster.sed
echo SourceFiles=SourceFiles >> hamster.sed
echo [SourceFiles] >> hamster.sed
echo SourceFiles0=%cd%\~~hamster~~ >> hamster.sed
echo [Strings] >> hamster.sed
echo InstallPrompt=Die Installation wird vorbereitet. Temporäre Dateien werden nach Beendigung gelöscht. Fortsetzen? >> hamster.sed
echo DisplayLicense= >> hamster.sed
echo FinishMessage= >> hamster.sed
echo TargetName=hamsterclassic.exe >> hamster.sed
echo FriendlyName=Hamster >> hamster.sed
echo AppLaunched=cmd.exe /c md "%%programfiles%%\hc_instl" ^&^& copy *.* "%%programfiles%%\hc_instl" ^&^& "%%programfiles%%\hc_instl\runsetup.cmd" >> hamster.sed
echo PostInstallCmd=^<None^> >> hamster.sed
echo AdminQuietInstCmd= >> hamster.sed
echo UserQuietInstCmd= >> hamster.sed
echo [SourceFiles0] >> hamster.sed
echo hamster.exe=>> hamster.sed
echo Hamster-Hilfe.pdf=>> hamster.sed
echo Hamster-Setup.inf=>> hamster.sed
echo HashInfo.txt=>> hamster.sed
echo libeay32.dll=>> hamster.sed
echo openssl.exe=>> hamster.sed
echo OpenSSL License.txt=>> hamster.sed
echo ReadMe.txt=>> hamster.sed
echo ssleay32.dll=>> hamster.sed
echo Changes_de.txt=>> hamster.sed
echo Changes_en.txt=>> hamster.sed
echo cs_ibm437_unicode.cnv=>> hamster.sed
echo cs_iso-8859-1_unicode.cnv=>> hamster.sed
echo cs_iso-8859-1_windows-1252.cnv=>> hamster.sed
echo cs_iso-8859-10_unicode.cnv=>> hamster.sed
echo cs_iso-8859-11_unicode.cnv=>> hamster.sed
echo cs_iso-8859-13_unicode.cnv=>> hamster.sed
echo cs_iso-8859-14_unicode.cnv=>> hamster.sed
echo cs_iso-8859-15_unicode.cnv=>> hamster.sed
echo cs_iso-8859-15_windows-1252.cnv=>> hamster.sed
echo cs_iso-8859-16_unicode.cnv=>> hamster.sed
echo cs_iso-8859-2_unicode.cnv=>> hamster.sed
echo cs_iso-8859-3_unicode.cnv=>> hamster.sed
echo cs_iso-8859-4_unicode.cnv=>> hamster.sed
echo cs_iso-8859-5_unicode.cnv=>> hamster.sed
echo cs_iso-8859-6_unicode.cnv=>> hamster.sed
echo cs_iso-8859-7_unicode.cnv=>> hamster.sed
echo cs_iso-8859-8_unicode.cnv=>> hamster.sed
echo cs_iso-8859-9_unicode.cnv=>> hamster.sed
echo cs_unicode_windows-1252.cnv=>> hamster.sed
echo cs_us-ascii_windows-1252.cnv=>> hamster.sed
echo cs_windows-1250_unicode.cnv=>> hamster.sed
echo cs_windows-1251_unicode.cnv=>> hamster.sed
echo cs_windows-1252_unicode.cnv=>> hamster.sed
echo cs_windows-1253_unicode.cnv=>> hamster.sed
echo cs_windows-1254_unicode.cnv=>> hamster.sed
echo cs_windows-1255_unicode.cnv=>> hamster.sed
echo cs_windows-1256_unicode.cnv=>> hamster.sed
echo cs_windows-1257_unicode.cnv=>> hamster.sed
echo cs_windows-1258_unicode.cnv=>> hamster.sed
echo cs_windows-437_unicode.cnv=>> hamster.sed 
echo cs_windows-737_unicode.cnv=>> hamster.sed
echo cs_windows-775_unicode.cnv=>> hamster.sed
echo cs_windows-850_unicode.cnv=>> hamster.sed
echo cs_windows-852_unicode.cnv=>> hamster.sed
echo cs_windows-855_unicode.cnv=>> hamster.sed
echo cs_windows-857_unicode.cnv=>> hamster.sed
echo cs_windows-860_unicode.cnv=>> hamster.sed
echo cs_windows-861_unicode.cnv=>> hamster.sed
echo cs_windows-862_unicode.cnv=>> hamster.sed
echo cs_windows-863_unicode.cnv=>> hamster.sed
echo cs_windows-864_unicode.cnv=>> hamster.sed
echo cs_windows-865_unicode.cnv=>> hamster.sed
echo cs_windows-866_unicode.cnv=>> hamster.sed
echo cs_windows-869_unicode.cnv=>> hamster.sed
echo cs_windows-874_unicode.cnv=>> hamster.sed
echo hamster.ini=>> hamster.sed
echo hamster_de.cnt=>> hamster.sed
echo hamster_de.dat=>> hamster.sed
echo hamster_de.hlp=>> hamster.sed
echo hamster_en.cnt=>> hamster.sed
echo hamster_en.dat=>> hamster.sed
echo hamster_en.hlp=>> hamster.sed
echo hamster_sr.dat=>> hamster.sed
echo hstrings.hsm=>> hamster.sed
echo htime.hsm=>> hamster.sed
echo kHighLi.ini.example=>> hamster.sed
echo MAlias.hst=>> hamster.sed
echo PCRE_LICENCE.txt=>> hamster.sed
echo ReadMe.data=>> hamster.sed
echo Root-Zertifikate aktualisieren.hsc=>> hamster.sed
echo RootCA.pem=>> hamster.sed
echo Scriptexamples.zip=>> hamster.sed
echo runsetup.cmd=>> hamster.sed
echo WinHlpUpd.cmd=>> hamster.sed
exit/b
