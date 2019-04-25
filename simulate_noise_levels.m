function out = simulate_noise_levels()
% Simulate how different levels of noise affect the RMSE between calcualted
% and real orientation angles with some reasonable assumptions

amplitude = 200;
offset = 700; 
motor_freq = 1; % in Hz
exposure_time = 50e-3; % in s
num_frames = 1000;

xs = 0:0.2:30;
ys = zeros(1, length(xs));
for i = 1:length(xs)
   num_sims = 30;
   tmp_real = zeros(1, length(num_sims));
   tmp_computed = zeros(1, length(num_sims));
   for j = 1:num_sims
       [tmp_real(j), tmp_computed(j)] = simulate_rotating_waveplate_signal(motor_freq, exposure_time, num_frames, amplitude, offset, xs(i));
   end
   diff = tmp_real - tmp_computed;
   sq = power(diff, 2);
   m = mean(sq);
   rmse = sqrt(m);
   ys(i) = rmse;
end

% Display
plot(xs, ys, 'LineWidth', 2, 'Color', 'k');
title('Average RMSE of Orientation Angle (Theoretical vs Fitted)', 'FontSize', 20);
xlabel('Noise Magnitude (relative to signal amplitude, a.u.)', 'FontSize', 20);
ylabel('RMSE', 'FontSize', 20);
eq_str = sprintf('S(t)=%dcos(2 \\pi (4)(%f) t) + %d', amplitude, motor_freq, offset);
text(2.5, 5, eq_str, 'FontSize', 20);
end

