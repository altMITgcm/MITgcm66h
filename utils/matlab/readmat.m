% read solver matrix
%--------------------
% input  : snx,sny,npx,npy
% output : as2d, aw2d, cent
% files  : aw2d*, as2d*, cent* in MITGCMUV mdsio format

nx=npx*snx;
ny=npy*sny;

aw2d=zeros(nx,ny);
as2d=zeros(nx,ny);
cent=zeros(nx,ny);
for i = 1:npx,
  ii=(i-1)*snx;
  xc1=ii+1:ii+snx;

  for j = 1:npy,
    jj=(j-1)*sny;
    yc1=jj+1:jj+sny;

    fname = sprintf('aw2d.%03i.%03i.data', i, j );
    fid=fopen(fname,'r');
    aw2d(xc1,yc1) = fread( fid, [snx,sny], 'float32' );
    fclose(fid);

    fname = sprintf('as2d.%03i.%03i.data', i, j );
    fid=fopen(fname,'r');
    as2d(xc1,yc1) = fread( fid, [snx,sny], 'float32' );
    fclose(fid);

    fname = sprintf('cent.%03i.%03i.data', i, j );
    fid=fopen(fname,'r');
    cent(xc1,yc1) = fread( fid, [snx,sny], 'float64' );
    fclose(fid);
  end
end
