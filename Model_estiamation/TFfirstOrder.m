Ts = 7.5;

%Gain = 375;
%Gain = 639.7 / 0.63;
Gain = 650;

%T = Ts/4;
T = 1.8;

Gorder1 = tf(Gain, [T 1]);
Gorder11 = tf([-650 Gain], [T 1]);

Gorder11m = tf([-(Gain / 400)*1.385 (Gain / 400)*1.385], [T 1]);

hold on;

[pl1, pl1Time] = step(Gorder1);
[pl2, pl2Time] = step(Gorder11m);

limAcc1 = limiter(pl1, 0, 320);
limAcc2 = limiter(pl2, 0, 640);

step(Gorder1);
step(Gorder11m);
%step(G);

plot(pl1Time, limAcc1, 'r-.');
plot(pl2Time, limAcc2, 'g-.');

Gss1 = ss(Gorder11);

Gorder11
Gss1


