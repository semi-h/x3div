!Copyright (c) 2012-2022, Xcompact3d
!This file is part of Xcompact3d (xcompact3d.com)
!SPDX-License-Identifier: BSD 3-Clause

!********************************************************************
!
subroutine derx_00(tx,ux,rx,sx,ffx,fsx,fwx,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tx,ux,rx
  real(mytype), dimension(ny,nz):: sx
  real(mytype), dimension(nx):: ffx,fsx,fwx

  do k=1,nz
     do j=1,ny
        tx(1,j,k)=afix*(ux(2,j,k)-ux(nx,j,k))&
             +bfix*(ux(3,j,k)-ux(nx-1,j,k))
        rx(1,j,k)=-one
        tx(2,j,k)=afix*(ux(3,j,k)-ux(1,j,k))&
             +bfix*(ux(4,j,k)-ux(nx,j,k))
        rx(2,j,k)=zero
        do i=3,nx-2
           tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           rx(i,j,k)=zero
        enddo
        tx(nx-1,j,k)=afix*(ux(nx,j,k)-ux(nx-2,j,k))&
             +bfix*(ux(1,j,k)-ux(nx-3,j,k))
        rx(nx-1,j,k)=zero
        tx(nx,j,k)=afix*(ux(1,j,k)-ux(nx-1,j,k))&
             +bfix*(ux(2,j,k)-ux(nx-2,j,k))
        rx(nx,j,k)=alfaix
        do i=2, nx
           tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           rx(i,j,k)=rx(i,j,k)-rx(i-1,j,k)*fsx(i)
        enddo
        tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
        rx(nx,j,k)=rx(nx,j,k)*fwx(nx)
        do i=nx-1,1,-1
           tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           rx(i,j,k)=(rx(i,j,k)-ffx(i)*rx(i+1,j,k))*fwx(i)
        enddo
        sx(j,k)=(tx(1,j,k)-alfaix*tx(nx,j,k))&
             /(one+rx(1,j,k)-alfaix*rx(nx,j,k))
        do i=1,nx
           tx(i,j,k)=tx(i,j,k)-sx(j,k)*rx(i,j,k)
        enddo
     enddo
  enddo

  return
end subroutine derx_00

!********************************************************************
!
subroutine derx_11(tx,ux,rx,sx,ffx,fsx,fwx,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tx,ux,rx
  real(mytype), dimension(ny,nz):: sx
  real(mytype), dimension(nx):: ffx,fsx,fwx


  if (npaire==1) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=zero
           tx(2,j,k)=afix*(ux(3,j,k)-ux(1,j,k))&
                +bfix*(ux(4,j,k)-ux(2,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afix*(ux(nx,j,k)-ux(nx-2,j,k))&
                +bfix*(ux(nx-1,j,k)-ux(nx-3,j,k))
           tx(nx,j,k)=zero
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=afix*(ux(2,j,k)+ux(2,j,k))&
                +bfix*(ux(3,j,k)+ux(3,j,k))
           tx(2,j,k)=afix*(ux(3,j,k)-ux(1,j,k))&
                +bfix*(ux(4,j,k)+ux(2,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afix*(ux(nx,j,k)-ux(nx-2,j,k))&
                +bfix*((-ux(nx-1,j,k))-ux(nx-3,j,k))
           tx(nx,j,k)=afix*((-ux(nx-1,j,k))-ux(nx-1,j,k))&
                +bfix*((-ux(nx-2,j,k))-ux(nx-2,j,k))
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derx_11

!********************************************************************
!
subroutine derx_12(tx,ux,rx,sx,ffx,fsx,fwx,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: tx,ux,rx
  real(mytype), dimension(ny,nz):: sx
  real(mytype), dimension(nx):: ffx,fsx,fwx

  if (npaire==1) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=zero
           tx(2,j,k)=afix*(ux(3,j,k)-ux(1,j,k))&
                +bfix*(ux(4,j,k)-ux(2,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afmx*(ux(nx,j,k)-ux(nx-2,j,k))
           tx(nx,j,k)=(-afnx*ux(nx,j,k))-bfnx*ux(nx-1,j,k)-cfnx*ux(nx-2,j,k)
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=afix*(ux(2,j,k)+ux(2,j,k))&
                +bfix*(ux(3,j,k)+ux(3,j,k))
           tx(2,j,k)=afix*(ux(3,j,k)-ux(1,j,k))&
                +bfix*(ux(4,j,k)+ux(2,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afmx*(ux(nx,j,k)-ux(nx-2,j,k))
           tx(nx,j,k)=(-afnx*ux(nx,j,k))-bfnx*ux(nx-1,j,k)-cfnx*ux(nx-2,j,k)
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derx_12

!********************************************************************
!
subroutine derx_21(tx,ux,rx,sx,ffx,fsx,fwx,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: tx,ux,rx
  real(mytype), dimension(ny,nz):: sx
  real(mytype), dimension(nx):: ffx,fsx,fwx


  if (npaire==1) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=af1x*ux(1,j,k)+bf1x*ux(2,j,k)+cf1x*ux(3,j,k)
           tx(2,j,k)=af2x*(ux(3,j,k)-ux(1,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afix*(ux(nx,j,k)-ux(nx-2,j,k))&
                +bfix*(ux(nx-1,j,k)-ux(nx-3,j,k))
           tx(nx,j,k)=zero
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=af1x*ux(1,j,k)+bf1x*ux(2,j,k)+cf1x*ux(3,j,k)
           tx(2,j,k)=af2x*(ux(3,j,k)-ux(1,j,k))
           do i=3,nx-2
              tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                   +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
           enddo
           tx(nx-1,j,k)=afix*(ux(nx,j,k)-ux(nx-2,j,k))&
                +bfix*((-ux(nx-1,j,k))-ux(nx-3,j,k))
           tx(nx,j,k)=afix*((-ux(nx-1,j,k))-ux(nx-1,j,k))&
                +bfix*((-ux(nx-2,j,k))-ux(nx-2,j,k))
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derx_21

!********************************************************************
!
subroutine derx_22(tx,ux,rx,sx,ffx,fsx,fwx,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: tx,ux,rx
  real(mytype), dimension(ny,nz):: sx
  real(mytype), dimension(nx):: ffx,fsx,fwx


  do k=1,nz
     do j=1,ny
        tx(1,j,k)=af1x*ux(1,j,k)+bf1x*ux(2,j,k)+cf1x*ux(3,j,k)
        tx(2,j,k)=af2x*(ux(3,j,k)-ux(1,j,k))
        do i=3,nx-2
           tx(i,j,k)=afix*(ux(i+1,j,k)-ux(i-1,j,k))&
                +bfix*(ux(i+2,j,k)-ux(i-2,j,k))
        enddo
        tx(nx-1,j,k)=afmx*(ux(nx,j,k)-ux(nx-2,j,k))
        tx(nx,j,k)=(-afnx*ux(nx,j,k))-bfnx*ux(nx-1,j,k)-cfnx*ux(nx-2,j,k)
        do i=2,nx
           tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*fsx(i)
        enddo
        tx(nx,j,k)=tx(nx,j,k)*fwx(nx)
        do i=nx-1,1,-1
           tx(i,j,k)=(tx(i,j,k)-ffx(i)*tx(i+1,j,k))*fwx(i)
        enddo
     enddo
  enddo

  return
end subroutine derx_22

!********************************************************************
!
subroutine dery_00(ty,uy,ry,sy,ffy,fsy,fwy,ppy,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivY

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: ty,uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz)  :: sy
  real(mytype), dimension(ny) :: ffy,fsy,fwy,ppy


  do k=1,nz
     do i=1,nx
        ty(i,1,k)=afjy*(uy(i,2,k)-uy(i,ny,k))&
             +bfjy*(uy(i,3,k)-uy(i,ny-1,k))
        ry(i,1,k)=-one
        ty(i,2,k)=afjy*(uy(i,3,k)-uy(i,1,k))&
             +bfjy*(uy(i,4,k)-uy(i,ny,k))
        ry(i,2,k)=zero
     enddo
  enddo
  do k=1,nz
     do j=3,ny-2
        do i=1,nx
           ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           ry(i,j,k)=zero
        enddo
     enddo
  enddo
  do k=1,nz
     do i=1,nx
        ty(i,ny-1,k)=afjy*(uy(i,ny,k)-uy(i,ny-2,k))&
             +bfjy*(uy(i,1,k)-uy(i,ny-3,k))
        ry(i,ny-1,k)=zero
        ty(i,ny,k)=afjy*(uy(i,1,k)-uy(i,ny-1,k))&
             +bfjy*(uy(i,2,k)-uy(i,ny-2,k))
        ry(i,ny,k)=alfajy
     enddo
  enddo
  do k=1,nz
     do j=2,ny
        do i=1,nx
           ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           ry(i,j,k)=ry(i,j,k)-ry(i,j-1,k)*fsy(j)
        enddo
     enddo
  enddo
  do k=1,nz
     do i=1,nx
        ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        ry(i,ny,k)=ry(i,ny,k)*fwy(ny)
     enddo
  enddo
  do k=1,nz
     do j=ny-1,1,-1
        do i=1,nx
           ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           ry(i,j,k)=(ry(i,j,k)-ffy(j)*ry(i,j+1,k))*fwy(j)
        enddo
     enddo
  enddo
  do k=1,nz
     do i=1,nx
        sy(i,k)=(ty(i,1,k)-alfajy*ty(i,ny,k))&
             /(1.+ry(i,1,k)-alfajy*ry(i,ny,k))
     enddo
  enddo
  do k=1,nz
     do j=1,ny
        do i=1,nx
           ty(i,j,k)=ty(i,j,k)-sy(i,k)*ry(i,j,k)
        enddo
     enddo
  enddo
  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif
  return
end subroutine dery_00

!********************************************************************
!
subroutine dery_11(ty,uy,ry,sy,ffy,fsy,fwy,ppy,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivY

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: ty,uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz)  :: sy
  real(mytype), dimension(ny) :: ffy,fsy,fwy,ppy


  if (npaire==1) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=zero
           ty(i,2,k)=afjy*(uy(i,3,k)-uy(i,1,k))&
                +bfjy*(uy(i,4,k)-uy(i,2,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afjy*(uy(i,ny,k)-uy(i,ny-2,k))&
                +bfjy*(uy(i,ny-1,k)-uy(i,ny-3,k))
           ty(i,ny,k)=zero
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=afjy*(uy(i,2,k)+uy(i,2,k))&
                +bfjy*(uy(i,3,k)+uy(i,3,k))
           ty(i,2,k)=afjy*(uy(i,3,k)-uy(i,1,k))&
                +bfjy*(uy(i,4,k)+uy(i,2,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afjy*(uy(i,ny,k)-uy(i,ny-2,k))&
                +bfjy*((-uy(i,ny-1,k))-uy(i,ny-3,k))
           ty(i,ny,k)=afjy*((-uy(i,ny-1,k))-uy(i,ny-1,k))&
                +bfjy*((-uy(i,ny-2,k))-uy(i,ny-2,k))
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif
  return
end subroutine dery_11

!********************************************************************
!
subroutine dery_12(ty,uy,ry,sy,ffy,fsy,fwy,ppy,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivY

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: ty,uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz)  :: sy
  real(mytype), dimension(ny) :: ffy,fsy,fwy,ppy


  if (npaire==1) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=zero
           ty(i,2,k)=afjy*(uy(i,3,k)-uy(i,1,k))&
                +bfjy*(uy(i,4,k)-uy(i,2,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afmy*(uy(i,ny,k)-uy(i,ny-2,k))
           ty(i,ny,k)=-afny*uy(i,ny,k)-bfny*uy(i,ny-1,k)-cfny*uy(i,ny-2,k)
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=afjy*(uy(i,2,k)+uy(i,2,k))&
                +bfjy*(uy(i,3,k)+uy(i,3,k))
           ty(i,2,k)=afjy*(uy(i,3,k)-uy(i,1,k))&
                +bfjy*(uy(i,4,k)+uy(i,2,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afmy*(uy(i,ny,k)-uy(i,ny-2,k))
           ty(i,ny,k)=-afny*uy(i,ny,k)-bfny*uy(i,ny-1,k)-cfny*uy(i,ny-2,k)
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif
  return
end subroutine dery_12

!********************************************************************
!
subroutine dery_21(ty,uy,ry,sy,ffy,fsy,fwy,ppy,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivY

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: ty,uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz)  :: sy
  real(mytype), dimension(ny) :: ffy,fsy,fwy,ppy


  if (npaire==1) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=af1y*uy(i,1,k)+bf1y*uy(i,2,k)+cf1y*uy(i,3,k)
           ty(i,2,k)=af2y*(uy(i,3,k)-uy(i,1,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afjy*(uy(i,ny,k)-uy(i,ny-2,k))&
                +bfjy*(uy(i,ny-1,k)-uy(i,ny-3,k))
           ty(i,ny,k)=zero
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=af1y*uy(i,1,k)+bf1y*uy(i,2,k)+cf1y*uy(i,3,k)
           ty(i,2,k)=af2y*(uy(i,3,k)-uy(i,1,k))
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                   +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=afjy*(uy(i,ny,k)-uy(i,ny-2,k))&
                +bfjy*((-uy(i,ny-1,k))-uy(i,ny-3,k))
           ty(i,ny,k)=afjy*((-uy(i,ny-1,k))-uy(i,ny-1,k))&
                +bfjy*((-uy(i,ny-2,k))-uy(i,ny-2,k))
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
           enddo
        enddo
     enddo
  endif
  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif
  return
end subroutine dery_21

!********************************************************************
!
subroutine dery_22(ty,uy,ry,sy,ffy,fsy,fwy,ppy,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivY

  implicit none

  integer :: nx,ny,nz,i,j,k,npaire
  real(mytype), dimension(nx,ny,nz) :: ty,uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz)  :: sy
  real(mytype), dimension(ny) :: ffy,fsy,fwy,ppy


  do k=1,nz
     do i=1,nx
        ty(i,1,k)=af1y*uy(i,1,k)+bf1y*uy(i,2,k)+cf1y*uy(i,3,k)
        ty(i,2,k)=af2y*(uy(i,3,k)-uy(i,1,k))
     enddo
  enddo
  do k=1,nz
     do j=3,ny-2
        do i=1,nx
           ty(i,j,k)=afjy*(uy(i,j+1,k)-uy(i,j-1,k))&
                +bfjy*(uy(i,j+2,k)-uy(i,j-2,k))
        enddo
     enddo
  enddo
  do k=1,nz
     do i=1,nx
        ty(i,ny-1,k)=afmy*(uy(i,ny,k)-uy(i,ny-2,k))
        ty(i,ny,k)=-afny*uy(i,ny,k)-bfny*uy(i,ny-1,k)-cfny*uy(i,ny-2,k)
     enddo
  enddo
  do k=1,nz
     do j=2,ny
        do i=1,nx
           ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*fsy(j)
        enddo
     enddo
  enddo
  do k=1,nz
     do i=1,nx
        ty(i,ny,k)=ty(i,ny,k)*fwy(ny)
     enddo
  enddo
  do k=1,nz
     do j=ny-1,1,-1
        do i=1,nx
           ty(i,j,k)=(ty(i,j,k)-ffy(j)*ty(i,j+1,k))*fwy(j)
        enddo
     enddo
  enddo

  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif

  return
end subroutine dery_22

!********************************************************************
!
subroutine derz_00(tz,uz,rz,sz,ffz,fsz,fwz,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivZ

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tz,uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: ffz,fsz,fwz


  do j=1,ny
     do i=1,nx
        tz(i,j,1)=afkz*(uz(i,j,2)-uz(i,j,nz  ))&
             +bfkz*(uz(i,j,3)-uz(i,j,nz-1))
        rz(i,j,1)=-one
        tz(i,j,2)=afkz*(uz(i,j,3)-uz(i,j,1 ))&
             +bfkz*(uz(i,j,4)-uz(i,j,nz))
        rz(i,j,2)=zero
     enddo
  enddo
  do k=3,nz-2
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           rz(i,j,k)=zero
        enddo
     enddo
  enddo
  do j=1,ny
     do i=1,nx
        tz(i,j,nz-1)=afkz*(uz(i,j,nz)-uz(i,j,nz-2))&
             +bfkz*(uz(i,j,1 )-uz(i,j,nz-3))
        rz(i,j,nz-1)=zero
        tz(i,j,nz  )=afkz*(uz(i,j,1)-uz(i,j,nz-1))&
             +bfkz*(uz(i,j,2)-uz(i,j,nz-2))
        rz(i,j,nz  )=alfakz
     enddo
  enddo
  do k=2,nz
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           rz(i,j,k)=rz(i,j,k)-rz(i,j,k-1)*fsz(k)
        enddo
     enddo
  enddo
  do j=1,ny
     do i=1,nx
        tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        rz(i,j,nz)=rz(i,j,nz)*fwz(nz)
     enddo
  enddo
  do k=nz-1,1,-1
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           rz(i,j,k)=(rz(i,j,k)-ffz(k)*rz(i,j,k+1))*fwz(k)
        enddo
     enddo
  enddo
  do j=1,ny
     do i=1,nx
        sz(i,j)=(   tz(i,j,1)-alfakz*tz(i,j,nz))/&
             (1.+rz(i,j,1)-alfakz*rz(i,j,nz))
     enddo
  enddo
  do k=1,nz
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=tz(i,j,k)-sz(i,j)*rz(i,j,k)
        enddo
     enddo
  enddo
  return
end subroutine derz_00

!********************************************************************
!
subroutine derz_11(tz,uz,rz,sz,ffz,fsz,fwz,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivZ

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tz,uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: ffz,fsz,fwz


  if (npaire==1) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=zero
           tz(i,j,2)=afkz*(uz(i,j,3)-uz(i,j,1))&
                +bfkz*(uz(i,j,4)-uz(i,j,2))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=afkz*(uz(i,j,nz  )-uz(i,j,nz-2))&
                +bfkz*(uz(i,j,nz-1)-uz(i,j,nz-3))
           tz(i,j,nz  )=zero
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=afkz*(uz(i,j,2)+uz(i,j,2))&
                +bfkz*(uz(i,j,3)+uz(i,j,3))
           tz(i,j,2)=afkz*(uz(i,j,3)-uz(i,j,1))&
                +bfkz*(uz(i,j,4)+uz(i,j,2))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=afkz*( uz(i,j,nz  )-uz(i,j,nz-2))&
                +bfkz*(-uz(i,j,nz-1)-uz(i,j,nz-3))
           tz(i,j,nz  )=afkz*(-uz(i,j,nz-1)-uz(i,j,nz-1))&
                +bfkz*(-uz(i,j,nz-2)-uz(i,j,nz-2))
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derz_11

!********************************************************************
!
subroutine derz_12(tz,uz,rz,sz,ffz,fsz,fwz,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivZ

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tz,uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: ffz,fsz,fwz


  if (npaire==1) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=zero
           tz(i,j,2)=afkz*(uz(i,j,3)-uz(i,j,1))&
                +bfkz*(uz(i,j,4)-uz(i,j,2))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)= afmz*(uz(i,j,nz)-uz(i,j,nz-2))
           tz(i,j,nz  )=-afnz*uz(i,j,nz)-bfnz*uz(i,j,nz-1)&
                -cfnz*uz(i,j,nz-2)
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=afkz*(uz(i,j,2)+uz(i,j,2))&
                +bfkz*(uz(i,j,3)+uz(i,j,3))
           tz(i,j,2)=afkz*(uz(i,j,3)-uz(i,j,1))&
                +bfkz*(uz(i,j,4)+uz(i,j,2))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)= afmz*(uz(i,j,nz)-uz(i,j,nz-2))
           tz(i,j,nz  )=-afnz*uz(i,j,nz)-bfnz*uz(i,j,nz-1)&
                -cfnz*uz(i,j,nz-2)
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derz_12

!********************************************************************
!
subroutine derz_21(tz,uz,rz,sz,ffz,fsz,fwz,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivZ

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tz,uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: ffz,fsz,fwz


  if (npaire==1) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=af1z*uz(i,j,1)+bf1z*uz(i,j,2)&
                +cf1z*uz(i,j,3)
           tz(i,j,2)=af2z*(uz(i,j,3)-uz(i,j,1))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=afkz*(uz(i,j,nz  )-uz(i,j,nz-2))&
                +bfkz*(uz(i,j,nz-1)-uz(i,j,nz-3))
           tz(i,j,nz  )=zero
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif
  if (npaire==0) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=af1z*uz(i,j,1)+bf1z*uz(i,j,2)&
                +cf1z*uz(i,j,3)
           tz(i,j,2)=af2z*(uz(i,j,3)-uz(i,j,1))
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                   +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=afkz*( uz(i,j,nz  )-uz(i,j,nz-2))&
                +bfkz*(-uz(i,j,nz-1)-uz(i,j,nz-3))
           tz(i,j,nz  )=afkz*(-uz(i,j,nz-1)-uz(i,j,nz-1))&
                +bfkz*(-uz(i,j,nz-2)-uz(i,j,nz-2))
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derz_21

!********************************************************************
!
subroutine derz_22(tz,uz,rz,sz,ffz,fsz,fwz,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivZ

  implicit none

  integer :: nx,ny,nz,npaire,i,j,k
  real(mytype), dimension(nx,ny,nz) :: tz,uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: ffz,fsz,fwz


  do j=1,ny
     do i=1,nx
        tz(i,j,1)=af1z*uz(i,j,1)+bf1z*uz(i,j,2)&
             +cf1z*uz(i,j,3)
        tz(i,j,2)=af2z*(uz(i,j,3)-uz(i,j,1))
     enddo
  enddo
  do k=3,nz-2
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=afkz*(uz(i,j,k+1)-uz(i,j,k-1))&
                +bfkz*(uz(i,j,k+2)-uz(i,j,k-2))
        enddo
     enddo
  enddo
  do j=1,ny
     do i=1,nx
        tz(i,j,nz-1)= afmz*(uz(i,j,nz)-uz(i,j,nz-2))
        tz(i,j,nz  )=-afnz*uz(i,j,nz)-bfnz*uz(i,j,nz-1)&
             -cfnz*uz(i,j,nz-2)
     enddo
  enddo
  do k=2,nz
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*fsz(k)
        enddo
     enddo
  enddo
  do j=1,ny
     do i=1,nx
        tz(i,j,nz)=tz(i,j,nz)*fwz(nz)
     enddo
  enddo
  do k=nz-1,1,-1
     do j=1,ny
        do i=1,nx
           tz(i,j,k)=(tz(i,j,k)-ffz(k)*tz(i,j,k+1))*fwz(k)
        enddo
     enddo
  enddo

  return
end subroutine derz_22

!********************************************************************
!
subroutine derxvp(tx,ux,rx,sx,cfx6,csx6,cwx6,nx,nxm,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,nxm,ny,nz,npaire
  real(mytype), dimension(nxm,ny,nz) :: tx
  real(mytype), dimension(nx,ny,nz) :: ux,rx
  real(mytype), dimension(ny,nz) :: sx
  real(mytype), dimension(nxm) :: cfx6,csx6,cwx6
  integer :: i,j,k,nyz



  nyz=ny*nz

  if (nclx) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=acix6*(ux(2,j,k)-ux(1  ,j,k))&
                +bcix6*(ux(3,j,k)-ux(nx,j,k))
           rx(1,j,k)=-1.
           tx(2,j,k)=acix6*(ux(3,j,k)-ux(2 ,j,k))&
                +bcix6*(ux(4,j,k)-ux(1,j,k))
           rx(2,j,k)=0.
           do i=3,nx-2
              tx(i,j,k)=acix6*(ux(i+1,j,k)-ux(i,j,k))&
                   +bcix6*(ux(i+2,j,k)-ux(i-1,j,k))
              rx(i,j,k)=0.
           enddo
           tx(nx-1,j,k)=acix6*(ux(nx,j,k)-ux(nx-1,j,k))&
                +bcix6*(ux(1 ,j,k)-ux(nx-2,j,k))
           rx(nx-1,j,k)=0.
           tx(nx  ,j,k)=acix6*(ux(1,j,k)-ux(nx,j,k))&
                +bcix6*(ux(2,j,k)-ux(nx-1,j,k))
           rx(nx  ,j,k)=alcaix6
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*csx6(i)
              rx(i,j,k)=rx(i,j,k)-rx(i-1,j,k)*csx6(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*cwx6(nx)
           rx(nx,j,k)=rx(nx,j,k)*cwx6(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-cfx6(i)*tx(i+1,j,k))*cwx6(i)
              rx(i,j,k)=(rx(i,j,k)-cfx6(i)*rx(i+1,j,k))*cwx6(i)
           enddo
           sx(j,k)=(tx(1,j,k)-alcaix6*tx(nx,j,k))/&
                (1.+rx(1,j,k)-alcaix6*rx(nx,j,k))
           do i=1,nx
              tx(i,j,k)=tx(i,j,k)-sx(j,k)*rx(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do j=1,ny
              tx(1,j,k)=acix6*(ux(2,j,k)-ux(1,j,k))&
                   +bcix6*(ux(3,j,k)-ux(2,j,k))
              tx(2,j,k)=acix6*(ux(3,j,k)-ux(2,j,k))&
                   +bcix6*(ux(4,j,k)-ux(1,j,k))
              do i=3,nxm-2
                 tx(i,j,k)=acix6*(ux(i+1,j,k)-ux(i,j,k))&
                      +bcix6*(ux(i+2,j,k)-ux(i-1,j,k))
              enddo
              tx(nxm-1,j,k)=acix6*(ux(nxm,j,k)-ux(nxm-1,j,k))&
                   +bcix6*(ux(nx,j,k)-ux(nxm-2,j,k))
              tx(nxm,j,k)=acix6*(ux(nx,j,k)-ux(nxm,j,k))&
                   +bcix6*(ux(nxm,j,k)-ux(nxm-1,j,k))
              do i=2,nxm
                 tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*csx6(i)
              enddo
              tx(nxm,j,k)=tx(nxm,j,k)*cwx6(nxm)
              do i=nxm-1,1,-1
                 tx(i,j,k)=(tx(i,j,k)-cfx6(i)*tx(i+1,j,k))*cwx6(i)
              enddo
           enddo
        enddo
     endif
     if (npaire==0) then
        do k=1,nz
           do j=1,ny
              tx(1,j,k)=acix6*(ux(2,j,k)-ux(1,j,k))&
                   +bcix6*(ux(3,j,k)-2.*ux(1,j,k)+ux(2,j,k))
              tx(2,j,k)=acix6*(ux(3,j,k)-ux(2,j,k))&
                   +bcix6*(ux(4,j,k)-ux(1,j,k))
              do i=3,nxm-2
                 tx(i,j,k)=acix6*(ux(i+1,j,k)-ux(i,j,k))&
                      +bcix6*(ux(i+2,j,k)-ux(i-1,j,k))
              enddo
              tx(nxm-1,j,k)=acix6*(ux(nxm,j,k)-ux(nxm-1,j,k))&
                   +bcix6*(ux(nx,j,k)-ux(nxm-2,j,k))
              tx(nxm,j,k)=acix6*(ux(nx,j,k)-ux(nxm,j,k))&
                   +bcix6*(2.*ux(nx,j,k)-ux(nxm,j,k)-ux(nxm-1,j,k))
              do i=2,nxm
                 tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*csx6(i)
              enddo
              tx(nxm,j,k)=tx(nxm,j,k)*cwx6(nxm)
              do i=nxm-1,1,-1
                 tx(i,j,k)=(tx(i,j,k)-cfx6(i)*tx(i+1,j,k))*cwx6(i)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine derxvp

!********************************************************************
!
subroutine interxvp(tx,ux,rx,sx,cifx6,cisx6,ciwx6,nx,nxm,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,nxm,ny,nz,npaire,i,j,nyz,k
  real(mytype), dimension(nxm,ny,nz) :: tx
  real(mytype), dimension(nx,ny,nz) :: ux,rx
  real(mytype), dimension(ny,nz) :: sx
  real(mytype), dimension(nxm) :: cifx6,cisx6,ciwx6

  nyz=ny*nz

  if (nclx) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=aicix6*(ux(2,j,k)+ux(1  ,j,k))&
                +bicix6*(ux(3,j,k)+ux(nx,j,k))&
                +cicix6*(ux(4,j,k)+ux(nx-1,j,k))&
                +dicix6*(ux(5,j,k)+ux(nx-2,j,k))
           rx(1,j,k)=-1.
           tx(2,j,k)=aicix6*(ux(3,j,k)+ux(2 ,j,k))&
                +bicix6*(ux(4,j,k)+ux(1,j,k))&
                +cicix6*(ux(5,j,k)+ux(nx,j,k))&
                +dicix6*(ux(6,j,k)+ux(nx-1,j,k))
           rx(2,j,k)=0.
           tx(3,j,k)=aicix6*(ux(4,j,k)+ux(3 ,j,k))&
                +bicix6*(ux(5,j,k)+ux(2,j,k))&
                +cicix6*(ux(6,j,k)+ux(1,j,k))&
                +dicix6*(ux(7,j,k)+ux(nx,j,k))
           rx(3,j,k)=0.
           do i=4,nx-4
              tx(i,j,k)=aicix6*(ux(i+1,j,k)+ux(i,j,k))&
                   +bicix6*(ux(i+2,j,k)+ux(i-1,j,k))&
                   +cicix6*(ux(i+3,j,k)+ux(i-2,j,k))&
                   +dicix6*(ux(i+4,j,k)+ux(i-3,j,k))

              rx(i,j,k)=0.
           enddo
           tx(nx-3,j,k)=aicix6*(ux(nx-2,j,k)+ux(nx-3,j,k))&
                +bicix6*(ux(nx-1,j,k)+ux(nx-4,j,k))&
                +cicix6*(ux(nx,j,k)+ux(nx-5,j,k))&
                +dicix6*(ux(1,j,k)+ux(nx-6,j,k))
           rx(nx-3,j,k)=0.
           tx(nx-2,j,k)=aicix6*(ux(nx-1,j,k)+ux(nx-2,j,k))&
                +bicix6*(ux(nx ,j,k)+ux(nx-3,j,k))&
                +cicix6*(ux(1,j,k)+ux(nx-4,j,k))&
                +dicix6*(ux(2,j,k)+ux(nx-5,j,k))
           rx(nx-2,j,k)=0.
           tx(nx-1,j,k)=aicix6*(ux(nx,j,k)+ux(nx-1,j,k))&
                +bicix6*(ux(1 ,j,k)+ux(nx-2,j,k))&
                +cicix6*(ux(2,j,k)+ux(nx-3,j,k))&
                +dicix6*(ux(3,j,k)+ux(nx-4,j,k))
           rx(nx-1,j,k)=0.
           tx(nx  ,j,k)=aicix6*(ux(1,j,k)+ux(nx,j,k))&
                +bicix6*(ux(2,j,k)+ux(nx-1,j,k))&
                +cicix6*(ux(3,j,k)+ux(nx-2,j,k))&
                +dicix6*(ux(4,j,k)+ux(nx-3,j,k))
           rx(nx  ,j,k)=ailcaix6
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*cisx6(i)
              rx(i,j,k)=rx(i,j,k)-rx(i-1,j,k)*cisx6(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*ciwx6(nx)
           rx(nx,j,k)=rx(nx,j,k)*ciwx6(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-cifx6(i)*tx(i+1,j,k))*ciwx6(i)
              rx(i,j,k)=(rx(i,j,k)-cifx6(i)*rx(i+1,j,k))*ciwx6(i)
           enddo
           sx(j,k)=(tx(1,j,k)-ailcaix6*tx(nx,j,k))/&
                (1.+rx(1,j,k)-ailcaix6*rx(nx,j,k))
           do i=1,nx
              tx(i,j,k)=tx(i,j,k)-sx(j,k)*rx(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do j=1,ny
              tx(1,j,k)=aicix6*(ux(2,j,k)+ux(1,j,k))&
                   +bicix6*(ux(3,j,k)+ux(2,j,k))&
                   +cicix6*(ux(4,j,k)+ux(3,j,k))&
                   +dicix6*(ux(5,j,k)+ux(4,j,k))
              tx(2,j,k)=aicix6*(ux(3,j,k)+ux(2,j,k))&
                   +bicix6*(ux(4,j,k)+ux(1,j,k))&
                   +cicix6*(ux(5,j,k)+ux(2,j,k))&
                   +dicix6*(ux(6,j,k)+ux(3,j,k))
              tx(3,j,k)=aicix6*(ux(4,j,k)+ux(3,j,k))&
                   +bicix6*(ux(5,j,k)+ux(2,j,k))&
                   +cicix6*(ux(6,j,k)+ux(1,j,k))&
                   +dicix6*(ux(7,j,k)+ux(2,j,k))
              do i=4,nxm-3
                 tx(i,j,k)=aicix6*(ux(i+1,j,k)+ux(i,j,k))&
                      +bicix6*(ux(i+2,j,k)+ux(i-1,j,k))&
                      +cicix6*(ux(i+3,j,k)+ux(i-2,j,k))&
                      +dicix6*(ux(i+4,j,k)+ux(i-3,j,k))
              enddo
              tx(nxm-2,j,k)=aicix6*(ux(nxm-1,j,k)+ux(nxm-2,j,k))&
                   +bicix6*(ux(nxm,j,k)+ux(nxm-3,j,k))&
                   +cicix6*(ux(nx,j,k)+ux(nxm-4,j,k))&
                   +dicix6*(ux(nxm,j,k)+ux(nxm-5,j,k))
              tx(nxm-1,j,k)=aicix6*(ux(nxm,j,k)+ux(nxm-1,j,k))&
                   +bicix6*(ux(nx,j,k)+ux(nxm-2,j,k))&
                   +cicix6*(ux(nxm,j,k)+ux(nxm-3,j,k))&
                   +dicix6*(ux(nxm-1,j,k)+ux(nxm-4,j,k))
              tx(nxm,j,k)=aicix6*(ux(nx,j,k)+ux(nxm,j,k))&
                   +bicix6*(ux(nxm,j,k)+ux(nxm-1,j,k))&
                   +cicix6*(ux(nxm-1,j,k)+ux(nxm-2,j,k))&
                   +dicix6*(ux(nxm-2,j,k)+ux(nxm-3,j,k))
              do i=2,nxm
                 tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*cisx6(i)
              enddo
              tx(nxm,j,k)=tx(nxm,j,k)*ciwx6(nxm)
              do i=nxm-1,1,-1
                 tx(i,j,k)=(tx(i,j,k)-cifx6(i)*tx(i+1,j,k))*ciwx6(i)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interxvp

!********************************************************************
!
subroutine derxpv(tx,ux,rx,sx,cfi6,csi6,cwi6,cfx6,csx6,cwx6,nxm,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,nxm,ny,nz,npaire
  real(mytype), dimension(nx,ny,nz) :: tx
  real(mytype), dimension(nxm,ny,nz) :: ux,rx
  real(mytype), dimension(ny,nz) :: sx
  real(mytype), dimension(nx) :: cfi6,csi6,cwi6
  real(mytype), dimension(nx) :: cfx6,csx6,cwx6
  integer :: i,j,k

  if (nclx) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=acix6*(ux(1,j,k)-ux(nx  ,j,k))&
                +bcix6*(ux(2,j,k)-ux(nx-1,j,k))
           rx(1,j,k)=-1.
           tx(2,j,k)=acix6*(ux(2,j,k)-ux(1 ,j,k))&
                +bcix6*(ux(3,j,k)-ux(nx,j,k))
           rx(2,j,k)=0.
           do i=3,nx-2
              tx(i,j,k)=acix6*(ux(i,j,k)-ux(i-1,j,k))&
                   +bcix6*(ux(i+1,j,k)-ux(i-2,j,k))
              rx(i,j,k)=0.
           enddo
           tx(nx-1,j,k)=acix6*(ux(nx-1,j,k)-ux(nx-2,j,k))&
                +bcix6*(ux(nx ,j,k)-ux(nx-3,j,k))
           rx(nx-1,j,k)=0.
           tx(nx  ,j,k)=acix6*(ux(nx,j,k)-ux(nx-1,j,k))&
                +bcix6*(ux(1,j,k)-ux(nx-2,j,k))
           rx(nx  ,j,k)=alcaix6
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*csx6(i)
              rx(i,j,k)=rx(i,j,k)-rx(i-1,j,k)*csx6(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*cwx6(nx)
           rx(nx,j,k)=rx(nx,j,k)*cwx6(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-cfx6(i)*tx(i+1,j,k))*cwx6(i)
              rx(i,j,k)=(rx(i,j,k)-cfx6(i)*rx(i+1,j,k))*cwx6(i)
           enddo
           sx(j,k)=(tx(1,j,k)-alcaix6*tx(nx,j,k))/&
                (1.+rx(1,j,k)-alcaix6*rx(nx,j,k))
           do i=1,nx
              tx(i,j,k)=tx(i,j,k)-sx(j,k)*rx(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do j=1,ny
              tx(1,j,k)=0.
              tx(2,j,k)=acix6*(ux(2,j,k)-ux(1,j,k))&
                   +bcix6*(ux(3,j,k)-ux(1,j,k))
              do i=3,nx-2
                 tx(i,j,k)=acix6*(ux(i,j,k)-ux(i-1,j,k))&
                      +bcix6*(ux(i+1,j,k)-ux(i-2,j,k))
              enddo
              tx(nx-1,j,k)=acix6*(ux(nx-1,j,k)-ux(nx-2,j,k))&
                   +bcix6*(ux(nx-1,j,k)-ux(nx-3,j,k))
              tx(nx,j,k)=0.
              do i=2,nx
                 tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*csi6(i)
              enddo
              tx(nx,j,k)=tx(nx,j,k)*cwi6(nx)
              do i=nx-1,1,-1
                 tx(i,j,k)=(tx(i,j,k)-cfi6(i)*tx(i+1,j,k))*cwi6(i)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine derxpv

!********************************************************************
!
subroutine interxpv(tx,ux,rx,sx,cifi6,cisi6,ciwi6,cifx6,cisx6,ciwx6,&
     nxm,nx,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  use derivX

  implicit none

  integer :: nx,nxm,ny,nz,npaire
  real(mytype), dimension(nx,ny,nz) :: tx,rx
  real(mytype), dimension(nxm,ny,nz) :: ux
  real(mytype), dimension(ny,nz) :: sx
  real(mytype), dimension(nx) :: cifi6,cisi6,ciwi6
  real(mytype), dimension(nx) :: cifx6,cisx6,ciwx6
  integer :: i,j,k

  if (nclx) then
     do k=1,nz
        do j=1,ny
           tx(1,j,k)=aicix6*(ux(1,j,k)+ux(nx  ,j,k))&
                +bicix6*(ux(2,j,k)+ux(nx-1,j,k))&
                +cicix6*(ux(3,j,k)+ux(nx-2,j,k))&
                +dicix6*(ux(4,j,k)+ux(nx-3,j,k))
           rx(1,j,k)=-1.
           tx(2,j,k)=aicix6*(ux(2,j,k)+ux(1 ,j,k))&
                +bicix6*(ux(3,j,k)+ux(nx,j,k))&
                +cicix6*(ux(4,j,k)+ux(nx-1,j,k))&
                +dicix6*(ux(5,j,k)+ux(nx-2,j,k))
           rx(2,j,k)=0.
           tx(3,j,k)=aicix6*(ux(3,j,k)+ux(2 ,j,k))&
                +bicix6*(ux(4,j,k)+ux(1,j,k))&
                +cicix6*(ux(5,j,k)+ux(nx,j,k))&
                +dicix6*(ux(6,j,k)+ux(nx-1,j,k))
           rx(3,j,k)=0.
           tx(4,j,k)=aicix6*(ux(4,j,k)+ux(3 ,j,k))&
                +bicix6*(ux(5,j,k)+ux(2,j,k))&
                +cicix6*(ux(6,j,k)+ux(1,j,k))&
                +dicix6*(ux(7,j,k)+ux(nx,j,k))
           rx(4,j,k)=0.
           do i=5,nx-3
              tx(i,j,k)=aicix6*(ux(i,j,k)+ux(i-1,j,k))&
                   +bicix6*(ux(i+1,j,k)+ux(i-2,j,k))&
                   +cicix6*(ux(i+2,j,k)+ux(i-3,j,k))&
                   +dicix6*(ux(i+3,j,k)+ux(i-4,j,k))
              rx(i,j,k)=0.
           enddo
           tx(nx-2,j,k)=aicix6*(ux(nx-2,j,k)+ux(nx-3,j,k))&
                +bicix6*(ux(nx-1,j,k)+ux(nx-4,j,k))&
                +cicix6*(ux(nx,j,k)+ux(nx-5,j,k))&
                +dicix6*(ux(1,j,k)+ux(nx-6,j,k))
           rx(nx-2,j,k)=0.
           tx(nx-1,j,k)=aicix6*(ux(nx-1,j,k)+ux(nx-2,j,k))&
                +bicix6*(ux(nx ,j,k)+ux(nx-3,j,k))&
                +cicix6*(ux(1,j,k)+ux(nx-4,j,k))&
                +dicix6*(ux(2,j,k)+ux(nx-5,j,k))
           rx(nx-1,j,k)=0.
           tx(nx  ,j,k)=aicix6*(ux(nx,j,k)+ux(nx-1,j,k))&
                +bicix6*(ux(1,j,k)+ux(nx-2,j,k))&
                +cicix6*(ux(2,j,k)+ux(nx-3,j,k))&
                +dicix6*(ux(3,j,k)+ux(nx-4,j,k))
           rx(nx  ,j,k)=ailcaix6
           do i=2,nx
              tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*cisx6(i)
              rx(i,j,k)=rx(i,j,k)-rx(i-1,j,k)*cisx6(i)
           enddo
           tx(nx,j,k)=tx(nx,j,k)*ciwx6(nx)
           rx(nx,j,k)=rx(nx,j,k)*ciwx6(nx)
           do i=nx-1,1,-1
              tx(i,j,k)=(tx(i,j,k)-cifx6(i)*tx(i+1,j,k))*ciwx6(i)
              rx(i,j,k)=(rx(i,j,k)-cifx6(i)*rx(i+1,j,k))*ciwx6(i)
           enddo
           sx(j,k)=(tx(1,j,k)-ailcaix6*tx(nx,j,k))/&
                (1.+rx(1,j,k)-ailcaix6*rx(nx,j,k))
           do i=1,nx
              tx(i,j,k)=tx(i,j,k)-sx(j,k)*rx(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do j=1,ny
              tx(1,j,k)=aicix6*(ux(1,j,k)+ux(1,j,k))&
                   +bicix6*(ux(2,j,k)+ux(2,j,k))&
                   +cicix6*(ux(3,j,k)+ux(3,j,k))&
                   +dicix6*(ux(4,j,k)+ux(4,j,k))
              tx(2,j,k)=aicix6*(ux(2,j,k)+ux(1,j,k))&
                   +bicix6*(ux(3,j,k)+ux(1,j,k))&
                   +cicix6*(ux(4,j,k)+ux(2,j,k))&
                   +dicix6*(ux(5,j,k)+ux(3,j,k))
              tx(3,j,k)=aicix6*(ux(3,j,k)+ux(2,j,k))&
                   +bicix6*(ux(4,j,k)+ux(1,j,k))&
                   +cicix6*(ux(5,j,k)+ux(1,j,k))&
                   +dicix6*(ux(6,j,k)+ux(2,j,k))
              tx(4,j,k)=aicix6*(ux(4,j,k)+ux(3,j,k))&
                   +bicix6*(ux(5,j,k)+ux(2,j,k))&
                   +cicix6*(ux(6,j,k)+ux(1,j,k))&
                   +dicix6*(ux(7,j,k)+ux(1,j,k))
              do i=5,nx-4
                 tx(i,j,k)=aicix6*(ux(i,j,k)+ux(i-1,j,k))&
                      +bicix6*(ux(i+1,j,k)+ux(i-2,j,k))&
                      +cicix6*(ux(i+2,j,k)+ux(i-3,j,k))&
                      +dicix6*(ux(i+3,j,k)+ux(i-4,j,k))
              enddo
              tx(nx-3,j,k)=aicix6*(ux(nx-3,j,k)+ux(nx-4,j,k))&
                   +bicix6*(ux(nx-2,j,k)+ux(nx-5,j,k))&
                   +cicix6*(ux(nx-1,j,k)+ux(nx-6,j,k))&
                   +dicix6*(ux(nx-1,j,k)+ux(nx-7,j,k))
              tx(nx-2,j,k)=aicix6*(ux(nx-2,j,k)+ux(nx-3,j,k))&
                   +bicix6*(ux(nx-1,j,k)+ux(nx-4,j,k))&
                   +cicix6*(ux(nx-1,j,k)+ux(nx-5,j,k))&
                   +dicix6*(ux(nx-2,j,k)+ux(nx-6,j,k))
              tx(nx-1,j,k)=aicix6*(ux(nx-1,j,k)+ux(nx-2,j,k))&
                   +bicix6*(ux(nx-1,j,k)+ux(nx-3,j,k))&
                   +cicix6*(ux(nx-2,j,k)+ux(nx-4,j,k))&
                   +dicix6*(ux(nx-3,j,k)+ux(nx-5,j,k))
              tx(nx,j,k)=aicix6*(ux(nx-1,j,k)+ux(nx-1,j,k))&
                   +bicix6*(ux(nx-2,j,k)+ux(nx-2,j,k))&
                   +cicix6*(ux(nx-3,j,k)+ux(nx-3,j,k))&
                   +dicix6*(ux(nx-4,j,k)+ux(nx-4,j,k))
              do i=2,nx
                 tx(i,j,k)=tx(i,j,k)-tx(i-1,j,k)*cisi6(i)
              enddo
              tx(nx,j,k)=tx(nx,j,k)*ciwi6(nx)
              do i=nx-1,1,-1
                 tx(i,j,k)=(tx(i,j,k)-cifi6(i)*tx(i+1,j,k))*ciwi6(i)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interxpv

!********************************************************************
!
subroutine interyvp(ty,uy,ry,sy,cify6,cisy6,ciwy6,nx,ny,nym,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivY

  implicit none

  integer :: nx,ny,nym,nz,npaire
  real(mytype), dimension(nx,nym,nz) :: ty
  real(mytype), dimension(nx,ny,nz) :: uy,ry
  real(mytype), dimension(nx,nz) :: sy
  real(mytype), dimension(nym) :: cify6,cisy6,ciwy6
  integer :: i,j,k

  if (ncly) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=aiciy6*(uy(i,2,k)+uy(i,1,k))&
                +biciy6*(uy(i,3,k)+uy(i,ny,k))&
                +ciciy6*(uy(i,4,k)+uy(i,ny-1,k))&
                +diciy6*(uy(i,5,k)+uy(i,ny-2,k))
           ry(i,1,k)=-1.
           ty(i,2,k)=aiciy6*(uy(i,3,k)+uy(i,2,k))&
                +biciy6*(uy(i,4,k)+uy(i,1,k))&
                +ciciy6*(uy(i,5,k)+uy(i,ny,k))&
                +diciy6*(uy(i,6,k)+uy(i,ny-1,k))
           ry(i,2,k)=0.
           ty(i,3,k)=aiciy6*(uy(i,4,k)+uy(i,3,k))&
                +biciy6*(uy(i,5,k)+uy(i,2,k))&
                +ciciy6*(uy(i,6,k)+uy(i,1,k))&
                +diciy6*(uy(i,7,k)+uy(i,ny,k))
           ry(i,3,k)=0.
        enddo
     enddo
     do k=1,nz
        do j=4,ny-4
           do i=1,nx
              ty(i,j,k)=aiciy6*(uy(i,j+1,k)+uy(i,j,k))&
                   +biciy6*(uy(i,j+2,k)+uy(i,j-1,k))&
                   +ciciy6*(uy(i,j+3,k)+uy(i,j-2,k))&
                   +diciy6*(uy(i,j+4,k)+uy(i,j-3,k))
              ry(i,j,k)=0.
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-3,k)=aiciy6*(uy(i,ny-2,k)+uy(i,ny-3,k))&
                +biciy6*(uy(i,ny-1,k)+uy(i,ny-4,k))&
                +ciciy6*(uy(i,ny,k)+uy(i,ny-5,k))&
                +diciy6*(uy(i,1,k)+uy(i,ny-6,k))
           ry(i,ny-3,k)=0.
           ty(i,ny-2,k)=aiciy6*(uy(i,ny-1,k)+uy(i,ny-2,k))&
                +biciy6*(uy(i,ny,k)+uy(i,ny-3,k))&
                +ciciy6*(uy(i,1,k)+uy(i,ny-4,k))&
                +diciy6*(uy(i,2,k)+uy(i,ny-5,k))
           ry(i,ny-2,k)=0.
           ty(i,ny-1,k)=aiciy6*(uy(i,ny,k)+uy(i,ny-1,k))&
                +biciy6*(uy(i,1,k)+uy(i,ny-2,k))&
                +ciciy6*(uy(i,2,k)+uy(i,ny-3,k))&
                +diciy6*(uy(i,3,k)+uy(i,ny-4,k))
           ry(i,ny-1,k)=0.
           ty(i,ny,k)=aiciy6*(uy(i,1,k)+uy(i,ny,k))&
                +biciy6*(uy(i,2,k)+uy(i,ny-1,k))&
                +ciciy6*(uy(i,3,k)+uy(i,ny-2,k))&
                +diciy6*(uy(i,4,k)+uy(i,ny-3,k))
           ry(i,ny,k)=ailcaiy6
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*cisy6(j)
              ry(i,j,k)=ry(i,j,k)-ry(i,j-1,k)*cisy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*ciwy6(ny)
           ry(i,ny,k)=ry(i,ny,k)*ciwy6(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-cify6(j)*ty(i,j+1,k))*ciwy6(j)
              ry(i,j,k)=(ry(i,j,k)-cify6(j)*ry(i,j+1,k))*ciwy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           sy(i,k)=(ty(i,1,k)-ailcaiy6*ty(i,ny,k))&
                /(1.+ry(i,1,k)-ailcaiy6*ry(i,ny,k))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-sy(i,k)*ry(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do i=1,nx
              ty(i,1,k)=aiciy6*(uy(i,2,k)+uy(i,1,k))&
                   +biciy6*(uy(i,3,k)+uy(i,2,k))&
                   +ciciy6*(uy(i,4,k)+uy(i,3,k))&
                   +diciy6*(uy(i,5,k)+uy(i,4,k))
              ty(i,2,k)=aiciy6*(uy(i,3,k)+uy(i,2,k))&
                   +biciy6*(uy(i,4,k)+uy(i,1,k))&
                   +ciciy6*(uy(i,5,k)+uy(i,2,k))&
                   +diciy6*(uy(i,6,k)+uy(i,3,k))
              ty(i,3,k)=aiciy6*(uy(i,4,k)+uy(i,3,k))&
                   +biciy6*(uy(i,5,k)+uy(i,2,k))&
                   +ciciy6*(uy(i,6,k)+uy(i,1,k))&
                   +diciy6*(uy(i,7,k)+uy(i,2,k))
           enddo
        enddo
        do k=1,nz
           do j=4,nym-3
              do i=1,nx
                 ty(i,j,k)=aiciy6*(uy(i,j+1,k)+uy(i,j,k))&
                      +biciy6*(uy(i,j+2,k)+uy(i,j-1,k))&
                      +ciciy6*(uy(i,j+3,k)+uy(i,j-2,k))&
                      +diciy6*(uy(i,j+4,k)+uy(i,j-3,k))
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,nym-2,k)=aiciy6*(uy(i,nym-1,k)+uy(i,nym-2,k))&
                   +biciy6*(uy(i,nym,k)+uy(i,nym-3,k))&
                   +ciciy6*(uy(i,ny,k)+uy(i,nym-4,k))&
                   +diciy6*(uy(i,nym,k)+uy(i,nym-5,k))
              ty(i,nym-1,k)=aiciy6*(uy(i,nym,k)+uy(i,nym-1,k))&
                   +biciy6*(uy(i,ny,k)+uy(i,nym-2,k))&
                   +ciciy6*(uy(i,nym,k)+uy(i,nym-3,k))&
                   +diciy6*(uy(i,nym-1,k)+uy(i,nym-4,k))
              ty(i,nym,k)=aiciy6*(uy(i,ny,k)+uy(i,nym,k))&
                   +biciy6*(uy(i,nym,k)+uy(i,nym-1,k))&
                   +ciciy6*(uy(i,nym-1,k)+uy(i,nym-2,k))&
                   +diciy6*(uy(i,nym-2,k)+uy(i,nym-3,k))
           enddo
        enddo
        do k=1,nz
           do j=2,nym
              do i=1,nx
                 ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*cisy6(j)
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,nym,k)=ty(i,nym,k)*ciwy6(nym)
           enddo
        enddo
        do k=1,nz
           do j=nym-1,1,-1
              do i=1,nx
                 ty(i,j,k)=(ty(i,j,k)-cify6(j)*ty(i,j+1,k))*ciwy6(j)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interyvp

!********************************************************************
!
subroutine deryvp(ty,uy,ry,sy,cfy6,csy6,cwy6,ppyi,nx,ny,nym,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivY

  implicit none

  integer :: nx,ny,nym,nz,npaire
  real(mytype), dimension(nx,nym,nz) :: ty
  real(mytype), dimension(nx,ny,nz) :: uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz) :: sy
  real(mytype), dimension(nym) :: cfy6,csy6,cwy6,ppyi
  integer :: i,j,k

  if (ncly) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=aciy6*(uy(i,2,k)-uy(i,1,k))&
                +bciy6*(uy(i,3,k)-uy(i,ny,k))
           ry(i,1,k)=-1.
           ty(i,2,k)=aciy6*(uy(i,3,k)-uy(i,2,k))&
                +bciy6*(uy(i,4,k)-uy(i,1,k))
           ry(i,2,k)=0.
        enddo
     enddo
     do k=1,nz
        do j=3,ny-2
           do i=1,nx
              ty(i,j,k)=aciy6*(uy(i,j+1,k)-uy(i,j,k))&
                   +bciy6*(uy(i,j+2,k)-uy(i,j-1,k))
              ry(i,j,k)=0.
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=aciy6*(uy(i,ny,k)-uy(i,ny-1,k))&
                +bciy6*(uy(i,1,k)-uy(i,ny-2,k))
           ry(i,ny-1,k)=0.
           ty(i,ny,k)=aciy6*(uy(i,1,k)-uy(i,ny,k))&
                +bciy6*(uy(i,2,k)-uy(i,ny-1,k))
           ry(i,ny,k)=alcaiy6
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*csy6(j)
              ry(i,j,k)=ry(i,j,k)-ry(i,j-1,k)*csy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*cwy6(ny)
           ry(i,ny,k)=ry(i,ny,k)*cwy6(ny)
        enddo
     enddo
     do k=1,nz
        do j=ny-1,1,-1
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-cfy6(j)*ty(i,j+1,k))*cwy6(j)
              ry(i,j,k)=(ry(i,j,k)-cfy6(j)*ry(i,j+1,k))*cwy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           sy(i,k)=(ty(i,1,k)-alcaiy6*ty(i,ny,k))&
                /(1.+ry(i,1,k)-alcaiy6*ry(i,ny,k))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-sy(i,k)*ry(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==0) then
        do k=1,nz
           do i=1,nx
              ty(i,1,k)=aciy6*(uy(i,2,k)-uy(i,1,k))&
                   +bciy6*(uy(i,3,k)-2.*uy(i,1,k)+uy(i,2,k))
              ty(i,2,k)=aciy6*(uy(i,3,k)-uy(i,2,k))&
                   +bciy6*(uy(i,4,k)-uy(i,1,k))
           enddo
        enddo
        do k=1,nz
           do j=3,nym-2
              do i=1,nx
                 ty(i,j,k)=aciy6*(uy(i,j+1,k)-uy(i,j,k))&
                      +bciy6*(uy(i,j+2,k)-uy(i,j-1,k))
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,nym-1,k)=aciy6*(uy(i,nym,k)-uy(i,nym-1,k))&
                   +bciy6*(uy(i,ny,k)-uy(i,nym-2,k))
              ty(i,nym,k)=aciy6*(uy(i,ny,k)-uy(i,nym,k))&
                   +bciy6*(2.*uy(i,ny,k)-uy(i,nym,k)-uy(i,nym-1,k))
           enddo
        enddo
        do k=1,nz
           do j=2,nym
              do i=1,nx
                 ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*csy6(j)
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,nym,k)=ty(i,nym,k)*cwy6(nym)
           enddo
        enddo
        do k=1,nz
           do j=nym-1,1,-1
              do i=1,nx
                 ty(i,j,k)=(ty(i,j,k)-cfy6(j)*ty(i,j+1,k))*cwy6(j)
              enddo
           enddo
        enddo
     endif
  endif

  if (istret.ne.0) then
     do k=1,nz
        do j=1,nym
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppyi(j)
           enddo
        enddo
     enddo
  endif

  return
end subroutine deryvp

!********************************************************************
!
subroutine interypv(ty,uy,ry,sy,cifi6y,cisi6y,ciwi6y,cify6,cisy6,ciwy6,&
     nx,nym,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivY

  implicit none

  integer :: nx,ny,nym,nz,npaire
  real(mytype), dimension(nx,ny,nz) :: ty
  real(mytype), dimension(nx,nym,nz) :: uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz) :: sy
  real(mytype), dimension(ny) :: cifi6y,cisi6y,ciwi6y
  real(mytype), dimension(ny) :: cify6,cisy6,ciwy6
  integer :: i,j,k

  if (ncly) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=aiciy6*(uy(i,1,k)+uy(i,ny,k))&
                +biciy6*(uy(i,2,k)+uy(i,ny-1,k))&
                +ciciy6*(uy(i,3,k)+uy(i,ny-2,k))&
                +diciy6*(uy(i,4,k)+uy(i,ny-3,k))
           ry(i,1,k)=-1.
           ty(i,2,k)=aiciy6*(uy(i,2,k)+uy(i,1,k))&
                +biciy6*(uy(i,3,k)+uy(i,ny,k))&
                +ciciy6*(uy(i,4,k)+uy(i,ny-1,k))&
                +diciy6*(uy(i,5,k)+uy(i,ny-2,k))
           ry(i,2,k)=0.
           ty(i,3,k)=aiciy6*(uy(i,3,k)+uy(i,2,k))&
                +biciy6*(uy(i,4,k)+uy(i,1,k))&
                +ciciy6*(uy(i,5,k)+uy(i,ny,k))&
                +diciy6*(uy(i,6,k)+uy(i,ny-1,k))
           ry(i,3,k)=0.
           ty(i,4,k)=aiciy6*(uy(i,4,k)+uy(i,3,k))&
                +biciy6*(uy(i,5,k)+uy(i,2,k))&
                +ciciy6*(uy(i,6,k)+uy(i,1,k))&
                +diciy6*(uy(i,7,k)+uy(i,ny,k))
           ry(i,4,k)=0.
        enddo
     enddo
     do k=1,nz
        do j=5,ny-3
           do i=1,nx
              ty(i,j,k)=aiciy6*(uy(i,j,k)+uy(i,j-1,k))&
                   +biciy6*(uy(i,j+1,k)+uy(i,j-2,k))&
                   +ciciy6*(uy(i,j+2,k)+uy(i,j-3,k))&
                   +diciy6*(uy(i,j+3,k)+uy(i,j-4,k))
              ry(i,j,k)=0.
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-2,k)=aiciy6*(uy(i,ny-2,k)+uy(i,ny-3,k))&
                +biciy6*(uy(i,ny-1,k)+uy(i,ny-4,k))&
                +ciciy6*(uy(i,ny,k)+uy(i,ny-5,k))&
                +diciy6*(uy(i,1,k)+uy(i,ny-6,k))
           ry(i,ny-2,k)=0.
           ty(i,ny-1,k)=aiciy6*(uy(i,ny-1,k)+uy(i,ny-2,k))&
                +biciy6*(uy(i,ny,k)+uy(i,ny-3,k))&
                +ciciy6*(uy(i,1,k)+uy(i,ny-4,k))&
                +diciy6*(uy(i,2,k)+uy(i,ny-5,k))
           ry(i,ny-1,k)=0.
           ty(i,ny,k)=aiciy6*(uy(i,ny,k)+uy(i,ny-1,k))&
                +biciy6*(uy(i,1,k)+uy(i,ny-2,k))&
                +ciciy6*(uy(i,2,k)+uy(i,ny-3,k))&
                +diciy6*(uy(i,3,k)+uy(i,ny-4,k))
           ry(i,ny,k)=ailcaiy6
        enddo
     enddo
     do k=1,nz
        do j=2,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*cisy6(j)
              ry(i,j,k)=ry(i,j,k)-ry(i,j-1,k)*cisy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*ciwy6(ny)
           ry(i,ny,k)=ry(i,ny,k)*ciwy6(ny)
        enddo
     enddo
     do j=ny-1,1,-1
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-cify6(j)*ty(i,j+1,k))*ciwy6(j)
              ry(i,j,k)=(ry(i,j,k)-cify6(j)*ry(i,j+1,k))*ciwy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           sy(i,k)=(ty(i,1,k)-ailcaiy6*ty(i,ny,k))/&
                (1.+ry(i,1,k)-ailcaiy6*ry(i,ny,k))
        enddo
     enddo
     do j=1,ny
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-sy(i,k)*ry(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do i=1,nx
              ty(i,1,k)=aiciy6*(uy(i,1,k)+uy(i,1,k))&
                   +biciy6*(uy(i,2,k)+uy(i,2,k))&
                   +ciciy6*(uy(i,3,k)+uy(i,3,k))&
                   +diciy6*(uy(i,4,k)+uy(i,4,k))
              ty(i,2,k)=aiciy6*(uy(i,2,k)+uy(i,1,k))&
                   +biciy6*(uy(i,3,k)+uy(i,1,k))&
                   +ciciy6*(uy(i,4,k)+uy(i,2,k))&
                   +diciy6*(uy(i,5,k)+uy(i,3,k))
              ty(i,3,k)=aiciy6*(uy(i,3,k)+uy(i,2,k))&
                   +biciy6*(uy(i,4,k)+uy(i,1,k))&
                   +ciciy6*(uy(i,5,k)+uy(i,1,k))&
                   +diciy6*(uy(i,6,k)+uy(i,2,k))
              ty(i,4,k)=aiciy6*(uy(i,4,k)+uy(i,3,k))&
                   +biciy6*(uy(i,5,k)+uy(i,2,k))&
                   +ciciy6*(uy(i,6,k)+uy(i,1,k))&
                   +diciy6*(uy(i,7,k)+uy(i,1,k))
           enddo
        enddo
        do j=5,ny-4
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=aiciy6*(uy(i,j,k)+uy(i,j-1,k))&
                      +biciy6*(uy(i,j+1,k)+uy(i,j-2,k))&
                      +ciciy6*(uy(i,j+2,k)+uy(i,j-3,k))&
                      +diciy6*(uy(i,j+3,k)+uy(i,j-4,k))
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,ny-3,k)=aiciy6*(uy(i,ny-3,k)+uy(i,ny-4,k))&
                   +biciy6*(uy(i,ny-2,k)+uy(i,ny-5,k))&
                   +ciciy6*(uy(i,ny-1,k)+uy(i,ny-6,k))&
                   +diciy6*(uy(i,ny-1,k)+uy(i,ny-7,k))
              ty(i,ny-2,k)=aiciy6*(uy(i,ny-2,k)+uy(i,ny-3,k))&
                   +biciy6*(uy(i,ny-1,k)+uy(i,ny-4,k))&
                   +ciciy6*(uy(i,ny-1,k)+uy(i,ny-5,k))&
                   +diciy6*(uy(i,ny-2,k)+uy(i,ny-6,k))
              ty(i,ny-1,k)=aiciy6*(uy(i,ny-1,k)+uy(i,ny-2,k))&
                   +biciy6*(uy(i,ny-1,k)+uy(i,ny-3,k))&
                   +ciciy6*(uy(i,ny-2,k)+uy(i,ny-4,k))&
                   +diciy6*(uy(i,ny-3,k)+uy(i,ny-5,k))
              ty(i,ny,k)=aiciy6*(uy(i,ny-1,k)+uy(i,ny-1,k))&
                   +biciy6*(uy(i,ny-2,k)+uy(i,ny-2,k))&
                   +ciciy6*(uy(i,ny-3,k)+uy(i,ny-3,k))&
                   +diciy6*(uy(i,ny-4,k)+uy(i,ny-4,k))
           enddo
        enddo
        do j=2,ny
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*cisi6y(j)
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,ny,k)=ty(i,ny,k)*ciwi6y(ny)
           enddo
        enddo
        do j=ny-1,1,-1
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=(ty(i,j,k)-cifi6y(j)*ty(i,j+1,k))*ciwi6y(j)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interypv

!********************************************************************
!
subroutine derypv(ty,uy,ry,sy,cfi6y,csi6y,cwi6y,cfy6,csy6,cwy6,&
     ppy,nx,nym,ny,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivY

  implicit none

  integer :: nx,ny,nym,nz,npaire
  real(mytype), dimension(nx,ny,nz) :: ty
  real(mytype), dimension(nx,nym,nz) :: uy
  real(mytype), dimension(nx,ny,nz) :: ry
  real(mytype), dimension(nx,nz) :: sy
  real(mytype), dimension(ny) :: cfi6y,csi6y,cwi6y,ppy
  real(mytype), dimension(nym) :: cfy6,csy6,cwy6
  integer :: i,j,k

  if (ncly) then
     do k=1,nz
        do i=1,nx
           ty(i,1,k)=aciy6*(uy(i,1,k)-uy(i,ny,k))&
                +bciy6*(uy(i,2,k)-uy(i,ny-1,k))
           ry(i,1,k)=-1.
           ty(i,2,k)=aciy6*(uy(i,2,k)-uy(i,1,k))&
                +bciy6*(uy(i,3,k)-uy(i,ny,k))
           ry(i,2,k)=0.
        enddo
     enddo
     do j=3,ny-2
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=aciy6*(uy(i,j,k)-uy(i,j-1,k))&
                   +bciy6*(uy(i,j+1,k)-uy(i,j-2,k))
              ry(i,j,k)=0.
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny-1,k)=aciy6*(uy(i,ny-1,k)-uy(i,ny-2,k))&
                +bciy6*(uy(i,ny,k)-uy(i,ny-3,k))
           ry(i,ny-1,k)=0.
           ty(i,ny,k)=aciy6*(uy(i,ny,k)-uy(i,ny-1,k))&
                +bciy6*(uy(i,1,k)-uy(i,ny-2,k))
           ry(i,ny,k)=alcaiy6
        enddo
     enddo
     do j=2,ny
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*csy6(j)
              ry(i,j,k)=ry(i,j,k)-ry(i,j-1,k)*csy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           ty(i,ny,k)=ty(i,ny,k)*cwy6(ny)
           ry(i,ny,k)=ry(i,ny,k)*cwy6(ny)
        enddo
     enddo
     do j=ny-1,1,-1
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=(ty(i,j,k)-cfy6(j)*ty(i,j+1,k))*cwy6(j)
              ry(i,j,k)=(ry(i,j,k)-cfy6(j)*ry(i,j+1,k))*cwy6(j)
           enddo
        enddo
     enddo
     do k=1,nz
        do i=1,nx
           sy(i,k)=(ty(i,1,k)-alcaiy6*ty(i,ny,k))&
                /(1.+ry(i,1,k)-alcaiy6*ry(i,ny,k))
        enddo
     enddo
     do j=1,ny
        do k=1,nz
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)-sy(i,k)*ry(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do k=1,nz
           do i=1,nx
              ty(i,1,k)=0.
              ty(i,2,k)=aciy6*(uy(i,2,k)-uy(i,1,k))&
                   +bciy6*(uy(i,3,k)-uy(i,1,k))
           enddo
        enddo
        do j=3,ny-2
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=aciy6*(uy(i,j,k)-uy(i,j-1,k))&
                      +bciy6*(uy(i,j+1,k)-uy(i,j-2,k))
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,ny-1,k)=aciy6*(uy(i,ny-1,k)-uy(i,ny-2,k))&
                   +bciy6*(uy(i,ny-1,k)-uy(i,ny-3,k))
              ty(i,ny,k)=0.
           enddo
        enddo
        do j=2,ny
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=ty(i,j,k)-ty(i,j-1,k)*csi6y(j)
              enddo
           enddo
        enddo
        do k=1,nz
           do i=1,nx
              ty(i,ny,k)=ty(i,ny,k)*cwi6y(ny)
           enddo
        enddo
        do j=ny-1,1,-1
           do k=1,nz
              do i=1,nx
                 ty(i,j,k)=(ty(i,j,k)-cfi6y(j)*ty(i,j+1,k))*cwi6y(j)
              enddo
           enddo
        enddo
     endif
  endif

  if (istret.ne.0) then
     do k=1,nz
        do j=1,ny
           do i=1,nx
              ty(i,j,k)=ty(i,j,k)*ppy(j)
           enddo
        enddo
     enddo
  endif

  return
end subroutine derypv

!********************************************************************
!
subroutine derzvp(tz,uz,rz,sz,cfz6,csz6,cwz6,nx,ny,nz,nzm,npaire)
  !
  !********************************************************************

  USE param
  USE derivZ

  implicit none

  integer :: nx,ny,nz,nzm,npaire
  real(mytype), dimension(nx,ny,nzm) :: tz
  real(mytype), dimension(nx,ny,nz) :: uz
  real(mytype), dimension(nx,ny,nz) :: rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nzm) :: cfz6,csz6,cwz6
  integer :: i,j,k

  if (nclz) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=aciz6*(uz(i,j,2)-uz(i,j,1))&
                +bciz6*(uz(i,j,3)-uz(i,j,nz))
           rz(i,j,1)=-1.
           tz(i,j,2)=aciz6*(uz(i,j,3)-uz(i,j,2))&
                +bciz6*(uz(i,j,4)-uz(i,j,1))
           rz(i,j,2)=0.
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=aciz6*(uz(i,j,k+1)-uz(i,j,k))&
                   +bciz6*(uz(i,j,k+2)-uz(i,j,k-1))
              rz(i,j,k)=0.
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=aciz6*(uz(i,j,nz)-uz(i,j,nz-1))&
                +bciz6*(uz(i,j,1)-uz(i,j,nz-2))
           rz(i,j,nz-1)=0.
           tz(i,j,nz)=aciz6*(uz(i,j,1)-uz(i,j,nz))&
                +bciz6*(uz(i,j,2)-uz(i,j,nz-1))
           rz(i  ,j,nz)=alcaiz6
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*csz6(k)
              rz(i,j,k)=rz(i,j,k)-rz(i,j,k-1)*csz6(k)
           enddo
        enddo
     enddo
     do i=1,nx
        do j=1,ny
           tz(i,j,nz)=tz(i,j,nz)*cwz6(nz)
           rz(i,j,nz)=rz(i,j,nz)*cwz6(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-cfz6(k)*tz(i,j,k+1))*cwz6(k)
              rz(i,j,k)=(rz(i,j,k)-cfz6(k)*rz(i,j,k+1))*cwz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           sz(i,j)=(tz(i,j,1)-alcaiz6*tz(i,j,nz))/&
                (1.+rz(i,j,1)-alcaiz6*rz(i,j,nz))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-sz(i,j)*rz(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do j=1,ny
           do i=1,nx
              tz(i,j,1)=aciz6*(uz(i,j,2)-uz(i,j,1))&
                   +bciz6*(uz(i,j,3)-uz(i,j,2))
              tz(i,j,2)=aciz6*(uz(i,j,3)-uz(i,j,2))&
                   +bciz6*(uz(i,j,4)-uz(i,j,1))
           enddo
        enddo
        do k=3,nzm-2
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=aciz6*(uz(i,j,k+1)-uz(i,j,k))&
                      +bciz6*(uz(i,j,k+2)-uz(i,j,k-1))
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm-1)=aciz6*(uz(i,j,nzm)-uz(i,j,nzm-1))&
                   +bciz6*(uz(nz,j,k)-uz(nzm-2,j,k))
              tz(i,j,nzm)=aciz6*(uz(i,j,nz)-uz(i,j,nzm))&
                   +bciz6*(uz(i,j,nzm)-uz(i,j,nzm-1))
           enddo
        enddo
        do k=2,nzm
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*csz6(k)
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm)=tz(i,j,nzm)*cwz6(nzm)
           enddo
        enddo
        do k=nzm-1,1,-1
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=(tz(i,j,k)-cfz6(k)*tz(i,j,k+1))*cwz6(k)
              enddo
           enddo
        enddo
     endif
     if (npaire==0) then
        do j=1,ny
           do i=1,nx
              tz(i,j,1)=aciz6*(uz(i,j,2)-uz(i,j,1))&
                   +bciz6*(uz(i,j,3)-2.*uz(i,j,1)+uz(i,j,2))
              tz(i,j,2)=aciz6*(uz(i,j,3)-uz(i,j,2))&
                   +bciz6*(uz(i,j,4)-uz(i,j,1))
           enddo
        enddo
        do k=3,nzm-2
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=aciz6*(uz(i,j,k+1)-uz(i,j,k))&
                      +bciz6*(uz(i,j,k+2)-uz(i,j,k-1))
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm-1)=aciz6*(uz(i,j,nz-1)-uz(i,j,nz-2))&
                   +bciz6*(uz(i,j,nz)-uz(i,j,nz-3))
              tz(i,j,nzm)=aciz6*(uz(i,j,nz)-uz(i,j,nz-1))&
                   +bciz6*(2.*uz(i,j,nz)-uz(i,j,nz-1)-uz(i,j,nz-2))
           enddo
        enddo
        do k=2,nzm
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*csz6(k)
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm)=tz(i,j,nzm)*cwz6(nzm)
           enddo
        enddo
        do k=nzm-1,1,-1
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=(tz(i,j,k)-cfz6(k)*tz(i,j,k+1))*cwz6(k)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine derzvp

!********************************************************************
!
subroutine interzvp(tz,uz,rz,sz,cifz6,cisz6,ciwz6,nx,ny,nz,nzm,npaire)
  !
  !********************************************************************

  USE param
  USE derivZ

  implicit none

  integer :: nx,ny,nz,nzm,npaire
  real(mytype), dimension(nx,ny,nzm) :: tz
  real(mytype), dimension(nx,ny,nz) :: uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nzm) :: cifz6,cisz6,ciwz6
  integer :: i,j,k

  if (nclz) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=aiciz6*(uz(i,j,2)+uz(i,j,1))&
                +biciz6*(uz(i,j,3)+uz(i,j,nz))&
                +ciciz6*(uz(i,j,4)+uz(i,j,nz-1))&
                +diciz6*(uz(i,j,5)+uz(i,j,nz-2))
           rz(i,j,1)=-1.
           tz(i,j,2)=aiciz6*(uz(i,j,3)+uz(i,j,2))&
                +biciz6*(uz(i,j,4)+uz(i,j,1))&
                +ciciz6*(uz(i,j,5)+uz(i,j,nz))&
                +diciz6*(uz(i,j,6)+uz(i,j,nz-1))
           rz(i,j,2)=0.
           tz(i,j,3)=aiciz6*(uz(i,j,4)+uz(i,j,3))&
                +biciz6*(uz(i,j,5)+uz(i,j,2))&
                +ciciz6*(uz(i,j,6)+uz(i,j,1))&
                +diciz6*(uz(i,j,7)+uz(i,j,nz))
           rz(i,j,3)=0.
        enddo
     enddo
     do k=4,nz-4
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=aiciz6*(uz(i,j,k+1)+uz(i,j,k))&
                   +biciz6*(uz(i,j,k+2)+uz(i,j,k-1))&
                   +ciciz6*(uz(i,j,k+3)+uz(i,j,k-2))&
                   +diciz6*(uz(i,j,k+4)+uz(i,j,k-3))
              rz(i,j,k)=0.
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-3)=aiciz6*(uz(i,j,nz-2)+uz(i,j,nz-3))&
                +biciz6*(uz(i,j,nz-1)+uz(i,j,nz-4))&
                +ciciz6*(uz(i,j,nz)+uz(i,j,nz-5))&
                +diciz6*(uz(i,j,1)+uz(i,j,nz-6))
           rz(i,j,nz-3)=0.
           tz(i,j,nz-2)=aiciz6*(uz(i,j,nz-1)+uz(i,j,nz-2))&
                +biciz6*(uz(i,j,nz)+uz(i,j,nz-3))&
                +ciciz6*(uz(i,j,1)+uz(i,j,nz-4))&
                +diciz6*(uz(i,j,2)+uz(i,j,nz-5))
           rz(i,j,nz-2)=0.
           tz(i,j,nz-1)=aiciz6*(uz(i,j,nz)+uz(i,j,nz-1))&
                +biciz6*(uz(i,j,1)+uz(i,j,nz-2))&
                +ciciz6*(uz(i,j,2)+uz(i,j,nz-3))&
                +diciz6*(uz(i,j,3)+uz(i,j,nz-4))
           rz(i,j,nz-1)=0.
           tz(i,j,nz)=aiciz6*(uz(i,j,1)+uz(i,j,nz))&
                +biciz6*(uz(i,j,2)+uz(i,j,nz-1))&
                +ciciz6*(uz(i,j,3)+uz(i,j,nz-2))&
                +diciz6*(uz(i,j,4)+uz(i,j,nz-3))
           rz(i  ,j,nz)=ailcaiz6
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*cisz6(k)
              rz(i,j,k)=rz(i,j,k)-rz(i,j,k-1)*cisz6(k)
           enddo
        enddo
     enddo
     do i=1,nx
        do j=1,ny
           tz(i,j,nz)=tz(i,j,nz)*ciwz6(nz)
           rz(i,j,nz)=rz(i,j,nz)*ciwz6(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-cifz6(k)*tz(i,j,k+1))*ciwz6(k)
              rz(i,j,k)=(rz(i,j,k)-cifz6(k)*rz(i,j,k+1))*ciwz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           sz(i,j)=(tz(i,j,1)-ailcaiz6*tz(i,j,nz))/&
                (1.+rz(i,j,1)-ailcaiz6*rz(i,j,nz))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-sz(i,j)*rz(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do j=1,ny
           do i=1,nx
              tz(i,j,1)=aiciz6*(uz(i,j,2)+uz(i,j,1))&
                   +biciz6*(uz(i,j,3)+uz(i,j,2))&
                   +ciciz6*(uz(i,j,4)+uz(i,j,3))&
                   +diciz6*(uz(i,j,5)+uz(i,j,4))
              tz(i,j,2)=aiciz6*(uz(i,j,3)+uz(i,j,2))&
                   +biciz6*(uz(i,j,4)+uz(i,j,1))&
                   +ciciz6*(uz(i,j,5)+uz(i,j,2))&
                   +diciz6*(uz(i,j,6)+uz(i,j,3))
              tz(i,j,3)=aiciz6*(uz(i,j,4)+uz(i,j,3))&
                   +biciz6*(uz(i,j,5)+uz(i,j,2))&
                   +ciciz6*(uz(i,j,6)+uz(i,j,1))&
                   +diciz6*(uz(i,j,7)+uz(i,j,2))
           enddo
        enddo
        do k=4,nzm-3
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=aiciz6*(uz(i,j,k+1)+uz(i,j,k))&
                      +biciz6*(uz(i,j,k+2)+uz(i,j,k-1))&
                      +ciciz6*(uz(i,j,k+3)+uz(i,j,k-2))&
                      +diciz6*(uz(i,j,k+4)+uz(i,j,k-3))
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm-2)=aiciz6*(uz(i,j,nzm-1)+uz(i,j,nzm-2))&
                   +biciz6*(uz(i,j,nzm)+uz(i,j,nzm-3))&
                   +ciciz6*(uz(i,j,nz)+uz(i,j,nzm-4))&
                   +diciz6*(uz(i,j,nzm)+uz(i,j,nzm-5))
              tz(i,j,nzm-1)=aiciz6*(uz(i,j,nzm)+uz(i,j,nzm-1))&
                   +biciz6*(uz(i,j,nz)+uz(i,j,nzm-2))&
                   +ciciz6*(uz(i,j,nzm)+uz(i,j,nzm-3))&
                   +diciz6*(uz(i,j,nzm-1)+uz(i,j,nzm-4))
              tz(i,j,nzm)=aiciz6*(uz(i,j,nz)+uz(i,j,nzm))&
                   +biciz6*(uz(i,j,nzm)+uz(i,j,nzm-1))&
                   +ciciz6*(uz(i,j,nzm-1)+uz(i,j,nzm-2))&
                   +diciz6*(uz(i,j,nzm-2)+uz(i,j,nzm-3))
           enddo
        enddo
        do k=2,nzm
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*cisz6(k)
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nzm)=tz(i,j,nzm)*ciwz6(nzm)
           enddo
        enddo
        do k=nzm-1,1,-1
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=(tz(i,j,k)-cifz6(k)*tz(i,j,k+1))*ciwz6(k)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interzvp

!********************************************************************
!
subroutine derzpv(tz,uz,rz,sz,cfiz6,csiz6,cwiz6,cfz6,csz6,cwz6,&
     nx,ny,nzm,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivZ

  implicit none

  integer :: nx,nzm,ny,nz,npaire
  real(mytype), dimension(nx,ny,nz) :: tz
  real(mytype), dimension(nx,ny,nzm) :: uz,rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: cfiz6,csiz6,cwiz6
  real(mytype), dimension(nz) :: cfz6,csz6,cwz6
  integer :: i,j,k

  if (nclz) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=aciz6*(uz(i,j,1)-uz(i,j,nz))&
                +bciz6*(uz(i,j,2)-uz(i,j,nz-1))
           rz(i,j,1)=-1.
           tz(i,j,2)=aciz6*(uz(i,j,2)-uz(i,j,1))&
                +bciz6*(uz(i,j,3)-uz(i,j,nz))
           rz(i,j,2)=0.
        enddo
     enddo
     do k=3,nz-2
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=aciz6*(uz(i,j,k)-uz(i,j,k-1))&
                   +bciz6*(uz(i,j,k+1)-uz(i,j,k-2))
              rz(i,j,k)=0.
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-1)=aciz6*(uz(i,j,nz-1)-uz(i,j,nz-2))&
                +bciz6*(uz(i,j,nz)-uz(i,j,nz-3))
           rz(i,j,nz-1)=0.
           tz(i,j,nz)=aciz6*(uz(i,j,nz)-uz(i,j,nz-1))&
                +bciz6*(uz(i,j,1)-uz(i,j,nz-2))
           rz(i,j,nz)=alcaiz6
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*csz6(k)
              rz(i,j,k)=rz(i,j,k)-rz(i,j,k-1)*csz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*cwz6(nz)
           rz(i,j,nz)=rz(i,j,nz)*cwz6(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-cfz6(k)*tz(i,j,k+1))*cwz6(k)
              rz(i,j,k)=(rz(i,j,k)-cfz6(k)*rz(i,j,k+1))*cwz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           sz(i,j)=(tz(i,j,1)-alcaiz6*tz(i,j,nz))/&
                (1.+rz(i,j,1)-alcaiz6*rz(i,j,nz))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-sz(i,j)*rz(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do j=1,ny
           do i=1,nx
              tz(i,j,1)=0.
              tz(i,j,2)=aciz6*(uz(i,j,2)-uz(i,j,1))&
                   +bciz6*(uz(i,j,3)-uz(i,j,1))
           enddo
        enddo
        do k=3,nz-2
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=aciz6*(uz(i,j,k)-uz(i,j,k-1))&
                      +bciz6*(uz(i,j,k+1)-uz(i,j,k-2))
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nz-1)=aciz6*(uz(i,j,nz-1)-uz(i,j,nz-2))&
                   +bciz6*(uz(i,j,nz-1)-uz(i,j,nz-3))
              tz(i,j,nz)=0.
           enddo
        enddo
        do k=2,nz
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*csiz6(k)
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nz)=tz(i,j,nz)*cwiz6(nz)
           enddo
        enddo
        do k=nz-1,1,-1
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=(tz(i,j,k)-cfiz6(k)*tz(i,j,k+1))*cwiz6(k)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine derzpv

!********************************************************************
!
subroutine interzpv(tz,uz,rz,sz,cifiz6,cisiz6,ciwiz6,cifz6,cisz6,ciwz6,&
     nx,ny,nzm,nz,npaire)
  !
  !********************************************************************

  USE param
  USE derivZ

  implicit none

  integer :: nx,ny,nz,nzm,npaire
  real(mytype), dimension(nx,ny,nz) :: tz
  real(mytype), dimension(nx,ny,nzm) :: uz
  real(mytype), dimension(nx,ny,nz) :: rz
  real(mytype), dimension(nx,ny) :: sz
  real(mytype), dimension(nz) :: cifiz6,cisiz6,ciwiz6
  real(mytype), dimension(nz) :: cifz6,cisz6,ciwz6
  integer :: i,j,k

  if (nclz) then
     do j=1,ny
        do i=1,nx
           tz(i,j,1)=aiciz6*(uz(i,j,1)+uz(i,j,nz))&
                +biciz6*(uz(i,j,2)+uz(i,j,nz-1))&
                +ciciz6*(uz(i,j,3)+uz(i,j,nz-2))&
                +diciz6*(uz(i,j,4)+uz(i,j,nz-3))
           rz(i,j,1)=-1.
           tz(i,j,2)=aiciz6*(uz(i,j,2)+uz(i,j,1))&
                +biciz6*(uz(i,j,3)+uz(i,j,nz))&
                +ciciz6*(uz(i,j,4)+uz(i,j,nz-1))&
                +diciz6*(uz(i,j,5)+uz(i,j,nz-2))
           rz(i,j,2)=0.
           tz(i,j,3)=aiciz6*(uz(i,j,3)+uz(i,j,2))&
                +biciz6*(uz(i,j,4)+uz(i,j,1))&
                +ciciz6*(uz(i,j,5)+uz(i,j,nz))&
                +diciz6*(uz(i,j,6)+uz(i,j,nz-1))
           rz(i,j,3)=0.
           tz(i,j,4)=aiciz6*(uz(i,j,4)+uz(i,j,3))&
                +biciz6*(uz(i,j,5)+uz(i,j,2))&
                +ciciz6*(uz(i,j,6)+uz(i,j,1))&
                +diciz6*(uz(i,j,7)+uz(i,j,nz))
           rz(i,j,4)=0.
        enddo
     enddo
     do k=5,nz-3
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=aiciz6*(uz(i,j,k)+uz(i,j,k-1))&
                   +biciz6*(uz(i,j,k+1)+uz(i,j,k-2))&
                   +ciciz6*(uz(i,j,k+2)+uz(i,j,k-3))&
                   +diciz6*(uz(i,j,k+3)+uz(i,j,k-4))
              rz(i,j,k)=0.
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz-2)=aiciz6*(uz(i,j,nz-2)+uz(i,j,nz-3))&
                +biciz6*(uz(i,j,nz-1)+uz(i,j,nz-4))&
                +ciciz6*(uz(i,j,nz)+uz(i,j,nz-5))&
                +diciz6*(uz(i,j,1)+uz(i,j,nz-6))
           rz(i,j,nz-2)=0.
           tz(i,j,nz-1)=aiciz6*(uz(i,j,nz-1)+uz(i,j,nz-2))&
                +biciz6*(uz(i,j,nz)+uz(i,j,nz-3))&
                +ciciz6*(uz(i,j,1)+uz(i,j,nz-4))&
                +diciz6*(uz(i,j,2)+uz(i,j,nz-5))
           rz(i,j,nz-1)=0.
           tz(i,j,nz)=aiciz6*(uz(i,j,nz)+uz(i,j,nz-1))&
                +biciz6*(uz(i,j,1)+uz(i,j,nz-2))&
                +ciciz6*(uz(i,j,2)+uz(i,j,nz-3))&
                +diciz6*(uz(i,j,3)+uz(i,j,nz-4))
           rz(i,j,nz)=ailcaiz6
        enddo
     enddo
     do k=2,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*cisz6(k)
              rz(i,j,k)=rz(i,j,k)-rz(i,j,k-1)*cisz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           tz(i,j,nz)=tz(i,j,nz)*ciwz6(nz)
           rz(i,j,nz)=rz(i,j,nz)*ciwz6(nz)
        enddo
     enddo
     do k=nz-1,1,-1
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=(tz(i,j,k)-cifz6(k)*tz(i,j,k+1))*ciwz6(k)
              rz(i,j,k)=(rz(i,j,k)-cifz6(k)*rz(i,j,k+1))*ciwz6(k)
           enddo
        enddo
     enddo
     do j=1,ny
        do i=1,nx
           sz(i,j)=(tz(i,j,1)-ailcaiz6*tz(i,j,nz))/&
                (1.+rz(i,j,1)-ailcaiz6*rz(i,j,nz))
        enddo
     enddo
     do k=1,nz
        do j=1,ny
           do i=1,nx
              tz(i,j,k)=tz(i,j,k)-sz(i,j)*rz(i,j,k)
           enddo
        enddo
     enddo
  else
     if (npaire==1) then
        do j=1,ny
           do i=1,nx
              tz(i,j,1)=aiciz6*(uz(i,j,1)+uz(i,j,1))&
                   +biciz6*(uz(i,j,2)+uz(i,j,2))&
                   +ciciz6*(uz(i,j,3)+uz(i,j,3))&
                   +diciz6*(uz(i,j,4)+uz(i,j,4))
              tz(i,j,2)=aiciz6*(uz(i,j,2)+uz(i,j,1))&
                   +biciz6*(uz(i,j,3)+uz(i,j,1))&
                   +ciciz6*(uz(i,j,4)+uz(i,j,2))&
                   +diciz6*(uz(i,j,5)+uz(i,j,3))
              tz(i,j,3)=aiciz6*(uz(i,j,3)+uz(i,j,2))&
                   +biciz6*(uz(i,j,4)+uz(i,j,1))&
                   +ciciz6*(uz(i,j,5)+uz(i,j,1))&
                   +diciz6*(uz(i,j,6)+uz(i,j,2))
              tz(i,j,4)=aiciz6*(uz(i,j,4)+uz(i,j,3))&
                   +biciz6*(uz(i,j,5)+uz(i,j,2))&
                   +ciciz6*(uz(i,j,6)+uz(i,j,1))&
                   +diciz6*(uz(i,j,7)+uz(i,j,1))
           enddo
        enddo
        do k=5,nz-4
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=aiciz6*(uz(i,j,k)+uz(i,j,k-1))&
                      +biciz6*(uz(i,j,k+1)+uz(i,j,k-2))&
                      +ciciz6*(uz(i,j,k+2)+uz(i,j,k-3))&
                      +diciz6*(uz(i,j,k+3)+uz(i,j,k-4))
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nz-3)=aiciz6*(uz(i,j,nz-3)+uz(i,j,nz-4))&
                   +biciz6*(uz(i,j,nz-2)+uz(i,j,nz-5))&
                   +ciciz6*(uz(i,j,nz-1)+uz(i,j,nz-6))&
                   +diciz6*(uz(i,j,nz-1)+uz(i,j,nz-7))
              tz(i,j,nz-2)=aiciz6*(uz(i,j,nz-2)+uz(i,j,nz-3))&
                   +biciz6*(uz(i,j,nz-1)+uz(i,j,nz-4))&
                   +ciciz6*(uz(i,j,nz-1)+uz(i,j,nz-5))&
                   +diciz6*(uz(i,j,nz-2)+uz(i,j,nz-6))
              tz(i,j,nz-1)=aiciz6*(uz(i,j,nz-1)+uz(i,j,nz-2))&
                   +biciz6*(uz(i,j,nz-1)+uz(i,j,nz-3))&
                   +ciciz6*(uz(i,j,nz-2)+uz(i,j,nz-4))&
                   +diciz6*(uz(i,j,nz-3)+uz(i,j,nz-5))
              tz(i,j,nz)=aiciz6*(uz(i,j,nz-1)+uz(i,j,nz-1))&
                   +biciz6*(uz(i,j,nz-2)+uz(i,j,nz-2))&
                   +ciciz6*(uz(i,j,nz-3)+uz(i,j,nz-3))&
                   +diciz6*(uz(i,j,nz-4)+uz(i,j,nz-4))
           enddo
        enddo
        do k=2,nz
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=tz(i,j,k)-tz(i,j,k-1)*cisiz6(k)
              enddo
           enddo
        enddo
        do j=1,ny
           do i=1,nx
              tz(i,j,nz)=tz(i,j,nz)*ciwiz6(nz)
           enddo
        enddo
        do k=nz-1,1,-1
           do j=1,ny
              do i=1,nx
                 tz(i,j,k)=(tz(i,j,k)-cifiz6(k)*tz(i,j,k+1))*ciwiz6(k)
              enddo
           enddo
        enddo
     endif
  endif

  return
end subroutine interzpv
