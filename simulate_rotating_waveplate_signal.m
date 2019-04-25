function [real_angle, computed_angle] = simulate_rotating_waveplate_signal(motor_freq, exposure_time, num_frames, amplitude, offset, noise_magnitude)
% Simulate an experiment wherein the motor rotates at motor_freq (Hz) and
% the camera exposure time is given by exposure_time (s)
% @param motor_freq: frequency of the DC motor (Hz)
% @param exposure_time: exposure time of camera (equivalent to sampling
% period)
% @param num_frames: number of frames in the video (equivalent to total
% number of samples)
% @param amplitude: the amplitude of the noiseless signal (i.e. the
% absolute difference between perpendicular and parallel emission
% intensities)
% @param offset: the average intensity over the entire cycle
% @param noise_magnitude: magnitude of noise, relative to signal
% intensity (noise_magnitude = 2 means we will superimpose white noise with
% zero mean and standard deviation of twice the amplitude of the noiseless
% signal)
% @return: the root mean squared error between the true dichroic ratio and
% the fitted dichroic ratio

T = exposure_time; % sampling period
Fs = 1 / T; % sampling frequency
L = num_frames; % number of samples obtained
t = (0:L-1)*T;

% Generate the idealized cosine waveform, which is the convolution of the motor
% rotation with the emission of the sample, assuming the sample emits
% 600 (+- 200) photons on average.

S = (amplitude * cos(2*pi*motor_freq*4*t)+offset);

% A note on noise: while Poisson noise from photon emission is expected to
% go as the square root of the signal, there are other noise sources (laser
% intensity variation, etc) which are assumed to contribute
% white noise with magnitude of 20% of the observed signal. Justification
% comes from fitting the mean and standard deviation of polarization data,
% which showed a mean of 711 and stddev of 133 for a particular
% polarization of incident light. We will simulate other values, too.
X = S + normrnd(0, noise_magnitude*amplitude, size(t));


Y = fft(X);

% compute single-sided spectrum from two-sided spectrum
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

%plot(f(2:end),P1(2:end));
[pk, idx] = max(P1(2:end));
fourier_amplitude = P1(201);

% Auxilliary plotting
%{
subplot(3,1,1, 'FontSize', 20);
hold on;
plot(t(1:100),S(1:100), 'LineWidth', 3);
title('Noiseless Sampling', 'FontSize', 20);
subplot(3,1,2, 'FontSize', 20);
hold on;
plot(t(1:100),X(1:100), 'LineWidth', 3);
title('Sampling with Noise', 'FontSize', 20);
ylabel('Signal Intensity (a.u.)', 'FontSize', 20);
subplot(3,1,3, 'FontSize', 20);
hold on;
%}

%{
plot(t(1:100),sin_fit(t(1:100)), 'LineWidth', 3);
title('Fit to Sine Function', 'FontSize', 20);
xlabel('time (s)', 'FontSize', 20);
%}

%{
plot(f(2:end),P1(2:end), 'LineWidth', 2);
title('One-Sided Spectrum of FFT', 'FontSize', 20);
xlabel('Frequency (Hz)');
%}

% Compute the real and fitted dichroic ratios
real_rho = (offset + 0.5 * amplitude) / (offset - 0.5 * amplitude); % let's assume top is perpendicular
computed_offset = mean(X);
computed_perp = computed_offset + 0.5 * fourier_amplitude;
computed_par = computed_offset - 0.5 * fourier_amplitude;
computed_rho = computed_perp / computed_par;

% Compute the real and fitted orientations, assuming incident angle is 80
% deg
real_angle = CalculateThetaFromRho(real_rho, 80);
computed_angle = CalculateThetaFromRho(computed_rho, 80);

% Display
%{
sprintf('True dichroic ratio: %f', real_rho)
sprintf('Computed dichroic ratio: %f', computed_rho)
%}
end

