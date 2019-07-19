% Calculate a 3D plot of the possible random angles given various
% constraints (theta2 and theta1)

matrix = zeros(90,90);
for theta2=90:-1:1
   for theta1=theta2:-1:1
       matrix(theta1,theta2) = CalculateThetaFromConstraints(theta1,theta2);
   end
end

X = 1:1:90;
Y = 1:1:90;
surf(X,Y, matrix(X,Y));
hold on;
surf(X,Y, 54 * ones(length(X),length(X)));
xlabel('\theta_1 (deg)');
ylabel('\theta_2 (deg)');
idxs = find(matrix >= 53 & matrix <= 55);

for i = 1:length(idxs)
    t1 = floor(idxs(i) / 90);
    t2 = mod(idxs(i), 90);
    fprintf('Theta may range from %f to %f\n', t1, t2);
end