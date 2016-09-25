% 
% % % Script 26
b = [0, 1];
A = input('Enter the positive integers in a single line\n');
modulo = mod(A, 2);
for i=1:size(A,2)
    if (modulo(i) == 1)
        b(1) = b (1) + A(i);
    else
        b(2) = b(2) * A(i);
    end
end
b
