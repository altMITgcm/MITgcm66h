% Compare temperature output of new and reference (c44_e25) codes.

p1='../output/';                     % reference (c32)output location
p2='../../../exe/';                  % new output file location

lat=13:2:43; lon=322:2:360;          % latitude, longitude

% model depths
dZ=[10 10 15 20 20 25 35 50 75 100 150 200 275 ...
      350 415 450 500 500 500 500 500 500 500];
dpt=dZ/2;
for i=2:length(dZ)
  dpt(i)=dpt(i)+sum(dZ(1:(i-1)));
end

dp=1;                                % depth level
cx=[15 28]; cxd=[-1 1]*.005;         % color axes

T1=readbin([p1 'T.0000000020.001.001.data'],[20 16 23],1);
T2=readbin([p2 'T.0000000020.001.001.data'],[20 16 23],1);

figure(1), clf reset
set(gcf,'PaperOrientation','portrait')
set(gcf,'PaperPosition',[0.5 0.5 7.5 10.])
subplot(311), pcolor(lon,lat,T1(:,:,dp)');
shading flat, caxis(cx), colorbar
title(['c44 e25 temperature (deg C), day 30' ...
      ', ' int2str(dpt(dp)) ' m depth' ...
      ', ' ' min=' num2str(min(min(T1(:,:,dp))),4) ...
      ', ' ' max=' num2str(max(max(T1(:,:,dp))),4) ])
ylabel('Latitude North'), set(gca,'xticklabel',[])

subplot(312), pcolor(lon,lat,T2(:,:,dp)');
shading flat, caxis(cx), colorbar
title(['new temperature (deg C), day 30' ...
      ', ' ' min=' num2str(min(min(T1(:,:,dp))),4) ...
      ', ' ' max=' num2str(max(max(T1(:,:,dp))),4) ])
ylabel('Latitude North'), set(gca,'xticklabel',[])

subplot(313), pcolor(lon,lat,T2(:,:,dp)'-T1(:,:,dp)');
shading flat, caxis(cxd), colorbar
title(['Difference (deg C)' ...
      ', ' ' min=' num2str(min(min(T2(:,:,dp)'-T1(:,:,dp)')),4) ...
      ', ' ' max=' num2str(max(max(T2(:,:,dp)'-T1(:,:,dp)')),4) ])
ylabel('Latitude North'), xlabel('Longitude East')
