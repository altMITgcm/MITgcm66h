% read matrix coefficient, build distributes S^-1 matrix,
% and write it in files
%--------------------------------------------------------
% input  : snx,sny,npx,npy
% output : files ss_matrix* in MITGCMUV mdsio format

readmat;
build;

% the final distribution can be different from the read in one
% all you need to do is to redefine the parameters here
%snx =
%sny =
%npx =
%npy =

distri;
store;
