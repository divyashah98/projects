f = @(t,y)[3-t^2*y];
[t, xa] = ode45(f, [1 3], [0 1]);
plot(t,xa(:,2))
title('y(t)')
xlabel('t'), ylabel('y')
