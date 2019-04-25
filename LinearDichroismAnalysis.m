function [theta] = LinearDichroismAnalysis(ref,sample)
% Assign variables to analyze


% Analyze the reference
time = ref(1,:);
dc = ref(2,:);
diode = ref(3,:);
r = ref(4,:);
theta = ref(5,:);
freq = ref(6,:);

% Analyze the sample
time_sample = sample(1,:);
dc_sample = sample(2,:);
diode_sample = sample(3,:);
r_sample = sample(4,:);
theta_sample = sample(5,:);
freq_sample = sample(6,:);

DC_r = mean(dc);
DC_s = mean(dc_sample);
diode_r = mean(diode);
diode_s = mean(diode_sample);
RMS_r = mean(r);
RMS_s = mean(r_sample);

% Divide by the diode voltage to account for laser drift
dc_r_corrected = DC_r / diode_r;
dc_s_corrected = DC_s / diode_s;
RMS_r_corrected = RMS_r / diode_r;
RMS_s_corrected = RMS_s / diode_s;
Vpk_r = 2.9405 * RMS_r_corrected;
I0_par = dc_r_corrected + 0.5 * Vpk_r;
I0_perp = dc_r_corrected - 0.5 * Vpk_r;
Vpk_s = 2.9405 * RMS_s_corrected;
Ipar = dc_s_corrected + 0.5 * Vpk_s;
Iperp = dc_s_corrected - 0.5 * Vpk_s;
A_par = -log10(Ipar/I0_par);
A_perp = -log10(Iperp/I0_perp);

% From Bohn, et al: The dichroic ratio is defined as the ratio of
% absorbance of 'transverse electric' to absorbance of 'transverse
% magnetic'; here, transverse is with respect to the plane of
% incidence. Therefore, light polarized perpendicular to the z-axis,
% which has its electric vector in the xy-plane, has its electric vector
% oriented transverse to the plane of incidence (the xz-plane), and thus
% A parallel = A transverse electric.
%
% Additional note: since we are dividing every voltage by the reference,
% all numbers are pure and thus have no units, except the orientation.

ratio = A_perp/A_par;

%fprintf("I0_par: %f\n", I0_par);
%fprintf("I0_perp: %f\n", I0_perp);
%fprintf("Ipar: %f\n", Ipar);
%fprintf("Iperp: %f\n", Iperp);
%fprintf("Apar: %f\n", A_par);
%fprintf("Aperp: %f\n", A_perp);
%fprintf("Dichroic ratio: %f\n", ratio);


% Using the known angle of incidence, calculate the angle the transition
% moment subtends with the z-axis
% Adapted from Mark McLean's code
n1=1.55222;
n2=1.335;
n=n2/n1;
theta_i = 63;
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

