@echo off

if not exist "C:\tools\mdconv" mkdir "C:\tools\mdconv"


ruby --version >nul 2>&1
if ERRORLEVEL 1 (
    echo Ruby is not installed. Please install Ruby first:
    echo https://www.ruby-lang.org/en/downloads/
    pause
    exit /b
)


cd /d "C:\tools\mdconv"


if not exist "MD-Convert" (
    git clone https://github.com/Jimmxyz/MD-Convert.git
) else (
    echo Repository already exists, skipping clone.
)


if exist "%CD%\MD-Convert\mdconv.bat" (
    copy /Y "%CD%\MD-Convert\mdconv.bat" "%CD%\mdconv.bat"
) else (
    echo WARNING: mdconv.bat not found in repo!
)


cd /d "%CD%\MD-Convert\prgm"
gem install bundler --no-document
bundle install


cd /d "C:\tools\mdconv"


call "%CD%\mdconv.bat" %*
