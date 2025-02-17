#!/bin/bash

##################################################################################
# Name of Script: evs_cam_plots_radar.sh
# Contact(s):     Logan C. Dawson (logan.dawson@noaa.gov)
# Purpose of Script: This script runs METplus to generate radar
#                    verification graphics for deterministic and ensemble CAMs.
# History Log:
# 04/28/2023: Initial script assembled by Logan Dawson
##################################################################################


set -x

export PLOT_TYPE=$1
export DOMAIN=$2
export var_name=$3
export LINE_TYPE=$4
export FCST_INIT_HOUR=$5
export JOBNUM=$6
export job_name="job${JOBNUM}"

export LOG_TEMPLATE="${LOG_DIR}/EVS_verif_plotting_job${JOBNUM}_`date '+%Y%m%d-%H%M%S'`_$$.out"


###################################################################
# Set some additional variables based on job arguments
###################################################################

if [ $DOMAIN = conus ]; then

   export NBR_WIDTH=17
   export INTERP_PNTS=289
   export VX_MASK_LIST="CONUS,CONUS_East,CONUS_West,CONUS_Central,CONUS_South"

elif [ $DOMAIN = alaska ]; then

   export NBR_WIDTH=27
   export INTERP_PNTS=729
   export VX_MASK_LIST="Alaska"

fi


if [ $var_name = REFC ]; then

   export FCST_THRESHs=">=20 >=30 >=40 >=50"
   export FCST_THRESH=">=20,>=30,>=40,>=50"
   export FCST_LEVEL="L0"

   export OBS_THRESH=">=20,>=30,>=40,>=50"
   export OBS_LEVEL="Z500"

elif [ $var_name = RETOP ]; then

   export FCST_THRESHs=">=20 >=30 >=40"
   export FCST_THRESH=">=20,>=30,>=40"
   export FCST_LEVEL="L0"

   export OBS_THRESH=">=20,>=30,>=40"
   export OBS_LEVEL="Z500"

fi


if [ $LINE_TYPE = nbrcnt ] || [ $LINE_TYPE = nbrctc ]; then
   export INTERP="NBRHD_SQUARE"
fi


###################################################################
# Run python scripts for the specified plot type 
###################################################################

if [ $PLOT_TYPE = performance_diagram ]; then

   export STATS="sratio,pod,csi"
   python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
   export err=$?; err_chk

elif [ $PLOT_TYPE = threshold_average ]; then

   if [ $LINE_TYPE = nbrcnt ]; then

      export STATS="fss"
      python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
      export err=$?; err_chk

   elif [ $LINE_TYPE = nbrctc ]; then

      export STATS="csi"
      python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
      export err=$?; err_chk

      export STATS="fbias"
      python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
      export err=$?; err_chk

   fi

elif [ $PLOT_TYPE = lead_average ]; then

   for FCST_THRESH in ${FCST_THRESHs}; do

      OBS_THRESH=${FCST_THRESH}

      if [ $LINE_TYPE = nbrcnt ]; then

         export STATS="fss"
         python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
         export err=$?; err_chk

      elif [ $LINE_TYPE = nbrctc ]; then

         export STATS="csi"
         python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
         export err=$?; err_chk

         export STATS="fbias"
         python ${USHevs}/${COMPONENT}/${PLOT_TYPE}.py
         export err=$?; err_chk
      fi

   done

fi


exit
