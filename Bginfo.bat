@echo off
start /min powershell -ExecutionPolicy Bypass -File "C:\BGInfo\Scripts\AnyDesk.ps1"
timeout /t 2 /nobreak > nul
start /min "" "C:\BGInfo\Bginfo.exe" "C:\BGInfo\Bginfo.bgi" /accepteula /silent /timer:0
