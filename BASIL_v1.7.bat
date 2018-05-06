@echo off
cls
:start
cls
echo.
echo	########     ###     ######  #### ##       
echo	##     ##   ## ##   ##    ##  ##  ##       
echo	##     ##  ##   ##  ##        ##  ##       
echo	########  ##     ##  ######   ##  ##       
echo	##     ## #########       ##  ##  ##       
echo	##     ## ##     ## ##    ##  ##  ##       
echo	########  ##     ##  ######  #### ########
echo.
echo.
echo	1. Maintenance
echo	2. Remote Computer Information
echo	3. Exit
echo.
echo.
CHOICE /N /C 1234 /M "Choose a menu option by pressing the number."
if errorlevel == 3 goto exit
if errorlevel == 2 goto reminfo
if errorlevel == 1 goto maintain

:reminfo
cls
echo.
echo	########     ###     ######  #### ##       
echo	##     ##   ## ##   ##    ##  ##  ##       
echo	##     ##  ##   ##  ##        ##  ##       
echo	########  ##     ##  ######   ##  ##       
echo	##     ## #########       ##  ##  ##       
echo	##     ## ##     ## ##    ##  ##  ##       
echo	########  ##     ##  ######  #### ########
echo.
echo.
echo	1. Model Info
echo	2. Network Info
echo	3. Installed Programs
echo	4. Main Menu
echo	5. Exit
echo.
echo.
CHOICE /N /C 12345 /M "Choose a menu option by pressing the number."
if errorlevel == 5 goto exit
if errorlevel == 4 goto start
if errorlevel == 3 goto programs
if errorlevel == 2 goto ipinfo
if errorlevel == 1 goto modelinfo

:modelinfo
cls
echo.
set /p compname="Remote computer name?:"
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

:ipinfo
cls
echo.
set /p compname="Remote computer name?: "
echo.
echo Querying %compname% ...
powershell.exe -ExecutionPolicy Bypass -command "Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName %compname% | Format-List -Property Description,IPAddress,MACAddress,DNSServerSearchOrder,DHCPServer
echo Mapped Network Drives
powershell -ExecutionPolicy Bypass -command "Get-Wmiobject Win32_MappedLogicalDisk -computername %compname% | select name,providername | FOrmat-Table -HideTableHeaders
echo.
wmic /node:"%compname%" computersystem get username
pause
goto reminfo

:programs
cls
echo.
set /p compname="Remote computer name?: "
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
if errorlevel == 1 goto del

:del
del c:\%compname%.txt
echo.
echo Deleted.
echo.
timeout /t 2 >nul
goto reminfo

:maintain
cls
echo.
echo	########     ###     ######  #### ##       
echo	##     ##   ## ##   ##    ##  ##  ##       
echo	##     ##  ##   ##  ##        ##  ##       
echo	########  ##     ##  ######   ##  ##       
echo	##     ## #########       ##  ##  ##       
echo	##     ## ##     ## ##    ##  ##  ##       
echo	########  ##     ##  ######  #### ########
echo.
echo.
echo	1. Clear IE Cache
echo	2. Kill IE, Clear Cache
echo	3. Flush Printer Stuck Jobs
echo	4. Main Menu
echo	5. Exit
echo.
echo.
CHOICE /N /C 12345 /M "Choose a menu option by pressing the number."
if errorlevel == 5 goto exit
if errorlevel == 4 goto start
if errorlevel == 3 goto printjob
if errorlevel == 2 goto killie
if errorlevel == 1 goto clearcache

:printjob
cls
echo.
echo Stopping Print Spooler...
net stop spooler
timeout /t 1 >nul
echo Flushing stuck jobs...
del /q %windir%\System32\spool\PRINTERS
echo.
echo Complete.
echo Starting Spooler system...
net start spooler
timeout /t 1 >nul
echo Complete. Printer queue flushed and restarted. Returning to menu.
timeout /t 2 >nul
goto maintain

:clearcache
cls
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
timeout /t 3 >nul
goto maintain

:killie
cls
echo.
echo Taking down Internet Explorer forcefully...
REM Kill Internet Explorer
taskkill /f /im iexplor*
echo.
echo.
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
rem echo.
rem echo Clearing deep Temporary Files...
rem del %userprofile%\AppData\Local\Microsoft\Windows
echo Cleanup complete, returning to menu.
timeout /t 3 >nul
goto maintain


:exit
cls
echo.
echo	########     ###     ######  #### ##       
echo	##     ##   ## ##   ##    ##  ##  ##       
echo	##     ##  ##   ##  ##        ##  ##       
echo	########  ##     ##  ######   ##  ##       
echo	##     ## #########       ##  ##  ##       
echo	##     ## ##     ## ##    ##  ##  ##       
echo	########  ##     ##  ######  #### ########
echo.
echo.
echo	Made for the LKQ Helpdesk by Martin G.
timeout /t 2 >nul
exit