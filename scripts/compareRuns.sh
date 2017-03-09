########################################################
#
#
# Compara el resultado actual con el puesto como base de comparacion.
#	Estudiar este Script junto con "goSanity.sh"
#
#
########################################################
Repository=${HOME}/work/TekQAOf/
PrevRuns=$Repository/outputTests/CorridasAnteriores/

echo "Analisis de la corrida de las siguientes fechas:"> $PrevRuns/DiffAnalisis.txt
echo -n "Corrida Actual :" >> $PrevRuns/DiffAnalisis.txt
stat -c %y $PrevRuns/ActualErrors.txt>> $PrevRuns/DiffAnalisis.txt

echo -n "Corrida Base   :" >> $PrevRuns/DiffAnalisis.txt
stat -c %y $PrevRuns/PreviousErros.txt >> $PrevRuns/DiffAnalisis.txt
echo "">>$PrevRuns/DiffAnalisis.txt
echo "">>$PrevRuns/DiffAnalisis.txt


echo "Errores Corregidos">> $PrevRuns/DiffAnalisis.txt
echo "=====================">> $PrevRuns/DiffAnalisis.txt
comm -13 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErros.txt>> $PrevRuns/DiffAnalisis.txt

echo "">> $PrevRuns/DiffAnalisis.txt
echo "Errores que Permanecen">> $PrevRuns/DiffAnalisis.txt
echo "=====================">> $PrevRuns/DiffAnalisis.txt
comm -12 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErros.txt>> $PrevRuns/DiffAnalisis.txt

echo "">> $PrevRuns/DiffAnalisis.txt
echo "Errores Nuevos">> $PrevRuns/DiffAnalisis.txt
echo "==============">> $PrevRuns/DiffAnalisis.txt
comm -23 $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErros.txt>> $PrevRuns/DiffAnalisis.txt

echo "  FIN del Trabajo  ">> $PrevRuns/DiffAnalisis.txt

###############################################
#
# Si anduviera el mail, se enviaria el archivo....
#
###############################################
cat $PrevRuns/DiffAnalisis.txt

