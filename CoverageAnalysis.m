A_disc = pi * 5e-9 * 5e-9;
A_field = 80e-6 * 80e-6;
xs = linspace(0, 1, 100);
ys = zeros(100,1);
N_discs = 100;

% Probability that our hit rate (binding to discs) is at least 50% 
ys = binocdf(50, N_discs, 1-xs);
hold on;
plot(xs, ys);

% P(hit rate) > 60%
plot(xs, binocdf(40, N_discs, 1-xs));

% P(hit rate) > 70%
plot(xs, binocdf(30, N_discs, 1-xs));
hold off;
