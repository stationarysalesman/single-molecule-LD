function [theta] = CalculateThetaFromConstraints(theta1, theta2)
% Compute the expected angle based on a molecule constrained to randomly
% sample angles in the range [theta1, theta2] (90 deg >= theta2 >= theta1)

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

theta1_rad = theta1 * (pi / 180);
theta2_rad = theta2 * (pi / 180);
inside = (sqrt(2) * E_z * cot(theta1_rad)) / E_x;
numerator = (E_y * E_y) * (sqrt(2) * abs(E_z) * atan(inside) - E_x * atan(cot(theta1_rad)));
denominator = power(E_x, 3) - (2 * E_x * (E_z * E_z));
rho1 = numerator / denominator;

inside2 = (sqrt(2) * E_z * cot(theta2_rad)) / E_x;
numerator2 = (E_y * E_y) * (sqrt(2) * abs(E_z) * atan(inside2) - E_x * atan(cot(theta2_rad)));
rho2 = numerator2 / denominator;
rho = (rho2 - rho1) / (theta2_rad - theta1_rad);
theta = CalculateThetaFromRho(rho, 80);
end

