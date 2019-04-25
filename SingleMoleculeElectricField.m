

% Adapted from Mark McLean's code
n1=1.55222;
n2=1.335;
n=n2/n1;
theta_i = 80; % a reasonable assumption, not measured precisely

% Plot the electric field amplitudes as a function of the incident angle
% (the incident angle being the angle made by the normal to the reflecting
% surface and the incident light)
xs = linspace(46, 90, 100);
ys_E_x = zeros(1,length(xs));
length(ys_E_x)
for i=1:length(xs)
    ys_E_x(i) = calc_E_x(xs(i), n);
end
length(ys_E_x)
ys_E_y = zeros(1,length(xs));
for i=1:length(xs)
    ys_E_y(i) = calc_E_y(xs(i), n);
end
ys_E_z = zeros(1,length(xs));
for i=1:length(xs)
    ys_E_z(i) = calc_E_z(xs(i), n);
end

%hold on;
%plot(xs, ys_E_x);
%plot(xs, ys_E_y);
%plot(xs, ys_E_z);


% Now, calculate the amplitude of each component of the electric field in
% the rarer medium (i.e. buffer) assuming unit illumination with either
% parallel (Ex0 and Ez0 components) or perpendicular (Ey) polarization.
E_x = calc_E_x(theta_i, n);
E_y = calc_E_y(theta_i, n);
E_z = calc_E_z(theta_i, n);
E_perp = E_y;
E_parallel = sqrt(square(E_x) + square(E_z));
fprintf('Electric field amplitude (perpendicular): %f\n', E_perp);
fprintf('Electric field amplitude (parallel): %f\n', E_parallel);

function E_x = calc_E_x(theta_i, n)
E_x = abs(2*sqrt(power(sind(theta_i),2) - power(n,2)) * cosd(theta_i) / ...
    sqrt(1-power(n,2)) / sqrt((1+power(n,2)) * power(sind(theta_i),2) - ...
    power(n,2)));
end
function E_y = calc_E_y(theta_i, n)
E_y = abs(2*cosd(theta_i) / sqrt(1 - power(n,2)));
end
function E_z = calc_E_z(theta_i, n)
E_z = abs(2*cosd(theta_i) * sind(theta_i) / sqrt(1-power(n,2)) / ...
    sqrt((1+power(n,2)) * power(sind(theta_i),2) - power(n,2)));
end
