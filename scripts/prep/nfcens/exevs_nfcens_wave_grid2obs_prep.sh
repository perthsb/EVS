#!/bin/bash
###############################################################################
# Name of Script: exevs_nfcens_wave_grid2obs_prep.sh                           
# Deanna Spindler / Deanna.Spindler@noaa.gov                                   
# Mallory Row / Mallory.Row@noaa.gov
# Purpose of Script: Run the grid2obs data prep for any global wave model      
#                    (deterministic and ensemble: GEFS-Wave, GFS-Wave, NWPS)   
#                                                                              
# Usage:                                                                       
#  Parameters: None                                                            
#  Input files:                                                                
#     gdas.${cycle}.prepbufr                                                   
#  Output files:                                                               
#     gdas.${validdate}.nc                                                     
#     individual fcst grib2 files                                              
#  Condition codes:                                                            
#     99  - Missing input file                                                 
#  User controllable options: None                                             
###############################################################################

set -x 

##############################
## grid2obs NFCENS Model Prep 
##############################

cd $DATA
echo "in $0 JLOGFILE is $jlogfile"
echo "Starting grid2obs_prep for ${MODELNAME}_${RUN}"

echo ' '
echo ' *************************************'
echo " *** ${MODELNAME}-${RUN} grid2obs prep ***"
echo ' *************************************'
echo ' '
echo "Starting at : `date`"
echo '-------------'
echo ' '

###############################################################################
# create today's NFCENS individual fcst grib2 files and add them to the archive
###############################################################################
cycles='00 12'

mkdir -p ${DATA}/gribs

for cyc in ${cycles} ; do
    # copy the model grib2 files
    COMINfilename="${COMINnfcens}/${MODELNAME}.${INITDATE}/HTSGW_mean.t${cyc}z.grib2"
    DATAfilename="${DATA}/gribs/HTSGW_mean.${INITDATE}.t${cyc}z.grib2"
    if [ ! -s $COMINfilename ]; then
        export subject="NFCENS Forecast Data Missing for EVS ${COMPONENT}"
        echo "Warning: No NFCENS forecast was available for ${INITDATE}${cyc}" > mailmsg
        echo "Missing file is $COMINfilename" >> mailmsg
        echo "Job ID: $jobid" >> mailmsg
        cat mailmsg | mail -s "$subject" $maillist
    else
        cp -v $COMINfilename $DATAfilename
    fi
    if [ -s $DATAfilename ]; then
        fcst=0
        # create the individual fcst files for every 6hrs
        while (( $fcst <= 240 )); do
            FCST=$(printf "%03d" "$fcst")
            DATAfilename_fhr=${DATA}/gribs/HTSGW_mean.${INITDATE}.t${cyc}z.f${FCST}.grib2
            ARCmodelfilename_fhr=${ARCmodel}/HTSGW_mean.${INITDATE}.t${cyc}z.f${FCST}.grib2
            if [ ! -s $ARCmodelfilename_fhr ]; then
                if [ $fcst = 0 ]; then
                    grib2_match_fhr=":surface:anl:"
                else
                    grib2_match_fhr=":${fcst} hour fcst:"
                fi
                DATAfilename_fhr=${DATA}/gribs/HTSGW_mean.${INITDATE}.t${cyc}z.f${FCST}.grib2
                wgrib2 $DATAfilename -match "$grib2_match_fhr" -grib $DATAfilename_fhr > /dev/null
                if [ $SENDCOM = YES ]; then
                    cp -v $DATAfilename_fhr ${ARCmodel}/.
                fi
            fi
            fcst=$(( $fcst+ 6 ))
        done
    fi
done

############################################
# get the GDAS prepbufr files for yesterday 
############################################
echo 'Copying GDAS prepbufr files'

for cyc in 00 06 12 18 ; do

  export cycle=t${cyc}z
  if [ ! -s ${COMINobsproc}.${INITDATE}/${cyc}/atmos/gdas.${cycle}.prepbufr ]; then
      export subject="GDAS Prepbufr Data Missing for EVS ${COMPONENT}"
      echo "Warning: No GDAS Prepbufr was available for init date ${INITDATE}${cyc}" > mailmsg
      echo "Missing file is ${COMINobsproc}.${INITDATE}/${cyc}/atmos/gdas.${cycle}.prepbufr" >> mailmsg
      echo "Job ID: $jobid" >> mailmsg
      cat mailmsg | mail -s "$subject" $maillist
  else
      cp -v ${COMINobsproc}.${INITDATE}/${cyc}/atmos/gdas.${cycle}.prepbufr ${DATA}/gdas.${INITDATE}${cyc}.prepbufr
  fi

done

############################################
# run PB2NC                                 
############################################
echo 'Run pb2nc'

mkdir $DATA/ncfiles

for cyc in 00 12; do
    export cyc=$cyc
    export cycle=t${cyc}z
    if [ -s ${DATA}/gdas.${INITDATE}${cyc}.prepbufr ]; then
        if [ ! -s ${COMOUT}.${INITDATE}/${MODELNAME}/${VERIF_CASE}/gdas.${INITDATE}${cyc}.nc ]; then
            run_metplus.py ${PARMevs}/metplus_config/machine.conf ${PARMevs}/metplus_config/${STEP}/${COMPONENT}/${RUN}_${VERIF_CASE}/PB2NC_wave.conf
            export err=$?; err_chk
            if [ $SENDCOM = YES ]; then
                cp -v $DATA/ncfiles/gdas.${INITDATE}${cyc}.nc ${COMOUT}.${INITDATE}/${MODELNAME}/${VERIF_CASE}/.
            fi
        fi
    fi
done

echo ' '
echo "Ending at : `date`"
echo ' '
echo " *** End of ${MODELNAME}-${RUN} grid2obs prep *** "
echo ' '

# End of NFCENS grid2obs prep script -------------------------------------- #
