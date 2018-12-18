! \file modtimedepsc.f90
!!  Prescribes surface values, fluxes and LS forcings at certain times for scalars

!>
!!  Prescribes surface values, fluxes and LS forcings at certain times for scalars
!>
!!  \author Roel Neggers, KNMI
!!  \author Thijs Heus,MPI-M
!!  \author Stephan de Roode, TU Delft
!!  \author Simon Axelsen, UU
!!  \par Revision list
!! \todo documentation
!  This file is part of DALES.
!
! DALES is free software; you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation; either version 3 of the License, or
! (at your option) any later version.
!
! DALES is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!  Copyright 1993-2009 Delft University of Technology, Wageningen University, Utrecht University, KNMI
!



module modtimedepsc

use netcdf
implicit none
private
public :: inittimedepsc, timedepsc,ltimedepsc,exittimedepsc
save
! switches for timedependent surface fluxes and large scale forcings
  logical       :: ltimedepsc     = .false. !< Overall switch, input in namoptions
  logical       :: ltimedepscz    = .false. !< Switch for large scale forcings
  logical       :: ltimedepscsurf = .true.  !< Switch for surface fluxes

  integer, parameter    :: kflux = 100
  integer, parameter    :: kls   = 100
  real, allocatable     :: timescsurf (:)
  real, allocatable     :: scst     (:,:) !< Time dependent surface scalar concentration

  real, allocatable     :: timescz  (:)
  real, allocatable     :: sczt(:,:,:) !< Time dependent, height dependent scalar concentrations



contains
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  subroutine inittimedepsc
    use modmpi,   only :myid,my_real,mpi_logical,mpierr,comm3d
    use modglobal,only :cexpnr,kmax,k1,ifinput,runtime,nsc,&
                         nc_input  !cstep

    implicit none

    character (80):: chmess
    character (1) :: chmess1
    character (16) :: outputfmt !format used to write the input read to stdout
    integer :: k,t,n, ierr
    real :: dummyr
    real, allocatable, dimension (:) :: height

    !cstep : NCDF vars
    integer :: ncid,varID,sts ! checks for presence ncdf input file
    integer :: nsc_in         ! number of passive scalars present in ncdf input file. 
                              !if nsc_in < nsc, profiles are assumed to be zero
    integer :: dimIDkls,dimIDkflux,dimIDnsc
    integer :: kflux_nc, kls_nc
    character(len=nf90_max_name) :: tmpName


    if (nsc==0 .or. .not.ltimedepsc ) return  !cstep : only do if ltimedepsc = .true.

    allocate(height(k1))
    allocate(timescsurf (0:kflux))
    allocate(scst  (kflux,nsc))
    allocate(timescz  (0:kls))
    timescsurf = 0
    timescz   = 0
    scst       = 0

    if (myid==0) then

       outputfmt = '(f10.3,100e10.3)'
       write(outputfmt(8:10),'(I3)') nsc

!    --- load lsforcings---
             sts          = nf90_inq_varid(ncid,"timescz",varID)
             sts          = nf90_get_var(ncid, varID, timescz(1:kls_nc))
 
             sts          = nf90_inq_varid(ncid,"timescsurf",varID)
             sts          = nf90_get_var(ncid, varID, timescsurf(1:kflux_nc))

    
             sts          = nf90_inq_varid(ncid,"zf",varID)
             sts          = nf90_get_var(ncid, varID, height(1:kmax))

             sts          = nf90_inq_varid(ncid,"scst",varID)
             sts          = nf90_get_var(ncid, varID, scst(1:kflux_nc,1:nsc))



      else !cstep input from ascii file

         open(ifinput,file='ls_fluxsc.inp.'//cexpnr)
         read(ifinput,'(a80)') chmess
         write(6,*) chmess
         read(ifinput,'(a80)') chmess
         write(6,*) chmess
         read(ifinput,'(a80)') chmess
         write(6,*) chmess


!      --- load fluxes---
         t    = 0
         ierr = 0
         do while (timescsurf(t)< runtime.and.t.lt.kflux)
            t=t+1
            read(ifinput,*, iostat = ierr) timescsurf(t), (scst(t,n),n=1,nsc)
            if (ierr < 0) then
                stop 'STOP: No time dependend data for end of run (surface fluxes of scalar)'
            end if
         end do

         ! flush to the end of fluxlist
         do while (ierr ==0)
            read (ifinput,*,iostat=ierr) dummyr
         end do
!       ---load large scale forcings----

      t    = 0
      do while (timescsurf(t)< runtime)
         t=t+1
         write(*,'(f9.1,4e12.4)') timescsurf(t), (scst(t,n),n=1,nsc)
      end do


      if(timescsurf(1)>runtime) then
         write(6,*) 'Time dependent surface variables do not change before end of'
         write(6,*) 'simulation. --> only large scale changes in scalars'
         ltimedepscsurf=.false.
      endif

      if ((timescz(1) > runtime) .or. (timescsurf(1) > runtime)) then
         write(6,*) 'Time dependent large scale forcings sets in after end of simulation -->'
         write(6,*) '--> only time dependent surface variables (scalars)'
         ltimedepscz=.false.
      end if
   endif   !myid

   
    call MPI_BCAST(timescsurf(1:kflux),kflux,MY_REAL,0,comm3d,mpierr)
    !cstep  call MPI_BCAST(timescz(1:kflux),kflux,MY_REAL,0,comm3d,mpierr)
    call MPI_BCAST(scst             ,kflux*nsc,MY_REAL,0,comm3d,mpierr)
    call MPI_BCAST(timescz(1:kls)    ,kls,MY_REAL  ,0,comm3d,mpierr)
    call MPI_BCAST(ltimedepscsurf ,1,MPI_LOGICAL,0,comm3d,mpierr)
    call MPI_BCAST(ltimedepscz    ,1,MPI_LOGICAL,0,comm3d,mpierr)
    call timedepsc

    deallocate(height)

  end subroutine inittimedepsc

  subroutine timedepsc
    use modglobal, only : nsc
    implicit none

    if(nsc==0 .or. .not.ltimedepsc) return
    call timedepscz
    call timedepscsurf

  end subroutine timedepsc

  subroutine timedepscz
  implicit none

    if(.not.(ltimedepscz)) return
    stop 'Modtimedepsc: time dependent scalars at all levels not programmed'

    return
  end subroutine timedepscz

  subroutine timedepscsurf
    use modglobal,   only : rtimee,nsc
    use modsurfdata,  only : scs
    implicit none
    integer t,n
    real fac

    if(.not.(ltimedepscsurf)) return

  !     --- interpolate! ----
    t=1
    do while(rtimee>timescsurf(t))
      t=t+1
    end do
    if (rtimee>timescsurf(t)) then
      t=t-1
    end if

    fac = ( rtimee-timescsurf(t) ) / ( timescsurf(t+1)-timescsurf(t))
    do n=1,nsc
       scs(n) = scst(t,n) + fac * (scst(t+1,n) - scst(t,n))
    enddo
    return
  end subroutine timedepscsurf


  subroutine exittimedepsc
    use modglobal, only : nsc
    implicit none
    if (nsc==0 .or. .not.ltimedepsc) return
  end subroutine exittimedepsc

end module modtimedepsc
