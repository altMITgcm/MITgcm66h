% need to be in verification/lab_sea/matlab directory
% and to specify location of exp1 output
cd ../../../verification/lab_sea/matlab
exp1_path='../input/';

% load monthly-mean SMMR-SSM/I data
load SSMI

% B-grid latitude for uice and vice
Blat=lat+1; Blon=lon+1;

% load model output
area =readbin('../results/AREAtave.0000000010.data' ,[20 16 1],1);
heff =readbin('../results/HEFFtave.0000000010.data' ,[20 16 1],1);
uice =readbin('../results/UICEtave.0000000010.data' ,[20 16 1],1);
vice =readbin('../results/VICEtave.0000000010.data' ,[20 16 1],1);
area1=readbin([exp1_path 'AREAtave.0000000010.data'],[20 16 1],1);
heff1=readbin([exp1_path 'HEFFtave.0000000010.data'],[20 16 1],1);
uice1=readbin([exp1_path 'UICEtave.0000000010.data'],[20 16 1],1);
vice1=readbin([exp1_path 'VICEtave.0000000010.data'],[20 16 1],1);

% compute ice speed and direction
udir=0*uice; vdir=0*vice;
udir1=0*uice; vdir1=0*vice;
icespeed=100*sqrt(uice.^2+vice.^2);
in=find(icespeed);
udir(in)=uice(in)./icespeed(in);
vdir(in)=vice(in)./icespeed(in);
icespeed1=100*sqrt(uice1.^2+vice1.^2);
in=find(icespeed1);
udir1(in)=uice1(in)./icespeed1(in);
vdir1(in)=vice1(in)./icespeed1(in);

% plot comparison figures

clf, subplot(321)
mypcolor(lon,lat,area1'); caxis([0 1]), colorbar
title('Sea-ice concentration')
set(gca,'xticklabel',[])

subplot(322)
mypcolor(lon,lat,area1'-area'); colorbar
title('Difference with release1 patch16')
set(gca,'xticklabel',[])

subplot(323)
mypcolor(lon,lat,heff1'); caxis([0 .3]), colorbar
title('Effective sea-ice thickness (m)')
set(gca,'xticklabel',[])

subplot(324)
mypcolor(lon,lat,heff1'-heff'); colorbar
title('Difference with release1 patch16')
set(gca,'xticklabel',[])

subplot(325)
mypcolor(Blon,Blat,icespeed1'); caxis([0 10]), colorbar
hold on, myquiver(Blon,Blat,udir1',vdir1','k');
title('Sea-ice velocity (cm/s)')

subplot(326)
mypcolor(Blon,Blat,icespeed1'-icespeed'); colorbar
if mmax(abs(udir1-udir)) | mmax(abs(vdir1-vdir))
  hold on, myquiver(Blon,Blat,udir1'-udir',vdir1'-vdir','k');
end
title('Difference with release1 patch16')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%55


if 0

 p1='';
 p2='../nokppgmsalt_pert/';
 it=24:24:2399;
 it=96:96:35424;

 nz=1;
 k=1;
 for i=it
%  fn=['AREA.' myint2str(i,10) '.data'];
%  fn=['HEFF.' myint2str(i,10) '.data'];
  fn=['T.' myint2str(i,10) '.data'];
  a1=readbin([p1 fn],[20 16 nz],1,'real*8');
  a2=readbin([p2 fn],[20 16 nz],1,'real*8');
  clf
  subplot(211), mypcolor(a1(:,:,k)'); colorbar, grid, title(i)
  subplot(212), mypcolor(a2(:,:,k)'-a1(:,:,k)'); colorbar, grid
  title(fn); pause(.001)
 end


 a1=zeros(20,16,length(it));
 a2=a1; h1=a1; h2=a2;
 t1=zeros(20,16,23,length(it)); t2=t1;
 n=0;
 for i=it, mydisp(i), n=n+1;
  fn=['AREA.' myint2str(i,10) '.data'];
  a1(:,:,n)=readbin([p1 fn],[20 16],1,'real*8');
  a2(:,:,n)=readbin([p2 fn],[20 16],1,'real*8');
  fn=['HEFF.' myint2str(i,10) '.data'];
  h1(:,:,n)=readbin([p1 fn],[20 16],1,'real*8');
  h2(:,:,n)=readbin([p2 fn],[20 16],1,'real*8');
  fn=['T.' myint2str(i,10) '.data'];
  t1(:,:,:,n)=readbin([p1 fn],[20 16 23],1,'real*8');
  t2(:,:,:,n)=readbin([p2 fn],[20 16 23],1,'real*8');
 end

ix=12; iy=9;
ix=19; iy=2;
clf
plot(it,squeeze(h2(ix,iy,:)-h1(ix,iy,:)))

clf, in=40:120;
subplot(311),plot(it(in),squeeze(t2(ix,iy,1,in)-t1(ix,iy,1,in)))
subplot(312)
plot(it(in),squeeze(t2(ix,iy,1,in)), ...
     it(in),squeeze(t2(ix,iy,2,in)), ...
     it(in),squeeze(t2(ix,iy,3,in)), ...
     it(in),squeeze(t2(ix,iy,4,in)), ...
     it(in),squeeze(t2(ix,iy,5,in)), ...
     it(in),squeeze(t2(ix,iy,6,in)))
subplot(313)
plot(it(in),squeeze(t2(ix,iy,2,in)-t2(ix,iy,1,in)), ...
     it(in),squeeze(t2(ix,iy,3,in)-t2(ix,iy,2,in)), ...
     it(in),squeeze(t2(ix,iy,4,in)-t2(ix,iy,3,in)), ...
     it(in),squeeze(t2(ix,iy,5,in)-t2(ix,iy,4,in)), ...
     it(in),squeeze(t2(ix,iy,6,in)-t2(ix,iy,5,in)), ...
     it(in),squeeze(t2(ix,iy,7,in)-t2(ix,iy,6,in)))

plot(it(in),squeeze(t2(ix,iy,1,in)-t1(ix,iy,1,in)), ...
     it(in),squeeze(t2(ix,iy,2,in)-t1(ix,iy,2,in)), ...
     it(in),squeeze(t2(ix,iy,3,in)-t1(ix,iy,3,in)), ...
     it(in),squeeze(t2(ix,iy,4,in)-t1(ix,iy,4,in)), ...
     it(in),squeeze(t2(ix,iy,5,in)-t1(ix,iy,5,in)), ...
     it(in),squeeze(t2(ix,iy,6,in)-t1(ix,iy,6,in)))

clf, in=1:length(it);
subplot(311)
mypcolor(in,-(1:23),squeeze(t2(ix,iy,:,in)-t1(ix,iy,:,in)))
caxis([-1 1]/1e10)
colorbar
subplot(311)
mypcolor(in,-(1:23),squeeze(t2(ix,iy,:,in)-t1(ix,iy,:,in)))
caxis([-1 1]/1e10)
colorbar
subplot(311)
mypcolor(in,-(1:23),squeeze(t2(ix,iy,:,in)-t1(ix,iy,:,in)))
caxis([-1 1]/1e10)
colorbar



end
