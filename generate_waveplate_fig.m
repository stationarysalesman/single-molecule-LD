function [xs, ys] = generate_waveplate_fig()
% Generate a plot of input signal and exposure time pulse train plus TTL
% trigger pulse


% All signals need to have the same total time
T = 5; % in seconds

% Input signal: sampled cosine wave with frequency given by DC motor rotational
% velocity (in Hz); sampling frequency determined by exposure time
exposure_time = 100e-3; % in seconds
motor_freq = 1; % in Hertz
t_input = 0:exposure_time:T;
ys_input = 0.5 * (cos(motor_freq * 2 * pi * t_input) + 1);
hold on;
plot(t_input,ys_input, 'LineStyle', 'None', 'Marker', 'o');

% Superimpose the real cosine wave
t_real = 0:1e-4:T % e.g. 10kHz sampling
ys_real = 0.5 * (cos(motor_freq * 2 * pi * t_real) + 1);
plot(t_real, ys_real, 'LineWidth', 2);