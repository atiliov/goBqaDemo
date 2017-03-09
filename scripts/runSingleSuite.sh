#!/bin/bash
############################################
#
# Corre una sola suite en un VNC independiente.
#
############################################
Repository=${HOME}/work/TekQAOf/
Results=${Repository}/outputTests
PrgmPage=Sanity
Now=$(date +"%Y-%m-%d_%H%M%S")
NowDisplay=$(date +"%H:%M:%S")
VmArgs=""
export Repository Now PrgmPage

# Por defecto pongo display en 5
export DISPLAY=:5
suite="SUITE_NULA"


while [[ $# >0 ]]
do
key="$1"
#echo "runSingleSuite. Analizando:\$1:$1: \$2:$2:"

case $key in
	-d|--display)
	export DISPLAY=:$2
	export tail=$2
	shift
	;;
	-pg|ProgramPage)
	echo "ProgmPage: $2"
	export PrgmPage=$2
	shift
	;;
	-s|--suite)
	suite=$2
	shift
	;;
	-od|--outputDirectory)
	export OutputDirectory=$2
	shift
	;;
	-DjvmArgs)
	eval export $2
	shift
	;;
	-h|--help)
	echo "Usage:runSingleSuite.sh [-d Nro_De_Display] -s SuiteName [-pg PaginaDelPrograma] [-DjvmArgs var=value] [-od outputDir] [-h]"
	echo "-d: Setea el Display del vnc que va a laventar con el Nro. indicado."
	echo "     Si se omite se usa el display 5"
	echo "-s: Indica la suite a correr"
	echo "-pg: Nombre de la pagina a usar para ejecutar del archivo de programas. "
	echo "     Valor por defecto: Sanity"
	echo "-DjvmArgs: Argumento para pasar a la JVM"
	echo "-od:  Directiorio donde dejar los archivos"
	echo "-h: Muestra este mensaje"
	exit 0
	;;
	*)
	# unknown option
	echo "runSingleSuite: Opcion '$key' Invalida. Ejecute la opcion --help "
	exit 0
	;;
esac
shift # past argument or value
done

cd $Repository

#echo "DISPLAY=${DISPLAY}"

#echo "Killing previous VNC Server..."
vncserver -kill ${DISPLAY} >& /dev/null
sleep 2

echo "Running VNC Server for '${suite}' Display ${DISPLAY}.  Details on /tmp/${suite}_${tail}.log"
vncserver ${DISPLAY} -geometry 1366x768 -depth 24p >& /dev/null
echo "OutputDirectory=$OutputDirectory" 
gradle cleanTest test -Dtest.single="$suite" -DOutputDirectory="$OutputDirectory" >& /tmp/${suite}_${tail}.log

EndDisplay=$(date +"%H:%M:%S")
echo "Ending suite $suite sobre display ${DISPLAY} (started:${NowDisplay}, End:${EndDisplay})"
vncserver -kill ${DISPLAY} >& /dev/null

