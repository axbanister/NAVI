@echo off
cls
:start
cls
echo.
echo     ##    ##    ###    ##     ## ####
echo     ###   ##   ## ##   ##     ##  ##
echo     ####  ##  ##   ##  ##     ##  ##
echo     ## ## ## ##     ## ##     ##  ##
echo     ##  #### #########  ##   ##   ##
echo     ##   ### ##     ##   ## ##    ##
echo     ##    ## ##     ##    ###    ####
echo.
echo.
echo     1. Remote Computer Information
echo     2. Install NAVI on Remote Computer
echo.
echo     3. Uninstall or Repair a program
echo     4. Outlook Prompting for Credentials
echo     5. Troubleshoot Internet Explorer
echo     6. Troubleshoot Prelude Reporting
echo     7. Add Desktop Shortcuts
echo     8. Restart Computer
echo.
echo     9. Exit
echo.
echo.

CHOICE /N /C 123456789 /M "Choose a menu option by pressing the number."
if errorlevel 9 == goto Exit
if errorlevel 8 == goto restart
if errorlevel 7 == goto shortcuts
if errorlevel 6 == goto preludereporting
if errorlevel 5 == goto troubleshootIE
if errorlevel 4 == goto outlookcreds
if errorlevel 3 == goto uninstall
if errorlevel 2 == goto installNavi
if errorlevel 1 == goto reminfo

:reminfo
cls
echo.
echo     ##    ##    ###    ##     ## ####
echo     ###   ##   ## ##   ##     ##  ##
echo     ####  ##  ##   ##  ##     ##  ##
echo     ## ## ## ##     ## ##     ##  ##
echo     ##  #### #########  ##   ##   ##
echo     ##   ### ##     ##   ## ##    ##
echo     ##    ## ##     ##    ###    ####
echo.
echo.
echo     1. Model Info
echo     2. Network Info
echo     3. Installed Programs
echo     4. Main Menu
echo     5. Exit
echo.
echo.

CHOICE /N /C 12345 /M "Choose a menu option by pressing the number."
if errorlevel == 5 goto exit
if errorlevel == 4 goto start
if errorlevel == 3 goto remPrograms
if errorlevel == 2 goto remNetinfo
if errorlevel == 1 goto remModelinfo

:remModelinfo
cls
set /p compname="Enter computer name: "
echo.
echo Querying %compname% ...
wmic /node: "%compname%" computersystem get manufacturer /value | find "="> C:\manuf.txt
FOR %%a IN ( "C:\manuf.txt" ) DO (FINDSTR /i "Dell" "%%~a" > nul
        if errorlevel 1 (
		goto lenovo
	) else (
		wmic /node:"%compname%" computersystem get manufacturer,model,systemtype && wmic /node:"%compname%" bios get serialnumber && wmic /node:"%compname%" OS get Caption,CSDVersion,OSArchitecture,Version
	)
)
echo.
del c:\manuf.txt
pause
goto reminfo

:lenovo
FOR %%a IN ( "C:\manuf.txt" ) DO (FINDSTR /i "Lenovo" "%%~a" > nul
if errorlevel 1 (
		goto surface
	) else (
		wmic /node:"%compname%" computersystem get manufacturer,model,systemtype && wmic /node:"%compname%" cpu get description,name && wmic /node:"%compname%" csproduct get version && wmic /node:"%compname%" OS get Caption,OSArchitecture,Version
	)
)
echo.
del c:\manuf.txt
pause
goto reminfo

:surface
FOR %%a IN ( "C:\manuf.txt" ) DO (FINDSTR /i "Microsoft" "%%~a" > nul
if errorlevel 1 (
		goto asus
	) else (
wmic /node:"%compname%" computersystem get manufacturer,model,systemtype && wmic /node:"%compname%" csproduct get version,identifyingnumber,UUID && wmic /node:"%compname%" OS get Caption,CSDVersion,OSArchitecture,Version
	)
)
echo.
del c:\manuf.txt
pause
goto reminfo

:asus
wmic /node:"%compname%" baseboard get manufacturer,serialnumber,product,version && wmic /node:"%compname%" cpu get description,name && wmic /node:"%compname%" OS get Caption,CSDVersion,OSArchitecture,Version
echo.
del c:\manuf.txt
pause
goto reminfo

:remNetinfo
cls
echo.
set /p compname="Enter computer name: "
echo.
echo Querying %compname% ...
powershell.exe -ExecutionPolicy Bypass -command "Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName %compname% | Format-List -Property Description,IPAddress,MACAddress,DNSServerSearchOrder,DHCPServer
echo Mapped Network Drives
powershell -ExecutionPolicy Bypass -command "Get-Wmiobject Win32_MappedLogicalDisk -computername %compname% | select name,providername | FOrmat-Table -HideTableHeaders
echo.
wmic /node:"%compname%" computersystem get username
pause
goto reminfo

:remPrograms
cls
echo.
set /p compname="Enter computer name: "
echo.
echo Querying %compname% ...
echo.
wmic /node:"%compname%" product get name,version | sort > c:\"%compname%".txt
echo.
echo Complete... Opening.
c:\%compname%.txt
pause
echo.
echo.
CHOICE /M "Delete Output file?."
if errorlevel == 2 goto reminfo
if errorlevel == 1 goto remProgramsdel

:remProgramsdel
del c:\%compname%.txt
echo.
echo Deleted.
echo.
timeout /t 2 >nul
goto reminfo

:installNavi
cls
echo You must have PsExec installed on your computer in C:\PSTools in order for this to work.
echo.
set /p compname="Enter computer name: "
cls
echo Transferring NAVI to %compname% ...
mkdir \\%compname%\c$\DATA\NAVI
echo.
xcopy \\fs950o\IT\Software\NAVI\NAVI.bat \\%compname%\c$\DATA\NAVI
echo.
echo.
echo Navi installed successfully. Located c:\DATA\NAVI
echo.
echo Starting NAVI ...
c:\pstools\psexec.exe -s -d \\%compname% -i c:\DATA\NAVI\navi.bat
echo.
echo Navi started on %compname%.
timeout /t 3 >nul
echo Returning to menu...
timeout /t 3 >nul
goto start

:uninstall
cls
echo Opening control panel...
timeout /t 2 >nul
appwiz.cpl
timeout /t 2 >nul
goto start

:outlookcreds
cls
echo.
echo     ##    ##    ###    ##     ## ####
echo     ###   ##   ## ##   ##     ##  ##
echo     ####  ##  ##   ##  ##     ##  ##
echo     ## ## ## ##     ## ##     ##  ##
echo     ##  #### #########  ##   ##   ##
echo     ##   ### ##     ##   ## ##    ##
echo     ##    ## ##     ##    ###    ####
echo.
echo.
echo     Outlook prompting for credentials.
echo     This operation will perform the following:
echo     -- Close Outlook
echo     -- Clear Credential Manager
echo     -- Clear local user temp directory
echo     -- Clear local windows temp directory
echo.
echo     1. Continue
echo     2. Main Menu
echo     3. Exit
echo.
echo.

CHOICE /N /C 123 /M "Choose a menu option by pressing the number."
if errorlevel == 3 goto exit
if errorlevel == 2 goto start
if errorlevel == 1 goto outlookcredsContinue

:outlookcredsContinue
cls
echo.
echo Closing Outlook...
timeout /t 2 >nul
taskkill /im outlook.exe /f
timeout /t 2 >nul
echo.
echo Generating credential list...
echo.
cmdkey.exe /list > "%TEMP%\List.txt"
findstr.exe Target "%TEMP%\List.txt" > "%TEMP%\tokensonly.txt"
FOR /F "tokens=1,2 delims= " %%G IN (%TEMP%\tokensonly.txt) DO cmdkey.exe /delete:%%H
echo.
echo Deleting cached credentials and temp files...
echo.
del "%TEMP%\*.*" /s /f /q
del "C:\Windows\Temp\*.*" /s /f /q
pause
goto outlookcreds

:troubleshootIE
cls
echo.
echo     ##    ##    ###    ##     ## ####
echo     ###   ##   ## ##   ##     ##  ##
echo     ####  ##  ##   ##  ##     ##  ##
echo     ## ## ## ##     ## ##     ##  ##
echo     ##  #### #########  ##   ##   ##
echo     ##   ### ##     ##   ## ##    ##
echo     ##    ## ##     ##    ###    ####
echo.
echo.
echo	1. Close IE, Cleare Cache
echo	2. Reset IE
echo	3. Flush DNS
echo	4. Main Menu
echo	5. Exit
echo.
echo.
CHOICE /N /C 12345 /M "Choose a menu option by pressing the number."
if errorlevel == 5 goto exit
if errorlevel == 4 goto start
if errorlevel == 3 goto flushdns
if errorlevel == 2 goto resetie
if errorlevel == 1 goto killiecache

:killiecache
cls
echo Closing Internet Explorer...
timeout /t 1 >nul
taskkill /f /im iexplor*
echo.
echo Clearing Temporary Internet Files...
REM Clear Temporary Internet Files
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4
echo.
echo Clearing Cookies...
REM Clear Cookies
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
echo.
echo Clearing Browsing History...
REM Clear Browsing History
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
echo.
echo Clearing Tracking Data...
REM Clear Tracking Data
RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2048
echo.
echo Cleanup complete, returning to menu.
timeout /t 2 >nul
goto troubleshootIE

:resetie
cls
echo Resetting Internet Explorer
RunDll32.exe InetCpl.cpl,ResetIEtoDefaults
echo.
echo Reset complete, returning to menu.
timeout /t 2 >nul
goto troubleshootIE

:flushdns
cls
echo Flushing DNS
timeout /t 1 >nul
ipconfig /flushdns
echo.
echo Returning to menu.
timeout /t 2 >nul
goto troubleshootIE

:preludereporting
cls
echo WARNING: Close ALL open prelude sessions before continuing.
pause
cls
echo.
echo   Clearing temp directories
echo.
timeout /t 1 >nul
del "%TEMP%\*.*" /s /f /q
del "C:\Windows\Temp\*.*" /s /f /q
echo.
echo   Temp directories clear
timeout /t 1 >nul
echo.
echo   Creating Temp directory in C:\
mkdir c:\Temp
echo.
echo   Temp directory created. Returning to menu.
timeout /t 5 >nul
goto start

:shortcuts
cls
echo Creating Desktop Shortcuts
Setlocal EnableDelayedExpansion
echo Creating Kronos Link...
echo [InternetShortcut] > "%Userprofile%\Desktop\Kronos.url"
set "kronos=https://lkq.kronos.net/wfc/applications/wtk/html/ess/quick-tslite.jsp?noclear=yes&c_timeout=2&nologon=yes"
echo URL=!kronos! >> "%Userprofile%\Desktop\kronos.url"
echo IDList= >> "%Userprofile%\Desktop\kronos.url"
echo IconIndex=0 >> "%Userprofile%\Desktop\kronos.url"
echo HotKey=0 >> "%Userprofile%\Desktop\kronos.url"

echo Creating ProjectX Link...
echo [InternetShortcut] > "%Userprofile%\Desktop\ProjectX.url"
echo URL=http://lkqpxweb/security/ >> "%Userprofile%\Desktop\ProjectX.url"
echo IDList= >> "%Userprofile%\Desktop\ProjectX.url"
echo IconIndex=0 >> "%Userprofile%\Desktop\ProjectX.url"
echo HotKey=0 >> "%Userprofile%\Desktop\ProjectX.url"

echo Creating Outlook Web Link...
echo [InternetShortcut] > "%Userprofile%\Desktop\OutlookWebApp.url"
echo URL=https://outlook.lkqcorp.com >> "%Userprofile%\Desktop\OutlookWebApp.url"
echo IDList= >> "%Userprofile%\Desktop\OutlookWebApp.url"
echo IconIndex=0 >> "%Userprofile%\Desktop\OutlookWebApp.url"
echo HotKey=0 >> "%Userprofile%\Desktop\OutlookWebApp.url"

echo Creating Finesse Link... 
echo [InternetShortcut] > "%Userprofile%\Desktop\Finesse.url"
echo URL=http://agentlogin1/desktop >> "%Userprofile%\Desktop\Finesse.url"
echo IDList= >> "%Userprofile%\Desktop\Finesse.url"
echo IconIndex=0 >> "%Userprofile%\Desktop\Finesse.url"
echo HotKey=0 >> "%Userprofile%\Desktop\Finesse.url"

echo Creating Printer Installer Tool Link... 
echo [InternetShortcut] > "%Userprofile%\Desktop\Printertool.url"
echo URL=http://printertool/ >> "%Userprofile%\Desktop\Printertool.url"
echo IDList= >> "%Userprofile%\Desktop\Printertool.url"
echo IconIndex=0 >> "%Userprofile%\Desktop\Printertool.url"
echo HotKey=0 >> "%Userprofile%\Desktop\Printertool.url"
echo.
echo Shortcuts Creation Complete. Returning to menu.
timeout /t 4 >nul
goto start

:restart
cls
echo Are you sure?
echo.
echo     1. Yes (will not restart, for testing purposes)
echo     2. No
echo.

CHOICE /N /C 12 /M "Choose a menu option by pressing the number."
if errorlevel == 2 goto restartFalse
if errorlevel == 1 goto restartTrue

:restartTrue
cls
echo WARNING: Close ALL open prelude sessions before continuing.
pause
echo "this is where we'd put 'shutdown /r /t 0'"
echo.
echo for now, going back to main menu.
timeout /t 4 >nul
goto start

:restartFalse
cls
echo.
echo Returning to Menu
timeout /t 4 >nul
goto start

:exit
cls
echo.
echo     ##    ##    ###    ##     ## ####
echo     ###   ##   ## ##   ##     ##  ##
echo     ####  ##  ##   ##  ##     ##  ##
echo     ## ## ## ##     ## ##     ##  ##
echo     ##  #### #########  ##   ##   ##
echo     ##   ### ##     ##   ## ##    ##
echo     ##    ## ##     ##    ###    ####
echo.
echo.
echo     Made for the LKQ Helpdesk by Aaron B, Sam G, and Martin G.
timeout /t 2 >nul
exit
