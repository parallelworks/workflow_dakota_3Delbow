docker run -i --rm -v $PWD:/scratch -w /scratch parallelworks/dakota_openfoam /bin/bash templatedir/runDakota.sh templatedir/dakota_DOE.in results/out.dat results/out.html
