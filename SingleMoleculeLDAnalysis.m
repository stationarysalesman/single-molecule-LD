function [theta] = SingleMoleculeLDAnalysis(Iperp, Ipar)

% From Bohn, et al: The dichroic ratio is defined as the ratio of
% absorbance of 'transverse electric' to absorbance of 'transverse
% magnetic'; here, transverse is with respect to the plane of
% incidence. Therefore, light polarized perpendicular to the z-axis,
% which has its electric vector in the xy-plane, has its electric vector
% oriented transverse to the plane of incidence (the xz-plane), and thus
% A parallel = A transverse electric.

ratio = Iperp/Ipar;

% Using the known angle of incidence, calculate the angle the transition
% moment subtends with the z-axis
% Adapted from Mark McLean's code

n1=1.515;
n2=1.335;
n=n2/n1;
theta_i = 80;
E_x = abs(2*sqrt(power(sind(theta_i),2) - power(n,2)) * cosd(theta_i) / ...
    sqrt(1-power(n,2)) / sqrt((1+power(n,2)) * power(sind(theta_i),2) - ...
    power(n,2)));
E_y = abs(2*cosd(theta_i) / sqrt(1 - power(n,2)));
E_z = abs(2*cosd(theta_i) * sind(theta_i) / sqrt(1-power(n,2)) / ...
    sqrt((1+power(n,2)) * power(sind(theta_i),2) - power(n,2)));

numerator = (power(E_y, 2) / ratio) - power(E_x, 2);
denom = 2 * power(E_z, 2);
frac = numerator / denom;
theta = acotd(sqrt(frac));

