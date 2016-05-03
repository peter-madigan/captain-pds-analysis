#!/bin/bash
source /project/projectdirs/captain/releases/CAPTAIN/captain.profile

cd /global/homes/p/pmadigan/work/pds_analysis/pds_analysisCode

datadir=/project/projectdirs/captain/data/2016/pmt/Cosmic
outdir=./calib

root -q -b PDSAnalysis.cc+

# rate calibration

runs=( 9993 )

for runno in "${runs[@]}"; do
    echo "Checking for run $runno..."
    if [ -d $datadir/run$runno ]; then
        echo "Run found!"
        i=0
        mkdir -v $outdir/pdsTree$runno
        for infile in `ls "$datadir/run$runno"`; do
            if [ -f "$infile" ] && [ -s "$infile" ] && [ "${infile: -5}" == ".root" ]; then
                root -q -b "PDSAnalysis.cc+(\"$datadir/run$runno/$infile\",$runno,\"$outdir/pdsTree$runno/pdsEvTree_$i.root\",\"s r\")"
                let "i++"
            fi
        done
    fi
done

root macros/pmt_rate.C
