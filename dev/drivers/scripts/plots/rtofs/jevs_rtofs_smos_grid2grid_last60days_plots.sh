#PBS -N jevs_rtofs_smos_grid2grid_last60days_plots
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=00:15:00
#PBS -l select=1:ncpus=1:mem=500GB
#PBS -l debug=true

############################################################
# Load modules
############################################################
set -x

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS
source $HOMEevs/versions/run.ver

module reset
module load prod_envir/${prod_envir_ver}

export KEEPDATA=YES
export SENDDBN=NO

# specify environment variables
export envir=prod
export NET=evs
export STEP=plots
export COMPONENT=rtofs
export RUN=smos
export VERIF_CASE=grid2grid

source $HOMEevs/modulefiles/${COMPONENT}/${COMPONENT}_${STEP}.sh

# set up COMIN and COMROOT
export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/$NET/${evs_ver}
export COMROOT=/lfs/h2/emc/ptmp/$USER
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp

export job=${PBS_JOBNAME:-jevs_rtofs_smos_grid2grid_last60days_plots}
export jobid=$job.${PBS_JOBID:-$$}

# call j-job
$HOMEevs/jobs/JEVS_RTOFS_PLOTS

######################################################################
# Purpose: The job and task scripts work together to create plots
#          for RTOFS forecast verification using MET/METplus.
# Author: L. Gwen Chen (lichuan.chen@noaa.gov)
######################################################################
