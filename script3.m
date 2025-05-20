% Signal parameters
fs = 32000;     % sampling frequency
N  = fs;        % number of samples in the signal
T  = 1;         % signal total duration [s]

% Time vector
dt = 1/fs;
t  = dt:dt:T;

% Generate acceleration signal
f   = 159.2;  % [Hz] frequency of single component 
acc = sin(2*pi*f*t);  % acceleration signal

% Proposed algorithm
N_frag   = 4;     % parameter: number of fragments
% parameter: number of samples in processed window
w_len    = 4096;    
% parameter: ISO 20816 VRMS frequency band limits [Hz]
limits   = [10 1000]; 
% parameter: downsampling factor
r        = 4;         

% original spectral resolution: 1 Hz
df       = fs/N;              
% new sampling frequency: 32kHz/4 = 8kHz
fs_new   = ceil(fs/r);        
% new spectral resolution: 8000/4096=1.953125Hz
df_new   = fs_new/w_len;      
fax      = 0:df_new:fs_new/2; % new frequency axis
% optionally generate Tukey window
win      = tukeywin(w_len, .2);     
acc_down = acc(1:r:fs);     % downsample data
% new sampling frequency: 32kHz/4=8kHz
fs_new   = ceil(fs/r);  

% ------------------- static indexes reference ----------------------------
% N_overlap = floor(w_len-(fs_new-w_len)/(No_frag-1))+1; % overlap: 2795
% w_len*[0:N_frag-1] - N_overlap*[0:N_frag-1]+1          % starting indexes
% w_len*[1:N_frag  ] - N_overlap*[0:N_frag-1]            % ending indexes
% -------------------------------------------------------------------------
% --------------------- loop indexes reference ----------------------------
% index_from = (w_len - N_overlap)*(i-1) + 1;    % [   1 1302 2603 3904]
% index_till = index_from + w_len - 1;           % [4096 5397 6698 7999]
% x          = acc_down(index_from:index_till);  
% -------------------------------------------------------------------------

VRMS_frag = zeros(1,N_frag);
for i = 1:N_frag
    switch i
     % static indexes for clarity
        case 1
            x = acc_down(1:4096);       
        case 2
            x = acc_down(1302:5397);
        case 3
            x = acc_down(2603:6698);
        otherwise
            x = acc_down(3904:7999);
    end

    x = x - mean(x);  % remove DC
    x = x.*win';      % optional signal windowing
% spectral acceleration amplitudes
    Y = abs(fft(x)); 
% spectral acceleration amplitudes    
    Y = Y(1:w_len/2+1)./(w_len/2);      
% Omega arithmetics
    Y = Y(2:end)./(2*pi*fax(2:end));    
% scale acc [g] to vel [mm/s]
    Y = Y*9810;                         
% i_start: 5
    i_start = round(limits(1)/df_new);  
% i_start: 512
    i_stop  = floor(limits(2)/df_new);  

    VRMS_frag(i) = sqrt(1/2*sum(Y(i_start:i_stop).^2));
end
% VRMS no window:   6.944205362809169 mm/s
% VRMS plus window: 6.487143417476240 mm/s                               
VRMS = min(VRMS_frag);         

% Note: the amplitude of the velocity signal of this one component is:
% 9810/(2*pi*159.2) = 9.807223566152597 mm/s
% and the analytical value of the VRMS (in frequency domain) is:
% sqrt(1/2*(9810/(2*pi*159.2))^2) = 6.934754288239017 mm/s
