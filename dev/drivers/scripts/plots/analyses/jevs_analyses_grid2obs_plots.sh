#!/bin/bash
#PBS -N jevs_analyses_grid2obs_plots
#PBS -j oe
#PBS -S /bin/bash
#PBS -q "dev"
#PBS -A VERF-DEV
#PBS -l walltime=02:00:00
#PBS -l select=1:ncpus=1:mem=10GB
#PBS -l debug=true

export model=evs

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/$USER/EVS

source $HOMEevs/versions/run.ver

############################################################
# Load modules
############################################################
set -x

module reset
module load prod_envir/${prod_envir_ver}

############################################################
### For dev testing
##############################################################

export envir=prod
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
export KEEPDATA=YES
export SENDMAIL=YES

export NET=evs
export STEP=plots
export COMPONENT=analyses
export RUN=atmos
export VERIF_CASE=grid2obs
export MODELNAME=rtma
export modsys=rtma
export mod_ver=${rtma_ver}

source $HOMEevs/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh

export job=${PBS_JOBNAME:-jevs_${MODELNAME}_${VERIF_CASE}_${STEP}}
export jobid=$job.${PBS_JOBID:-$$}


export COMIN=/lfs/h2/emc/vpppg/noscrub/$USER/${NET}/${evs_ver}
export COMOUT=/lfs/h2/emc/vpppg/noscrub/$USER/${NET}/${evs_ver}

export vhr=00
echo $vhr

export maillist="perry.shafran@noaa.gov,alicia.bentley@noaa.gov"

export config=$HOMEevs/parm/evs_config/analyses/config.evs.rtma.prod
source $config

# CALL executable job script here
$HOMEevs/jobs/JEVS_ANALYSES_PLOTS

######################################################################
## Purpose: This job will generate the grid2obs statistics for the NAM_FIREWXNEST
##          model and generate stat files.
#######################################################################
#
exit
