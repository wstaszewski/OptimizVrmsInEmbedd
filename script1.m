% Signal parameters
fs = 32000;     % sampling frequency
N  = fs;        % number of samples in the signal
T  = 1;         % signal total duration [s]

% Time vector
dt = 1/fs;
t  = dt:dt:T;

% Generate acceleration signal
f   = 159.2;  % [Hz] frequency of single component 
acc = sin(2*pi*f*t);   % acceleration signal

% Classical time-domain algorithm
acc   = acc - mean(acc);    % remove DC component
fo    = 4;                  %  filter order
fc    = 10;                 %  filter HP cutoff frequency
% generate filter coefficients
[b,a] = butter(fo,fc/(fs/2),'high');    
acc   = filter(b,a,acc);    % filter the signal
% remove DC before integration
acc       = acc - mean(acc); 
accInt    = acc;            % cumulative variable
accInt(1) = 0;   % set first point manually to "0"

% integration loop
for i = 2:N
    accInt(i) = accInt(i-1) + acc(i)/fs; 
end

% scale acc to vel [g] to [mm/s]
vel  = accInt * 9810;
% remove DC componentafter integration
vel  = vel - mean(vel);         

% VRMS: 6.980024376200330 mm/s
VRMS = sqrt(1/N*sum(vel.^2));   

% Note: the amplitude of the velocity signal of this one component is:
% 9810/(2*pi*159.2) = 9.807223566152597 mm/s
% and the analytical value of the VRMS (in frequency domain) is:
% sqrt(1/2*(9810/(2*pi*159.2))^2) = 6.934754288239017 mm/s
