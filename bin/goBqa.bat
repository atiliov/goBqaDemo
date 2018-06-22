@echo off
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
if not exist instalacion.ini goto error1
if  exist instalacion.ini goto setear
:error1
echo "No se encuentra el archivo 'instalacion.ini' con el directorio donde se encuentra instalado el producto"
goto fail
:setear

set /p installationDIR=<instalacion.ini

set GRADLE_HOME=%installationDir%\gradle-4.5
set JAVA_HOME=%installationDir%\jdk1.8.0_162\
set PATH=%GRADLE_HOME%\bin;%JAVA_HOME%\bin;%PATH%

REM **********************************************************************
REM             COMPLETAR CON LOS VALORES PARA LA CORRIDA SOLO SI SE CORRE CON BROWSER EN "REMOTE"
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


set PrgmPage=Sanity
set OutputDirectory=outputTests\
set logFile=%installationDir%\logfile.txt

REM Ahora los argumentos para modificar la ejecucion
REM Por defecto quedan las que usa el aplicativo (Chrome sobre linux)


:loop
IF NOT "%1"=="" (
    if "%1"=="-h" (
        echo USO:
        echo "goBqa.bat [-h] [-p page] [-env]"
        echo ""
        echo "-h:  Este mensaje de ayuda. Si necesita documentacion completa, enviar un mail a info@bairesqa.com solicitandola"
        echo "     con gusto se la enviamos."
        echo "-p page: El nombre de la pagina dentro del excel a ejecutar, valor por defecto:'Sanity'"
        echo "-env: muestra como quedan algunas de las variables de entorno al momento de ejecutarse"
        goto fail
    )
    IF "%1"=="-page" (
        SET PrgmPage=%2
        SHIFT
    )
    IF "%1"=="env" (
            echo ""
            echo installationDIR=%installationDIR%
            echo GRADLE_HOME=%GRADLE_HOME%
            echo JAVA_HOME=%JAVA_HOME%
            echo PATH=%PATH%
            echo PrgmPage=%PrgmPage%
            echo logFile=%logFile%
            echo OutputDirectory es siempre relativa al installationDir, se muestra absoluto
            echo OutputDirectory=%OutputDirectory%

        )

    SHIFT
    GOTO :loop
)

REM ###########################################################################
REM Perform TEST  Mando output al logfile
REM ##########################################################################

@echo "Ejecutando los test...."
@echo "La primera vez tarda en arrancar pues baja algunas librerias. Se puede ver el log de ejecucion en %logfile%"
@echo "...."

cd %installationDir%\goBqaDemo

gradle cleanTest test --info >%logFile% 2>&1
echo "Tests Finalizados"

REM
REM COMPRIMO EL DIRECTORIO DE RESULTADOS A SER ENVIADOS ANTES DE SU ANALISIS
REM Pues El analisis los preserva
REM
REM jar -cMf Enviar\ResultadosTest.zip outputTests


REM
REM El sigiente programa analiza la ejecucion y preserva los datos para un futuro analisis
REM Preserva los datos en el directorio "PreviousRun\fecha_de_ejecucion"
REM El archivo "PreviousRun\DiffAnalisis.txt" tiene el analisis

REM "C:\Program Files\Git\bin\bash.exe" scripts/AnalizeDif.sh

REM
REM  Se envia mail con el resultado.
REM
REM  ATENCION: Al menos durante una primer etapa mantener el envio de una copia a "atilio@bairesqa.com" para revisarlos
REM            hasta estar tranquilos que los test corren en forma estable
REM
REM blat %HOMEPATH%\Desktop\PreviousRun\DiffAnalisis.txt -to atilio@bairesqa.com -server smtp.mandrillapp.com -port 587 -f noreply@fxstreet.com -subject "Test Results - Extraer attach para detalles" -u "FOREXSTREET S.L." -pw nXuOcX9XdOj5RduHLgVQ5A -attach "Enviar\ResultadosTest.zip"

REM pause

:skip
exit /b 0


:fail
exit /b 1
