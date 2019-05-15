function [filtered] = filter_smLD_data(data)
% get that shit data out of here
%   Criteria for keeping data:
%       > 5 seconds of data
%       > 75 avg. signal intensity
%       Only data up to first change point will be considered.
num_trajs = length(data(:,1));
filtered = [];
mean_cutoff = 75;
length_cutoff = 50; % total number of samples
for i = 1:num_trajs
   traj = data(i,:);
   cp = findcp(traj);
   if (length(cp) ~= 1)
       continue;
   end
   signal = traj(1:cp(1));
   if (length(signal) < length_cutoff) || (mean(signal) < mean_cutoff)
       continue;
   end
   
   filtered = [filtered; traj];
   
end
end

