function [xyY, mask] = preethamSky(resolution, phiSun, thetaSun, turbidity)

mAY = [  0.1787 -1.4630; -0.3554 0.4275; -0.0227 5.3251;  0.1206 -2.5771; -0.0670 0.3703 ];
mAx = [ -0.0193 -0.2592; -0.0665 0.0008; -0.0004 0.2125; -0.0641 -0.8989; -0.0033 0.0452 ];
mAy = [ -0.0167 -0.2608; -0.0950 0.0092; -0.0079 0.2102; -0.0441 -1.6537; -0.0109 0.0529 ];

AY = mAY * [turbidity 1]';
Ax = mAx * [turbidity 1]';
Ay = mAy * [turbidity 1]';

mxz = [ 0.00166 -0.00375 0.00209 0; -0.02903 0.06377 -0.03202 0.00394; 0.11693 -0.21196 0.06052 0.25886 ];
myz = [ 0.00275 -0.00610 0.00317 0; -0.04214 0.08970 -0.04153 0.00516; 0.15346 -0.26756 0.06670 0.26688 ];

chi = ((4.0 / 9.0) - (turbidity / 120.0)) * (pi - (2.0 * thetaSun));

T = [(turbidity * turbidity) turbidity 1 ];
Theta = [(thetaSun^3) (thetaSun^2) thetaSun 1]';

% zenith color
xz = T * mxz * Theta;
yz = T * myz * Theta;
Yz = (4.0453 * turbidity - 4.9710) * tan(chi) - 0.2155 * turbidity + 2.4192;

% convert kcd/m� to cd/m�
Yz = Yz * 1000.0;

xyY = ones(resolution, resolution, 3);

radiusInPixel = resolution / 2;
rangeStart = -radiusInPixel + 0.5;
rangeEnd = radiusInPixel - 0.5;

% direction to sun
s = [ sin(thetaSun) * cos(phiSun), sin(thetaSun) * sin(phiSun), cos(thetaSun) ];

% precompute denominator which stays constant for each
% point on the hemisphere
denominator_x = digamma(0, thetaSun, Ax);
denominator_y = digamma(0, thetaSun, Ay);
denominator_Y = digamma(0, thetaSun, AY);

% create zero centered pixel coordinates
[a,b] = meshgrid(rangeStart:rangeEnd, rangeEnd:-1:rangeStart);

% compute distance from center for each pixel coordinate pair
radius = sqrt((abs(a).^2)+(abs(b).^2));

% http://en.wikipedia.org/wiki/Stereographic_projection
% we use the south pole (0, 0, -1) as projection point
% because we want to project the upper hemisphere onto
% a circle
% X Y represent coordinates after stereographic projection
X = a ./ radiusInPixel;
Y = b ./ radiusInPixel;
l = 1 + X.^2 + Y.^2;

% convert X Y to coordinates on the unit sphere
x = 2.*X ./ l;
y = 2.*Y ./ l;
z = (1 - X.^2 - Y.^2) ./ l;

v(:,:,1) = x;
v(:,:,2) = y;
v(:,:,3) = z;

% http://de.wikipedia.org/wiki/Kugelkoordinaten
% We use the same coordinate system as shown at the site above
% coordinate axes of said coordinate system and the one for
% stereographic projection match

% compute spherical coordinates
xy_norm = sqrt((abs(x).^2)+(abs(y).^2));
phiAngle = atan2(y, x);
thetaAngle = (pi / 2) - atan(z ./ xy_norm);

% compute angle between direction to sun and coordinates
% on hemisphere
ss = repmat(reshape(s,[1 1 3]),resolution,resolution);
rotAxes = cross(v, ss, 3);
normRotAxes = sqrt(sum(abs(rotAxes).^2,3));
gammaAngle = atan2(normRotAxes, dot(ss, v, 3));

% compute preetham model for coordinates on hemisphere
v_x = xz .* (digamma(thetaAngle, gammaAngle, Ax) ./ denominator_x);
v_y = yz .* (digamma(thetaAngle, gammaAngle, Ay) ./ denominator_y);
v_Y = Yz .* (digamma(thetaAngle, gammaAngle, AY) ./ denominator_Y);

% pixels outside of the projected hemisphere are set to 0
mask = radius > radiusInPixel;
v_x(mask) = 0;
v_y(mask) = 0;
v_Y(mask) = 0;

% preetham gives results in xyY space
xyY(:,:,1) = v_x;
xyY(:,:,2) = v_y;
xyY(:,:,3) = v_Y;

%% Old implementation
% MATLAB memory layout, image coordinate (1,1) is at top left
% start j at top
% for j = rangeEnd:-1:rangeStart
%     % start i at left
%     for i = rangeStart:rangeEnd
%         radius = norm([i j]);
%         
%         % if we are inside circle the hemisphere is projected onto
%         if ( radius <= radiusInPixel )
%             % indices into result array
%             ix = i - rangeStart + 1;
%             iy = rangeEnd - j + 1;
%             
%             % http://en.wikipedia.org/wiki/Stereographic_projection
%             % we use the south pole (0, 0, -1) as projection point
%             % because we want to project the upper hemisphere onto
%             % a circle
%             
%             % X Y represent coordinates after stereographic projection
%             radiusNormalised = radius / radiusInPixel;
%             X = i / radiusInPixel;
%             Y = j / radiusInPixel;
%             
%             l = 1 + X*X + Y*Y;
%             
%             % convert X Y to coordinates on the unit sphere
%             x = 2*X / l;
%             y = 2*Y / l;
%             z = (1 - X*X - Y*Y) / l;
%             
%             % http://de.wikipedia.org/wiki/Kugelkoordinaten
%             % We use the same coordinate system as shown at the site above
%             % coordinate axes of said coordinate system and the one for
%             % stereographic projection match
%             
%             % compute spherical coordinates
%             phiAngle   = atan2(y, x);
%             thetaAngle = (pi / 2) - atan(z/norm([x y]));
%             
%             % compute angle between direction to sun and current coordinate
%             % on hemisphere
%             v = [x y z];
%             cosGamma = s * v';
%             gammaAngle = acos(cosGamma);
%             
%             % compute preetham model for current coordinate on hemisphere
%             v_x = xz * (digamma(thetaAngle, gammaAngle, Ax) / denominator_x);
%             v_y = yz * (digamma(thetaAngle, gammaAngle, Ay) / denominator_y);
%             v_Y = Yz * (digamma(thetaAngle, gammaAngle, AY) / denominator_Y);
%             
%             % preetham gives results in xyY space
%             xyY(iy,ix,1) = v_x;
%             xyY(iy,ix,2) = v_y;
%             xyY(iy,ix,3) = v_Y;
%             
%             % convert xyY to XYZ
%             lXYZ = zeros(1,3);
%             lXYZ(1) = (v_x / v_y) * v_Y;
%             lXYZ(2) = v_Y;
%             lXYZ(3) = ((1.0 - v_x - v_y) / v_y) * v_Y;
%             
%             XYZ(iy,ix,:) = lXYZ;
%             
%             % convert XYZ to linear sRGB
%             lsRGB = XYZ2sRGBD50 * lXYZ';
%             sRGB(iy,ix,:) = lsRGB;
%         end
%     end
% end


end