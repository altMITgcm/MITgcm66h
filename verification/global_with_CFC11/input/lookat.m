% look at some tracer model output
nx=90; ny=40; nz=15;
lon=2:4:358; lat=-78:4:78;
dz=[50 70 100 140 190 240 290 340 390 440 490 540 590 640 690];
dpt=(cumsum(dz)+cumsum([0 dz(1:14)]))/2;
tr=readbin('TR1.0000039934.001.001.data',[nx ny nz],1);

clf
subplot(221),mypcolor(tr(:,:,1)');colorbar
subplot(222),mypcolor(tr(:,:,3)');colorbar
subplot(223),mypcolor(tr(:,:,6)');colorbar
subplot(224),mypcolor(tr(:,:,9)');colorbar

clf
mypcolor(lat,-dpt,squeeze(tr(51,:,:))')
axis([-80 80 -2000 0]), colorbar
