@echo off
REM CPing.bat - Display Reply according to TTL using PainText I took from https://stackoverflow.com/a/41411439


for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (set "DEL=%%a")
<nul set /p=" "
echo.
if [%1]==[] goto usage
if %1==help goto usage
:loop

SET IP=%1 
SET marker=0F
SET RESPONSE=Not able to parse response. Either you need to check command parameters or just quit this program and use regular ping 
FOR /F "tokens=1-10 delims==:< " %%a IN ('PING -n 1 %IP%') DO (
rem echo %%a %%b %%c %%d %%e %%f %%g %%h %%i

IF "%%h"=="TTL" SET RESPONSE=%%a %%b %%c %%d %%e %%f %%g %%h %%i
IF "%%c"=="out." SET RESPONSE=%%a %%b %%c %%d %%e %%f %%g %%h %%i
IF "%%c"=="failed." SET RESPONSE=%%a %%b %%c %%d %%e %%f %%g
IF "%%f"=="unreachable." SET RESPONSE=%%a %%b %%c %%d %%e %%f %%g
IF "%%i"=="Please" SET RESPONSE=%%a %%b %%c %%d %%e %%f %%g %%h %%i %%j %%k %%l %%m %%n
IF "%%c"=="out." SET marker=0C 
IF "%%c"=="failed." SET marker=0C 
IF "%%i"=="Please" SET marker=0C 
IF "%%f"=="unreachable." SET marker=0C 
IF "%%i"=="128" SET marker=0A  
IF "%%i"=="255" SET marker=0E	)  

call :PainText %marker% "%RESPONSE%"
timeout /t 1 > nul
goto loop

REM Text coloring function. Do not remove     
goto :end
:PainText
<nul set /p "=%DEL%" > "%~2"
findstr /v /a:%1 /R "+" "%~2" nul
del "%~2" > nul
echo.
goto :eof

:usage

@echo.
@echo CPing.bat is Ping wrapper that colors the reply message according to the TTL value. designed for AMT/Host/BIOS TTL values when no routers in the middle 
@echo Written by Issi Hazan using PainText function taken from https://stackoverflow.com/a/41411439 plus some idea about ping parsing taken from https://stackoverflow.com/a/39669401
@echo You are welcome to change and improve. Let me know of any feedback
@echo. 
echo Usage example: 
call :PainText 0E "CPing.bat 172.16.109.141"
@echo. 
@echo Known limitations:
@echo No roundtrip and packet loss statistics are saved or displayed
@echo The display function trims the colon (":") from the response
call :PainText 0C "This wrapper is probably not bug free. Consider and use on your own risk "
@echo. 

:end

