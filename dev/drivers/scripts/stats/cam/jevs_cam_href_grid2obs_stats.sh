#PBS -N jevs_cam_href_grid2obs_stats
#PBS -j oe
#PBS -q dev
#PBS -S /bin/bash
#PBS -A VERF-DEV
#PBS -l walltime=04:30:00
#PBS -l place=vscatter,select=1:ncpus=72:mem=500GB
#PBS -l debug=true

export OMP_NUM_THREADS=1

export HOMEevs=/lfs/h2/emc/vpppg/noscrub/${USER}/EVS
source $HOMEevs/versions/run.ver

set -x 

export NET=evs
export STEP=stats
export COMPONENT=cam
export RUN=atmos
export VERIF_CASE=grid2obs
export MODELNAME=href
export KEEPDATA=YES
export SENDMAIL=YES

module reset
module load prod_envir/${prod_envir_ver}
source $HOMEevs/modulefiles/$COMPONENT/${COMPONENT}_${STEP}.sh

export run_envir=dev

export cyc=00

export run_mpi=yes
export gather=yes


export COMOUT=/lfs/h2/emc/vpppg/noscrub/${USER}/$NET/$evs_ver/$STEP/$COMPONENT
export envir=prod
export DATAROOT=/lfs/h2/emc/stmp/${USER}/evs_test/$envir/tmp
export job=${PBS_JOBNAME:-jevs_${MODELNAME}_${VERIF_CASE}_${STEP}}
export jobid=$job.${PBS_JOBID:-$$}

export maillist='alicia.bentley@noaa.gov,binbin.zhou@noaa.gov'
if [ -z "$maillist" ]; then

   echo "maillist variable is not defined. Exiting without continuing."

else

 ${HOMEevs}/jobs/JEVS_CAM_STATS

fi
