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

Repository=${HOME}/FxStreet/goBqa/
OutputDirectory=outputTests
Results=${Repository}/${OutputDirectory}/
PrevRuns=${HOME}/Desktop/PreviousRun/
#OutLog=Completar con el log del output de la corrida

Now=$(date +"%Y-%m-%d_%H%M%S")

export Repository PrevRuns Now OutputDirectory OutLog

#
# Muevo todos los Zips a un directorio con las corridas efectuadas
#
echo "Resguardando resultados de corridas anteriores en $PrevRuns" 
echo "==========================================================="


mkdir $PrevRuns/$Now  
for i in $Repository/*.zip
do
	mv $i $PrevRuns/$Now
done 
cp ${Repository}/OutputDirectory/index.html $PrevRuns/$Now
# Ver donde quedo el log
#mv ${OutLog} $PrevRuns/$Now

fin=$(date +"%H:%M:%S")


#####################################
#
# Analisis de los diff
#
#####################################
cd $Results



#
# Preparo el inventario de archivos de errores 
# y ademas contamos cuantas lineas tienen. De esta forma se 
# manejan como 2 errores distintos si 
wc -l *.dif |grep -v "total$">$PrevRuns/ActualErrors.txt

# Asume la existencia de PreviousErros.txt y ActualErros.txt
# Este comando deja el output en $PrevRuns/DiffAnalisis.txt
compareRuns.sh


###########################################
#
# Hacer una version donde se pase como argumento la orden 
# de preservar o los resultados de la ultima ejecucion
# Por ahora se compara siempre contra la ultima ejecucion
#
#if [[ "$preserveResults"="true" ]]
#then
#	echo "Setting previous run as new Base to compare"
#	setAsBase.sh
#fi
#############################################
setAsBase.sh
