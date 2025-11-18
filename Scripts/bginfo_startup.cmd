@echo off
REM --- Início do script de inicialização do BGInfo ---
set SRC=\\SEU-SERVIDOR\gpo\BGInfo
set DST=C:\BGInfo

if not exist "%DST%" mkdir "%DST%"
if not exist "%DST%\Scripts" mkdir "%DST%\Scripts"

xcopy "%SRC%\*" "%DST%\" /E /Y /R

REM Executa o script PowerShell que extrai o ID do AnyDesk
start /min powershell -ExecutionPolicy Bypass -File "C:\BGInfo\Scripts\AnyDesk.ps1"
timeout /t 2 /nobreak > nul

start /min "" "C:\BGInfo\Bginfo.exe" "C:\BGInfo\Bginfo.bgi" /accepteula /silent /timer:0

exit /b 0

