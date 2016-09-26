% Electric Drives Project %

% Declaring the different parameters for the Armature Comtrolled %
% DC Motor and the Capstan Slide %
J = 10.91*10^-3;        % Inertial of roller, shaft, motor and tachometer %   
K = 0.8379;             % Torque constant / Back EMF constant %
R = 1.36;               % Motor Inductance %
L = 3.6*10^-3;          % Motor Inductance %
M = 12.6530;            % M is the sum of the mass of slide and drive bar %
R_rad = 31.75*10^-3;    % Roller Radius %
s = tf('s');

% Using different equations - transfer function relating input armature %
% voltage with the output current %
I_motor = (s/L)/((s+(R/L))*s + (K^2/(J*L)))
step(I_motor);
title('Step Response of the plant (Ia(s) / Va(s)) without the Controller');
grid on;

% Kp and Ki for current controller %
Kp = 0.3955;            % Value of Kp calculated using pidtool %
Ki = 702.7961;          % Value of Ki calculated using pidtool %
Ci = pid(Kp, Ki);

% Calculating the transfer function with the controller %
sys_cl = feedback(Ci*I_motor, 1); 
figure;
bode(sys_cl, logspace(0,2))
margin(sys_cl)
grid on;
figure;
step(sys_cl);
title('Step Response of the plant (Ia(s) / Va(s)) with Controller');
grid on;

% Using different equations, transfer function relating input armature %
% voltage with the resulting motor speed %
Ia =  (1/L)/(s + R/L);
current_contr = feedback(Ci*Ia, 1);
Speed_contr = feedback(current_contr*K*(1/(s*J)), K);
figure;
step(Speed_contr);
title('Step Response of the plant (Wm(s) / Va(s)) without Speed Controller');
grid on;

% Kp, Ki and Kd for speed controller %
Kp = 5.4721             % Value of Kp calculated using pidtool %
Ki = 70.2297;           % Value of Ki calculated using pidtool %
Kd = 0.10659;           % Value of Kd calculated using pidtool %
Cs = pid(Kp, Ki, Kd);

% Calculating the transfer function with the controller %
sys_cl = feedback(Cs*Speed_contr, 1);
figure;
bode(sys_cl, logspace(0,2))
margin(sys_cl)
grid on;
figure;
step(sys_cl);
title('Step Response of the plant (Wm(s) / Va(s)) with Speed Controller');
grid on;

% Using different equations to model transfer function relating motor %
% torque with the position of the linear slide %

position_contr = feedback(1/(s^2*M*R_rad), 1);
figure;
step(position_contr, 1:10);
title('Step Response of the plant (Tm(s) / X(s)) without Position Controller');
grid on;

% Kp, Ki and Kd for position controller %
Kp = 20.086;
Ki = 3.4079;
Kd = 3.5132;
C = pid(Kp, Ki, Kd);

% Calculating the transfer function with the controller %
sys_cl = feedback(C*position_contr, 1);
figure;
bode(sys_cl, logspace(0,2))
margin(sys_cl)
grid on;
figure;
step(sys_cl);
title('Step Response of the plant (Tm(s) / X(s)) with Position Controller');
grid on;