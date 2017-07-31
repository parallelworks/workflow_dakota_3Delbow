#!/bin/bash

paramsrun=$1
jsonfile=$2
mkdir templatedir

#using rsync instead of cp because cp exit with 1 when folders are omitted
rsync -a openfoam/ templatedir/
rsync  dakota/* templatedir/
rsync dakota/utils/* templatedir/
rsync swift.conf templatedir/
rsync openfoam/inputs/points.dat .
rsync results/out.dat .

python templatedir/input_parser.py templatedir/$paramsrun templatedir/input.template templatedir/$jsonfile templatedir/dakota_surr.in templatedir/runDakota_surr.sh
