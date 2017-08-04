rm deamon_jobs*.txt
echo $$ > deamon_pid.txt
counter=0
while [ 1 ]
do
	sleep 20 # check new jobs for every 10s
	num_cases=0
	for ii in work_dir/*
	do
		if [ -e $ii/READY_SWIFT.txt ]
		then
			let num_cases=$num_cases+1
			echo $ii >> deamon_jobs_$counter.txt
			rm $ii/READY_SWIFT.txt
		fi		

	done
	
	if [ "$num_cases" -gt "0" ]
	then
		cp -ar templatedir batch_work_$counter
		cp deamon_jobs_$counter.txt batch_work_$counter
		./templatedir/batch_submit.sh batch_work_$counter/deamon_jobs_$counter.txt batch_work_$counter & $1>batch_work_$counter/batch_stdout.txt $2>batch_work_$counter/batch_stderr.txt
		let counter=$counter+1
	fi

done
