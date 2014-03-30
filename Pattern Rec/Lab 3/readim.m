% This function reads a 256x256 grayscale image from the
% specified file.
%
% Usage: im = readim('filename');
%

function im = readim(fname)

fid = fopen(fname,'r');
if (fid < 0),
  fid = fopen([deblank(fname) '.im'],'r');
  if (fid < 0),
    error('READIM: Could not find specified file name.');
  end;
end;

im = fread(fid,[256 256],'uint8');
fclose(fid);
colormap(gray);

