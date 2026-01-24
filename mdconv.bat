@echo off

cd /d "%~dp0MD-Convert"

git pull
if ERRORLEVEL 1 (
    echo Failed to update. Please check the URL and your network connection.
)

REM Run the Ruby script
ruby .\MD-Convert\prgm\main.rb %*
