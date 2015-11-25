function wavenumberslod

clear
close all

time = 1;
igs = 2 / (1 + sqrt(5));
%igs = 1 / (1 + sqrt(5));
%igs = 0.5;

geometry = [];
geometry.geometryRes = 256;
geometry.gradientRes = 256;

maxArea = 2000;
geometry.lodAreas = areas(maxArea, 4, igs);

settings = [];
settings.generatorName = 'Unified';
settings.wind = [ 2.5 0 ];
settings.fetch = 500000;

o = ocean_init(geometry, settings);

minK = [0 maxWavenumbers(o)];
writeRangedSpectra(o, 'sampling_scale_06_lod_%d.dat', 4);
writeRangedSpectra(o, 'sampling_scale_06_lod_%d_capped.dat', 4, minK);

igs = 1 / (1 + sqrt(5));
geometry.geometryRes = 256;
geometry.gradientRes = 256;
geometry.lodAreas = areas(maxArea, 4, igs);
o = ocean_init(geometry, settings);

minK = [0 maxWavenumbers(o)];
writeRangedSpectra(o, 'sampling_scale_03_lod_%d.dat', 4);
writeRangedSpectra(o, 'sampling_scale_03_lod_%d_capped.dat', 4, minK);

end

%%
function a = areas(largestArea, nAreas, scale)
    a = power(scale,0:1:nAreas-1) .* largestArea;
end
%%
function k = uniqueWavenumbers(kn, minK)
k = sort(unique(kn));
ix = find(k > minK, 1, 'first');
k = k(ix:end);
end
%%
function [kn, a] = rangedSpectrum(lod, minK, delta, settings)
    kn = uniqueWavenumbers(lod.kn, minK);
    kn = kn(1:delta:end);
    a  = UnifiedSpectrum1Dk(kn, settings.wind, settings.fetch, []);
end
%%
function maxK = maxWavenumbers(ocean)
    maxK = zeros(1, numel(ocean.lods));
    for l=1:numel(ocean.lods)
        maxK(l) = sqrt(2)* pi * (ocean.lods{l}.resolution / ocean.lods{l}.area);
    end
end
%%
function writeRangedSpectra(ocean, baseFileame, varargin)

delta = 1;
minK = zeros(1, numel(ocean.lods));

optargin = size(varargin,2);

if optargin > 0
    delta = varargin{1};
end

if optargin > 1
    minK = varargin{2};
end

for l=1:numel(ocean.lods)
    [ kn, a ] = rangedSpectrum(ocean.lods{l}, minK(l), delta, ocean.settings);
    write2dcsv(kn', a', sprintf(baseFileame, l));
end

end
%%

% figure
% hold on
% cmap = hsv(numel(o.lods));
% minK = 0;
% maxK = realmax();
% 
% for l=1:numel(o.lods)
%     minKx = (pi * o.lods{l}.resolution) / o.lods{l}.area;
%     minK(end+1) = sqrt(minKx^2 + minKx^2);
%     maxK(end+1) = 2*pi/o.lods{l}.area;
% end
% 
% for l=1:numel(o.lods)
%     kn = sort(unique(o.lods{l}.kn));
%     ix = find(kn > minK(l), 1, 'first');
%     kn = kn(ix:end);
%     %size(kn)
%     a = UnifiedSpectrum1Dk(kn, settings.wind, settings.fetch, []);
%     harea = area(kn, a);% 'Color', cmap(l,:));
%     child = get(harea,'Children');
%     set(child,'FaceColor', cmap(l,:))
%     set(child,'FaceAlpha', 1.0 - l*0.1);
%     set(child,'EdgeColor', 'black'); 
% end
% hold off
% 
% for l=1:numel(o.lods)
%     kn = sort(unique(o.lods{l}.kn));
%     kn = kn(2:end);
%     a = UnifiedSpectrum1Dk(kn, settings.wind, settings.fetch, []);
%     figure
%     harea = area(kn, a);% 'Color', cmap(l,:));
%     child = get(harea,'Children');
%     set(child,'FaceColor', cmap(l,:))
%     set(child,'FaceAlpha', l*0.1);
%     set(child,'EdgeColor', 'black'); 
% end



% k = [];
% for l=1:numel(o.lods)
%     u = unique(o.lods{l}.kn);
%     k = [ k;  u];
% end
% 
% k = unique(k);
% 
% [ a b ] = Donelan19851Dk(k, settings.wind, settings.fetch, []);
