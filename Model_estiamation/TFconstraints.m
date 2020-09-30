Ts = 7.5;

Gain = 375;

T = Ts/4;

Gorder1 = tf(Gain, [T 1]);
Gorder11 = tf([-200 Gain*1.5], [T 1]);

hold on;

[pl1, pl1Time] = step(Gorder1);
[pl2, pl2Time] = step(Gorder11);

limAcc1 = limiter(pl1, 0, 320);
limAcc2 = limiter(pl2, 0, 320);

step(Gorder1);
%step(Gorder11);
step(G);

plot(pl1Time, limAcc1, 'r-.');
plot(pl2Time, limAcc2, 'g-.');
