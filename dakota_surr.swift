# GENERAL DAKOTA CASE RUNNER
type file;

# -- INPUT / OUTPUT DEFINITIONS
# Parallel.Works automates the creation of the Swift run command using your workflow definition
# Swift needs to pick up the run arguments with the arg() command

# inputs
#file casein         <arg("case","dakota/dakota_case.in")>;

# outputs
file outdat         <arg("dat","results/out.dat")>;
file surrdat         <arg("surr","results/surr.dat")>;
# these are external files needed by the Swift workflow
#file execute        <"runDakota.sh">;
file pts      <arg("pts","openfoam/inputs/points.dat")>;

file swiftconf <"swift.conf">;


file[] openfoam <Ext;exec="mapper.sh",root="openfoam">;
file[] dakota <Ext;exec="mapper.sh",root="dakota">;
file[] templatedir <Ext;exec="mapper.sh",root="templatedir">;
file[] templatedir_ofa <Ext;exec="mapper_ofa.sh">;

 
# -- APP DEFINITIONS


app (file sout, file serr, file surrdat ) prepInputs (file[] openfoam, file[] dakota, file outdat, file pts, file swiftconf) {
    bash "dakota/utils/prepInputs_surr.sh" "sweepParams.run" "inputs/elbowKPI.json" ;
    bash "templatedir/start_docker_surr.sh" stdout=@sout stderr=@serr;
}

#app (file pout, file perr) tree (file[] openfoam)
#{
#    tree stdout=@pout stderr=@perr;
#}

# -- WORKFLOW COMMANDS
# this commpand runs app specified above
file sout   <"logs/surr.out">;
file serr   <"logs/surr.err">;
(sout,serr,surrdat) = prepInputs(openfoam, dakota, outdat,pts, swiftconf);
#(dout,derr,outdat,outhtml) = runDAKOTA(templatedir_ofa,dakota,swiftconf, inlet5_X_min, inlet5_X_max, inlet6_Y_min, inlet6_Y_max, num_cases);

#(sout,serr)=tree(openfoam);
