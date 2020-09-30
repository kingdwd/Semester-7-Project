Gm = tf(1.108, [0.7353 0.8386 1]);

%PID = pid(Kp,Ki,Kd,Tf);

PID = pid(1,0.1,0.01,1);

syms 'K';
%K = sym(K);
%K = 2;

%Gg = tf([-1.108*K 4.924*K],[0.7353 0.417 4.727 4.444]);

%TF = feedback(Gg, tf(1,1));

a3 = 0.7353;
a2 = 0.417;
a1 = 4.727 - 1.108*K;
a0 = 4.444 + 4.924*K;

b1 = -(a3*a0 - a1*a2)/a2;
c1 = -(a2*0 - a0*b1)/b1;

Kr = 1;
Ti = 1;
Td = 1;
n = 1;

Gr = tf(Kr,1) * tf([Ti + 1], [Ti 0]) * tf([Td + 1], [Td/n 1]);

C = tf(PID*Gm);
D = tf(Gr*Gm);

% hold on;

% step(Gm);
% step(C);
% step(D);

% xlim([0 25]);
% ylim([-1 10]);

% PID
% C

%Gg
%TF

margin(Gm);
%bode(Gm);

title('Bode plot of speed transfer function', 'FontSize',20);

% xlabel('Time','FontSize',20);
% ylabel('Ticks per second','FontSize',20);
% xlim([0 12]);
% ylim([-100 500]);
% set(gca,'FontSize',20);

b1
c1