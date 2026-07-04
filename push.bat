@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ============================================
echo   Push nach GitHub (if-fonds)
echo ============================================
echo.

rem --- Haengengebliebene Git-Lock-Dateien entfernen (OneDrive-Problem) ---
del /q /s ".git\*.lock" >nul 2>&1

rem --- Aktuelle Aenderungen anzeigen ---
echo Aenderungen:
git status --short
echo.

rem --- Wenn nichts zu committen ist, abbrechen ---
git diff --quiet && git diff --cached --quiet
if %errorlevel%==0 (
  echo Keine Aenderungen zum Pushen gefunden.
  echo.
  pause
  exit /b 0
)

rem --- Commit-Nachricht abfragen ---
set "msg="
set /p "msg=Commit-Nachricht (Enter = 'update'): "
if "%msg%"=="" set "msg=update"

echo.
echo Committe und pushe...
git add -A
git commit -m "%msg%"
git push origin main

echo.
if %errorlevel%==0 (
  echo FERTIG - Push erfolgreich.
) else (
  echo FEHLER beim Push - siehe Meldung oben.
)
echo.
pause
