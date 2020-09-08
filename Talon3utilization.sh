#!/bin/bash

##6/13/2018
#Charles Peterson
#
#This will print the Node utilization of Talon3


usage () {

echo "Talon3 utiliztion script"
echo "Usage: Talon3utilization.sh [-h] [-c] [-l] [-g]"
echo ""
echo "Options: "
echo "         -h : shows this usage message"
echo "         -c : current Talon3 utilization is displayed"
echo "         -l : logs current utilization into log file"
echo "         -g STARTDATE ENDDATE: gets avg utilization"
echo "           Date format: YYYY-MM-DD"
exit

}

getutil() {
c32tot=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | wc -l`
c64tot=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | wc -l`
c512tot=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | wc -l`
computetot=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | wc -l`
gputot=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep gpu | wc -l`

c32idle=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | grep idle | wc -l`
c64idle=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | grep idle | wc -l`
c512idle=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | grep idle | wc -l`
computeidle=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | grep idle | wc -l`
gpuidle=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep public | grep gpu | wc -l`

c32mix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | grep 'mix\|draining' | awk '{print $1}'`
c64mix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | grep 'mix\|draining' | awk '{print $1}'`
c512mix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | grep 'mix\|draining' | awk '{print $1}'`
computemix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | grep 'mix\|draining' | awk '{print $1}'`
gpumix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep gpu | grep 'mix\|draining' | awk '{print $1}'`

c32nummix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | grep 'mix\|draining' | wc -l`
c64nummix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | grep 'mix\|draining' | wc -l`
c512nummix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | grep 'mix\|draining' | wc -l`
computenummix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | grep 'mix\|draining' | wc -l`
gpunummix=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep gpu | grep 'mix\|draining' | wc -l`

c32acc=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | grep allocated | wc -l`
c64acc=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | grep allocated | wc -l`
c512acc=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | grep allocated | wc -l`
computeacc=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | grep allocated | wc -l`
gpuacc=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep gpu | grep allocated | wc -l`


c32main=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c32 | grep preproduction | grep 'drained\|down' | wc -l`
c64main=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c64 | grep preproduction | grep 'drained\|down' | wc -l`
c512main=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep c512 | grep bigmem | grep  'drained\|down' | wc -l`
computemain=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep compute | grep production | grep 'drained\|down' | wc -l`
gpumain=`/cm/shared/apps/slurm/17.11.12/bin/sinfo -lNe | grep gpu | grep gpu | grep 'drained\|down' | wc -l`


c32cpuacc=`echo "$c32acc * 16" | bc`
c32cpufree=`echo "$c32idle * 16" | bc`
for i in $c32mix ; do
x=`/cm/shared/apps/slurm/17.11.12/bin/scontrol show node $i | grep CPUAlloc | awk '{print $1}' | cut -d '=' -f2`
c32cpuacc=`echo "$c32cpuacc + $x" |bc`
y=`echo "16-$x" | bc`
c32cpufree=`echo "$c32cpufree + $y" |bc`
done

c64cpuacc=`echo "$c64acc * 16" | bc`
c64cpufree=`echo "$c64idle * 16" | bc`
for i in $c64mix ; do
x=`/cm/shared/apps/slurm/17.11.12/bin/scontrol show node $i | grep CPUAlloc | awk '{print $1}' | cut -d '=' -f2`
c32cpuacc=`echo "$c32cpuacc + $x" |bc`
y=`echo "16-$x" | bc`
c64cpufree=`echo "$c64cpufree + $y" |bc`
done

c512cpuacc=`echo "$c512acc * 32" | bc`
c512cpufree=`echo "$c512idle * 32" | bc`
for i in $c512mix ; do
x=`/cm/shared/apps/slurm/17.11.12/bin/scontrol show node $i | grep CPUAlloc | awk '{print $1}' | cut -d '=' -f2`
c512cpuacc=`echo "$c512cpuacc + $x" |bc`
y=`echo "32-$x" | bc`
c512cpufree=`echo "$c512cpufree + $y" |bc`
done

computecpuacc=`echo "$computeacc * 28" | bc`
computecpufree=`echo "$computeidle * 28" | bc`
for i in $computemix ; do
x=`/cm/shared/apps/slurm/17.11.12/bin/scontrol show node $i | grep CPUAlloc | awk '{print $1}' | cut -d '=' -f2`
computecpuacc=`echo "$computecpuacc + $x" |bc`
y=`echo "28-$x" | bc`
computecpufree=`echo "$computecpufree + $y" |bc`
done

gpucpuacc=`echo "$gpuacc * 28" | bc`
gpucpufree=`echo "$gpuidle * 28" | bc`
for i in $gpumix ; do
x=`/cm/shared/apps/slurm/17.11.12/bin/scontrol show node $i | grep CPUAlloc | awk '{print $1}' | cut -d '=' -f2`
gpucpuacc=`echo "$gpucpuacc + $x" |bc`
y=`echo "28-$x" | bc`
gpucpufree=`echo "$gpucpufree + $y" |bc`
done

r420accpercentcore=`echo "(( ($c32cpuacc + $c64cpuacc)) / (($c32tot + $c64tot) *16) *100)" | bc -l`
r720accpercentcore=`echo "(( ($c512cpuacc)) / (($c512tot) *32) *100)" | bc -l`
c6320accpercentcore=`echo "(( ($computecpuacc)) / (($computetot) *28) *100)" | bc -l`
r730accpercentcore=`echo "(( ($gpucpuacc)) / (($gputot) *28) *100)" | bc -l`

r420mainpercentcore=`echo "(( ($c32main + $c64main) * 16) / (($c32tot + $c64tot) *16) *100)" | bc -l`
r720mainpercentcore=`echo "(( ($c512main) * 32) / (($c512tot) *32) *100)" | bc -l`
c6320mainpercentcore=`echo "(( ($computemain) * 28) / (($computetot) *28) *100)" | bc -l`
r730mainpercentcore=`echo "(( ($gpumain) * 28) / (($gputot) *28) *100)" | bc -l`

r420idlepercentcore=`echo "(( ($c32cpufree + $c64cpufree)) / (($c32tot + $c64tot) *16) *100)" | bc -l`
r720idlepercentcore=`echo "(( ($c512cpufree)) / (($c512tot) *32) *100)" | bc -l`
c6320idlepercentcore=`echo "(( ($computecpufree)) / (($computetot) *28) *100)" | bc -l`
r730idlepercentcore=`echo "(( ($gpucpufree) ) / (($gputot) *28) *100)" | bc -l`

r420cputot=`echo "($c32tot + $c64tot) *16" | bc -l`
r720cputot=`echo "($c512tot) *32" | bc -l`
c6320cputot=`echo "($computetot) *28" | bc -l`
r730cputot=`echo "($gputot) *28" | bc -l`

r420accpercentnode=`echo "(( ($c32acc + $c64acc + $c32nummix + $c64nummix)) / (($c32tot + $c64tot) ) *100)" | bc -l`
r720accpercentnode=`echo "(( ($c512acc + $c512nummix)) / (($c512tot) ) *100)" | bc -l`
c6320accpercentnode=`echo "(( ($computeacc + $computenummix)) / (($computetot) ) *100)" | bc -l`
r730accpercentnode=`echo "(( ($gpuacc + $gpunummix)) / (($gputot) ) *100)" | bc -l`

r420mainpercentnode=`echo "(( ($c32main + $c64main) ) / (($c32tot + $c64tot) ) *100)" | bc -l`
r720mainpercentnode=`echo "(( ($c512main) ) / (($c512tot) ) *100)" | bc -l`
c6320mainpercentnode=`echo "(( ($computemain) ) / (($computetot) ) *100)" | bc -l`
r730mainpercentnode=`echo "(( ($gpumain) ) / (($gputot) ) *100)" | bc -l`

r420idlepercentnode=`echo "(( ($c32idle + $c64idle)) / (($c32tot + $c64tot) ) *100)" | bc -l`
r720idlepercentnode=`echo "(( ($c512idle)) / (($c512tot) ) *100)" | bc -l`
c6320idlepercentnode=`echo "(( ($computeidle)) / (($computetot) ) *100)" | bc -l`
r730idlepercentnode=`echo "(( ($gpuidle) ) / (($gputot) ) *100)" | bc -l`

r420tot=`echo "$c32tot + $c64tot" | bc -l`

if [ ! -z $display  ] ; then
#Print results to display
printf "         +-- Talon3 utilization by CORE --+\n"
printf "                       TOTAL  Alloc   Idle    Down   \n"
printf "                       ------- -------  ---- ---- \n"
printf "           c6320     :  %i  %3.1f    %3.1f    %3.1f  \n" $c6320cputot $c6320accpercentcore $c6320idlepercentcore $c6320mainpercentcore
printf "           r420      :  %i  %3.1f    %3.1f    %3.1f  \n" $r420cputot $r420accpercentcore $r420idlepercentcore $r420mainpercentcore
printf "           r720      :  %i  %3.1f    %3.1f    %3.1f  \n" $r720cputot $r720accpercentcore $r720idlepercentcore  $r720mainpercentcore
printf "           r730(GPU) :  %i  %3.1f    %3.1f    %3.1f  \n" $r730cputot $r730accpercentcore $r730idlepercentcore $r730mainpercentcore
printf "         +-------------------------------+\n"
echo ""
echo ""
printf "         +-- Talon3 utilization by NODE --+\n"
printf "                       TOTAL  Alloc   Idle    Down  \n"
printf "                       ------- -------  ---- ---- \n"
printf "           c6320     :  %i  %3.1f    %3.1f    %3.1f  \n" $computetot $c6320accpercentnode $c6320idlepercentnode $c6320mainpercentnode
printf "           r420      :  %i  %3.1f    %3.1f    %3.1f  \n" $r420tot $r420accpercentnode $r420idlepercentnode $r420mainpercentnode
printf "           r720      :  %i  %3.1f    %3.1f    %3.1f  \n" $c512tot $r720accpercentnode $r720idlepercentnode  $r720mainpercentnode
printf "           r730(GPU) :  %i  %3.1f    %3.1f    %3.1f  \n" $gputot $r730accpercentnode $r730idlepercentnode $r730mainpercentnode
printf "         +-------------------------------+\n"
fi

if [ ! -z $log ] ; then
#Write to log file
currdate=`date`

cat << EOF1 >> $logfile
$currdate $c6320cputot $c6320accpercentcore $c6320idlepercentcore $c6320mainpercentcore $computetot $c6320accpercentnode $c6320idlepercentnode $c6320mainpercentnode $r420cputot $r420accpercentcore $r420idlepercentcore $r420mainpercentcore $r420tot $r420accpercentnode $r420idlepercentnode $r420mainpercentnode $r720cputot $r720accpercentcore $r720idlepercentcore  $r720mainpercentcore $c512tot $r720accpercentnode $r720idlepercentnode  $r720mainpercentnode $r730cputot $r730accpercentcore $r730idlepercentcore $r730mainpercentcore $gputot $r730accpercentnode $r730idlepercentnode $r730mainpercentnode
EOF1

fi

}

getavg() {
if [  "$startdate" == $(date -d "$startdate" '+%Y-%m-%d') ] && [  "$enddate" == $(date -d "$enddate" '+%Y-%m-%d') ]; then 
cstartdate=`date -d $startdate +%s`
cenddate=`date  +%s -d "${enddate}+1 days"`
c6320accpercentcoreavg=0
c6320idlepercentcoreavg=0
c6320mainpercentcoreavg=0
c6320accpercentnodeavg=0
c6320idlepercentnodeavg=0
c6320mainpercentnodeavg=0
r420accpercentcoreavg=0
r420idlepercentcoreavg=0
r420mainpercentcoreavg=0
r420accpercentnodeavg=0
r420idlepercentnodeavg=0
r420mainpercentnodeavg=0
r720accpercentcoreavg=0
r720idlepercentcoreavg=0
r720mainpercentcoreavg=0
r720accpercentnodeavg=0
r720idlepercentnodeavg=0
r720mainpercentnodeavg=0
r730accpercentcoreavg=0
r730idlepercentcoreavg=0
r730mainpercentcoreavg=0
r730accpercentnodeavg=0
r730idlepercentnodeavg=0
r730mainpercentnodeavg=0


c6320cputotavg=0
computetotavg=0
r420cputotavg=0
r420totavg=0
r720cputotavg=0
c512totavg=0
r730cputotavg=0
gputotavg=0


itr=0
while IFS= read line 
do
	linedate=`echo $line | awk '{print $1 + $2 + $3 + $4 + $5 + $6}'`
	clinedate=`date -d $linedate  +%s`
	if [ $clinedate -ge $cstartdate ] && [ $clinedate -le $cenddate ]; then 
c6320cputotavg=`echo "$c6320cputotavg + $(echo $line | awk '{print $7}')" | bc -l`
c6320accpercentcoreavg=`echo "$c6320accpercentcoreavg + $(echo $line | awk '{print $8}')" | bc -l`
c6320idlepercentcoreavg=`echo "$c6320idlepercentcoreavg + $(echo $line |awk '{print $9}')" | bc -l`
c6320mainpercentcoreavg=`echo "$c6320mainpercentcoreavg + $(echo $line | awk '{print $10}')" | bc -l`
computetotavg=`echo "$computetotavg + $(echo $line | awk '{print $11}')" | bc -l`
c6320accpercentnodeavg=`echo "$c6320accpercentnodeavg + $(echo $line | awk '{print $12}')" |  bc -l`
c6320idlepercentnodeavg=`echo "$c6320idlepercentnodeavg + $(echo $line | awk '{print $13}')" | bc -l`
c6320mainpercentnodeavg=`echo "$c6320mainpercentnodeavg + $(echo $line | awk '{print $14}')" | bc -l`
r420cputotavg=`echo "$r420cputotavg + $(echo $line | awk '{print $15}')" | bc -l`
r420accpercentcoreavg=`echo "$r420accpercentcoreavg + $(echo $line | awk '{print $16}')" | bc -l`
r420idlepercentcoreavg=`echo "$r420idlepercentcoreavg + $(echo $line | awk '{print $17}')" | bc -l`
r420mainpercentcoreavg=`echo "$r420mainpercentcoreavg + $(echo $line | awk '{print $18}')" | bc -l`
r420totavg=`echo "$r420totavg + $(echo $line | awk '{print $19}')" | bc -l`
r420accpercentnodeavg=`echo "$r420accpercentnodeavg + $(echo $line | awk '{print $20}')" | bc -l`
r420idlepercentnodeavg=`echo "$r420idlepercentnodeavg + $(echo $line | awk '{print $21}')" | bc -l`
r420mainpercentnodeavg=`echo "$r420mainpercentnodeavg + $(echo $line |awk '{print $22}')" | bc -l`
r720cputotavg=`echo "$r720cputotavg + $(echo $line |awk '{print $23}')" | bc -l`
r720accpercentcoreavg=`echo "$r720accpercentcoreavg + $(echo $line |awk '{print $24}')" | bc -l`
r720idlepercentcoreavg=`echo "$r720idlepercentcoreavg + $(echo $line |awk '{print $25}')" | bc -l`
r720mainpercentcoreavg=`echo "$r720mainpercentcoreavg + $(echo $line |awk '{print $26}')" | bc -l`
c512totavg=`echo "$c512totavg + $(echo $line |awk '{print $27}')" | bc -l`
r720accpercentnodeavg=`echo "$r720accpercentnodeavg + $(echo $line |awk '{print $28}')" | bc -l`
r720idlepercentnodeavg=`echo "$r720idlepercentnodeavg + $(echo $line | awk '{print $29}')" |bc -l`
r720mainpercentnodeavg=`echo "$r720mainpercentnodeavg + $(echo $line |awk '{print $30}')" | bc -l`
r730cputotavg=`echo "$r730cputotavg + $(echo $line |awk '{print $31}')" | bc -l`
r730accpercentcoreavg=`echo "$r730accpercentcoreavg + $(echo $line | awk '{print $32}')" | bc -l`
r730idlepercentcoreavg=`echo "$r730idlepercentcoreavg + $(echo $line |awk '{print $33}')" | bc -l`
r730mainpercentcoreavg=`echo "$r730mainpercentcoreavg + $(echo $line |awk '{print $34}')" | bc -l`
gputotavg=`echo "$gputotavg + $(echo $line |awk '{print $35}')" | bc -l`
r730accpercentnodeavg=`echo "$r730accpercentnodeavg + $(echo $line |awk '{print $36}')" | bc -l`
r730idlepercentnodeavg=`echo "$r730idlepercentnodeavg + $(echo $line | awk '{print $37}')" | bc -l`
r730mainpercentnodeavg=`echo "$r730mainpercentnodeavg + $(echo $line |awk '{print $38}')" | bc -l`
itr=`echo "$itr + 1" | bc -l`
	fi
done < $logfile

if [ "$itr" -eq "0" ] ; then
echo "Date is out of range"
echo ""
echo ""
usage
fi
c6320accpercentcoreavg=`echo "$c6320accpercentcoreavg / $itr" | bc -l`
c6320idlepercentcoreavg=`echo "$c6320idlepercentcoreavg / $itr" | bc -l`
c6320mainpercentcoreavg=`echo "$c6320mainpercentcoreavg / $itr" | bc -l`
c6320accpercentnodeavg=`echo "$c6320accpercentnodeavg / $itr" |  bc -l`
c6320idlepercentnodeavg=`echo "$c6320idlepercentnodeavg / $itr" | bc -l`
c6320mainpercentnodeavg=`echo "$c6320mainpercentnodeavg / $itr" | bc -l`
r420accpercentcoreavg=`echo "$r420accpercentcoreavg / $itr" | bc -l`
r420idlepercentcoreavg=`echo "$r420idlepercentcoreavg / $itr" | bc -l`
r420mainpercentcoreavg=`echo "$r420mainpercentcoreavg / $itr" | bc -l`
r420accpercentnodeavg=`echo "$r420accpercentnodeavg / $itr" | bc -l`
r420idlepercentnodeavg=`echo "$r420idlepercentnodeavg / $itr" | bc -l`
r420mainpercentnodeavg=`echo "$r420mainpercentnodeavg / $itr" | bc -l`
r720accpercentcoreavg=`echo "$r720accpercentcoreavg / $itr" | bc -l`
r720idlepercentcoreavg=`echo "$r720idlepercentcoreavg / $itr" | bc -l`
r720mainpercentcoreavg=`echo "$r720mainpercentcoreavg / $itr" | bc -l`
r720accpercentnodeavg=`echo "$r720accpercentnodeavg / $itr" | bc -l`
r720idlepercentnodeavg=`echo "$r720idlepercentnodeavg / $itr" |bc -l`
r720mainpercentnodeavg=`echo "$r720mainpercentnodeavg / $itr" | bc -l`
r730accpercentcoreavg=`echo "$r730accpercentcoreavg / $itr" | bc -l`
r730idlepercentcoreavg=`echo "$r730idlepercentcoreavg / $itr" | bc -l`
r730mainpercentcoreavg=`echo "$r730mainpercentcoreavg " | bc -l`
r730accpercentnodeavg=`echo "$r730accpercentnodeavg / $itr" | bc -l`
r730idlepercentnodeavg=`echo "$r730idlepercentnodeavg / $itr" | bc -l`
r730mainpercentnodeavg=`echo "$r730mainpercentnodeavg / $itr" | bc -l`
c6320cputotavg=`echo "$c6320cputotavg / $itr" | bc -l`
computetotavg=`echo "$computetotavg / $itr" | bc -l`
r420cputotavg=`echo "$r420cputotavg / $itr" | bc -l`
r420totavg=`echo "$r420totavg / $itr" | bc -l`
r720cputotavg=`echo "$r720cputotavg / $itr" | bc -l`
c512totavg=`echo "$c512totavg / $itr" | bc -l`
r730cputotavg=`echo "$r730cputotavg / $itr" | bc -l`
gputotavg=`echo "$gputotavg / $itr" | bc -l`



printf "         +-- Talon3 utilization by CORE --+\n"
printf "                       TOTAL  Alloc   Idle    Down   \n"
printf "                       ------- -------  ---- ---- \n"
printf "           c6320     :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $c6320cputotavg $c6320accpercentcoreavg $c6320idlepercentcoreavg $c6320mainpercentcoreavg
printf "           r420      :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $r420cputotavg $r420accpercentcoreavg $r420idlepercentcoreavg $r420mainpercentcoreavg
printf "           r720      :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $r720cputotavg $r720accpercentcoreavg $r720idlepercentcoreavg  $r720mainpercentcoreavg
printf "           r730(GPU) :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $r730cputotavg $r730accpercentcoreavg $r730idlepercentcoreavg $r730mainpercentcoreavg
printf "         +-------------------------------+\n"
echo ""
echo ""
printf "         +-- Talon3 utilization by NODE --+\n"
printf "                       TOTAL  Alloc   Idle    Down   \n"
printf "                       ------- -------  ---- ---- \n"
printf "           c6320     :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $computetotavg $c6320accpercentnodeavg $c6320idlepercentnodeavg $c6320mainpercentnodeavg
printf "           r420      :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $r420totavg $r420accpercentnodeavg $r420idlepercentnodeavg $r420mainpercentnodeavg
printf "           r720      :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $c512totavg $r720accpercentnodeavg $r720idlepercentnodeavg  $r720mainpercentnodeavg
printf "           r730(GPU) :  %4.0f  %3.1f    %3.1f    %3.1f  \n" $gputotavg $r730accpercentnodeavg $r730idlepercentnodeavg $r730mainpercentnodeavg
printf "         +-------------------------------+\n"

else
echo "Invaild date format"
echo ""
echo ""
usage
fi
}

logfile=/cm/shared/admin/logs/talon3util.log
while getopts ":hclg" opt; do
    case $opt in
    h) usage ;;
    c) display=TRUE ; getutil ;;
    l) log=TRUE ; getutil ;;
    g) startdate=$2 ; enddate=$3 ; getavg ;;
    ?) echo "error: No -$OPTARG option"; usage ;;
    esac
done

