% compare finite difference and adjoint gradient
% cost function is total sea-ice volume
% control variable is surface air temperature

path('../../lab_sea/matlab',path);
load SSMI
fn='../../../exe/adxx_atemp.0000000000.001.001.data';
a=readbin(fn,[20 16],1,'real*8');
fn='../../../exe/ph-grd.txt';
fin=fopen(fn,'r'); b=0*a; c=0*a; d=0*a;
tmp=fgetl(fin); tmp=fgetl(fin); tmp=fgetl(fin);
for i=1:150
  tmp=fgetl(fin);
  tmp=fgetl(fin); arr1=sscanf(tmp(8:85),'%f');
  tmp=fgetl(fin); arr2=sscanf(tmp(8:85),'%f');
  b(arr1(4),arr1(5))=arr2(7);
  c(arr1(4),arr1(5))=arr2(8);
  d(arr1(4),arr1(5))=arr2(9);
  tmp=fgetl(fin);
  tmp=fgetl(fin);
end

clf reset, orient tall, wysiwyg
cx=[-1 1]; cl=[1 1 1]*.5; sc=3e5;
ax=([min(lon) max(lon) min(lat) max(lat)]);
subplot(411), mypcolor(lon,lat,b'/sc); caxis(cx), colorbar
% plotland('k'), axis(ax), grid
% plotland(cl,4), axis(ax)
xlabel('Longitude East'), ylabel('Latitude North')
title('Adjoint model: gradient of sea-ice volume wrt air temperature')
subplot(412), mypcolor(lon,lat,c'/sc); caxis(cx), colorbar
% plotland('k'), axis(ax), grid
% plotland(cl,4), axis(ax)
xlabel('Longitude East'), ylabel('Latitude North')
title('Finite-difference: gradient of sea-ice volume w.r.t. air temperature')
subplot(413), mypcolor(lon,lat,(c-b)'/sc); caxis(cx/10000), colorbar
% plotland('k'), axis(ax), grid
% plotland(cl,4), axis(ax)
xlabel('Longitude East'), ylabel('Latitude North')
title('Finite-difference minus adjoint gradient')
subplot(414), mypcolor(lon,lat,d'); caxis([-2 2]), colorbar
% plotland('k'), axis(ax), grid
% plotland(cl,4), axis(ax)
xlabel('Longitude East'), ylabel('Latitude North')
title('( adjoint minus finite-difference ) / adjoint')

% print -djpeg -r0 FIG1
% print -dpsc FIG1
