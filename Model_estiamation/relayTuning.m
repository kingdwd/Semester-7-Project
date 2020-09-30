% Ultimate <=> Critical 

% Relay range: 0.75 <-> 1.25, 0.5 <-> 1.5

% Ultimate period
Tu = 3.5; %3.5;

% Relay output amplitude
d = 0.25; %0.5;

% System output
a = 0.175; %0.35;

% ------------------------------------------------------------------------

% Gain factor
Kf = 0; %0.6;

% Integral time factor
Tif = 0; %0.5;

% Derivative time factor
Tdf = 0; %0.12;

% Classic PID
%Kf = 0.6; Tif = 0.5; Tdf = 0.12;

% Pessen Integral Rule
%Kf = 0.7; Tif = 1/2.5; Tdf = 3/20;

% No overshoot
%Kf = 0.2; Tif = 1/2; Tdf = 1/3;

% Some overshoot
Kf = 0.33; Tif = 1/2; Tdf = 1/3;

% ========================================================================

% Ultimate gain
Ku = (4*d) / (pi * a);

% Proportional controller gain
Kp = Kf * Ku;

% Integral time
Ti = Tif * Tu;

% Derivative time
Td = Tdf * Tu;

% Integral controller gain
Ki = Kp / Ti;

% Derivative controller gain
Kd = Kp * Td;

Kp
Ki
Kd

