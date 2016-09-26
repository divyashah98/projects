% Transfer function relating the armature current and the armature voltage
clear all;
J = 10.91*10^-3;    
K = 0.8379;
R = 1.36;
L = 3.6*10^-3;
s = tf('s');
M = 12.6530;
Kp = 0.3955
Ki = 702.7961
Ci = pid(Kp, Ki);
Ia =  (1/L)/(s + R/L);
current_contr = feedback(Ci*Ia, 1);
Speed_contr = feedback(current_contr*K*(1/(s*J)), K);
step(Speed_contr);
title('Step Response without Controller');
grid on;

% PI controller for the current loop control of the motor

Kp = 5.4721
Ki = 70.2297;
Kd = 0.10659;
C = pid(Kp, Ki, Kd);
sys_cl = feedback(C*Speed_contr, 1);
figure;
bode(sys_cl, logspace(0,2))
margin(sys_cl)
grid on;
figure;
step(sys_cl);
title('Step Response with Controller');
grid on;