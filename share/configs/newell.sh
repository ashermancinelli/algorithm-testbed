module purge
export OMP_CANCELLATION=true
export OMP_PROC_BIND=true
export OMPI_MCA_pml="ucx"
export UCX_NET_DEVICES=mlx5_1:1,mlx5_3:1
module load gcc/8.3.0
module load openmpi-gpu/4.1.0
module load cuda/10.2
module load cmake
