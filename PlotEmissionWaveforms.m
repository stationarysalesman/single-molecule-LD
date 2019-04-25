% Assume we have two molecules, a and b, with dichroic ratios 2.1 and 0.6,
% respectively.
a_rho = 2.1;
b_rho = 0.6;

% Assign an arbitrary background-subtracted emission intensity for the
% parallel polarization for each molecule, and calculate the perpendicular
% emission intensity using the dichroic ratio (rho = iperp/ipar).
a_ipar = 500;
a_iperp = a_rho * a_ipar; % Note a_iperp > a_ipar
b_ipar = 600;
b_iperp = b_rho * b_ipar; % Note b_iperp < b_ipar

% Now, plot the expected emission intensity as a function of the incident
% polarization. The maxima will represent orthogonal linear polarizations
% (parallel or perpendicular), and everything in between is elliptical
% polarization.


% We can represent the total function as a superposition of a cosine term
% (for the parallel intensity) and a cosine term with a phase offset (for 
% the perpendicular intensity). At t=0, the parallel term will be maximal 
% and the perpendicular term will be 0, and thus we will start with the 
% wave plate oriented at 0 degrees relative to the z-axis.

xs = linspace(0, 10*pi, 100); % step size will be pi/10
a_cos = (a_ipar/2) * cos(xs) + (a_ipar/2);
a_sin = (a_iperp/2) * cos(xs + pi) + (a_iperp/2);
a_total = a_cos + a_sin;
b_cos = (b_ipar/2) * cos(xs) + (b_ipar/2);
b_sin = (b_iperp/2) * cos(xs + pi) + (b_iperp/2);
b_total = b_cos + b_sin;

% Plot the resulting functions. 
hold on;
plot(a_total, 'r', 'LineWidth', 2);
plot(b_total, 'b', 'LineWidth', 2);
ax = gca;
ax.FontSize = 20;
title('Emission Waveforms for Molecules with Different Dichroic Ratios');
xlabel('time (a.u.)', 'FontSize', 20);
ylabel('Emission Intensity (a.u.)', 'FontSize', 20);
% Label the intensities
hline(a_ipar, 'r', 'Molecule A I_{\mid\mid}');
hline(a_iperp, 'r', 'Molecule A I_{\perp}');
hline(b_ipar, 'b', 'Molecule B I_{\mid\mid}');
hline(b_iperp, 'b', 'Molecule B I_{\perp}');

% Calculate the Orientation angles too. The incident angle beta is taken as
% 80 degrees, a reasonable number based on the NA of the TIRF microscope
% objective lens.
a_theta = CalculateThetaFromRho(a_rho);
b_theta = CalculateThetaFromRho(b_rho);
tmp1 = sprintf('Molecule A (\\theta=%f)', a_theta);
tmp2 = sprintf('Molecule B (\\theta=%f)', b_theta);
legend(tmp1, tmp2);
