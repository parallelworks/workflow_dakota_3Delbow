cases=$1
workdir=$2

export PATH=$PATH:/swift-k/dist/swift-svn/bin

mkdir $workdir/outputs
rm $workdir/outputs/cases.list
rm $workdir/evalid_caseid.txt
counter=0

for aa in $(cat $cases)
do
	echo $aa
	cat $aa/input.in | tr '\n' ',' | sed  's/;/=/g' | rev | cut -c 2- | rev >> $workdir/outputs/cases.list
	echo "$aa+$counter" >> $workdir/evalid_caseid.txt
	let counter=counter+1
done

cd $workdir

swift -config swift.conf_local_explicitDockers  mainElbow3D_batch.swift

cd ..

for bb in $(cat $workdir/evalid_caseid.txt)
do
	echo $bb
	folder=$(echo $bb | cut -d "+" -f 1)
	caseid=$(echo $bb | cut -d "+" -f 2)
	mkdir -p $folder/outputs/case0
	cp -ar $workdir/outputs/case$caseid/* $folder/outputs/case0
	echo "1" > $folder/READY_RETURN.txt	
done


