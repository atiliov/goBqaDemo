#!/bin/bash
############################################
#
# - Resguarda los resultados de las corridas anteriores (*.zip)
# - Hace un pull del repositorio para obtener la ultima version. 
# - Corre el sanity de todo.
#
#   - Argument: Pull: haga un pull antes de correr.
#   - suite {xxx} : Que ejecute solo esa suite.
#
############################################
Repository=${HOME}/work/TekQAOf/
OutputDirectory=outputTests/
Results=${Repository}/${OutputDirectory}
PrevRuns=${Results}/CorridasAnteriores/
OutLog=/tmp/CorridaSanity.log
Now=$(date +"%Y-%m-%d_%H%M%S")
NowDisplay=$(date +"%H:%M:%S")
export Repository PrevRuns OutLog Now OutputDirectory

pull="false"
preserveResults="false"
suite="false"


while [[ $# >0 ]]
do
key="$1"

case $key in
	-p|--pull)
	pull="true";
	;;
	-s|--suite)
	suite=$2
	shift
	;;
	-r|--results)
	preserveResults="true"
	;;
	-h|--help)
	echo ""
	echo "Usage: goSanity.sh [-s suiteName] [-p] [-r] [-h]"
	echo "Corre el sanity de Garbarino para todas las suites en ambiente de test."
	echo "Argumentos:"
	echo "-s o --suite: Se ejecuta solo la suite indicada."
	echo "-p o --pull: hace un git pull antes de correr. Pide password."
	echo "-r o --results:Establece a la ultima corrida como la 'Base de "
	echo "     comparacion' de resultados."
	echo "     Si no, siempre compara contra ultima 'Base de comparacion'"
	echo "     establecida."
	echo "     La comparacion quedara establecida contra la ultima corrida."
	echo "-h o --help: muestra este mensaje."
	echo ""
	exit 0
	;;
	*)
	# unknown option
	echo "Invalid Option. Check usage: goSanity.sh -h"
	exit 0
	;;
esac
shift # past argument or value
done

echo  Starting at: $NowDisplay

cd $Repository
# Cuando corre, hasta tanto no termine la primer suite
# el Index.html no se regenera.
rm -f outputTests/index.html

if [ "$pull" = "false" ]
then
	echo " "|&tee ${OutLog}
	echo "No pull from repository"|&tee ${OutLog}
	echo " "|&tee ${OutLog}
else
	echo "git pull  " |& tee ${OutLog}
	echo "=========="  |& tee -a ${OutLog}
	git pull    |& tee -a ${OutLog}
fi

if [ "$suite" = "false" ]
then
	# Correr todo 

	echo "gradle cleanTest test"  |& tee -a ${OutLog}
	echo "====================="  |& tee -a ${OutLog}

	((runSingleSuite.sh -d 5  -s CatalogoTC)         |& tee ${OutLog}.5)&
	sleep 5
	((runSingleSuite.sh -d 6  -s ClientesTC)         |& tee ${OutLog}.6)&
	sleep 5
	((runSingleSuite.sh -d 7  -s CMundoNPedidoTC)    |& tee ${OutLog}.7)&
	sleep 5
	((runSingleSuite.sh -d 8  -s NotaDePedido2TC)    |& tee ${OutLog}.8)&
	sleep 5
	((runSingleSuite.sh -d 9  -s NotaDePedidoTC)     |& tee ${OutLog}.9)&
	sleep 5
	((runSingleSuite.sh -d 10 -s NotaDeVentaTC )     |& tee ${OutLog}.10)&
	sleep 5
	((runSingleSuite.sh -d 11 -s RecepcionesTC)  	 |& tee ${OutLog}.11)&
	sleep 5
	((runSingleSuite.sh -d 12 -s Recepciones2TC)     |& tee ${OutLog}.12)&
	sleep 5
	((runSingleSuite.sh -d 13 -s Recepciones3TC)     |& tee ${OutLog}.13)&
	sleep 5
 	((runSingleSuite.sh -d 14 -s SolicitudCreditosTC)|& tee ${OutLog}.14)&
	sleep 5
	((runSingleSuite.sh -d 15 -s VentaTelefonicaTC ) |& tee ${OutLog}.15)&
	

	wait
	echo "FIN DE LA ESPERA" 

	# Consolido todos los logs en uno solo
	cat ${OutLog}.* > ${OutLog}
	rm ${OutLog}.*

else
	# Correr solo la que pide como argumento

	echo "runSingleSuite.sh -d 5 -s $suite "|& tee -a ${OutLog}
	echo "===================== " |& tee -a ${OutLog}

	runSingleSuite.sh -d 5 -s "$suite" |& tee -a ${OutLog}

fi




#
# Muevo todos los Zips a un directorio con las corridas efectuadas
#
echo "Resguardando resultados de corridas anteriores en $PrevRuns" |& tee -a ${OutLog}
echo "===========================================================" |& tee -a ${OutLog}
mkdir $PrevRuns/$Now   |& tee -a ${OutLog}
for i in $Repository/*.zip
do
	mv $i $PrevRuns/$Now
done |& tee -a ${OutLog}

mv ${OutLog} $PrevRuns/$Now

fin=$(date +"%H:%M:%S")


#####################################
#
# Analisis de los diff
#
#####################################
cd $Results

if [[ "$preserveResults"="true" ]]
then
	echo "Setting previous run as new Base to compare"
	setAsBase.sh
fi
ls *.dif >$PrevRuns/ActualErrors.txt

# Asume la existencia de PreviousErros.txt y ActualErros.txt

compareRuns.sh

echo "Test arranco ${NowDisplay}"
echo "Test termino ${fin}"
