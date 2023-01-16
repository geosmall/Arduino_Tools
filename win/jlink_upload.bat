@echo off
setlocal EnableExtensions

rem get unique temporary file name 
set "TMP_FILE_NAME=%tmp%\jlink~%RANDOM%.tmp"
echo %TMP_FILE_NAME%

set ERROR=0
set OZONE_CLI=Ozone.exe
set ADDRESS=0x8000000
set ERASE=
set MODE=
set PORT=
set OPTS=

:: Check tool
where /Q %OZONE_CLI%
if %errorlevel%==0 goto :param
::Check with default path
set STM32CP=%ProgramW6432%\SEGGER\Ozone
set STM32CP86=%ProgramFiles(X86)%\SEGGER\Ozone
set PATH=%PATH%;%STM32CP%;%STM32CP86%
echo %OZONE_CLI% found.
where /Q %OZONE_CLI%
if %errorlevel%==0 goto :param
echo %OZONE_CLI% not found.
echo Please install it or add ^<Ozone Debugger path^>\bin' to your PATH environment:
echo Aborting!
exit 1

:param
:: Parse options
rem if "%~1"=="" echo Not enough arguments! & set ERROR=2 & goto :usage
rem if "%~2"=="" echo Not enough arguments! & set ERROR=2 & goto :usage

set PROTOCOL=%~1
set DEVICE=%~2
set FILEPATH=%~3

echo void OnProjectLoad (void) {> %TMP_FILE_NAME%
echo   Project.AddSvdFile ("$(InstallDir)/Config/CPU/Cortex-M4F.svd");>> %TMP_FILE_NAME%
echo   File.Open ("%FILEPATH%");>> %TMP_FILE_NAME%
rem echo   Exec.Connect();>> %TMP_FILE_NAME%
rem echo   Exec.Reset();>> %TMP_FILE_NAME%
echo }>> %TMP_FILE_NAME%

:prog
echo %OZONE_CLI% -if %PROTOCOL% -device %DEVICE% -select USB -project %TMP_FILE_NAME%
START /B %OZONE_CLI% -if %PROTOCOL% -device %DEVICE% -select USB -project %TMP_FILE_NAME%
exit 0