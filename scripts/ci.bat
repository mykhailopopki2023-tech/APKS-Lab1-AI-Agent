@echo off
setlocal

set "PROJECT_ROOT=%~dp0.."
call "%PROJECT_ROOT%\mvnw.cmd" --batch-mode clean verify
if errorlevel 1 exit /b %errorlevel%

if not exist "%PROJECT_ROOT%\target\hello.jar" (
    echo ERROR: target\hello.jar was not generated.
    exit /b 1
)

java -jar "%PROJECT_ROOT%\target\hello.jar"
exit /b %errorlevel%
