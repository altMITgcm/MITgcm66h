% build sparse matrix
%--------------------
% input  : nx,ny,aw2d,as2d,cent
% output : A,cent

n      = nx*ny;
bl     = zeros(n,7);

aw2dp  = zeros(nx,ny);
aw2dpo = zeros(nx,ny);
aw2dm  = zeros(nx,ny);
aw2dmo = zeros(nx,ny);

as2dp  = zeros(nx,ny);
as2dm  = zeros(nx,ny);

aw2dpc(1:nx-1,:) = aw2d(2:nx,:);
aw2dpc(  nx  ,:) = aw2d(1,:);

aw2dp(1:nx-1,:) = aw2d(2:nx,:);
aw2dp(  nx  ,:) = 0;

aw2dpo(1:nx-1,:) = 0;
aw2dpo(  nx  ,:) = aw2d(1,:);

aw2dm(2:nx,:) = aw2d(2:nx,:);
aw2dm(   1,:) = 0;

aw2dmo(2:nx,:) = 0;
aw2dmo(   1,:) = aw2d(1,:);

as2dp(1:nx,1:ny-1) = as2d(:,2:ny);
as2dp(1:nx,  ny  ) = 0;

as2dm(:,2:ny) = as2d(:,2:ny);
as2dm(:,   1) = 0;

%bl(:,1) = reshape(-cent-aw2d-aw2dpc-as2dm-as2dp, n, 1);

cent = -cent-aw2d-aw2dpc-as2dm-as2dp;
bl(:,1) = reshape(cent , n, 1);
bl(:,2) = reshape(aw2dp, n, 1);
bl(:,3) = reshape(aw2dm, n, 1);
bl(:,4) = reshape(as2dp, n, 1);
bl(:,5) = reshape(as2dm, n, 1);

bl(:,6) = reshape(aw2dmo, n, 1);
bl(:,7) = reshape(aw2dpo, n, 1);
A = spdiags(bl,[0,-1,+1,-nx,+nx,-(nx-1),+(nx-1)],n,n);

clear aw2dp aw2dm aw2dmo aw2dpo as2dp as2dm bl;
