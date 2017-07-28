import sys
import json
import subprocess
import os



##################

##############try to use attribute eg inlet;ofa;10_20  num_exp;dakota;10
##########







params_file = sys.argv[1]
template_file=sys.argv[2]
json_file_name=sys.argv[3]
#params_dakota=sys.argv[4]
dakota_case=sys.argv[4]
runDakota=sys.argv[5]


with open(params_file) as f:
    param_list=f.read().splitlines()

if param_list[0].find("|") != -1 :  ## convert PW website format to multiple line format
	param_list=param_list[0].split("|")

#print param_list


params=[]
for ii in param_list:
	ii=ii.strip()
	tmp=ii.split(";")
	if tmp[2].find("_") !=-1 :
		tt=tmp[2].split("_")
		tmp[2]=tt[0]
		tmp.append(tt[1])
	else :
		tmp.append("")
	params.append(tmp)


num_changed=0
num_unchanged=0
changed_list=[]
changed_min=[]
changed_max=[]
unchanged_value=[]
unchanged_list=[]
num_exp=0;
for ii in params:
	if ii[1] == "ofa" :
		if ii[3] == "" :
			num_unchanged=num_unchanged+1
			unchanged_list.append(ii[0])
			unchanged_value.append(ii[2])
		else :
			num_changed=num_changed+1
			changed_list.append(ii[0])
			changed_min.append(ii[2])
			changed_max.append(ii[3])
	elif ii[1] == "dakota":
		if ii[0] == "num_exp":
			num_exp=ii[2]
#print changed_list, changed_min, changed_max
#print unchanged_list, unchanged_value

in_template=""
for ii in changed_list:
	in_template=in_template+ii+" {"+ii+"} \n"

for ii in range(len(unchanged_list)):
	in_template=in_template+unchanged_list[ii]+" "+unchanged_value[ii]+" \n"
#in_template=in_template.rstrip(",")


with open(template_file,"w") as t:
	t.write(in_template)
#print in_template



max_inputs=""
min_inputs=""
input_descriptors=""
for ii in range(len(changed_list)):
	max_inputs=max_inputs+" "+changed_max[ii]
	min_inputs=min_inputs+" "+changed_min[ii]
	input_descriptors=input_descriptors+" \\'"+changed_list[ii]+"\\'"


num_out=0
output_descriptors=""

with open(json_file_name) as json_file :
	jf=json.load(json_file)
for ii in jf.keys() :
	if jf[ii].get('extractStats','true') != 'false':
		num_out=num_out+1
		output_descriptors = output_descriptors + " \\'" + ii + "\\' "

#with open(params_dakota,'w') as pd:
#	pd.write(num_exp+" | ") #@@NUMBER_OF_EXPS@@
#	pd.write(str(num_changed)+" | ") #@@NUMBER_OF_INPUTS@@
#	pd.write(max_inputs+" | ") #@@MAX_INPUTS@@
#	pd.write(min_inputs+" | ") #@@MIN_INPUTS@@
#	pd.write(input_descriptors+" | ") #@@INPUT_DESCRIPTORS
#	pd.write(str(num_out)+" | ") #@@NUMBER_OF_OUTPUTS
#	pd.write(output_descriptors+"\n") #@@OUTPUT_DESCRIPTORS

os.system("sed -i 's/@@NUMBER_OF_EXPS@@/"+num_exp+"/' "+dakota_case)
os.system("sed -i 's/@@NUMBER_OF_INPUTS@@/"+str(num_changed)+"/' "+dakota_case)
os.system("sed -i 's/@@MAX_INPUTS@@/"+max_inputs+"/' "+dakota_case)
os.system("sed -i 's/@@MIN_INPUTS@@/"+min_inputs+"/' "+dakota_case)
#print input_descriptors
os.system("sed -i \"s/@@INPUT_DESCRIPTORS@@/"+input_descriptors+"/\" "+dakota_case)
#print cmd
#os.system("sed -i 's/@@INPUT_DESCRIPTORS@@/"+input_descriptors+"/' "+dakota_case)
os.system("sed -i 's/@@NUMBER_OF_OUTPUTS@@/"+str(num_out)+"/' "+dakota_case)
os.system("sed -i \"s/@@OUTPUT_DESCRIPTORS@@/"+output_descriptors+"/\" "+dakota_case)



os.system("sed -i 's/@@NUMBER_OF_INPUTS@@/"+str(num_changed)+"/' "+runDakota)
