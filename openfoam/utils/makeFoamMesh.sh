#!/bin/bash 
caseindex=$1
portlogFile=$2
meshScript=$3
meshParamsFile=$4

foamCaseTar=$5
caseDirPath=$6

fOut=$7
fErr=$8

######
# SALOMEPATH=/home/marmar/programs-local/SALOME-8.2.0-UB14.04/
# OPENFOAMPATH=/opt/openfoam4/
#####


WORK_DIR=$(pwd)
errDir=$(dirname "${fErr}")
mkdir -p $errDir
fOutDir=$(dirname "${fOut}")
mkdir -p $fOutDir
salLogDir=$(dirname "${portlogFile}")
mkdir -p $salLogDir


# Copy and extract openFoam case files
foamDirName=$(basename "$foamCaseTar")
foamDirName="${foamDirName%%.*}"

mkdir -p $caseDirPath
cp $foamCaseTar $caseDirPath
tar -xf $caseDirPath/$foamDirName.tar -C $caseDirPath
meshDir=$caseDirPath/$foamDirName/constant/triSurface/

# Generate the stl surfaces files using salome

printf 'Salome output\n------------\n' >> $fOut
printf 'Salome errors\n------------\n' >> $fErr
portlogFileAbsPath=${WORK_DIR}/$portlogFile 
$SALOMEPATH/salome start -t   --ns-port-log=$portlogFileAbsPath 1>>$fOut 2>>$fErr
$SALOMEPATH/salome shell -p `cat $portlogFileAbsPath`  $meshScript args:$meshParamsFile,$meshDir 1>>$fOut 2>>$fErr



source $OPENFOAMPATH/etc/bashrc ""

# Generate line emesh files for sharper edges

surfaceFeatureExtract -case  $caseDirPath/$foamDirName/  1>>$fOut 2>>$fErr

blockMesh -case  $caseDirPath/$foamDirName/ 1>>$fOut 2>>$fErr

snappyHexMesh -overwrite -case   $caseDirPath/$foamDirName/ 1>>$fOut 2>>$fErr 


cd $caseDirPath/$foamDirName/
tar -cf constant.tar constant
cd $WORK_DIR

