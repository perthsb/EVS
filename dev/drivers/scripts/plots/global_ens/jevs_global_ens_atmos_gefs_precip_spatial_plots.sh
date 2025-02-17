#PBS -N jevs_global_ens_atmos_gefs_precip_spatial_plots
#PBS -j oe 
#PBS -S /bin/bash
#PBS -q dev
#PBS -A VERF-DEV
#PBS -l walltime=00:30:00
#PBS -l select=1:ncpus=1:mem=5GB
#PBS -l debug=true

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
source $HOMEevs/versions/run.ver

export NET=evs
export STEP=plots
export COMPONENT=global_ens
export RUN=atmos
export VERIF_CASE=precip_spatial
export MODELNAME=gefs

export envir=prod

module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh

export KEEPDATA=YES

export cyc=00

export met_v=${met_ver:0:4}

export COMIN=/lfs/h2/emc/vpppg/noscrub/${USER}/$NET/$evs_ver
export COMINspatial=/lfs/h2/emc/vpppg/noscrub/${USER}/$NET/$evs_ver
export COMOUT=/lfs/h2/emc/ptmp/${USER}/$NET/$evs_ver
export COMROOT=/lfs/h2/emc/vpppg/noscrub/${USER}/com
export SENDMAIL=YES
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
export job=${PBS_JOBNAME:-jevs_${MODELNAME}_${VERIF_CASE}_${STEP}}
export jobid=$job.${PBS_JOBID:-$$}

$HOMEevs/jobs/JEVS_GLOBAL_ENS_PLOTS
