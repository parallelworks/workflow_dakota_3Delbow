#!/bin/bash

paramsrun=$1
jsonfile=$2
mkdir templatedir

#using rsync instead of cp because cp exit with 1 when folders are omitted
rsync -a openfoam/ templatedir/
rsync  dakota/* templatedir/
rsync dakota/utils/* templatedir/
rsync swift.conf templatedir/


python templatedir/input_parser.py templatedir/$paramsrun templatedir/input.template templatedir/$jsonfile templatedir/dakota_DOE.in templatedir/runDakota.sh
