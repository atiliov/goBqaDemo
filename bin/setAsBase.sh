#!/bin/bash
########################################################
#
#
# Establece el actual resultado de la corrida como la nueva base de
#	comparacion de la siguiente corrida.
#	Estudiar este script junto con el "goSanity.sh" y "compareRuns.sh"
#
#
########################################################
Repository=${HOME}/FxStreet/goBqa/
PrevRuns=${HOME}/Desktop/PreviousRun/


if [ -f $PrevRuns/ActualErrors.txt ]
then
	cp $PrevRuns/PreviousErrors.txt $PrevRuns/prev-backup.txt
	cp $PrevRuns/ActualErrors.txt $PrevRuns/actual-backup.txt
	cp $PrevRuns/ActualErrors.txt $PrevRuns/PreviousErrors.txt
fi


