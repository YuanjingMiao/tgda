wind = [15 0.0];

kx = -0.1:0.005:0.2;
ky =  0.1:-0.005:-0.1;
k = zeros(size(ky,2), size(kx,2), 2);
[ k(:,:,1) k(:,:,2) ] = meshgrid(kx, ky);

kx2tmp = realpow(k(:,:,1), 2);
ky2tmp = realpow(k(:,:,2), 2);
kx2y2tmp = kx2tmp + ky2tmp;
knorm = realsqrt(kx2y2tmp);
knormalised = zeros(size(ky,2), size(kx,2), 2);
knormalised(:,:,1) = k(:,:,1)./knorm;
knormalised(isnan(knormalised))=0;
knormalised(:,:,2) = k(:,:,2)./knorm;
knormalised(isnan(knormalised))=0;

%pmspectrum = PiersonMoskovitzSpectrum(k, knorm, knormalised, wind, [], []);
[jspectrum_k jspectrum_o_t] = JONSWAPSpectrum(k, knorm, knormalised, wind, [], []);

% figure;
% mesh(k(:,:,1),k(:,:,2),pmspectrum);
% figure;
% mesh(k(:,:,1),k(:,:,2),jspectrum);

xrow = jspectrum_o_t(find(kx==0),:,1);
xrow = xrow(find(xrow==0):end);
xgrid = repmat(xrow,size(ky,2),1);

ycolumn = pi/2:-pi/(size(ky,2)-1):-pi/2;
ycolumn = ycolumn';
ygrid = repmat(ycolumn,1,size(xrow,2));

[i j] = find(jspectrum_o_t(:,:,3)==0);
jsp = jspectrum_o_t(:,j:end,3);

xcolumn = xgrid(:,1);
ycolumn = ygrid(:,1);
dlmwrite('3dtest.txt', [xcolumn, ycolumn, jsp(:,1)], 'newline', 'pc', 'delimiter',',');

for i = 2:size(xgrid,1)
    xcolumn = xgrid(:,i);
    ycolumn = ygrid(:,i);
    dlmwrite('3dtest.txt',[], '-append', 'roffset', 1, 'newline', 'pc');
    dlmwrite('3dtest.txt', [xcolumn, ycolumn, jsp(:,i)], '-append', 'newline', 'pc', 'delimiter',',');
end