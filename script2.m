% Signal parameters
fs = 32000;     % sampling frequency
N  = fs;        % number of samples in the signal
T  = 1;         % signal total duration [s]

% Time vector
dt = 1/fs;
t  = dt:dt:T;

% Frequency vector
df  = fs/N;      % spectral resolution
fax = 0:df:fs/2; % frequency axis

% Generate acceleration signal
f   = 159.2;  % [Hz] frequency of single component 
acc = sin(2*pi*f*t);   % acceleration signal

% Frequency-domain algorithm
% spectral acceleration values
Y = abs(fft(acc));               
% one-sided, scaled scaled
Y = Y(1:N/2+1)/(N/2);            
% Omega arithmetics
Y = Y(2:end)./(2*pi*fax(2:end)); 
% scale acc [g] to vel [mm/s]
Y = Y*9810;                      

cutoff_start = 10;      % starting frequency [Hz]
cutoff_stop  = 1000;    % ending frequency [Hz]
% index corresponding to 10Hz
i_start      = floor(cutoff_start/df);  
% index corresponding to 1kHz
i_stop       = floor(cutoff_stop/df);   
% bandpass components
Y            = Y(i_start:i_stop);       
% VRMS: 6.958540507182517 mm/s
VRMS         = sqrt(1/2*sum(Y.^2));     

% Note: the amplitude of the velocity signal of this one component is:
% 9810/(2*pi*159.2) = 9.807223566152597 mm/s
% and the analytical value of the VRMS (in frequency domain) is:
% sqrt(1/2*(9810/(2*pi*159.2))^2) = 6.934754288239017 mm/s
