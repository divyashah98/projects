% Transfer function relating the armature current and the armature voltage

J = 10.91*10^-3;    
K = 0.8379;
R = 1.36;
L = 3.6*10^-3;
s = tf('s');
M = 12.6530;
I_motor = (s/L)/((s+(R/L))*s + (K^2/(J*L)))
step(I_motor);
title('Step Response without Controller');
grid on;

% PI controller for the current loop control of the motor

Kp = 0.3955
Ki = 702.7961
C = pid(Kp, Ki);
sys_cl = feedback(C*I_motor, 1);
figure;
bode(sys_cl, logspace(0,2))
margin(sys_cl)
grid on;
figure;
step(sys_cl);
title('Step Response with Controller');
grid on;