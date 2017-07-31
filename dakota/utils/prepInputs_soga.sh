#!/bin/bash

paramsrun=$1
jsonfile=$2
mkdir templatedir

#using rsync instead of cp because cp exit with 1 when folders are omitted
rsync -a openfoam/ templatedir/
rsync  dakota/* templatedir/
rsync dakota/utils/* templatedir/
mv templatedir/inputs/elbowKPI_soga.json templatedir/inputs/elbowKPI.json


python templatedir/input_parser.py templatedir/$paramsrun templatedir/input.template templatedir/$jsonfile templatedir/dakota_soga.in templatedir/runDakota_soga.sh
