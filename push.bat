@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
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

rem --- Lokale Aenderungen (inkl. neue/untracked Dateien) ermitteln ---
set "changes="
for /f "delims=" %%i in ('git status --porcelain') do set "changes=1"

rem --- Upstream und ausstehende (noch nicht gepushte) Commits ermitteln ---
set "hasupstream="
git rev-parse --abbrev-ref @{u} >nul 2>&1 && set "hasupstream=1"
set "ahead=0"
for /f "delims=" %%i in ('git rev-list --count @{u}..HEAD 2^>nul') do set "ahead=%%i"

rem --- Abbrechen nur, wenn nichts zu committen UND nichts zu pushen ist ---
if not defined changes if defined hasupstream if "!ahead!"=="0" (
  echo Keine Aenderungen und keine ausstehenden Commits zum Pushen gefunden.
  echo.
  pause
  exit /b 0
)

rem --- Falls lokale Aenderungen vorliegen: committen ---
if defined changes (
  set "msg="
  set /p "msg=Commit-Nachricht (Enter = 'update'): "
  if "!msg!"=="" set "msg=update"
  echo.
  echo Committe...
  git add -A
  git commit -m "!msg!"
) else (
  echo Keine neuen Aenderungen - es werden nur ausstehende Commits gepusht.
)

echo.
echo Pushe nach origin main...
git push origin main

echo.
if "!errorlevel!"=="0" (
  echo FERTIG - Push erfolgreich.
) else (
  echo FEHLER beim Push - siehe Meldung oben.
)
echo.
pause
