% build and distribute matrix of interior,interior
%-------------------------------------------------
% input  : nx,ny,npx,npy,A,as2s,aw2d,cent
% output : sumij

snx = nx/npx;
sny = ny/npy;

ninterf = snx+sny-1;
n1      = (snx-1)*(sny-1);

ka = 1:snx;
kb = snx+1:snx+sny-1;

%------ Cholesky factorization of matrix A
% compute sum( B' inv(A) B )

clear ACH;
clear ACHS;
clear sumij;

sumij = spalloc( ninterf*npx*npy, ninterf*npx*npy, 20*ninterf*npx*npy );
for i = 1:npx,
  ii=(i-1)*snx;
  for j = 1:npy,
%    [i,j]
    jj=(j-1)*sny;

    ad=zeros(snx-1,sny-1,snx-1,sny-1);
    for m2 = 2:sny,
     for l2 = 2:snx,
      for m1 = max(2,m2-1):min(sny,m2+1),
       for l1 = max(2,l2-1):min(snx,l2+1),
        ad(l1-1,m1-1,l2-1,m2-1) = -A(ii+l1+(jj+m1-1)*nx,ii+l2+(jj+m2-1)*nx);
       end
      end
     end
    end

    bi = zeros(snx-1,sny-1,ninterf,npx,npy);
%y=1
    for ix = 2:snx,
      bi(ix-1,   1,      ix,i,j) = -as2d(ii+ix,jj+ 2);
    end
%x=1
    for jy = 2:sny,
      bi(   1,jy-1,jy+snx-1,i,j) = -aw2d(ii+ 2,jj+jy);
    end

%y=1
    jp1 = j+1;
    if jp1 <= npy
     for ix = 2:snx,
       bi( ix-1,sny-1,     ix,i,jp1) = -as2d(ii+ix, (jp1-1)*sny+ 1);
     end
    end
%x=1
    ip1 = 1+mod(i  ,npx);
    for jy = 2:sny,
      bi(snx-1, jy-1,jy+snx-1,ip1,j) = -aw2d((ip1-1)*snx+ 1,jj+jy);
    end
%
    bi = reshape(bi,(snx-1)*(sny-1),ninterf*npx*npy);
%    'bi is there'

    ACHS = chol(sparse( reshape(ad,(snx-1)*(sny-1),(snx-1)*(sny-1)) ));
%    'ACHS is there'

    bi   = sparse(bi' / ACHS);
%    'bi solved'
    sumij = sumij - sparse(bi * bi');
  end
end
clear bi
clear ACHS
clear ad
clear A

%------ distributed matrix of (interface,interface)
qq = zeros(ninterf,npx,npy,ninterf,npx,npy);
for i = 1:npx,
  ii=(i-1)*snx;
  xx=ii+1:ii+snx;
  for j = 1:npy,
    jj=(j-1)*sny;
    yy=jj+2:jj+sny;

    qq(    1,i,j,snx+1,i,j) = -as2d(1+ii,jj+2);
    qq(snx+1,i,j,    1,i,j) = -as2d(1+ii,jj+2);

    for k = 1:snx
      qq(k,i,j,k,i,j) = -cent(ii+k,1+jj);
    end
    for k = 1:snx-1
      qq(k+1,i,j,k,i,j) = -aw2d(ii+k+1,1+jj);
    end
    for k = 2:snx
      qq(k-1,i,j,k,i,j) = -aw2d(ii+k,1+jj);
    end

    for k = 2:sny
      qq(snx-1+k,i,j,snx-1+k,i,j) = -cent(ii+1,jj+k);
    end
    for k = 2:sny-1
      qq(snx-1+k+1,i,j,snx-1+k,i,j) = -as2d(ii+1,jj+k+1);
    end
    for k = 3:sny
      qq(snx-1+k-1,i,j,snx-1+k,i,j) = -as2d(ii+1,jj+k);
    end

    im1 = 1+mod(i-2,npx);
    jm1 = j-1;

    qq(1,i,j,snx,im1,j) = -aw2d( ii+1,1+jj);
    if jm1 > 0
      qq(1,i,j,snx+sny-1,i,jm1) = -as2d( ii+1,1+jj);
    end

    ip1 = 1+mod(i  ,npx);
    jp1 = j+1;
    iif=(ip1-1)*snx;
    jjf=(jp1-1)*sny;

    qq(snx,i,j,1,ip1,j) = -aw2d(iif+1,1+jj);
    if jp1 <= npy
      qq(snx+sny-1,i,j,1,i,jp1) = -as2d(ii+1,1+jjf);
    end
  end
end

%------ compute matrix S = Q - sum(B' inv(A) B)
sumij = sumij + sparse(reshape(qq,ninterf*npx*npy,ninterf*npx*npy));

clear qq
