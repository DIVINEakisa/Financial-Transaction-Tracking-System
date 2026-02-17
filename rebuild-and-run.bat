@echo off
echo Cleaning and rebuilding project...

cd /d "%~dp0"

REM Clean old compiled files
if exist "target\classes\com\ftts\servlet\*.class" del /q "target\classes\com\ftts\servlet\*.class"
if exist "target\tomcat\work" rd /s /q "target\tomcat\work"

REM Try to compile with Maven if available
where mvn >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    echo Maven found, compiling...
    call mvn clean compile
    if %ERRORLEVEL% EQU 0 (
        echo Build successful!
        echo Starting Tomcat...
        call mvn tomcat7:run
    ) else (
        echo Maven build failed. Please use your IDE to rebuild.
        pause
    )
) else (
    echo Maven not found in PATH.
    echo Please rebuild the project in your IDE (IntelliJ/Eclipse/VS Code)
    echo Then run: mvn tomcat7:run
    pause
)
