%Discrete observer

numSpeed = [1.108];
denSpeed = [0.7353 0.8386 1];
TransferFunctonSpeed = tf(numSpeed,denSpeed)


%   State space model
[Aspeed,Bspeed,Cspeed,Dspeed] = tf2ss(numSpeed,denSpeed)
Gspeed = ss(Aspeed,Bspeed,Cspeed,Dspeed)

Ts = 0.01;                          
%GdSpeed = c2d(Gspeed,Ts,'zoh'); 
GdSpeed = c2d(Gspeed,Ts,'Tustin'); 

Aaugmented = [0 Gspeed.C; zeros(2,1) Gspeed.A]; 
Baugmented = [0; Gspeed.B]; 

roESpeed = 0.25;                             
q1 = 1;                                  	 %1) q1 = 1         2) 0.94
q2 = 2.2707;                                 %1) q2 = 2.2707    2) 1.65
q3 = 0.5;                                          
Qespeed = [ q1 0 0; 0 q2 0 ; 0 0 q3];
Qespeed = roESpeed*Qespeed;
Respeed = 1;

%finding the State feedback
K = -lqrd (Aaugmented,Baugmented,Qespeed,Respeed,Ts)

%finding the observer gains
poles = eig(GdSpeed)*0.5
L = place(GdSpeed.A',GdSpeed.C',poles)
Ltr = L'
eig(GdSpeed.A - Ltr*GdSpeed.C)
