!> \file modrelax.f90
!! Used to relax the passive scalar to its original value


module modrelax
implicit none
contains
    
 subroutine relax
 use modglobal, only : nsc,rdt,lrelax,zh,kmax,i2,j2,taubl,tauft
 use modfields, only : sc0,scm,scprof
 use modtimestat, only : zi

 implicit none
 integer :: n,i,j,k
if (nsc>0 .and. lrelax) then ! Relax the passive scalar to its orginal value (test) JCLu
! ref. DAVINI(2017)
! Scalar BL
   do k=1,kmax
      do j=1,j2
         do i=1,i2
            scm(i,j,k,1) = rdt/taubl*(zh(k)/1000-scm(i,j,k,1)) + scm(i,j,k,1) 
          end do
      end do
   end do
 ! Scalar FT
 ! Update SFT relaxation profile with new zi
 scprof(k,2) = 0 ! in case zi decrease
   do k=1,kmax
      if (zh(k)>=zi) then
         scprof(k,2)=1
      endif
   enddo
 write(*,*) 'relaxing scalars'
   do k=1,kmax
      do j=1,j2
         do i=1,i2
            scm(i,j,k,2) = rdt/tauft*(scprof(k,2)-scm(i,j,k,2)) + scm(i,j,k,2) 
         end do
      end do
     end do
endif ! end of relaxation

end subroutine relax
end module 
