#export OPENFOAMPATH=/opt/openfoam4
#export embeddedDocker=true

tar xvf cog_transfer.tar

chmod 777 -R *

#./utils/makeGeom.sh utils/elbow3D_inputFile.py outputs/simParamFiles/caseParamFile0.in inputs/openFoamCase.tar outputs/case0/ outputs/logFiles/mesh0.out outputs/errorFiles/mesh0.err

#./utils/makeMesh.sh outputs/simParamFiles/caseParamFile0.in inputs/openFoamCase.tar outputs/case0/ utils/writeBlockMeshDictFile.py outputs/logFiles/mesh0.out outputs/errorFiles/mesh0.err

#./utils/runSim.sh outputs/case0/openFoamCase.tar outputs/logFiles/extractRun0.out outputs/errorFiles/extractRun0.err

#./utils/PVExtract.sh outputs/case0/openFoamCase.tar inputs/elbowKPI.json outputs/png/0/ outputs/case0/metrics.csv outputs/logFiles/extractRun0.out outputs/errorFiles/extractRun0.err



swift -config swift.conf_local_explicitDockers  mainElbow3D.swift


fileid=$(cat input.in | sed 's/ /,/g' | tr -d '\n' | cut -c 1-200)
tar cvzf ${fileid}.tar.gz outputs

#exit 1
