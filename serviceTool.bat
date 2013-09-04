@echo off
setlocal

set ver=v1.9.5
set title= *  Technician's Service Tool - (TST)  %ver% *  on  %computername%
title %title%

::::::::::::::::::::::::::::::::::::::::
:: // Technician's Service Tool (TST) ::
:: // by Sivart Nedlaw                ::
:: // sivartnedlaw@gmail.com          ::
::::::::::::::::::::::::::::::::::::::::

cls
echo Initializing ...
echo.
goto initilization

:init_done
::   Initial Admin Check
set adminCheck=init
call :needAdmin

ping 127.0.0.1 /n 3 >nul
if "%detectedOS%" == "XP" call :invalidOS
if "%1" NEQ "" (
	call :%1
	exit /b)


:::::::::::::::::::::
:: // Main Menu // ::
:mainMenu
set return=mainMenu
set opt=
cls
echo.
echo                     ÄÄ[ Technician's Service Tool ]ÄÄ
echo.
echo.
echo        1. Special System Folders           5. Utilities
echo        2. System Dialog Shortcuts          6. Scripted Actions
echo        3. Internet Explorer Tools          7. User Management
echo        4. Control Panel                    8. System Information
if "%UAC%" == "true" (echo                                            9. Master Control Panel) else (echo.)
echo   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo        S. Shutdown Computer                H. Hibernate (a)
echo       RS. Shutdown Remote Computer        SL. Sleep (a)
echo        R. Restart Computer                 L. Lock Computer
echo       RR. Restart Remote Computer         LO. Log off
echo.
echo     Prefix Shutdown commands with F to Forcefully commit action
echo     (a) = signifies second method available to perform command
echo     Ex: FS = Force Shutdown  -  Ex: SLA = try alternate sleep method
echo   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo.
if "%installed%" == "yes" (
	if "%adminCheck%" NEQ "pass" (
echo     A. Run TST as Admin
		) else (
echo.)
	) else (
	if "%adminCheck%" NEQ "pass" (
echo     A. Run TST as Admin                    I. Install/Update Script   
		) else (
echo                                            I. Install/Update Script   )
)
if "%psexecexe%" == "no" (
echo     C. Open Command Prompt
	) else (
echo     C. Open Command Prompt                RC. Remote Command Prompt)
echo     x. Exit Service Tool                   D. TST Display Options
echo.

set /p opt=" Enter Selection [1-9] -->  "

if /i "%opt%" == "X" goto theEnd
if /i "%opt%" == "EXIT" goto theEnd
if "%opt%" == "1" goto shellFolders
if "%opt%" == "2" goto sysDialogs
if "%opt%" == "3" goto ie
if /i "%opt%" == "ieKill" call :ieKiller
if "%opt%" == "5" goto sysUtilities
if "%opt%" == "6" goto scriptedActions
if "%opt%" == "7" goto usrManagement
if "%opt%" == "4" goto controlPanel
if "%opt%" == "9" call :godMode
if "%opt%" == "8" goto sysInfo
if /i "%opt%" == "A" (
	call :admin
	exit /b)
if /i "%opt%" == "C" start "" cmd.exe /k cd /d "C:\temp"
if /i "%opt%" == "RC" call :startPsexec
if /i "%opt%" == "SRC" call :startPsexec
if /i "%opt%" == "S" call :shutdown
if /i "%opt%" == "FS" call :shutdownForce
if /i "%opt%" == "R" call :restart
if /i "%opt%" == "FR" call :restartForce
if /i "%opt%" == "RS" call :remoteStop
if /i "%opt%" == "FRS" call :remoteStop
if /i "%opt%" == "RR" call :remoteStop
if /i "%opt%" == "FRR" call :remoteStop
if /i "%opt%" == "H" start "" RunDll32.exe Powrprof.dll,SetSuspendState Hibernate
if /i "%opt%" == "HA" shutdown /h
if /i "%opt%" == "SL" start "" RunDll32.exe Powrprof.dll,SetSuspendState Sleep
if /i "%opt%" == "SLA" start "" RunDll32.exe powrprof.dll,SetSuspendState 0,1,0
if /i "%opt%" == "L" start "" RunDll32.exe User32.dll,LockWorkStation
if /i "%opt%" == "LO" shutdown /l
if /i "%opt%" == "I" call :install
if /i "%opt%" == "D" call :display

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto mainMenu
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto mainMenu
)



:shellFolders
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo             Shell Folders
echo.
echo.
echo      1. Pinned Applications
echo      2. SendTo List
echo      3. Favorite Folder Locations
echo      4. Quick Launch
echo      5. Network Places
echo.
echo      6. My Computer
echo      7. Start Menu
echo      8. Start Up
echo      9. Desktop
echo.
echo      0. Control Panel ...
echo.
echo.
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" explorer.exe shell:User Pinned
if "%opt%" == "2" (
	if "%UAC%" == "true" explorer.exe shell:SendTo
	if "%detectedOS%" == "XP" explorer.exe "%userprofile%\SendTo")
if "%opt%" == "3" explorer.exe shell:Links
if "%opt%" == "4" (
	if "%UAC%" == "true" explorer.exe shell:Quick Launch
	if "%detectedOS%" == "XP" explorer.exe "%appdata%\Microsoft\Internet Explorer\Quick Launch")
if "%opt%" == "5" (
	if "%UAC%" == "true" explorer.exe shell:NetworkPlacesFolder
	if "%detectedOS%" == "XP" explorer.exe shell:NetHood)
if "%opt%" == "6" (
	if "%UAC%" == "true" explorer.exe shell:MyComputerFolder
	if "%detectedOS%" == "XP" explorer.exe ::{20D04FE0-3AEA-1069-A2D8-08002B30309D})
if "%opt%" == "7" call :shellStartMenu
if "%opt%" == "8" call :shellStartup
if "%opt%" == "9" call :shellDesktop
if "%opt%" == "0" goto controlPanel

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto shellFolders
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto shellFolders
)



:sysDialogs
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo             System Dialogs
echo.
echo.
echo      1. Personalization Menu
echo      2. Network Menu
echo      3. System/Folder Properties Menu
echo      4. Security Menu
echo      5. Backup/Restore
echo.
echo      6. Action Center
echo      7. Power
echo      8. Sound
echo      9. Unplug/Eject Hardware
echo      0. Edit FileType Association
echo.
echo      s. System Properties
echo      w. Welcome Center
echo      a. About
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" goto personalization
if "%opt%" == "2" goto netSysDialogs
if "%opt%" == "3" goto sysFoldProperties
if "%opt%" == "4" goto security
if "%opt%" == "5" (
	if "%UAC%" == "true" start "" sdclt.exe
	if "%detectedOS%" == "XP" %SystemRoot%\system32\ntbackup.exe)
::sdclt.exe /restorewizardadmin
::sdclt.exe /restorewizard
::sdclt.exe /configure
if "%opt%" == "6" start "" RunDll32.exe shell32.dll,Control_RunDLL wscui.cpl
if "%opt%" == "7" start "" RunDll32.exe Shell32.dll,Control_RunDLL powercfg.cpl
if "%opt%" == "8" start "" RunDll32.exe shell32.dll,Control_RunDLL mmsys.cpl
if "%opt%" == "9" start "" RunDll32.exe shell32.dll,Control_RunDLL hotplug.dll
if "%opt%" == "0" call :openWith
if /i "%opt%" == "S" (
	if "%UAC%" == "true" start "" control /name Microsoft.System
	if "%detectedOS%" == "XP" start "" control.exe %windir%\system32\sysdm.cpl)
if /i "%opt%" == "W" start "" RunDll32.exe oobefldr.dll,ShowWelcomeCenter
if /i "%opt%" == "A" start "" RunDll32.exe SHELL32.DLL,ShellAboutW

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto sysDialogs
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto sysDialogs
)



:netSysDialogs
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo         Network System Dialogs
echo.
echo.
echo      1. Network Connections
echo      2. Available Wireless Networks
echo      3. Wireless Network Setup
echo      4. Manage Wireless Networks
echo.
echo      5. Internet Options 
echo      6. Add Network Location Wizard
echo      7. Map Network Drive
echo      8. Phone/Modem Options
echo.
echo      9. Open Network Places
echo.
echo.
echo.
echo.
echo   -. Go back
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-9] -->  "

if "%opt%" == "-" goto sysDialogs
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" RunDll32.exe shell32.dll,Control_RunDLL ncpa.cpl
if "%opt%" == "2" (
	if "%UAC%" == "true" start "" RunDll32.exe van.dll,RunVAN
	if "%detectedOS%" == "XP" start "" RunDll32.exe shell32.dll,Control_RunDLL ncpa.cpl)
if "%opt%" == "3" start "" RunDll32.exe shell32.dll,Control_RunDLL NetSetup.cpl,@0,WNSW
if "%opt%" == "4" explorer.exe shell:::{1fa9085f-25a2-489b-85d4-86326eedcd87}
if "%opt%" == "5" start "" RunDll32 Shell32.dll,Control_RunDLL Inetcpl.cpl,,0
if "%opt%" == "6" (
	if "%UAC%" == "true" start "" "RunDll32.exe shwebsvc.dll,AddNetPlaceRunDll"
	if "%detectedOS%" == "XP" start "" "rundll32.exe netshell.dll,StartNCW")
if "%opt%" == "7" start "" RunDll32.exe shell32.dll,SHHelpShortcuts_RunDLL Connect
if "%opt%" == "8" start "" RunDll32.exe shell32.dll,Control_RunDLL telephon.cpl
if "%opt%" == "9" (
	if "%UAC%" == "true" explorer.exe shell:NetworkPlacesFolder
	if "%detectedOS%" == "XP" explorer.exe shell:NetHood)
	
if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto netSysDialogs
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto netSysDialogs
)



:personalization
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo            Personalization
echo.
echo.
echo      1. Personalization Main
echo      2. Display Settings
echo      3.  - Screen Resolution
echo      4.  - Screen Saver
echo      5. Taskbar/Start Menu Options
echo.
echo      6. Keyboard
echo      7. Mouse
echo      8. Aero ON
echo      9. Aero OFF
echo.
echo      0. Open With...
echo      f. Favorite Folders
echo.
echo.
echo   -. Go back
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto sysDialogs
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl,,2
if "%opt%" == "2" (
	if "%UAC%" == "true" start "" RunDll32.exe shell32.dll,Control_RunDLL access.cpl,,3
	if "%detectedOS%" == "XP" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl)
if "%opt%" == "3" (
	if "%UAC%" == "true" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl
	if "%detectedOS%" == "XP" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl,,4)
if "%opt%" == "4" (
	if "%UAC%" == "true" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl,,1
	if "%detectedOS%" == "XP" start "" RunDll32.exe shell32.dll,Control_RunDLL desk.cpl,,1)
if "%opt%" == "5" start "" RunDll32.exe shell32.dll,Options_RunDLL 1
if "%opt%" == "6" start "" RunDll32.exe shell32.dll,Control_RunDLL main.cpl @1
if "%opt%" == "7" start "" RunDll32.exe shell32.dll,Control_RunDLL main.cpl @0
if "%opt%" == "8" start "" RunDll32.exe DwmApi #102
if "%opt%" == "9" start "" RunDll32.exe DwmApi #104
if "%opt%" == "0" call :openWith
if /i "%opt%" == "O" call :openWith
if /i "%opt%" == "F" explorer.exe shell:Links

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto personalization
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto personalization
)



:sysFoldProperties
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo        System/Folder Properties
echo.
echo      1. System Properties
echo      2.  - Hardware
echo      3.  - Advanced
echo      4.  - System Protection
echo      5.  - Remote Access
echo.
echo      6. Date/Time
echo      7. Taskbar
echo      8. Folder Options
echo      9.  - Search
echo      0.  - View Preferences
echo.
echo      e. Environment Variables
echo      i. Indexing Options
echo      n. Notification Area
echo.
echo   -. Go back
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto sysDialogs
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl
if "%opt%" == "2" start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,2
if "%opt%" == "3" start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,3
if "%opt%" == "4" start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,4
if "%opt%" == "5" start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,5
if "%opt%" == "6" start "" RunDll32.exe shell32.dll,Control_RunDLL timedate.cpl
if "%opt%" == "7" start "" RunDll32.exe shell32.dll,Options_RunDLL 1
if "%opt%" == "8" start "" RunDll32.exe shell32.dll,Options_RunDLL 0
if "%opt%" == "9" (
	if "%UAC%" == "true" start "" RunDll32.exe shell32.dll,Options_RunDLL 2
	if "%detectedOS%" == "XP" control.exe srchadmin.dll)
if "%opt%" == "0" start "" RunDll32.exe shell32.dll,Options_RunDLL 7
if /i "%opt%" == "E" start "" rundll32 sysdm.cpl,EditEnvironmentVariables
if /i "%opt%" == "I" control.exe srchadmin.dll
if /i "%opt%" == "N" start "" RunDll32.exe shell32.dll,Options_RunDLL 5

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto sysFoldProperties
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto sysFoldProperties
)



:security
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo                Security
echo.
echo.
echo      1. Windows Security Center
echo      2. User Accounts
echo      3.  - Forgotten Password Wizard
echo      4.  - Stored Usernames/Passwords
echo.
echo      5. Windows Firewall
echo      6. Content Advisor
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo.
echo   -. Go back
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-6] -->  "

if "%opt%" == "-" goto sysDialogs
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" RunDll32.exe shell32.dll,Control_RunDLL wscui.cpl
if "%opt%" == "2" start "" RunDll32.exe shell32.dll,Control_RunDLL nusrmgr.cpl
if "%opt%" == "3" start "" RunDll32.exe keymgr.dll,PRShowSaveWizardExW
if "%opt%" == "4" start "" RunDll32.exe keymgr.dll,KRShowKeyMgr
if "%opt%" == "5" start "" RunDll32.exe shell32.dll,Control_RunDLL firewall.cpl
if "%opt%" == "6" start "" RunDll32.exe msrating.dll,RatingSetupUI

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto security
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto security
)



:ie
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo           Internet Explorer
echo.
echo.
echo      1. Temporary Internet Files, Folder
echo      2. Cookies, Folder
echo      3. History, Folder
echo      4. Favorites, Folder
echo.
echo      5. Organize Favorites, Dialog
echo      6. Internet Properties, Dialog
echo      7. Launch Internet Explorer
echo      8. Launch Internet Explorer in Safe Mode
echo.
echo      9. Internet Explorer Cleanup Menu
echo      0. Kill IE Processes
echo.
echo    FIX. IE Repair
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-8] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "X" goto theEnd
if /i "%opt%" == "M" goto mainMenu

if "%opt%" == "1" (
	if "%UAC%" == "true" explorer.exe shell:Cache
	if "%detectedOS%" == "XP" (
		explorer.exe "%userprofile%\Local Settings\Temporary Internet Files"
		explorer.exe "%userprofile%\Local Settings\Temporary Internet Files\Content.IE5"))
if "%opt%" == "2" (
	if "%UAC%" == "true" explorer.exe shell:Cookies
	if "%detectedOS%" == "XP" explorer.exe "%userprofile%\Local Settings\Temporary Internet Files")
if "%opt%" == "3" (
	if "%UAC%" == "true" explorer.exe shell:History
	if "%detectedOS%" == "XP" explorer.exe "%userprofile%\Local Settings\History")
if "%opt%" == "4" (
	if "%UAC%" == "true" explorer.exe shell:Favorites
	if "%detectedOS%" == "XP" explorer.exe "%userprofile%\Favorites")
if "%opt%" == "5" start "" RunDll32.exe shdocvw.dll,DoOrganizeFavDlg
if "%opt%" == "6" start "" RunDll32 Shell32.dll,Control_RunDLL Inetcpl.cpl,,0
if "%opt%" == "7" (
	if "%UAC%" == "true" explorer.exe shell:InternetFolder
	if "%detectedOS%" == "XP" start "" "%ProgramFiles%\Internet Explorer\iexplore.exe")
if "%opt%" == "8" start "" "%ProgramFiles%\Internet Explorer\iexplore.exe" -extoff
if "%opt%" == "9" goto ieCleanup
if "%opt%" == "0" call :ieKill
if /i "%opt%" == "FIX" call :ieFix

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto ie
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto ie
)



:ieCleanup
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo           IE Cleanup Actions
echo.
echo.
echo    The pop-up box related to these actions says it 
echo    removes each of the items below no matter what 
echo    you pick.  It is a generic box.  Only what you 
echo    select will actually be removed.
echo.
echo      1. Delete Temporary Internet Files
echo      2. Delete Cookies
echo      3. Delete History
echo      4. Delete Form Data
echo      5. Delete Passwords
echo      6. Delete All of the Above
echo      7. Delete All + Add-on Caches
echo.
echo      8. Organize Favorites
echo.
echo   -. Go back to IE Menu
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-8] -->  "

if "%opt%" == "-" goto ie
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" call :ieCleanupTempFiles
if "%opt%" == "2" call :ieCleanupCookies
if "%opt%" == "3" call :ieCleanupHistory
if "%opt%" == "4" call :ieCleanupFormData
if "%opt%" == "5" call :ieCleanupPasswords
if "%opt%" == "6" call :ieCleanupAll
if "%opt%" == "7" call :ieCleanupReallyAll
if "%opt%" == "8" start "" RunDll32.exe shdocvw.dll,DoOrganizeFavDlg


if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto ieCleanup
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto ieCleanup
)



:sysUtilities
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo            System Utilities
echo.
echo.
echo      1. Task Manager
echo      2. Computer Management
echo     2R. Manage Remote PC
echo      3. Device Manager (a)
echo      4. Disk Management
echo.
echo      5. Services
echo      6. System Configuration
echo      7. System Restore
echo      8. Volume Mixer
::echo      9. Power Management
echo.
if "%sysToolsChk%" == "yes" (
echo      0. SysInternals)
echo      h. Reveal Hidden Hardware in Device Manager
echo      r. Registry Editor
if "%sysToolsChk%" NEQ "yes" (
echo.)
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-8] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" taskmgr.exe
if "%opt%" == "2" start "" compmgmt.msc
if /i "%opt%" == "2R" call :rManage
if "%opt%" == "3" start "" devmgmt.msc
if "%opt%" == "3A" start "" RunDll32.exe shell32.dll,Control_RunDLL hdwwiz.cpl
:: start "" RunDll32.exe devmgr.dll DeviceManager_Execute
if "%opt%" == "4" start "" diskmgmt.msc
if "%opt%" == "5" start "" services.msc
if "%opt%" == "6" start "" msconfig.exe
if "%opt%" == "7" (
	if "%UAC%" == "true" start "" "%systemroot%\system32\rstrui.exe"
	if "%detectedOS%" == "XP" start "" "%systemroot%\system32\restore\rstrui.exe")
if "%opt%" == "8" (
	if "%UAC%" == "true" start "" sndvol.exe
	if "%detectedOS%" == "XP" start "" "%SystemRoot%\system32\sndvol32.exe")
if "%opt%" == "9" goto powerManager
if "%opt%" == "0" goto sysInternals
if /i "%opt%" == "R" start "" regedit.exe
if /i "%opt%" == "H" call :revealHiddenHardware

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto sysUtilities
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto sysUtilities
)



:sysInternals
set opt=
cls
echo.
echo   ÄÄ[ Technician's  Service Tool ]ÄÄ
echo              SysInternals
echo.
echo      1. Process Explorer
echo      2. Disk Monitor
echo      3. File Monitor
echo      4. Process Monitor
echo      5. Registry Monitor
echo.
echo      6. Autoruns
echo      7. TCP Viewer
echo      8. Share Enumeration
echo      9. Access Enumeration
echo      0. Active Directory Explorer
echo.
echo      c. Open Command Window on Remote machine
echo      b. Copy/Delete File on Boot
echo      j. Create NTFS Junction
echo.
echo   -. Go back
echo   m. Go back to Main Menu
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto sysUtilities
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" "%sysTools%\procexp.exe"
if "%opt%" == "2" start "" "%sysTools%\Diskmon.exe"
if "%opt%" == "3" start "" "%sysTools%\Filemon.exe"
if "%opt%" == "4" start "" "%sysTools%\Procmon.exe"
if "%opt%" == "5" start "" "%sysTools%\Regmon.exe"
if "%opt%" == "6" start "" "%sysTools%\autoruns.exe"
if "%opt%" == "7" start "" "%sysTools%\Tcpview.exe"
if "%opt%" == "8" start "" "%sysTools%\ShareEnum.exe"
if "%opt%" == "9" start "" "%sysTools%\AccessEnum.exe"
if "%opt%" == "0" start "" "%sysTools%\ADExplorer.exe"
if /i "%opt%" == "C" call :startPsexec
if /i "%opt%" == "B" call :copyOnBoot
if /i "%opt%" == "J" call :createJunction

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto sysInternals
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto sysInternals
)



:scriptedActions
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo           Scripted Actions
echo.
echo.
echo      1. Clear Outlook Temp Files
echo      2. Default VB Script Engine
echo      3. IE Repair
echo      4. Reset Local Print Queues
echo      5. Reveal Hidden Hardware
echo.
echo      6. Schedule Disk Check
echo      7. Systray Missing Icon Fix
echo      8. Unistall MSI
echo      9. URL Shortcut Fix
echo.
echo    WMI. Windows Management Interface (WMI) Fix
echo     WU. Windows Update Repair
echo.
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-9] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" call :clrOutlookTemp
if "%opt%" == "2" call :defaultVBengine
if "%opt%" == "3" call :ieFix
if "%opt%" == "4" call :clrPrntQ
if "%opt%" == "5" call :revealHiddenHardware
if "%opt%" == "6" call :scheduleDiskCheck
if "%opt%" == "7" call :systrayFix
if "%opt%" == "8" call :msiRemove
if "%opt%" == "9" call :urlFix
if /i "%opt%" == "WMI" call :wmiFix
if /i "%opt%" == "WU" call :wuRepair

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto scriptedActions
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto scriptedActions
)



:usrManagement
set opt=
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo         User/Group Management
echo.
echo.
echo     ÄÄÄÄÄÄÄÄÄÄÄÄ Local Machine ÄÄÄÄÄÄÄÄÄÄÄÄ
echo      1. Add User to Local Admin Group
echo      2. Remove User from Local Admin Group
echo      3. Add User to Remote Desktop Group
echo      4. List Local Admins
echo      5. Start User Management GUI
echo.
echo.
if "%psexecexe%" == "no" echo        !!! REMOTE TOOLS UNAVAILABLE !!!
echo     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ Remote PC ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo      6. Add User to Local Admin Group
echo      7. Remove User from Local Admin Group
echo      8. Add User to Remote Desktop Group
echo      9. Start User Management GUI
echo.
if "%psexecexe%" NEQ "no" echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [1-9] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" call :addUsrLadmin
if "%opt%" == "2" call :rmUsrLadmin
if "%opt%" == "3" call :addUsrRDP
if "%opt%" == "4" call :localAdmins
if "%opt%" == "5" start "" lusrmgr.msc
if "%opt%" == "6" call :addUsrLadminRemote
if "%opt%" == "7" call :rmUsrLadminRemote
if "%opt%" == "8" call :addUsrRDPremote
if "%opt%" == "9" call :rUsrManage 
REM if "%opt%" == "0"

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto usrManagement
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto usrManagement
)



:sysinfo
call :sysinfoGather
call :javaChk
:sysinfo_noRefresh
set opt=
cls
echo.
echo                     ÄÄ[ Technician's Service Tool ]ÄÄ
echo                             System Information
echo.
echo      1. Show Full System Info
echo.
echo           OS Name: %infoOsName% SP%infoOsSp% %infoOsArch%
echo          CPU Name: %infoCpuName%
echo        CPU Detail: %infoCpuProcCount% Processor(s) with %infoCpuCoreCount% Cores @ %infoCpuSpeed%MHz (%infoCpuSpeedGZ%GHz)
echo      Manufacturer: %infoSysMfg% %infoSysModel%
echo      Install Date: %infoFirstBoot%
echo         Last Boot: %infoLastBoot%
echo        IP Address:%infoIP%  on  %domain%
echo.
echo    ÄÄÄÄÄÄÄÄÄÄÄÄ[ Java ]ÄÄÄÄÄÄÄÄÄÄÄÄ    ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[ Memory ]ÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo                                              Total RAM:  %infoMemTotal% MB  
echo               32 BIT      64 BIT             Available:  %infoMemAvail% MB
if "%adminCheck%" NEQ "pass" (
echo    Java 6  Cannot determine version     Page File Size:  %infoPfSize% MB
echo    Java 7     when not an admin              Page File:  %infoPfLoc% 
) else (
echo      Java 6   %j632ver%    %j664ver%      Page File Size:  %infoPfSize% MB
echo      Java 7   %j732ver%    %j764ver%           Page File:  %infoPfLoc% 
)
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd



if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto sysinfo_noRefresh
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto sysinfo
)



:controlPanel
set opt=
cls
echo.
echo                     ÄÄ[ Technician's Service Tool ]ÄÄ
echo                               Control Panel
echo.
echo.
echo      1. Add/Remove Programs(a)    1B. Add/Remove Windows Components
echo      2. Administrative Tools       
echo      3. Auto Play                  U. Application Updates
echo      4. Flash Player               F. Fonts
echo      5. Folder Options             N. Network Connections
echo.
echo      6. Internet Options           P. Printers
echo      7. System Dialog              J. Java 
echo      8. User Accounts             IE. Internet Explorer...
echo      9. Outlook Mail               S. System Utilities...
echo      0. Outlook PST Repair         
echo.
echo      C. Control Panel (a)          *. W7 Master Control Panel
echo.
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=" Enter Selection [0-9] -->  "

if "%opt%" == "-" goto mainMenu
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%opt%" == "1" start "" RunDll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,0
if /i "%opt%" == "1A" explorer.exe shell:ChangeRemoveProgramsFolder
if /i "%opt%" == "1B" start "" RunDll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,2
if "%opt%" == "2" explorer.exe shell:Common Administrative Tools
if "%opt%" == "3" start "" control /name Microsoft.AutoPlay
if "%opt%" == "4" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		start "" "%SystemDrive%\WINDOWS\SysWOW64\rundll32.exe" "%SystemDrive%\WINDOWS\SysWOW64\shell32.dll",#44 "%SystemDrive%\WINDOWS\SysWOW64\FlashPlayerCPLApp.cpl",Flash Player
	) else (
		start "" "%SystemRoot%\system32\rundll32.exe" "%SystemRoot%\system32\shell32.dll,Control_RunDLL" "%SystemRoot%\system32\FlashPlayerCPLApp.cpl",Flash Player))
if "%opt%" == "5" start "" control folders
if "%opt%" == "6" start "" RunDll32 Shell32.dll,Control_RunDLL Inetcpl.cpl,,0
if "%opt%" == "7" (
	if "%UAC%" == "true" (
		start "" control /name Microsoft.System
	) else (
	if "%detectedOS%" == "XP" (
		start "" RunDll32.exe shell32.dll,Control_RunDLL sysdm.cpl)))
if "%opt%" == "9" call :mailApplet
if "%opt%" == "0"  call :pstApplet
if "%opt%" == "8" start "" RunDll32.exe shell32.dll,Control_RunDLL nusrmgr.cpl
if /i "%opt%" == "C" start "" RunDll32.exe shell32.dll,Control_RunDLL
if /i "%opt%" == "CA" explorer.exe shell:ControlPanelFolder
if /i "%opt%" == "F" explorer.exe shell:Fonts
if /i "%opt%" == "J" goto javaManage
if /i "%opt%" == "N" explorer.exe shell:ConnectionsFolder
if /i "%opt%" == "P" explorer.exe shell:PrintersFolder
if /i "%opt%" == "S" goto sysUtilities
if /i "%opt%" == "U" explorer.exe shell:AppUpdatesFolder
if /i "%opt%" == "IE" goto ie
if "%opt%" == "*" call :godMode

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto controlPanel
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto controlPanel
)



:powerManager
exit /b



::::::::::::::::::::::::::::
:: // Folder Locations // ::
:shellStartMenu
if "%UAC%" == "true" (
	explorer.exe shell:Start Menu
	explorer.exe shell:Common Start Menu)
if "%detectedOS%" == "XP" (
	explorer.exe "%userprofile%\Start Menu"
	explorer.exe "%allusersprofile%\Start Menu")
ping 127.0.0.1 /n 2 >nul
exit /b
:shellStartup
if "%UAC%" == "true" (
	explorer.exe shell:Startup
	explorer.exe shell:Common Startup)
if "%detectedOS%" == "XP" (
	explorer.exe "%userprofile%\Start Menu\Programs\Startup"
	explorer.exe "%allusersprofile%\Start Menu\Programs\Startup")
ping 127.0.0.1 /n 2 >nul
exit /b
:shellDesktop
if "%UAC%" == "true" (
	explorer.exe shell:Desktop
	explorer.exe shell:Common Desktop)
if "%detectedOS%" == "XP" (
	explorer.exe "%userprofile%\Desktop"
	explorer.exe "%allusersprofile%\Desktop")
ping 127.0.0.1 /n 2 >nul
exit /b





::::::::::::::::::::::::::::
:: // Scripted Actions // ::

::  // Copies servicetool.bat and psexec.exe to C:\temp
:install
cls
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo             Installing ...
echo.
echo.

if "%installDir%" == "" (
	echo   * Enter directory in which to install TST.
	echo        Example: C:\Temp
	echo.
	echo        Leave Blank and press ENTER to install to C:\Temp
	echo.
	set /p installDir="--> "
	echo.
)

if /i "%installDir%" == "" (
		set installDir=C:\Temp
)

echo   * Creating directories
if not exist "%installDir%\sysinternals" md "%installDir%\sysinternals"
if not exist "%installDir%" (
	echo    ! Installation Failed
	echo    ! - Could not create install directory
	ping 127.0.0.1 /n 5 >nul
	echo.
	echo     Returning to script
	exit /b
)
echo.
echo   * Installing script
copy "\\zusbif01\helpdesk\csc\scripts\serviceTool.bat" /y "%installDir%" >nul
if not exist "%installDir%\serviceTool.bat" (
	echo    ! Installation Failed
	echo    ! - Script copy was not successful
	ping 127.0.0.1 /n 5 >nul
	echo.
	echo     Returning to script
	exit /b
)
echo.
echo   * Copying support files
if "%sysTools%" NEQ "%installDir%\sysinternals" xcopy /C /E /Q /Y "\\ousbif01\share\!User\waldent\apps\sysinternals\*" "%installDir%\sysinternals" >nul
if not exist "%installDir%\psexec.exe" copy "\\zusbif01\helpdesk\csc\scripts\psexec.exe" /y "%installDir%\psexec.exe" >nul
echo.
echo   * Creating shortcut
copy "\\zusbif01\helpdesk\csc\scripts\TST_link.lnk" /y "%userprofile%\Desktop\T.S.T..lnk" >nul
echo.
echo           Install Complete.
echo           Installed to [ %installDir% ].
ping 127.0.0.1 /n 3 >nul
echo           Starting T.S.T. . . .
ping 127.0.0.1 /n 3 >nul
call "%installDir%\serviceTool.bat"
exit
::  / End installation routine





:: Start Script Display Customizer /
:display
::MODE CON: COLS=80 LINES=300 /Defaults/
for /f "tokens=2 delims=: " %%i in ('mode con /status ^| find "Lines:"') do (set conLines=%%i)
for /f "tokens=*" %%i in ('mode con /status ^| find "Columns:"') do (set conColumns=%%i)
cls
set colour=
echo.
echo                ÄÄ[ Technician's Service Tool ]ÄÄ
echo                    Terminal Display Options
echo.
echo.
echo    0 = Black       8 = Dark Gray        
echo    1 = Blue        9 = Bright Blue      
echo    2 = Green       A = Bright Green       Current Console Info
echo    3 = Aqua        B = Bright Aqua      ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo    4 = Red         C = Bright Red          History:       %conLines%
echo    5 = Purple      D = Bright Purple       %conColumns%
echo    6 = Yellow      E = Bright Yellow    
echo    7 = Gray        F = Bright White     
echo.
echo.
echo         Example: 07 produces Black Background with Gray Text
echo                     ( 07 are the default terminal colors )
echo.
echo.
echo.
echo. 
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p colour="Enter Backgroud then Font Color Choices --> "

if "%colour%" == "-" goto mainMenu
if /i "%colour%" == "M" goto mainMenu
if /i "%colour%" == "X" goto theEnd

if "%colour%" == "" (
	echo.
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto display
)

color %colour%

if errorlevel 1 (
	echo.
	echo  !! ERROR !!  You cannot specify the BACKGROUND and FONT as the same color.
	echo.
	echo  Press ENTER to try again.
	pause >nul
	goto display)

:display0
echo.
set /p confirmDisplay="Would you like to keep these colors?  Enter Y/N > "
if /i "%confirmDisplay%" NEQ "Y" (
	if /i "%confirmDisplay%" NEQ "N" (
		echo.
		echo   Please only choose Y or N
		echo.
		goto display0
	)
)

if /i "%confirmDisplay%" == "N" (
	color 07
	goto display)

:display1
echo.
if /i "%keepDisplay%" == "Y" exit /b
if /i "%keepDisplay%" == "N" exit /b

set /p keepDisplay="Would you like to keep these colors after closing TST?  Enter Y/N > "

if /i "%keepDisplay%" NEQ "Y" (
	if /i "%keepDisplay%" NEQ "N" (
		echo.
		echo   Please only choose Y or N
		echo.
		goto display1
	)
)

exit /b
:: / End Script Display Customizer



:: Start Open Command Window on Remote PC /
:startPsexec
cls
set usr=
set psOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo         Start Remote Console

call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b
if /i "%opt%" == "SRC" goto startPsexecSys

echo.
echo  Enter domain\username for console to run as.
echo  Leave blank to run as %userdomain%\%username%
echo.
echo  Enter Q to Quit
echo.
set /p usr= Enter domain\username: 
if "%usr%" == "" set usr=%userdomain%\%username%
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

start "" "%psexecexe%" "\\%asset%" /u "%usr%" cmd.exe
goto startPsexecEnd

:startPsexecSys
start "" "%psexecexe%" "\\%asset%" cmd.exe

:startPsexecEnd
title %title%
exit /b
:: / End Open Command Window on Remote PC

:: Begin Clear Outlook Temp Files /
:clrOutlookTemp
cls
set olkOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo       Outlook Temp File Cleaner
echo.
echo.
echo     This script is needed when a user opens a file from Outlook with the same 
echo     name over and over again.  Once the user opens the file 100 times, 
echo     Outlook will throw up an error and refuse to open the file.
echo.
echo     !! This script will force close any instances of Outlook on the machine  !!
echo     !! Please Close Outlook before continuing to prevent possible PST issues !!
echo.
echo.
echo     Press C to clear the Current User
echo     Press ENTER to pick another user
echo.
echo.
echo.
echo.
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p olkOpt=" Enter Selection [c,enter] -->  "

if "%olkOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%olkOpt%" == "X" goto theEnd
if /i "%olkOpt%" == "C" set usr=%username%
if "%olkOpt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto clrOutlookTemp)

for /f "tokens=1" %%a IN ('tasklist /FI "IMAGENAME eq OUTLOOK.EXE"')  do (
set active=%%a)
if /i "%active%" == "OUTLOOK.EXE" (
	echo   *Outlook is Running ... Terminiating OUTLOOK.EXE
	taskkill /F /IM OUTLOOK.EXE
	ping 127.0.0.1 /n 6 >nul
)

if "%UAC%" == "true" goto clrOutlookTempW7
if "%detectedOS%" == "XP" goto clrOutlookTempXP

:clrOutlookTempW7
if /i "%olkOpt%" == "C" goto clrOutlookTempW71
call :usrPicker
if /i "%usr%" == "Q" exit /b
:clrOutlookTempW71
set olkOpt=
if exist "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Outlook" rmdir /s /q "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Outlook"
echo.
if not exist "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Windows\Temporary Internet Files\Content.Outlook\*" echo    *Outlook Temporary Files Directory has been cleared. 
echo.
set /p olkOpt=Remove Offline Storage File? [Y/N]: 
if /i "%olkOpt%" == "Y" (
	if exist "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Outlook\*.ost" del "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Outlook\*.ost" /y
	goto clrOutlookTempW72
)
if /i "%olkOpt%" == "Yes" (
	if exist "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Outlook\*.ost" del "%SystemDrive%\Users\%usr%\AppData\Local\Microsoft\Outlook\*.ost" /y
	goto clrOutlookTempW72
)
if /i "%olkOpt%" == "N" goto clrOutlookTempDone
if /i "%olkOpt%" == "No" goto clrOutlookTempDone
if "%olkOpt%" == "" (
	!!! Please Enter Y or N !!!
	goto clrOutlookTempW71
)
if "%olkOpt%" NEQ "" goto clrOutlookTempW71
:clrOutlookTempW72
echo.
echo    *Outlook Offline Storage Files has been deleted. 
goto clrOutlookTempDone
:clrOutlookTempXP
if /i "%olkOpt%" == "C" goto clrOutlookTempXP1
call :usrPicker
if /i "%usr%" == "Q" exit /b
:clrOutlookTempXP1
set opt=
if exist "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Temporary Internet Files\Content.Outlook" rmdir /s /q "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Temporary Internet Files\Content.Outlook"
echo.
if not exist "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Temporary Internet Files\Content.Outlook\*" echo    *Outlook Temporary Files Directory has been cleared. 
echo.
set /p opt=Remove Offline Storage File? [Y/N]: 
if /i "%opt%" == "Y" (
	if exist "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Application Data\Microsoft\Outlook\*.ost" del "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Application Data\Microsoft\Outlook\*.ost" /y
	goto clrOutlookTempXP2
)
if /i "%opt%" == "Yes" (
	if exist "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Application Data\Microsoft\Outlook\*.ost" del "%SystemDrive%\Documents and Settings\%usr%\Local Settings\Application Data\Microsoft\Outlook\*.ost" /y
	goto clrOutlookTempXP2
)
if /i "%opt%" == "N" goto clrOutlookTempDone
if /i "%opt%" == "No" goto clrOutlookTempDone
if "%opt%" == "" (
	!!! Please Enter Y or N !!!
	goto clrOutlookTempXP1
)
:clrOutlookTempXP2
echo.
echo    *Outlook Offline Storage Files has been deleted. 
:clrOutlookTempDone
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo       Outlook Temp File Cleaner
echo.
echo.
echo             *** Done ***
echo.
echo.
ping 127.0.0.1 /n 3 >nul
exit /b
:: / End Clear Outlook Temp Files


:: Begin Reveal Hidden Hardware /
:revealHiddenHardware
cls
set return=revealHiddenHardware
set rhhOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo        Reveal Hidden Hardware
echo.
echo.
echo        By default, Device Manager hides certain types of devices.
echo        In the "View" menu, you can select "Show Hidden Devices" and
echo        this will show you all currently connected/installed devices.
echo.
echo        However, Device Manager keeps track of all the devices that have
echo        been connected to the computer in the past, but will not normally
echo        show these devices.
echo.
echo.
echo        *** Press ENTER to show ALL devices in Device Manager ***
echo.
echo        ***Note***
echo             Once Device Manager opens, you need to 
echo             Click "View" ^> "Show hidden devices"
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p rhhOpt=Enter Selection --^>  
if "%rhhOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%rhhOpt%" == "X" goto theEnd
if "%rhhOpt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto revealHiddenHardware)

call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

set devmgr_show_nonpresent_devices=1
start "" devmgmt.msc
goto revealHiddenHardware
:: / End Reveal Hidden Hardware


:: Begin Default VB Script Engine Chooser /
:defaultVBengine
cls
set return=defaultVBengine
set dVBopt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo           Default VB Engine
echo.
echo.
echo      A good script will call the proper VB engine before  
echo      calling the VB script itself.  However, sometimes, this
echo      is not done and you get strange error messages.
echo      This script will set the default engine of your choice.
echo.
echo.
echo        WScript is used for GUI applications
echo        CScript is used for console applications
echo                (such as login scripts)
echo.
echo        Please make your selection from the choices below
echo.
echo        1. CScript
echo        2. WScript
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p dVBopt=Enter Selection --^>
if "%dVBopt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%dVBopt%" == "X" goto theEnd
if "%dVBopt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto defaultVBengine)

call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

echo.
if /i "%dVBopt%" == "1" (
	CScript //h:CScript //s //NoLogo
	exit /b
)
if /i "%dVBopt%" == "2" (
	CScript //h:WScript //s //NoLogo
	exit /b
)
goto defaultVBengine
:: / End Default VB Script Engine Chooser


:: Begin chkdsk scheduler /
:scheduleDiskCheck
set return=scheduleDiskCheck
set yn=
echo.
echo.
echo   This Disk Check can take anywhere from 15-120 minutes dependent
echo   on the size and speed of the hard drive.  For instance, the check 
echo   will take longer on a laptop than a desktop.
echo.
echo.
echo      ENTER. Schedule a Disk Check
echo          C. Cancel a Scheduled Disk Check
echo          Q. Quit - go back to menu.
echo.
echo.
set /p yn=" --> "

if "%yn%" == "-" exit /b
if /i "%yn%" == "Q" exit /b
if /i "%yn%" == "QUIT" exit /b
if /i "%yn%" == "C" goto scheduleDiskCheckCancel
if /i "%yn%" == "CANCEL" goto scheduleDiskCheckCancel
if "%yn%" NEQ "" goto scheduleDiskCheck

call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b
echo.

:scheduleDiskCheck_go
:: Check if disk check is scheduled.  If so, return to menu.  If not, schedule check.
REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" | find "/r \??\C:" >nul
if '%errorlevel%' == '0' (
	echo.
	echo  ***
	echo  *!*  Disk check has already been scheduled.  Returning to menu in 5 seconds...
	echo  ***
	ping 127.0.0.1 /n 6 >nul
	exit /b
)

:: Backup existing key before scheduling diskcheck
for /f "tokens=3*" %%r in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" ^| find "BootExecute"') do (
	REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_autoBak_Execute" /t REG_MULTI_SZ /d "%%r %%s" /f
)

:: Schedule disk check
echo Y| chkdsk /R %systemdrive%
echo.
echo.
echo   Returning to menu in 5 seconds...
ping 127.0.0.1 /n 6 >nul
exit /b

:scheduleDiskCheckCancel
echo.

:: Check if disk check was scheduled.  If not, display and return to menu.  If so, cancel disk check.
REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" | find "/r \??\C:" >nul
if '%errorlevel%' == '1' (
	echo.
	echo  ***
	echo  *!*  No disk check is scheduled.  Returning to menu in 5 seconds ...
	echo  ***
	ping 127.0.0.1 /n 6 >nul
	exit /b
)

:: If diskcheck was scheduled with TST, backup key will exist.  Restore original key.  
:: If scheduled by other means, backup existing key and replace with a key which has safe defaults.
:: \0 for CR
REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_autoBak_Execute" | find "Boot_autoBak_Execute" >nul
if '%errorlevel%' == '0' (
	for /f "tokens=3*" %%r in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_autoBak_Execute" ^| find "Boot_autoBak_Execute"') do (
		REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" /t REG_MULTI_SZ /d "%%r %%s" /f
		)
	reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_autoBak_Execute" /f
	echo.
	echo  ***
	echo  *!*  Disk check cancelled.  Returning to menu in 5 seconds...
	echo  ***
	echo.
	ping 127.0.0.1 /n 6 >nul
	exit /b
) else (
	echo.
	echo  ***
	echo  *!*  Disk check was not scheduled with TST.  Restoring with Safe Defaults.
	echo  ***
	echo.
	ping 127.0.0.1 /n 2 >nul
	for /f "tokens=3*" %%r in ('REG QUERY "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" ^| find "BootExecute"') do (
		REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_bak_Execute" /t REG_MULTI_SZ /d "%%r %%s" /f
		)
	REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "BootExecute" /t REG_MULTI_SZ /d "autocheck autochk *" /f
	reg delete "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager" /v "Boot_autoBak_Execute" /f
	echo.
	echo  ***
	echo  *!*  Disk check cancelled.  Returning to menu in 5 seconds...
	echo  ***
	echo.
	ping 127.0.0.1 /n 6 >nul
	exit /b	
)

echo.
echo  ***
echo  *!*  An unknown error occured.  Returning to menu in 10 seconds...
echo  ***
echo.
ping 127.0.0.1 /n 11 >nul
exit /b
:: / End chkdsk scheduler


:: Begin Reset Print Spooler /
:clrPrntQ
cls
set return=clrPrntQ
set pQopt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo          Reset Print Spooler
echo.
echo.
echo     This action is used to clear "stuck" print jobs.
echo     Or, diagnosing print related issues.
echo.     
echo     Print spooler will be stopped.
echo     Print jobs will be deleted.
echo     Print spooler will be restarted.
echo.
echo     *** NOTE ***
echo       Be sure all print jobs are complete before continuing.
echo       All existing print jobs will be deleted.
echo.     
echo.     
echo     *** PRESS ENTER TO BEGIN ***
echo.     
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p pQopt=Enter Selection --^>  
if "%pQopt%" == "-" exit /b
if /i "%pQopt%" == "M" goto mainMenu
if /i "%pQopt%" == "X" goto theEnd
if "%pQopt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto clrPrntQ)

call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

net stop spooler
del /q %systemroot%\system32\spool\printers\*.*
net start spooler
exit /b
:: / End Reset Print Spooler


:: Begin Windows Management Interface (WMI) Repair /
:wmiFix
cls
set return=wmiFix
set wmiOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo             XP WMI Repair
echo.
echo       This script will attempt to repair the Windows XP  Windows Management
echo       Instrumentation (WMI) system.  This problem is usually indicated by 
echo       pop-ups with errors such as:
echo         "WMI validation FAILED!", "WMI: Generic Failure"   
echo                 OR the more descriptive
echo         ". . . The Windows Management Instrumentation (WMI)
echo          information might be corrupted"
echo.
echo      *** NOTE *** You CANNOT run the repair if you are using
echo                   "RUN AS" on this script.  You must be 
echo                   directly logged on an an administrator.
echo.
echo      *** NOTE *** The script will take a LONG time to run as  
echo                   part of the repair process is to recompile
echo                   some system files.  Run it overnight if possible.
echo.
echo   Y. Start WMI Repair Procedure on XP ONLY
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p wmiOpt=Enter Selection [Y/N] --^>  
if "%wmiOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%wmiOpt%" == "X" goto theEnd

if "%detectedOS%" NEQ "XP" goto wmiFixERROR

if /i "%wmiOpt%" == "Y" goto startWmiFix
if /i "%wmiOpt%" == "YES" goto startWmiFix
if /i "%wmiOpt%" == "N" exit /b
if /i "%wmiOpt%" == "NO" exit /b
if "%wmiOpt%" == "" (
	echo.
	echo !!!  Please Make a Selection Y/N  !!!
	ping 127.0.0.1 /n 4 >nul
)
if "%wmiOpt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto wmiFix)
goto wmiFix
:wmiFixERROR
echo.
echo  !!!-----------------------------------------------------------------------!!!
echo  !!!-----------------------------------------------------------------------!!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!  -------------------------  W A R N I N G  -------------------------  !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                    The WMI Repair function has only                   !!!
echo  !!!                     been tested on Windows XP and                     !!!
echo  !!!                    will NOT run on your OS.  Period.                  !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                         Press ENTER to Continue                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!                                                                       !!!
echo  !!!-----------------------------------------------------------------------!!!
echo  !!!-----------------------------------------------------------------------!!!

pause >nul
exit /b
:startWmiFix
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

net stop winmgmt
127.0.0.1 /n 21 >nul

cd /d %SystemDrive%\windows\system32\wbem
rd /S /Q repository

regsvr32 /s %systemroot%\system32\scecli.dll
regsvr32 /s %systemroot%\system32\userenv.dll

mofcomp cimwin32.mof
mofcomp cimwin32.mfl
mofcomp rsop.mof
mofcomp rsop.mfl

for /f %%s in ('dir /b /s *.dll') do regsvr32 /s %%s
for /f %%s in ('dir /b *.mof') do mofcomp %%s
for /f %%s in ('dir /b *.mfl') do mofcomp %%s

mofcomp exwmi.mof
mofcomp -n:root\cimv2\applications\exchange wbemcons.mof
mofcomp -n:root\cimv2\applications\exchange smtpcons.mof
mofcomp exmgmt.mof
:endWmiFix
echo.
echo.
echo   ***  WMI REPAIR HAS COMPLETED  ***
echo.
echo   Press ENTER to REBOOT your computer
echo.
echo.
pause >nul
shutdown /r /t 0 /c "Restart Post WMI Repair Courtesy of TST"
exit /b
:: / End Windows Management Interface (WMI) Repair


:: Begin Windows Update Repair /
:wuRepair
cls
set return=wuRepair
set wuOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo         Windows Update Repair
echo.
echo.
echo.     
echo     Windows update giving you error codes?
echo     Updates failing for no apparent reason?
echo.
echo     The options below fix two of the most common 
echo     reasons why Windows Update stops working.
echo.     
echo.
echo     Quick Fix, should take a few seconds
echo     Full Repair will take considerably longer [5 min]
echo.
echo.
echo     Q. Quick Fix
echo     F. Full Repair
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.

set /p wuOpt=Enter Selection --^>  
if "%wuOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%wuOpt%" == "X" goto theEnd
if "%wuOpt%" == "" (
	ping 127.0.0.1 /n 2 >nul
	goto wuRepair)
if /i "%wuOpt%" == "Q" goto wuRepairQuick
if /i "%wuOpt%" == "F" goto wuRepairFull
if "%wuOpt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto wuRepair)
goto wuRepair

:wuRepairQuick
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

echo.
echo   *Stopping Windows Update Service
net stop wuauserv
echo   *Clearing Windows Update Cache
rd /s /q "%windir%\SoftwareDistribution"
echo   *Starting Windows Update Service
net start wuauserv
echo.
echo   *** Done ***
ping 127.0.0.1 /n 4 >nul
exit /b

:wuRepairFull
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

echo   *Stopping Windows Update Service
net stop bits
net stop wuauserv

echo   *Clearing Windows Update Cache
rd /s /q "%windir%\SoftwareDistribution"
if "%detectedOS%" == "XP" del "%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\qmgr*.dat"
if "%UAC%" == "true" del "%SystemDrive%\ProgramData\Microsoft\Network\Downloader\qmgr*.dat"

echo   *Backing up key files
ren "%systemroot%\SoftwareDistribution\DataStore" *.bak
ren "%systemroot%\SoftwareDistribution\Download" *.bak
ren "%systemroot%\system32\catroot2" *.bak

echo   *Reset BITS to defaults
sc.exe sdset bits D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)
sc.exe sdset wuauserv D:(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A;;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU

echo   *Unregistering DLLs
regsvr32.exe /u atl.dll
regsvr32.exe /u urlmon.dll
regsvr32.exe /u mshtml.dll
regsvr32.exe /u shdocvw.dll
regsvr32.exe /u browseui.dll
regsvr32.exe /u jscript.dll
regsvr32.exe /u vbscript.dll
regsvr32.exe /u scrrun.dll
regsvr32.exe /u msxml.dll
regsvr32.exe /u msxml3.dll
regsvr32.exe /u msxml6.dll
regsvr32.exe /u actxprxy.dll
regsvr32.exe /u softpub.dll
regsvr32.exe /u wintrust.dll
regsvr32.exe /u dssenh.dll
regsvr32.exe /u rsaenh.dll
regsvr32.exe /u gpkcsp.dll
regsvr32.exe /u sccbase.dll
regsvr32.exe /u slbcsp.dll
regsvr32.exe /u cryptdlg.dll
regsvr32.exe /u oleaut32.dll
regsvr32.exe /u ole32.dll
regsvr32.exe /u shell32.dll
regsvr32.exe /u initpki.dll
regsvr32.exe /u wuapi.dll
regsvr32.exe /u wuaueng.dll
regsvr32.exe /u wuaueng1.dll
regsvr32.exe /u wucltui.dll
regsvr32.exe /u wups.dll
regsvr32.exe /u wups2.dll
regsvr32.exe /u wuweb.dll
regsvr32.exe /u qmgr.dll
regsvr32.exe /u qmgrprxy.dll
regsvr32.exe /u wucltux.dll
regsvr32.exe /u muweb.dll
regsvr32.exe /u wuwebv.dll

echo   *Re-register DLLs
regsvr32.exe atl.dll
regsvr32.exe urlmon.dll
regsvr32.exe mshtml.dll
regsvr32.exe shdocvw.dll
regsvr32.exe browseui.dll
regsvr32.exe jscript.dll
regsvr32.exe vbscript.dll
regsvr32.exe scrrun.dll
regsvr32.exe msxml.dll
regsvr32.exe msxml3.dll
regsvr32.exe msxml6.dll
regsvr32.exe actxprxy.dll
regsvr32.exe softpub.dll
regsvr32.exe wintrust.dll
regsvr32.exe dssenh.dll
regsvr32.exe rsaenh.dll
regsvr32.exe gpkcsp.dll
regsvr32.exe sccbase.dll
regsvr32.exe slbcsp.dll
regsvr32.exe cryptdlg.dll
regsvr32.exe oleaut32.dll
regsvr32.exe ole32.dll
regsvr32.exe shell32.dll
regsvr32.exe initpki.dll
regsvr32.exe wuapi.dll
regsvr32.exe wuaueng.dll
regsvr32.exe wuaueng1.dll
regsvr32.exe wucltui.dll
regsvr32.exe wups.dll
regsvr32.exe wups2.dll
regsvr32.exe wuweb.dll
regsvr32.exe qmgr.dll
regsvr32.exe qmgrprxy.dll
regsvr32.exe wucltux.dll
regsvr32.exe muweb.dll
regsvr32.exe wuwebv.dll

echo   *Starting Windows Update Services
netsh reset winsock
net start bits
net start wuauserv
if "%UAC%" == "true" bitsadmin.exe /reset /allusers
echo.
echo   *** DONE ***
ping 127.0.0.1 /n 4 >nul
exit /b
:: / End Windows Update Repair


:: Start IE Kill Script /
:ieKill
set opt=
echo.
echo.
echo.
echo            ***   IE Process Killer   ***
echo.
echo     This script is designed to Kill all running IE
echo     processes, including zombie iexplore.exe processes
echo.
echo.
echo     Press ENTER to Begin
echo     Press Q to QUIT
echo.

set /p opt=" --> "
if "%opt%" == "-" exit /b
if /i "%opt%" == "Q" exit /b
if /i "%opt%" == "QUIT" exit /b
if /i "%opt%" NEQ "" goto ieKill


:ieKiller
tasklist /FI "IMAGENAME eq iexplore.exe" | find "iexplore.exe" >nul
if '%errorlevel%' == '0' (
	goto ieKillDo
) else (
	goto ieKillNone)

:ieKillDo
echo.
echo      Internet Explorer process^(es^) were detected ... killing.
echo.
:ieKillerDo
taskkill /F /IM iexplore.exe
ping 127.0.0.1 /n 4 >nul

tasklist /FI "IMAGENAME eq iexplore.exe" | find "iexplore.exe" >nul
if '%errorlevel%' == '0' goto ieKillerDo

echo.
echo           All Internet Explorer processes have been killed.
echo.
ping 127.0.0.1 /n 4 >nul
exit /b
	
:ieKillNone
echo.
echo      No Internet Explorer Processes Found.
echo         Exiting ...
echo.
ping 127.0.0.1 /n 3 >nul
exit /b
:: / End IE Kill Script


:: Start IE Fix Script /
:ieFix
set yn=
set return=ieFix
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

echo.
echo  ***  Press ENTER to Begin Reinitialization of IE  ***
echo.
echo       Press Q to QUIT
echo.
echo.
pause >nul

set /p yn= Press ENTER to Begin --^>

if "%yn%" == "-" exit /b
if /i "%yn%" == "Q" exit /b
if /i "%yn%" == "QUIT" exit /b
if "%yn%" NEQ "" goto ieFix

call :ieKiller

echo.
echo.
echo.
echo    * Re-registering IE DLL Files	
regsvr32 comcat.dll /s
regsvr32 CSSEQCHK.DLL /s
regsvr32 shdoc401.dll /s
regsvr32 shdoc401.dll /i /s
regsvr32 asctrls.ocx /s
regsvr32 oleaut32.dll /s
regsvr32 shdocvw.dll /I /s
regsvr32 shdocvw.dll /s
regsvr32 browseui.dll /s
regsvr32 browsewm.dll /s
regsvr32 browseui.dll /I /s
regsvr32 msrating.dll /s
regsvr32 mlang.dll /s
regsvr32 hlink.dll /s
regsvr32 mshtmled.dll /s
regsvr32 urlmon.dll /s
regsvr32 plugin.ocx /s
regsvr32 sendmail.dll /s
regsvr32 scrobj.dll /s
regsvr32 mmefxe.ocx /s
regsvr32 corpol.dll /s
regsvr32 jscript.dll /s
regsvr32 msxml.dll /s
regsvr32 imgutil.dll /s
regsvr32 thumbvw.dll /s
regsvr32 cryptext.dll /s
regsvr32 rsabase.dll /s
regsvr32 inseng.dll /s
regsvr32 iesetup.dll /i /s
regsvr32 cryptdlg.dll /s
regsvr32 actxprxy.dll /s
regsvr32 dispex.dll /s
regsvr32 occache.dll /s
regsvr32 occache.dll /i /s
regsvr32 iepeers.dll /s
regsvr32 urlmon.dll /i /s
regsvr32 cdfview.dll /s
regsvr32 webcheck.dll /s
regsvr32 mobsync.dll /s
regsvr32 pngfilt.dll /s
regsvr32 licmgr10.dll /s
regsvr32 icmfilter.dll /s
regsvr32 hhctrl.ocx /s
regsvr32 inetcfg.dll /s
regsvr32 tdc.ocx /s
regsvr32 MSR2C.DLL /s
regsvr32 msident.dll /s
regsvr32 msieftp.dll /s
regsvr32 xmsconf.ocx /s
regsvr32 ils.dll /s
regsvr32 msoeacct.dll /s
regsvr32 inetcomm.dll /s
regsvr32 msdxm.ocx /s
regsvr32 dxmasf.dll /s
regsvr32 l3codecx.ax /s
regsvr32 acelpdec.ax /s
regsvr32 mpg4ds32.ax /s
regsvr32 voxmsdec.ax /s
regsvr32 danim.dll /s
regsvr32 Daxctle.ocx /s
regsvr32 lmrt.dll /s
regsvr32 datime.dll /s
regsvr32 dxtrans.dll /s
regsvr32 dxtmsft.dll /s
regsvr32 WEBPOST.DLL /s
regsvr32 WPWIZDLL.DLL /s
regsvr32 POSTWPP.DLL /s
regsvr32 CRSWPP.DLL /s
regsvr32 FTPWPP.DLL /s
regsvr32 FPWPP.DLL /s
regsvr32 wshom.ocx /s
regsvr32 wshext.dll /s
regsvr32 vbscript.dll /s
regsvr32 scrrun.dll mstinit.exe /setup /s
regsvr32 msnsspc.dll /SspcCreateSspiReg /s
regsvr32 msapsspc.dll /SspcCreateSspiReg /s
regsvr32 licdll.dll /s
regsvr32 regwizc.dll /s
regsvr32 softpub.dll /s
regsvr32 IEDKCS32.DLL /s
regsvr32 MSTIME.DLL /s
regsvr32 WINTRUST.DLL /s
regsvr32 INITPKI.DLL /s
regsvr32 DSSENH.DLL /s
regsvr32 RSAENH.DLL /s
regsvr32 CRYPTDLG.DLL /s
regsvr32 Gpkcsp.dll /s
regsvr32 Sccbase.dll /s
regsvr32 Slbcsp.dll /s

exit /b
:: / End IE Fix Script


:: Start URL Fix /
:urlFix
set opt=
echo.
echo.
echo.
echo            ***   URL Shortcut Fix   ***
echo.
echo   An issue will sometimes arise where desktop internet shortcuts 
echo   and links in documents and applications will no longer open.  
echo   They act as if they were never clicked.  Script will remove a 
echo   corrupted registry key which will automatically be regenerated 
echo   when needed.
echo.
echo   System RESTART will be required before changes will take effect.
echo.
echo.
echo     Press ENTER to Begin
echo     Press Q to QUIT
echo.

set /p opt=" --> "
if "%opt%" == "-" exit /b
if /i "%opt%" == "Q" exit /b
if /i "%opt%" == "QUIT" exit /b
if /i "%opt%" NEQ "" goto urlFix

echo.
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

::    regsvr32 Shdocvw.dll /s      regsvr32 Mshtml.dll /s
::    regsvr32 Shdoc401.dll /s     regsvr32 Urlmon.dll /s
::    regsvr32 Oleaut32.dll /s     regsvr32 Shell32.dll /s
::    regsvr32 Actxprxy.dll /s

reg delete "HKEY_CLASSES_ROOT\http\shell\open\ddeexec" /f
reg delete "HKEY_CLASSES_ROOT\https\shell\open\ddeexec" /f

:: / End URL Fix


:: Start System Tray Icon Fix /
:systrayFix
set opt=
set return=systrayFix1
echo.
echo.
echo.
echo            ***   Systray Missing Icon Fix   ***
echo.
echo     Occasionally, you will notice that there are blank or 
echo     missing icons in your system tray (noticication bar).
echo     This script is desigend to remedy this problem with a 
echo     simple registry edit.
echo.
echo.
echo     Press ENTER to Begin
echo     Press Q to QUIT
echo.

set /p opt=" --> "

if "%opt%" == "-" exit /b
if /i "%opt%" == "Q" exit /b
if /i "%opt%" == "QUIT" exit /b
if /i "%opt%" NEQ "" goto systrayFix

:systrayFix1
echo.
echo.
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b
REM REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TrayNotify"
REG DELETE "HKEY_CURRENT_USER\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify"
exit /b
:: / End System Tray Icon Fix


:: Start MSI Remove Script /
:msiRemove
set yn=
set return=msiRemove
echo.
echo.
echo.
echo                  ***   Uninstall MSI   ***
echo.
echo     Sometimes a program does not show in the Add/Remove
echo     programs dialog box.  This can be because the install
echo     was aborted or the registry entry was corrupted and it
echo     no longer appears in the dialog.
echo.
echo.

if "%adminCheck%" NEQ "pass" (echo     Press ENTER to Begin)

echo     Press Q to QUIT
echo.

if "%adminCheck%" == "pass" goto msiRemove1

set /p yn= --^> 

if "%yn%" == "-" exit /b
if /i "%yn%" == "Q" exit /b
if /i "%yn%" == "QUIT" exit /b
if /i "%yn%" NEQ "" goto msiRemove

:msiRemove1
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

echo     Enter the path to the MSI 
echo     OR Drag the Icon onto this Window
echo.
echo.

set /p msiPath= Enter Path to MSI --^> 

if "%msiPath%" == "-" exit /b
if /i "%msiPath%" == "Q" exit /b
if /i "%msiPath%" == "QUIT" exit /b
if "%msiPath%" == "" (
	echo.
	echo.
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 4 >nul
	goto msiRemove)

if exist "%msiPath%" (
	set suffix=%msiPath:~-4%
	if /i "%suffix%" == ".MSI" (
		msiexec /x "%msiPath%"
		ping 127.0.0.1 /n 6 >nul
		exit /b
	) else (
		echo.
		echo.
		echo   ***
		echo   *!*  You must choose a .MSI file.
		echo   ***
		echo.
		echo.
		ping 127.0.0.1 /n 6 >nul
		goto msiRemove
	)
) else (
	echo.
	echo.
	echo   ***
	echo   *!*  Path Does Not Exist.
	echo   ***
	echo.
	echo.
	ping 127.0.0.1 /n 6 >nul
	goto msiRemove
)



ping 127.0.0.1 /n 6 >nul

exit /b
:: / End MSI Remove Script


:: Start Clear System Temp Directories /
:clrTemp
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b
for /f "tokens=*" %%i in ('dir /b "C:\Users"') do (
	if exist "C:\Users\%%i %%j\AppData\Local\Temp" del /s /q "C:\Users\%%i %%j\AppData\Local\Temp\*.*"
	if exist "C:\Users\%%i %%j\AppData\Local\Microsoft\Windows\Temporary Internet Files" del /s /q "C:\Users\%%i %%j\AppData\Local\Microsoft\Windows\Temporary Internet Files\*.*"
)
del /s /q "%windir%\Temp\*.*"
exit /b
:: / End Start Clear System Temp Directories 


:: Start Clear Page File on Reboot/
:clrPageFile
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b
for /f "tokens=4*" %%i in ('find "Page File Location" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoPfLoc=%%i %%j
	)
"%~dp0\movefile.exe" "%infoPfLoc%" ""

echo.
"%~dp0\pendmoves.exe" | find "%infoPfLoc%"
ping 127.0.0.1 /n 6 >nul
exit /b
:: Clear Pagefile on Shutdown Key
:: reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "ClearPageFileAtShutdown" /t REG_DWORD /d "1"
:: // Set Page File Key
:: reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "PagingFiles" /t REG_MULTI_SZ /d "C:\pagefile.sys 2048 4096" /f >nul 2>&1
:: / End Clear Page File on Reboot


:: Start Remove Printers/
:removePrinters
setlocal enabledelayedexpansion
for /f "tokens=3*" %%i in ('CScript //NoLogo "%~dp0\printTools.vbs" -l ^| find "Printer name"') do (
	echo.
	echo Printer: %%i %%j
	set dele=
	set /p dele="Delete? Y/N: "
		if /i '!dele!' == 'Y' (
			if '%%j' == '' (
			rundll32 printui.dll,PrintUIEntry /dn /n "%%i" >nul 2>&1
			rundll32 printui.dll,PrintUIEntry /dl /n "%%i" >nul 2>&1
			)
			if '%%j' NEQ '' (
			rundll32 printui.dll,PrintUIEntry /dn /n "%%i %%j" >nul 2>&1
			rundll32 printui.dll,PrintUIEntry /dl /n "%%i %%j" >nul 2>&1
		)	)
)
setlocal disabledelayedexpansion
exit /b
:: / End Remove Printers


:: Start New Script/
:script

exit /b
:: / End New Script


:: Begin Restart/Shutdown Functions /
:restart
shutdown /r /c "Restart Courtesy of Technician's Service Tool"
echo.
echo.
echo  Computer will reboot in 30 seconds...
goto startStopAbort
:restartForce
shutdown /r /t 3 /c "Restart Courtesy of Technician's Service Tool"
echo.
echo.
echo  Computer will reboot in  2 seconds...
goto startStopAbort
:shutdown
shutdown /s /c "Shutdown Courtesy of Technician's Service Tool"
echo.
echo.
echo  Computer will shutdown in 30 seconds...
goto startStopAbort
:shutdownForce
shutdown /s /f /t 3 /c "Shutdown Courtesy of Technician's Service Tool"
echo.
echo.
echo  Computer will shutdown in  2 seconds...

goto startStopAbort
:startStopAbort
echo.
echo     ***  PRESS ENTER TO ABORT  ***
pause >nul
shutdown /a
echo.
echo.
echo     *** RESTART/SHUTDOWN ABORTED ***
echo.
ping 127.0.0.1 /n 6 >nul
exit /b
:: / End Restart/Shutdown Functions


:: Begin Remote Restart/Shutdown Functions /
:remoteStop
cls
set rrsOpt=
echo.
echo   ÄÄ[ Technician's Service Tool ]ÄÄ
echo        Remote Restart/Shutdown
echo.
echo.
echo      *** PRESS ENTER TO BEGIN ***
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.
set /p rrsOpt=Enter Selection --^>  
if "%rrsOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%rrsOpt%" == "X" goto theEnd
if "%rrsOpt%" NEQ "" goto remoteStop
call :assetPicker
if /i "%opt%" == "RR" goto remoteRestart
if /i "%opt%" == "FRR" goto remoteForcedRestart
if /i "%opt%" == "RS" goto remoteShutdown
if /i "%opt%" == "FRS" goto remoteForcedShutdown
:remoteShutdown
shutdown /s /m \\%asset% /c "This workstation has been ordered to shutdown in the next 30 seconds.  Please comply.  -Your Friend, HAL"
echo.
echo.
echo  %asset% will shutdown in 30 seconds...
goto remoteStopABORT
:remoteForcedShutdown
shutdown /s /m \\%asset% /t 2 /c "This workstation has been ordered to shutdown in the 2 seconds.  Please comply.  -Your Friend, HAL"
echo.
echo.
echo  %asset% will shutdown in 2 seconds...
goto remoteStopABORT
:remoteRestart
shutdown /r /m \\%asset% /c "This workstation has been ordered to restart in the next 30 seconds.  Please comply.  -Your Friend, HAL"
echo.
echo.
echo  %asset% will restart in 30 seconds...
goto remoteStopABORT
:remoteForcedRestart
shutdown /r /m \\%asset% /t 2 /c "This workstation has been ordered to restart in 2 seconds.  Please comply.  -Your Friend, HAL"
echo.
echo.
echo  %asset% will shutdown in 2 seconds...
:remoteStopABORT
set rrsOpt=
echo.
echo.
echo  *** PRESS ENTER TO ABORT RESTART/SHUTDOWN ***
echo.
echo.
echo   -. Go Back to Menu
echo   x. Exit Service Tool
echo.
set /p rrsOpt=Enter Selection --^> 
if "%rrsOpt%" == "-" exit /b
if /i "%opt%" == "M" goto mainMenu
if /i "%rrsOpt%" == "X" goto theEnd
shutdown /a /m \\%asset%
echo.
echo.
echo        *** RESTART/SHUTDOWN ABORTED ***
echo.
ping 127.0.0.1 /n 6 >nul
exit /b

:: / End Remote Restart/Shutdown Functions


:: Begin FileType Open With /
:openWith
set ext=
echo.
echo.
echo    Edit what application opens a certain filetype.
echo    Enter the extension of the filetype you want to edit.
echo.
echo   Press Q to CANCEL
echo.
echo.
set /p ext=Enter a file extension: 
if /i "%ext%" == "Q" exit /b
RunDll32 Shell32.dll,OpenAs_RunDLL *.%ext%
echo.
exit /b
:: / End FileType Open With


:: Begin Copy File at next Boot /
:copyOnBoot
set src=
set dst=
echo.
echo.
echo    This process is for when you need to replace/delete an open file.
echo    The file copy/deletion will happen on the next boot.
echo.
echo   Enter Q to Quit
echo.
echo.
set /p src=Enter path of source file: 
if /i "%src%" == "Q" exit /b
if not exist "%src%" (
	echo  !!!  FILE NOT EXIST  !!!
	goto copyOnBoot)
set /p dst=Enter path to destination.  Leave blank to DELETE: 
"%sysTools%\movefile.exe" "%src%" "%dst%"
echo.
"%sysTools%\pendmoves.exe" | find "%infoPfLoc%"
echo.
pause
exit /b
:: / End Copy File at next Boot


:: Begin Create Filesystem Junction /
:createJunction
set lName=
set src=
echo.
echo.
echo    This process will create a NTFS Junction.
echo.
echo    A junction is a special type of link which acts like a real folder
echo    yet acts on the linked folder instead.  
echo    To the user/system, it is a regular folder.
echo.
echo   Enter Q to Quit
echo.
echo.
set /p lName=Enter link location: 
if /i "%lName%" == "Q" exit /b
set /p src=Enter link source: 
if not exist "%src%" (
	echo  !!!  FILE NOT EXIST  !!!
	goto createJunction)
"%sysTools%\junction.exe" "%lName%" "%src%"
echo.
if not exist "%lName%" (
	echo   !!!  Junction creation failed  !!!
	goto createJunction)
echo.
pause
exit /b
:: / End Create Filesystem Junction


:: Begin List Local Admins /
:localAdmins
echo.
echo.
net localgroup Administrators
echo.
pause
exit /b

:: Begin Add User to Local Admin Group /
:addUsrLadmin
set usr=
set return=addUsrLadmin
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b
:: call :usrPicker
echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

net localgroup Administrators /add %usr%
if "%ERRORLEVEL%" == "0" (
	echo  *** User %usr% had been successfully
	echo  *** added to the Administrators group.)
if "%ERRORLEVEL%" NEQ "0" (
	echo  *** An ERROR has occured in adding %usr%
	echo  *** to the Administrators group.)
ping 127.0.0.1 /n 4 >nul
exit /b
:: / End Add User to Local Admin Group.


:: Begin Add User to Local Admin Group on Remote PC /
:addUsrLadminRemote
set usr=
call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b

echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

set groupname=Administrators
set addRemove=add
call :createUsrAdminBAT
exit /b
:: / End Add User to Local Admin Group on Remote PC


:: Begin Remove User from Local Admin Group /
:rmUsrLadmin
set usr=
set return=rmUsrLadmin
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

:: call :usrPicker
echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

net localgroup Administrators /delete %usr%
if "%ERRORLEVEL%" == "0" (
	echo  User %usr% had been successfully 
	echo  removed from the Administrators group.)
if "%ERRORLEVEL%" NEQ "0" (
	echo  *** An ERROR has occured in removing %usr% 
	echo  *** from the Administrators group.
	echo.)
if "%ERRORLEVEL%" == "2" (
	echo  *** User was not removed.  User %usr% 
	echo  *** was not in the Administrators group.)
ping 127.0.0.1 /n 4 >nul
exit /b
:: / End Remove User from Local Admin Group


:: Begin Remove User to Local Admin Group on Remote PC /
:rmUsrLadminRemote
set usr=
call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b

echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

set groupname=Administrators
set addRemove=delete
call :createUsrAdminBAT
exit /b
:: / End Remove User to Local Admin Group on Remote PC


:: Begin Add User to Remote Desktop Group /
:addUsrRDP
set usr=
set return=addUsrRDP
call :needAdmin
if "%adminCheck%" NEQ "pass" exit /b

::call :usrPicker
echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

net localgroup "Remote Desktop Users" /add %usr%
echo.
if "%ERRORLEVEL%" == "0" (
	echo  *** User %usr% had been successfully 
	echo  *** added to the Remote Desktop Users group.)
if "%ERRORLEVEL%" NEQ "0" (
	echo  *** An ERROR has occured in adding %usr%
	echo  *** to the Remote Desktop Users group.)
ping 127.0.0.1 /n 4 >nul
exit /b
:: / End Add User to Remote Desktop Group


:: Begin Add User to Remote Desktop Users Group on Remote PC /
:addUsrRDPremote
set usr=
call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b

echo.
echo   * Enter Domain\Username
echo       (Type Q to Quit)
echo.

set /p usr= Enter domain\username: 
if /i "%usr%" == "Q" exit /b
if /i "%usr%" == "QUIT" exit /b

set groupname=Remote Desktop Users
set addRemove=add
call :createUsrAdminBAT
exit /b
:: / End Add User to Remote Desktop Users Group on Remote PC


:: Begin Remote User Management GUI /
:rUsrManage
call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b
start "" lusrmgr.msc /computer=\\%asset%
ping 127.0.0.1 /n 2 >nul
exit /b
:: / End Remote User Management GUI


:: Begin Remote Computer Management /
:rManage
call :assetPicker
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b
start "" compmgmt.msc /computer=\\%asset%
ping 127.0.0.1 /n 2 >nul
exit /b
:: / End Remote Computer Management



:createUsrAdminBAT
if exist "%temp%\tmp.bat" del "%temp%\tmp.bat"
type nul > "%temp%\tmp.bat"

echo @echo off >> "%temp%\tmp.bat"
echo net localgroup "%groupname%" "%usr%" /%addRemove% >> "%temp%\tmp.bat"
echo if ERRORLEVEL 2 ^( >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo									echo  ***** >> "%temp%\tmp.bat"
if "%addRemove%" == "delete" 	(echo 	echo  * ! *  User was not removed. >> "%temp%\tmp.bat"
								echo 	echo  * ! *  User %usr% was not in the %groupname% group. >> "%temp%\tmp.bat")
if "%addRemove%" ==    "add" 	(echo	echo  * ! *  User was not added. >> "%temp%\tmp.bat"
								echo 	echo  * ! *  User %usr% was already in the %groupname% group. >> "%temp%\tmp.bat")
echo									echo  ***** >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo	pause >> "%temp%\tmp.bat"
echo ^) ELSE ^(>> "%temp%\tmp.bat"
echo if ERRORLEVEL 0 ^( >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo								echo  ***** >> "%temp%\tmp.bat"
echo 								echo  * ! *  User %usr% had been successfully >> "%temp%\tmp.bat"
if "%addRemove%" == "delete" echo 	echo  * ! *  removed from the %groupname% group. >> "%temp%\tmp.bat"
if "%addRemove%" ==    "add" echo	echo  * ! *  added to the %groupname% group. >> "%temp%\tmp.bat"
echo								echo  ***** >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo	pause >> "%temp%\tmp.bat"
echo ^) ELSE ^( >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo									echo  ***** >> "%temp%\tmp.bat"
if "%addRemove%" == "delete" 	(echo 	echo  * ! *  An ERROR has occured in removing %usr% >> "%temp%\tmp.bat"
								echo 	echo  * ! *  from the %groupname% group. >> "%temp%\tmp.bat")
if "%addRemove%" ==    "add" 	(echo 	echo  * ! *  An ERROR has occured in adding %usr% >> "%temp%\tmp.bat"
								echo 	echo  * ! *  to the %groupname% group. >> "%temp%\tmp.bat")
								echo	echo  ***** >> "%temp%\tmp.bat"
echo 	echo. >> "%temp%\tmp.bat"
echo	pause ^) >> "%temp%\tmp.bat"
echo ^) >> "%temp%\tmp.bat"

"%psexecexe%" \\%asset% -c "%temp%\tmp.bat"
::"%psexecexe%" \\%asset% -u %userdomain%\%username% -c "%temp%\tmp.bat"

del "%temp%\tmp.bat" /q
if exist "\\%asset%\c$\windows\system32\tmp.bat" del "\\%asset%\c$\windows\system32\tmp.bat" /q
title %title%
exit /b



:::::::::::::::::::
:: // Actions // ::
:: Begin Need Admin? /
:admin
set return=mainMenu
call :needAdmin
exit /b
:needAdmin
if "%adminCheck%" == "pass" exit /b
if "%adminCheck%" NEQ "pass" call :adminCheck
if "%adminCheck%" == "fail" exit /b
if "%adminCheck%" NEQ "pass" (
	echo !!! No Admin Rights Detected.  Returning to Menu !!!
	ping 127.0.0.1 /n 3 >nul)
if "%detectedOS%" == "XP" if "%adminCheck%" == "pass" title Administrator:%title%
exit /b
:: / End Need Admin?


:: Begin Asset Picker /
:assetPicker
set asset=
echo.
echo.
echo  Enter Name/IP of target device
echo        Enter Q to Quit
echo.
echo.
set /p asset=Computer Name/IP -- ^> 
if /i "%asset%" == "Q" exit /b
if /i "%asset%" == "QUIT" exit /b
ping %asset% /n 2 >nul
if "%ERRORLEVEL%" NEQ "0" (
	echo  *** Computer does not exist or is not online ***
	ping 127.0.0.1 /n 4 >nul 
	goto assetPicker)
exit /b
:: / End Asset Picker


:: Begin User Picker /
:remoteUserPicker

:usrPicker
set usr=
if "%UAC%" == "true" goto usrPickerW7
if "%detectedOS%" == "XP" goto usrPickerXP
:usrPickerW7
set usr=
echo.
echo    *Available Users
echo         (Type Q to Quit)
echo.
dir /b "%SystemDrive%\Users"
echo.
set /p usr=*Enter USERNAME: 
if /i "%usr%" == "Q" exit /b
if not exist "%SystemDrive%\Users\%usr%" call :userNotExist
if "%usr%" == "" goto usrPicker
echo        *User has been set to %usr%
ping 127.0.0.1 /n 3 >nul
exit /b

:usrPickerXP
set usr=
echo.
echo    *Available Users
echo         (Type Q to Quit)
echo.
dir /b "%SystemDrive%\Documents and Settings"
echo.
set /p usr=*Enter USERNAME: 
if /i "%usr%" == "Q" exit /b
if not exist "%SystemDrive%\Documents and Settings\%usr%" call :userNotExist
if "%usr%" == "" goto usrPicker
echo        *User has been set to %usr%
ping 127.0.0.1 /n 3 >nul
exit /b
:: / End User Picker

:godMode
if not exist "%~dp0\MasterControl.{ED7BA470-8E54-465E-825C-99712043E01C}" mkdir "%~dp0\MasterControl.{ED7BA470-8E54-465E-825C-99712043E01C}"
if exist "%~dp0\MasterControl.{ED7BA470-8E54-465E-825C-99712043E01C}" start "" "%~dp0\MasterControl.{ED7BA470-8E54-465E-825C-99712043E01C}"
:: explorer.exe shell:::{21ec2020-3aea-1069-a2dd-08002b30309d}
exit /b

:superMode
%windir%\explorer.exe shell:::{F90C627B-7280-45db-BC26-CCE7BDD620A4}
exit /b


:: Internet Explorer Specific Commands /
:ieCleanupTempFiles
:: Delete Temporary Internet Files:
echo   Deleting Temporary Internet Files
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupCookies
:: Delete Cookies:
echo   Deleting Cookies
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 2
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupHistory
:: Delete History:
echo   Deleting Browsing History
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 1
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupFormData
:: Delete Form Data:
echo   Deleting Internet Explorer Form Data
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 16
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupPasswords
:: Delete Passwords:
echo   Deleting Saved Passwords
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 32
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupAll
:: Delete All:
echo   Deleting: Cookies, History, Saved Passwords, Form Data, and Temporary Internet Files
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 255
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:ieCleanupReallyAll
:: Delete All + files and settings stored by Add-ons:
echo   Deleting: Cookies, History, Saved Passwords, Form Data, Add-on Caches, and Temporary Internet Files
start "" RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 4351
echo      Done.
ping 127.0.0.1 /n 3 >nul
exit /b
:: / Internet Explorer Specific Commands






::::::::::::::::::::::::::
:: // Error Messages // ::
:invalidOS
set goOn=
cls
echo.
echo.
echo.
echo         !!!---------------------------------------------------------!!!
echo         !!!                                                         !!!
echo         !!!  ------------------  W A R N I N G  ------------------  !!!
echo         !!!                                                         !!!
echo         !!!             Some features of the program are            !!!
echo         !!!              NOT compatible with Windows XP             !!!
echo         !!!                                                         !!!
echo         !!!           Press ENTER to Continue or Q to quit          !!!
echo         !!!                                                         !!!
echo         !!!---------------------------------------------------------!!!
echo.
echo.
echo.
set /p goOn=
if /i "%goOn%" == "QUIT" goto theEnd
if /i "%goOn%" == "Q" goto theEnd
if "%goOn%" == "" exit /b
echo.
echo  Please enter either QUIT or just press ENTER
echo.
goto invalidOS

:userNotExist
echo.
echo.
echo   *** %usr% does not exist on this system.  ***
echo   ***         Please try again.             ***
echo.
ping 127.0.0.1 /n 4 >nul
exit /b

:: Begin OS Detect Fail Remedy
:detectOsFail
set dOS=
echo.
echo.
echo  !!!----------------------------------------!!!
echo  !!!         -- OS Detect Failed --         !!!
echo  !!!     Please Enter OS Version Below      !!!
echo  !!!----------------------------------------!!!
echo.
echo.
set /p dOS=Enter XP, W7 or W8 :  

if /i "%dOS%" == "XP" (
	set detectedOS=XP
	set UAC=false
	exit /b)
if /i "%dOS%" == "W7" (
	set detectedOS=W7
	set UAC=true
	exit /b)
if /i "%dOS%" == "W8" (
	set detectedOS=W8
	set UAC=true
	exit /b)
echo.
echo.
echo   !!!   Please only enter XP, W7, or W8   !!!
ping 127.0.0.1 /n 4 >nul
goto detectOsFail
:: / End OS Detect Fail Remedy

:: // Error Messages // ::
::::::::::::::::::::::::::



::::::::::::::::::::::::::::::
:: // DETECTION ROUTINES // ::

:: Start ScanPST Detection /
:pstApplet
echo.
echo  *** Please specify Outlook version as shown ***
echo.
echo   For Outlook 2003 enter:  2003
echo   For Outlook 2007 enter:  2007
echo   For Outlook 2010 enter:  2010
echo.
echo         Enter Q to QUIT
echo.
	
set /p olkVer= Enter Outlook Version --^> 

if /i "%olkVer%" == "Q" exit /b
if /i "%olkVer%" == "QUIT" exit /b

if "%olkVer%" == "2003" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office11\scanpst.exe" (
		start "" "%ProgramFiles(x86)%\Microsoft Office\Office11\scanpst.exe"
		) else (
		call :noPstApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office11\scanpst.exe" (
		start "" "%ProgramFiles%\Microsoft Office\Office11\scanpst.exe"
		) else (
		call :noPstApplet)
	)
)
if "%olkVer%" == "2007" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office12\scanpst.exe" (
		start "" "%ProgramFiles(x86)%\Microsoft Office\Office12\scanpst.exe"
		) else (
		call :noPstApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office12\scanpst.exe" (
		start "" "%ProgramFiles%\Microsoft Office\Office12\scanpst.exe"
		) else (
		call :noPstApplet)
	)
)
if "%olkVer%" == "2010" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office14\scanpst.exe" (
		start "" "%ProgramFiles(x86)%\Microsoft Office\Office14\scanpst.exe")
		if exist "%ProgramFiles%\Microsoft Office\Office14\scanpst.exe" (
		start "" "%ProgramFiles%\Microsoft Office\Office14\scanpst.exe")
		if not exist "%ProgramFiles(x86)%\Microsoft Office\Office14\scanpst.exe" if not exist "%ProgramFiles%\Microsoft Office\Office14\scanpst.exe" (
		call :noPstApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office14\scanpst.exe" (
		start "" "%ProgramFiles%\Microsoft Office\Office14\scanpst.exe"
		) else (
		call :noPstApplet)
	)
)
exit /b

:noPstApplet
echo.
echo       *** APPLET DOES NOT EXIST ON THIS MACHINE ***
ping 127.0.0.1 /n 3 >nul
exit /b
:: / End ScanPST Detection

:: Start Mail Applet Detection /
:mailApplet
echo.
echo  *** Please specify Outlook version as shown ***
echo.
echo   For Outlook 2003 enter:  2003
echo   For Outlook 2007 enter:  2007
echo   For Outlook 2010 enter:  2010
echo.
echo         Enter Q to QUIT
echo.
	
set /p olkVer= Enter Outlook Version --^> 

if /i "%olkVer%" == "Q" exit /b
if /i "%olkVer%" == "QUIT" exit /b
	
if "%olkVer%" == "2003" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office11\mlcfg32.cpl" (
		start "" control "%ProgramFiles(x86)%\Microsoft Office\Office11\mlcfg32.cpl"
		) else (
		call :noMailApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office11\mlcfg32.cpl" (
		start "" control "%ProgramFiles%\Microsoft Office\Office11\mlcfg32.cpl"
		) else (
		call :noMailApplet)
	)
)
if "%olkVer%" == "2007" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office12\mlcfg32.cpl" (
		start "" control "%ProgramFiles(x86)%\Microsoft Office\Office12\mlcfg32.cpl"
		) else (
		call :noMailApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office12\mlcfg32.cpl" (
		start "" control "%ProgramFiles%\Microsoft Office\Office12\mlcfg32.cpl"
		) else (
		call :noMailApplet)
	)
)
if "%olkVer%" == "2010" (
	if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
		if exist "%ProgramFiles(x86)%\Microsoft Office\Office14\mlcfg32.cpl" (
		start "" control "%ProgramFiles(x86)%\Microsoft Office\Office14\mlcfg32.cpl")
		if exist "%ProgramFiles%\Microsoft Office\Office14\mlcfg32.cpl" (
		start "" control "%ProgramFiles%\Microsoft Office\Office14\mlcfg32.cpl")
		if not exist "%ProgramFiles(x86)%\Microsoft Office\Office14\mlcfg32.cpl" if not exist "%ProgramFiles%\Microsoft Office\Office14\mlcfg32.cpl" (
		call :noMailApplet)
	)
	if "%PROCESSOR_ARCHITECTURE%" == "x86" (
		if exist "%ProgramFiles%\Microsoft Office\Office14\mlcfg32.cpl" (
		start "" control "%ProgramFiles%\Microsoft Office\Office14\mlcfg32.cpl"
		) else (
		call :noMailApplet)
	)
)
exit /b

:noMailApplet
echo.
echo       *** APPLET DOES NOT EXIST ON THIS MACHINE ***
ping 127.0.0.1 /n 3 >nul
exit /b
:: / End Mail Applet Detection


:: Start System Information Gatherer /
:sysinfoGather
if exist "C:\Temp\sysinfo_%computername%.txt" del "C:\Temp\sysinfo_%computername%.txt" /q
systeminfo > "C:\Temp\sysinfo_%computername%.txt"
REM if exist "C:\Temp\msinfo.txt" del "C:\Temp\msinfo.txt" /q
REM msinfo32 /report "C:\Temp\msinfo.txt"

if "%opt%" == "1" (
	echo.
	echo.
	type "C:\Temp\sysinfo_%computername%.txt"
	pause
	if exist "C:\Temp\sysinfo_%computername%.txt" del "C:\Temp\sysinfo_%computername%.txt" /q
	exit /b
	)

:: OS Name
for /f "tokens=2 delims==" %%i in ('wmic os get Caption /format:list ^| find "Caption"') do (
	set infoOsName=%%i
	)
for /f "tokens=2 delims==" %%i in ('wmic os get OSArchitecture /format:list ^| find "OSArchitecture"') do (
	set infoOsArch=%%i
	)
for /f "tokens=2 delims==" %%i in ('wmic os get ServicePackMajorVersion /format:list ^| find "ServicePackMajorVersion"') do (
	set infoOsSp=%%i
	)

:: CPU Info
for /f "tokens=2 delims==" %%i in ('wmic computersystem get NumberOfProcessors /format:list ^| find "NumberOfProcessors"') do (
	set infoCpuProcCount=%%i
	)
for /f "tokens=2 delims==" %%i in ('wmic cpu get NumberOfLogicalProcessors /format:list ^| find "NumberOfLogicalProcessors"') do (
	set infoCpuCoreCount=%%i
	)
for /f "tokens=2 delims==" %%i in ('wmic cpu get CurrentClockSpeed /format:list ^| find "CurrentClockSpeed"') do (
	set infoCpuSpeed=%%i
	set /a "beforeCpuSpeed=%%i / 1000"
	set /a "afterCpuSpeed=%%i %% 1000"
	)
set infoCpuSpeedGZ=%beforeCpuSpeed%.%afterCpuSpeed%
for /f "tokens=2 delims==" %%i in ('wmic cpu get Name /format:list ^| find "Name"') do (
	set infoCpuName=%%i
	)

:: OS Install Time
for /f "tokens=4*" %%i in ('find "Original Install Date" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoFirstBoot=%%i %%j
	)

:: Last Boot Time
for /f "tokens=4*" %%i in ('find "System Boot Time" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoLastBoot=%%i %%j
	)

:: System Manufacturer
for /f "tokens=3*" %%i in ('find "System Manufacturer" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoSysMfg=%%i %%j
	)
for /f "tokens=3*" %%i in ('find "System Model" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoSysModel=%%i %%j
	)	

:: Page File
for /f "tokens=2 delims==" %%i in ('wmic pagefile get AllocatedBaseSize /format:list ^| find "AllocatedBaseSize"') do (
	set infoPfSize=%%i
	)
for /f "tokens=4*" %%i in ('find "Page File Location" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoPfLoc=%%i %%j
	)	

:: IP address
for /f "tokens=2 delims=:^(" %%i in ('ipconfig /all ^| find "IPv4 Address"') do (
	set infoIP=%%i
	)
for /f "tokens=2*" %%i in ('find "Domain:" "C:\Temp\sysinfo_%computername%.txt"') do (
	set domain=%%i %%j
	)
	
:: Total Physical Memory
set infoMemTotal=
for /f "tokens=4" %%i in ('find "Total Physical Memory" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoMemTotal=%%i
	)
	
:: Available Physical Memory
set infoMemAvail=
for /f "tokens=4" %%i in ('find "Available Physical Memory" "C:\Temp\sysinfo_%computername%.txt"') do (
	set infoMemAvail=%%i
	)

if exist "C:\Temp\sysinfo_%computername%.txt" del "C:\Temp\sysinfo_%computername%.txt" /q
REM if exist "C:\Temp\msinfo.txt" del "C:\Temp\msinfo.txt" /q

exit /b
:: / End System Information Gatherer


:javaManage
set opt=
call :javaChk
echo.
echo.
echo   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[ Java Applets ] ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
echo.
echo       Installed Versions        32 BIT         64 BIT    
echo                   Java 6   1. %j632ver%    3. %j664ver%
echo                   Java 7   2. %j732ver%    4. %j764ver%
echo.
echo.
echo           If Java is installed and no version is being shown, 
echo           Press ENTER to Refresh
echo.
echo.
echo   -. Go back
echo   x. Exit Service Tool
echo.

set /p opt=Select Java Version to Manage --^> 

if "%opt%" == "-" goto controlPanel
if /i "%opt%" == "M" goto mainMenu
if /i "%opt%" == "X" goto theEnd

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
	if "%opt%" == "1" (
		if exist "%ProgramFiles%\Java\jre6\bin\javacpl.exe" (
			start "" "%ProgramFiles%\Java\jre6\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	if "%opt%" == "2" (
		if exist "%ProgramFiles%\Java\jre7\bin\javacpl.exe" (
			start "" "%ProgramFiles%\Java\jre7\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	if "%opt%" == "3" goto javaNotInstalled
	if "%opt%" == "4" goto javaNotInstalled
)
	
if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
	if "%opt%" == "1" (
		if exist "%ProgramFiles(x86)%\Java\jre6\bin\javacpl.exe" (
			start "" "%ProgramFiles(x86)%\Java\jre6\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	if "%opt%" == "2" (
		if exist "%ProgramFiles(x86)%\Java\jre7\bin\javacpl.exe" (
			start "" "%ProgramFiles(x86)%\Java\jre7\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	if "%opt%" == "3" (
		if exist "%ProgramFiles%\Java\jre6\bin\javacpl.exe" (
			start "" "%ProgramFiles%\Java\jre6\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	if "%opt%" == "4" (
		if exist "%ProgramFiles%\Java\jre7\bin\javacpl.exe" (
			start "" "%ProgramFiles%\Java\jre7\bin\javacpl.exe"
		) else (
			goto javaNotInstalled))
	)

if "%opt%" NEQ "" (
	ping 127.0.0.1 /n 2 >nul
	goto controlPanel
	) else (
	echo  !!!  Please Make a Selection  !!!
	ping 127.0.0.1 /n 3 >nul
	goto javaManage
)

:javaNotInstalled
echo.
echo.
echo   This version is not installed.
echo.
echo.
ping 127.0.0.1 /n 4 >nul
goto javaManage

:: Begin Java Version Checks /
:javaChk

:: Check which versions of Java 6 are installed
:java6cp
set j632ver=        
set j664ver=        

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
	if exist "%ProgramFiles%\Java\jre6\lib\i386\jvm.cfg" (set j632=yes) else (set j632=no)
	set j664=no
	if "%j632%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment" /v "Java6FamilyVersion" ^| find "1.6."') do (
			set j632ver=%%i)
	)
)

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
	if exist "%ProgramFiles%\Java\jre6\lib\amd64\jvm.cfg" (set j664=yes) else (set j664=no)
	if exist "%ProgramFiles(x86)%\Java\jre6\lib\i386\jvm.cfg" (set j632=yes) else (set j632=no)
	if "%j632%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment" /v "Java6FamilyVersion" ^| find "1.6."') do (
			j632ver=%%i)
	)
	if "%j664%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment" /v "Java6FamilyVersion" ^| find "1.6."') do (
			j664ver=%%i)
	)
)


:: Check which versions of Java 7 are installed
:java7cp
set j732ver=        
set j764ver=        

if "%PROCESSOR_ARCHITECTURE%" == "x86" (
	if exist "%ProgramFiles%\Java\jre7\lib\i386\jvm.cfg" (set j732=yes) else (set j732=no)
	set j764=no
	if "%j732%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment" /v "Java7FamilyVersion" ^| find "1.7."') do (
			set j732ver=%%i)
	)
)

if "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
	if exist "%ProgramFiles%\Java\jre7\lib\amd64\jvm.cfg" (set j764=yes) else (set j764=no)
	if exist "%ProgramFiles(x86)%\Java\jre7\lib\i386\jvm.cfg" (set j732=yes) else (set j732=no)
	if "%j732%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\JavaSoft\Java Runtime Environment" /v "Java7FamilyVersion" ^| find "1.7."') do (
			set j732ver=%%i)
	)
	if "%j764%" == "yes" (
		for /f "tokens=3" %%i in ('reg query "HKEY_LOCAL_MACHINE\SOFTWARE\JavaSoft\Java Runtime Environment" /v "Java7FamilyVersion" ^| find "1.7."') do (
			set j764ver=%%i)
	)
)
ping 127.0.0.1 /n 2 >nul
exit /b
:: / End Java Version Checks


:: Start Detect Script OS // ::
:detectOS
VER | FINDSTR /IL "5.0" > NUL
IF '%ERRORLEVEL%' == '0' SET detectedOS=XP
VER | FINDSTR /IL "5.1." > NUL
IF '%ERRORLEVEL%' == '0' SET detectedOS=XP
VER | FINDSTR /IL "5.2." > NUL
IF '%ERRORLEVEL%' == '0' SET detectedOS=XP
if "%detectedOS%" == "XP" (
	echo  Detected Operating System
	echo   * Windows XP 
	set UAC=false)
VER | FINDSTR /IL "6.0." > NUL
IF '%ERRORLEVEL%' == '0' (
	SET detectedOS=W7
	set UAC=true
	echo  Detected Operating System
	echo   * Windows 7 )
VER | FINDSTR /IL "6.1." > NUL
IF '%ERRORLEVEL%' == '0' (
	SET detectedOS=W7
	set UAC=true
	echo  Detected Operating System
	echo   * Windows 7 )
VER | FINDSTR /IL "6.2." > NUL
IF '%ERRORLEVEL%' == '0' (
	SET detectedOS=W8
	set UAC=true
	echo  Detected Operating System
	echo   * Windows 8 )
if "%detectedOS%" == "" call :detectOsFail
REM if /i "%1" == "admin" call :admin
REM if /i "%1" == "install" call :install
if "%detectedOS%" NEQ "W8" if "%detectedOS%" NEQ "W7" if "%detectedOS%" NEQ "XP" (
	echo  Detected Operating System
	echo   * Detection Failed!
	echo  pause
)
exit /b
:: / End Detect Script OS


:: Begin Admin Check /
:adminCheck
echo.
echo  Admin Check
net session >nul 2>&1
if %ERRORLEVEL% EQU 0 (
	if "%adminCheck%" == "init" (
		set adminCheck=pass
		echo   * Passed
		exit /b
	)
	set adminCheck=pass
	echo   * Passed
	exit /b
) else (
	if "%adminCheck%" == "init" (
		set adminCheck=fail
		echo   * Failed
		exit /b)
	if "%UAC%" == "true" (
		echo     -Failed ... Initiaiting UAC Prompt
		echo.
		echo   *** Script will open a new window with admin rights ***
		ping 127.0.0.1 /n 3 >nul
			if exist "%temp%\tstGetAdmin.vbs" del "%temp%\tstGetAdmin.vbs"
			echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\tstGetAdmin.vbs"
			echo UAC.ShellExecute "%~s0", "%return%", "", "runas", 1 >> "%temp%\tstGetAdmin.vbs"
		CScript //NoLogo "%temp%\tstGetAdmin.vbs"
		exit /b
	) else (
		set adminCheck=fail
		echo     -Failed ... Initiating Script as Admin
		echo.
		set /p usr=Admin domain\username: 
		runas /user:%usr% "%~s0"
		exit /b
	)
)
exit /b
:: / End Admin Check

:: // DETECTION ROUTINES // ::
::::::::::::::::::::::::::::::



:::::::::::::::::::::::::::::::::::::
:: // APPLICATION INITILIZATION // ::
:initilization
:::::::::::::::::::::::::::::::::::::::::
::  \/ \/ Set install Directory \/ \/  ::
set installDir=C:\Temp
if /i "%~dp0" == "%installDir%\" set installed=yes
if /i "%~dp0" == "%installDir%" set installed=yes


if not exist "%installDir%\sysinternals\readme.txt" (
	set sysToolsChk=no
) else (
	set sysTools=%installDir%\sysinternals
	set sysToolsChk=yes
)

if "%sysToolsChk%" NEQ "" (
	echo  Sysinternals Check
	echo  %sysTools%
	if "%sysToolsChk%" == "yes" echo   * Confirmed Path
	if "%sysToolsChk%" == "no" echo   * Sysinternals Tools Not Found
)

if exist "%~dp0psexec.exe" (
	set psChk=yes
	set psexecexe=%~dp0psexec.exe
) else (
	if "%sysToolsChk%" == "yes" (
		if exist "%sysTools%\psexec.exe" (
			set psexecexe=%sysTools%\psexec.exe)))
echo.
call :detectOS
goto init_done
:: // APPLICATION INITILIZATION // ::
:::::::::::::::::::::::::::::::::::::





::::::::::::::::::::::::::::
:: // EXIT APPLICATION // ::
:theEnd
echo.
echo  Goodbye.
ping 127.0.0.1 /n 2 >nul
title %comspec%
if /i "%keepDisplay%" == "N" color
endlocal
exit /b





:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: // Technician's Service Tool (TST)
:: // by Sivart Nedlaw
:: // sivartnedlaw@gmail.com
::
::
::  Change Log
::   2012-06-13 - List of commands, basic menus, non-functional (0.1.0)
::   2012-06-15 - Shell Folders and IE Menus are complete and functional (0.2.0)
::              - Added Windows 7 "God Mode" (0.3.0)
::   2012-06-19 - Added Shutdown/Restart Options (0.4.0)
::              - UI Improvements (0.5.0)
::              - Started work on System Dialogs (0.5.1)
::   2012-06-20 - Implemented the rest of the RunDll32 calls (0.6.0)
::              - Implemented system utilities (0.6.0)
::              - Implemented sysinternals (0.6.0)
::              - Name Change to Technician's Service Tool (0.7.0)
::   2012-06-21 - Menu formatting changes (0.7.1)
::              - Added regedit (0.8.0)
::   2012-09-13 - Replaced sleep.exe with native routine (0.9.0)
::   2012-09-21 - Added Environment Variables to Dialog box list (0.9.1)
::              - Opened up script to XP users after displaying a functionality warning (0.9.1)
::              - Added New OS Detection method (0.9.2)
::              - Added Sysinternals path checking (0.9.2)
::   2012-09-24 - Implemented scripted actions as sub-routines (0.10.0)
::              - Removed set back= action rendered unused by new sub-routine method (0.10.0)
::   2012-09-25 - Added File Extension "open with" dialog box (0.11.0)
::              - Added Internet Properties Dialog box (0.11.0)
::              - Added Organize Favorites to IE Cleanup options (0.11.0)
::              - Menu option clarifications (0.11.0)
::              - Added Taskbar/Start Menu Dialog (0.11.1)
::              - Menu spacing fixes after additions (0.11.1)
::              - Set Common menu commands to always be in the same place (0.11.1)
::              - Changed all RunDll32 commands to not wait for completion before TST responds again (0.11.2)
::              - Added Scripted Actions section bringing together many of my other standalone scripts (0.12.0)
::                   Frist up, Outlook Cache Cleaner (0.12.0)
::                   Remote Restart/Shutdown (0.12.1)
::                   Console on Remote PC (0.12.2)
::              - Added option to Dump to command line (0.12.2)
::   2012-09-26 - Added On Demand Admin Check (0.13.0)
::              - Added OS Detection Fallback (0.13.0)
::              - Added more scripted actions (0.13.0)
::                   Reveal Hidden Hardware (0.13.0)
::                   Script Engine Chooser (0.14.0)
::                   Windows Management Interface (WMI) Fix (0.14.0)
::                   Reset Print Spooler (0.14.0)
::              - Admin elevation on W7 now jumps right back to spcific screen instead of beginning of script (0.14.1)
::   2012-09-27 - Admin elevation process tweak, better code reusage (0.14.2)
::              - Added another scripted action, Windows Update Repair (0.15.0)
::              - Fixed bug in Remote Console config (0.15.1)
::   2012-09-28 - Added centralized user picker routine (0.16.0)
::              - Added some console based user management tasks (0.16.0)
::                   Add/Remove User to/from Administrators group on Local/Remote PC(0.16.0)
::                   Add user to Remote Desktop Users group on Local/Remote PC (0.16.0)
::              - User management tweaks and bug fixes, add usr to local admin would ask for username even without admin rights (0.16.1)
::              - Redid some main menu options for a cleaner look. (0.16.2)
::              - Updated some prompts to reflect new options ex "Choose Selection [1-6]ÄÄ> " (0.16.3)
::              - Changed psexec.exe check to local directory instead of sysTools directory (0.16.4)
::              - Changed the workflow when working against a remote PC and script is prompting for Asset (0.16.5)
::   2012-10-02 - Added Restart Script as Admin to Main Menu (0.17.0)
::              - Fixed Titlebar after remote connections (0.17.1)
::              - Added option for system level remote console (0.18.0)
::              - Fix bug in remote user management (0.18.1)
::              - Added alternate start methods for those with more than one launch method (0.19.0)
::              - Modified sysTools check method for faster performance.  
::                   Remote network locations or missing directories were causing massive slowdowns. (0.19.1)
::   2012-10-03 - Tweaking tool checks for performance/availability (0.19.2)
::   2012-10-04 - Menu tweaks (0.19.3)
::              - Reboot/Shutdown tweaks to prevent accidential shutdowns (0.19.4)
::   2012-10-05 - Menu orginization tweaks (0.19.5)
::              - More tool check performance tweaks (0.19.5)
::              - Eliminated multiple checks for the same item through better code (0.19.6)
::   2012-10-08 - Added "m" main menu option to every menu will bring you back to main menu (0.19.7)
::              - Added new "Control Panel" menu which contains shortcuts to control panel applets (0.20.0)
::              - Completed new Control Panel menu and fixed somOe bugs in new code (0.20.1)
::   2012-10-11 - Fixed Office 2010 path from Office 13 to Office 14 (0.20.2)
::   2012-10-22 - Fix typo in the forced restart label prevented code from running (0.20.3)
::   2012-11-01 - Fix typo in File Association routine (0.20.4)
::   2012-11-05 - Fixed status display when SysTools folder is not found (0.20.5)
::   2012-11-09 - Added ability to add user to Local Admin group even if the user was part of a different domain than admin (0.21.0)
::              - Tweak new domain code for easier use. (0.21.1)
::              - Tweak formatting of domain code for easier reading (0.21.2)
::   2012-11-19 - Added install/update action to install script to local computer (0.22.0)
::   2012-11-20 - RELEASE (1.0.0)
::              - UI updates to Main Menu (1.1.0)
::              - UI updates to rest of script (1.1.1)
::              - Modified install to copy sysinternals tools (1.1.2)
::              - Install option only presents itself if not running from "installed" location (1.1.3)
::   2012-11-26 - Fixed start as Admin option for XP users (1.1.4)
::   2012-11-27 - Fixed bug in install routine where sysinternals was not copied properly (1.1.5)
::   2012-11-28 - Tweaked install routine (1.1.6)
::   2012-11-29 - Minor tweak to ordering of install routine (1.1.7)
::   2012-11-30 - Drastically improved Windows XP compatability (1.2.0)
::              - Fixed Java Control Panel bug on 32bit systems (1.2.0)
::              - More feedback during local install process (1.2.0)
::              - Tweak XP Wireless dialog boxes (1.2.1)
::   2012-12-07 - Modified screen output during install (1.2.2)
::   2012-12-12 - 12/12/12 (1.2.12)
::              - Fix Mail CP applet on 32bit systems (1.2.12)
::   2012-12-13 - Fix automated remote user management not reporting correctly (1.2.3)
::              - Moved Outlook CP applet logic to subrountine instead of in the menu code (1.2.4)
::   2013-01-08 - Added ADMIN switch to start script as administrator (1.3.0)
::   2013-01-15 - Fix ADMIN switch so the non-admin window closes properly and works on XP (1.3.1)
::   2013-01-16 - Fix XP Admin switch was interrupted by error warning about XP compatability (1.3.2)
::   2013-01-17 - Fix ADMIN switch which would exit script if user was already an admin! (1.3.3)
::                Change the way the XP error handles exiting (1.3.3)
::   2013-01-21 - Added terminal color picker (1.4.0)
::              - Tweak admin right checking, menu will not offer to elevate if already running as admin (1.4.1)
::              - Added confirmation to color picker (1.4.2)
::              - Edited install routine to prompt for install directory if needed (1.4.3)
::   2013-01-24 - Added link to MS Outlook scanpst.exe (1.4.4)
::              - Fix bug in Java Control Panel Applet launch on 32bit systems (1.4.5)
::   2013-01-25 - Added computer name to title bar (1.4.6)
::              - Reordered some initialization operations and added more userfeedback (1.4.6)
::   2013-01-28 - Changed wording in Remote Computer Selection routine from assets to computername (1.4.7)
::              - Removed need to specify domain and username on seperate lines for user management actions (1.4.7)
::              - Fix had broken the automatic admin elevation while reorganizing the startup routine (1.4.7)
::   2013-01-29 - Change menu formatting in preparation for reorginization (1.4.8)
::              - Started menu reorginization.  (1.5.0)
::                  - Moved/combined second page of shell folders to Control Panel page
::                  - Added options to System Utilities, Netowork, and Personalization Menus
::              - Bug fixes in new menus and replaced instances of C: with SystemDrive variable (1.5.1)
::              - Added system drive check disk scheduler (1.5.2)
::   2013-01-30 - Fix bug in path to 32bit Flash Player Control Panel applet (1.5.3)
::              - Fix bug when IE launched in XP, TST will wait for IE to close (1.5.4)
::              - Changed some menu wording from "Exit Control Panel" to "Exit Service Tool" (1.5.4)
::   2013-01-31 - Reorganized Control Panel menu (1.5.5)
::   2013-02-01 - Enhanced disk scheduler with more intelligence.  Check for scheduled job and backs up reg keys (1.5.6)
::              - Added MSI Removal and IE Fix scripts.  (1.6.0)
::   2013-02-03 - Added variable nullification to a couple menus and the XP OS warning to fix a loop condition (1.6.1)
::   2013-02-04 - Tweaked MSI Removal code so admin check occurs after user decides to continue (1.6.2)
::   2013-02-12 - Tweaked remote console logic to prompt for what user to run as (1.6.3)
::   2013-02-13 - Fix command line argument causes script to not exit on the first try (1.6.4)
::   2013-03-07 - Added explicit Quit command to IE Repair process (1.6.5)
::              - Updated Date Formatting in log to match ISO standard (1.6.5)
::              - Fix - FINALLY squashed Control Panel bug on XP (1.6.5)
::   2013-03-17 - Added Systray icon fix to scripted actions (1.6.6)
::   2013-03-25 - Added System Information Menu (1.7.0)
::   2013-03-27 - Finished System Information Menu - errors on XP (1.7.1)
::   2013-05-15 - Added option to start Internet Explorer in SafeMode (1.7.2)
::   2013-05-16 - Added Windows 8 Detection and Support (1.8.0)
::   2013-06-04 - Added IE Process Kill script (1.8.1)
::              - Removed usage of double ampersand, utilized better coding logic (1.8.2)
::   2013-06-05 - Fixed TrayIcon repair script (1.8.3)
::   2013-06-06 - Launch command prompt will now open in C:\temp (1.8.4)
::              - Updated install routine (1.8.5)
::   2013-06-07 - Modified Installed Java Detection Routine (1.8.6)
::   2013-06-10 - Added URL Shortcut repair to scripted actions (1.8.7)
::   2013-07-15 - Rewrite of initialization routine.  Fixes ocassional startup slowness by reducing 
::                number of path checks and moved change log to the end of the file (1.9.0)
::              - Removed unused, commented out code (1.9.0)
::   2013-07-19 - Addded new subroutines for system cleanup, not yet exposed in UI (1.9.1)
::              - Added additional information to System Information menu (1.9.1)
::              - Removed inaccuratly calculated memory conversions.  Batch files hate math (1.9.1)
::   2013-07-24 - Fixed Diskcheck scheduler (1.9.2)
::   2013-08-06 - Reorganizing system information display (1.9.3)
::              - Modified Java applet launcher to utilize new detection routine (1.9.3)
::   2013-08-12 - Enabled System Information Menu on Windows XP, one datapoint displays error (1.9.4)
::   2013-08-27 - Fixed sysTools check and file copy during install (1.9.5)
::
::
::  Known Issues
::       - Certain combinations of menu options will result in unexpected behavior when exiting the script.
::         Instead of closing the script may go back a screen or come back to the same screen again.  Repeated
::         entry of the exit command will work through the backlog and finally exit the script cleanly.
::       - When running script as admin in XP, it inexplicably takes two attempts even if correct credentials are entered.
::       - Menu organization needs reviewed and updated.  As many new functions were added, exisiting
::         menu structure has become cumbersome. ***  Fix In Progress  ***
::
::
::  Notes
::       - Features to come:
::
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
