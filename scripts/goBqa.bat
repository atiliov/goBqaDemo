REM @echo off
REM **********************************************************************
REM
REM Este bat lo que hace es ejecutar el sanity en entorno windows
REM
REM  USO:
REM    goBqa.bat [-h] [-browser xxxx] [-browserVersion yy] [-os  ZZZ]
REM
REM Se puede modificar para que tambien se pueda elegir la suite a correr. Pero eso sera despues
REM
REM
REM **********************************************************************


REM
REM  RUNNING ENV.
REM
REM set GRADLE_HOME=c:\gradle-2.7
REM set JAVA_HOME=c:\jdk1.8.0_111\
REM set PATH=%GRADLE_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM **********************************************************************

REM             COMPLETAR CON LOS VALORES PARA LA CORRIDA SI SE CORRE CON BROWSER EN "REMOTE"

REM **********************************************************************


set goBqa_browser=Firefox
set goBqa_browserVersion=51
set goBqa_platform=Windows 7

REM **********************************************************************



set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto continue

echo .
echo ERROR: JAVA_HOME no esta seteada o es invalida y  el comando 'java' no esta en el path
echo .
echo Editar el bat "goBqa.bat" y ajustar esas variables y por las dudas revisar las de instalacion y outputDirectory
echo .

goto fail

:continue

REM
REM Variables de Instalacion
REM

set installationDIR=C:\Users\bairesqa\Documents\FxStreet
set PrgmPage=Sanity
set OutputDirectory=outputTests\
set logFile=%installationDir%\logfile.txt

REM Ahora los argumentos para modificar la ejecucion
REM Por defecto quedan las que usa el aplicativo (Chrome sobre linux)


:loop
IF NOT "%1"=="" (
    if "%1"=="-h" (
        echo USO:
        echo goBqa.bat [-h] [-browser xxxx] [-browserVersion yy] [-os  ZZZ]
        echo .
        goto fail
    )
    IF "%1"=="-browser" (
        SET goBqa_browser=%2
        SHIFT
    )
    IF "%1"=="-browserVersion" (
        SET goBqa_browserVersion=%2
        SHIFT
    )
    IF "%1"=="-os" (
            SET goBqa_platform=%2
            SHIFT
        )
    IF "%1"=="-skip" (
            GOTO :skip
        )
    SHIFT
    GOTO :loop
)

REM ###########################################################################
REM Perform TEST  Mando output al tacho
REM ##########################################################################

REM echo A punto de correr con estas variables:
REM echo installationDIR=%installationDIR%
REM echo PrgmPage=%PrgmPage%
REM echo OutputDirectory=%OutputDirectory%
REM echo logFile=%logFile%
echo Ejecutando tests en SauceLabs...

cd %installationDir%
rem gradle cleanTest test  >%logFile% 2>&1
gradle cleanTest test --info
echo "Tests Finalizados"

REM
REM COMPRIMO EL DIRECTORIO DE RESULTADOS A SER ENVIADOS ANTES DE SU ANALISIS
REM Pues El analisis los preserva
REM
jar -cMf Enviar\ResultadosTest.zip outputTests


REM
REM El sigiente programa analiza la ejecucion y preserva los datos para un futuro analisis
REM Preserva los datos en el directorio "PreviousRun\fecha_de_ejecucion"
REM El archivo "PreviousRun\DiffAnalisis.txt" tiene el analisis

"C:\Program Files\Git\bin\bash.exe" scripts/AnalizeDif.sh 

REM
REM  Se envia mail con el resultado. 
REM
REM  ATENCION: Al menos durante una primer etapa mantener el envio de una copia a "atilio@bairesqa.com" para revisarlos
REM            hasta estar tranquilos que los test corren en forma estable
REM
blat %HOMEPATH%\Desktop\PreviousRun\DiffAnalisis.txt -to atilio@bairesqa.com -server smtp.mandrillapp.com -port 587 -f noreply@fxstreet.com -subject "Test Results - Extraer attach para detalles" -u "FOREXSTREET S.L." -pw nXuOcX9XdOj5RduHLgVQ5A -attach "Enviar\ResultadosTest.zip"

pause

:skip
exit /b 0


:fail
exit /b 1
