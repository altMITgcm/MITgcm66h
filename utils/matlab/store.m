% invert S matrix and write it in MITGCMUV mdsio format
%------------------------------------------------------
% input  : sumij,npx,npy,ninterf
% output : files

% MITGCMUV has a funny distribution for 2x2=4 processors it is:
%
%         1 3
%         0 2
%
% Thus, we have to permute the npx and npy dimension
% write negative because we have used (-A) internally

%old ok
%sumij = full(sumij);
%sumij = -permute(reshape(inv(sumij),ninterf,npx,npy,ninterf,npx,npy),[1,3,2,4,5,6]);

sumij = full(sumij\eye(size(sumij)));
sumij = -permute(reshape(sumij,ninterf,npx,npy,ninterf,npx,npy),[1,3,2,4,5,6]);

ndims    = 1;
dimList  = [32768,    1,16384];
format   = 'float64';
sformat  = '''float64''';
nrecords = 1;
timeStepNumber = 0;

for i = 1:npx,
  for j = 1:npy,
    fname = sprintf('ss_matrix.%03i.%03i.data', i, j );
    fid   = fopen(fname,'w');
    fwrite( fid, sumij(:,:,:,:,i,j), format );
    fclose(fid);
    fname = sprintf('ss_matrix.%03i.%03i.meta', i, j );
    fid   = fopen(fname,'w');
    fprintf(fid, ' nDims = [ %3i ];\n', ndims);
    fprintf(fid, ' dimList = [\n');
    fprintf(fid, ' dimList = [\n');
    fprintf(fid, '            ');
    fprintf(fid, '%5i,', dimList);
    fprintf(fid, '\n          ]\n');
    fprintf(fid, 'format = [ %s ];\n', sformat);
    fprintf(fid, ' nrecords = [ %5i ];\n', nrecords);
    fprintf(fid, ' timeStepNumber = [ %8i ];\n', timeStepNumber);
    fclose(fid);
  end
end
%clear sumij;
