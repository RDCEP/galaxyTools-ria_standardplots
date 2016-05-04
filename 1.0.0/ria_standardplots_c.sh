#! /bin/bash

#if [ $# -ne 7 ]
#then
#  echo "Usage: `basename $0` {dssat input} {dssat output}"
#  exit -1
#fi

title=$1
plottype=$2
plotformat=$3
plotvariable=$4
inputfile=$5
group=$6
plotoutput=$7
acmooutput=$8
declare -i count

echo $PWD

   count=0
   while read line
   do
    data1=`echo $line|awk '{ print $1 }'`
    data2=`echo $line|awk '{ print $2 }'`
   if [ -n "$data1" ]; then
      count=$count+1
      echo $count
      mkdir $count
      if [ "$data1" == "csv" ];then
         echo $data1 $data2
         cp $data2 $count/
      fi
      if [ "$data1" == "zip" ]; then
	 echo $data1 $data2
         cp $data2 $count.zip
         unzip -o -q $count.zip -d $count/
      fi
   fi
   done < "$inputfile"
   

command -V R >/dev/null 2>&1 || { echo >&2 " 'R' is required by this tool was not found on past";exit 1;}

INSTALL_DIR=/mnt/galaxyTools/ria_standardplots/1.0.0
ria_standardplots_c=$INSTALL_DIR/ria_standardplots_c.r

xvfb-run -a R --no-save --vanilla --slave --args "$title" $plottype $plotformat $plotvariable $PWD $group $count $plotoutput $acmooutput< $ria_standardplots_c

cd $PWD
#rm -r *

exit
