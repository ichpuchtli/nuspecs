@echo off

rem Get nuget.org API Key
set /p key=<key.txt

rem Update all submodules
echo Updating Submodules...
git submodule update

rem Loop through submodules
for /D %%d in (*) do call :pack %%d
pause
goto exit

:pack

echo ------------------------------ %1 ---------------------------------------

rem Get latest tag from repository
for /f %%i in ('git -C %1 tag --list ^| tail -1') do set latest=%%i

echo Checking out %1@%latest%...
git -C %1 checkout tags/%latest%
echo Done.	

echo Packing %1.nuspec...
nuget pack %1.nuspec -Version %latest%

echo Pushing %1.%latest%.nupkg...
nuget push %1.%latest%.nupkg %key%

:exit