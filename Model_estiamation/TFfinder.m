% This is for a second order underdamped system
% Remember to choose a natural frequency at second last line

% Difference in input
DeltaX = 1;

% Difference in output
DeltaY = 320;

% Max peak value
Ymax = 375;

% Settling value
Yfinal = 320;

% Settling time
Ts = 7.1;

% Peak time
Tp = 2.8;

% Time of second peak of oscillation
Tp2 = 7;

% Time for Y to reach 10% of settling value
T10final = 0.45;

% Time for Y to reach 90% of settling value
T90final = 1.95;

% Settling Overshoot percent
SettlingOS = 2;

% Manual setting of a zero
Zero = 15;

% Manual setting of a pole
Pole = 0.15;

%==================================================

% 10% of settling value
Y10final = 0.1 * Yfinal;

% 90% of settling value
Y90final = 0.9 * Yfinal;

% Rise time
Tr = T90final - T10final;

% %OS
OS = ((Ymax - Yfinal) / Yfinal) * 100;

% Damping factor
Zeta = -log(OS/100) / sqrt(pi^2 + log(OS/100)^2);

% Time period between oscillations
Td = Tp2 - Tp;

% Way #1 of calculating the natural frequency. %OS must be 2%. This is an approxmitation.
OmegaN1 = 4 / (Zeta * Ts);

% Way #2 of calculating the natural frequency.
OmegaN2 = (2 * pi) / (Td * sqrt(1 - Zeta^2));

% Way #3 of calculating the natural frequency.
OmegaN3 = pi / (Tp * sqrt(1 - Zeta^2));

% Way #4 of calculating the natural frequency.
OmegaN4 = -log((SettlingOS/100) * sqrt(1 - Zeta^2)) / (Zeta * Ts);

% Way #5 of calculating the natural frequency.
OmegaN5 = (1.76*Zeta^3 - 0.417*Zeta^2 + 1.039*Zeta + 1) / Tr;

% Gain
K = DeltaY / DeltaX;

% Chosen or calculated natural frequency
OmegaN = OmegaN4;
OmegaNZ = OmegaN * 1.1;

% Transfer function
G = tf(K, [1/(OmegaN^2) (2*Zeta)/OmegaN 1]);

% Transfer function with a zero
G2 = tf([Zero K], [1/(OmegaNZ^2) (2*Zeta)/OmegaNZ 1]);

% Transfer function with 3 poles
G3 = tf([Zero K*0.95], [Pole 1/(OmegaN^2) (2*Zeta)/OmegaN 1]);

% State space model of G
[GssA, GssB, GssC, GssD] = tf2ss(K, [1/(OmegaN^2) (2*Zeta)/OmegaN 1]);
Gss = ss(G);

% G with delay
Gdelay = tf(K, [1/(OmegaN^2) (2*Zeta)/OmegaN 1], 'InputDelay',0.30);

%rlocus(G);

% Transfer function but with meter as output
Gm = tf((K / 400) * 1.385, [1/(OmegaN^2) (2*Zeta)/OmegaN 1]);

% State space model with meter as output, model of Gm
%[GmssA, GmssB, GmssC, GmssD] = tf2ss((K / 400) * 1.385, [1/(OmegaN^2) (2*Zeta)/OmegaN 1]);
Gmss = ss(Gm);


%hold on;
figure;
step(Gm);
figure;
margin(Gm);

A = Gss.A;
B = Gss.B;
C = Gss.C;

OmegaList = [OmegaN1, OmegaN2, OmegaN3, OmegaN4, OmegaN5];
Glist = [tf(1,1), tf(1,1), tf(1,1), tf(1,1), tf(1,1)];

for i = 1:length(OmegaList)
    Glist(i) = tf(K, [1/(OmegaList(i)^2) (2*Zeta)/OmegaList(i) 1], 'InputDelay',0.30);
end 

G_total_delay = tf(K, [1/(OmegaN^2) (2*Zeta)/OmegaN 1], 'InputDelay',0.45);


G
Gss
Gmss
%G2
%G3

