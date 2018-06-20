########################################################
#
#
# Compara el resultado actual con el puesto como base de comparacion.
#	Estudiar este Script junto con "goSanity.sh"
#
#
########################################################
Repository=${HOME}/FxStreet/goBqa/
PrevRuns=${HOME}/Desktop/PreviousRun
preserveResults="false"
outputFile=$PrevRuns/DiffAnalisis.txt

while [[ $# >0 ]]
do
key="$1"

case $key in
	-o)
	outputFile=$2
	shift
	;;

	#-r|--results)
	#preserveResults="true"
	#;;

	-h|--help)
	echo ""
	echo "Usage: compareRun.sh [-o outputFile]"
	echo " "
	echo "Compara los resultados de esta corrida con la corrida anterior"
	echo "En rigor, con lo que se haya puesto como 'base' de comparacion."
	echo "o con la ultima vez que se corrio este comando preservando los resultados"
	echo "Argumentos:"
	echo "========== "
	echo "-o outputFile:  Envia los resultados al file indicado"
	# echo "-r o --results:  Preserva el analisis para comparar con la proxima vez"
	echo "-h o --help: muestra este mensaje."
	echo ""
	exit 0
	;;
	*)
	# unknown option
	echo "Opcion Invalida. Correr el comando con la opcion -h para obtener ayuda"
	exit 0
	;;

esac
shift # past argument or value
done


echo "Analisis de las siguientes ejecuciones:">$outputFile



echo -n "Ejecucion Actual :" >> $outputFile
stat -c %z $PrevRuns/ActualErrors.txt>> $outputFile

echo -n "Ejecucion contra la que se compara:" >> $outputFile
stat -c %z $PrevRuns/PreviousErrors.txt >> $outputFile
echo "">>$outputFile
echo "">>$outputFile
echo "Se detallan a continuacion que test fallaron, cuales se corrigieron ">>$outputFile
echo "y cuales permanecen respecto de la ultima ejecucion de los tests">>$outputFile
echo "">>$outputFile
echo "">>$outputFile


echo "Errores Corregidos">> $outputFile
echo "=====================">> $outputFile
comm -13 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErrors.txt>> $outputFile

echo "">> $outputFile
echo "Errores que Permanecen">> $outputFile
echo "=====================">> $outputFile
comm -12 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErrors.txt>> $outputFile

echo "">> $outputFile
echo "Errores Nuevos">> $outputFile
echo "==============">> $outputFile
comm -23 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErrors.txt>> $outputFile

echo "">> $outputFile
echo "FIN del Analisis  ">> $outputFile

###############################################
#
# Se muestra el contendio
#
###############################################
cat $outputFile
