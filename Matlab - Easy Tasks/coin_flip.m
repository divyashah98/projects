% 
% % Script27

function [N] = coin_flip(M)
    N = 0;
    ans = 0;
    count = 0;
    while (ans ~= 1)
        heads = 0;
        tails = 0;
        while (heads ~= M)
            flip = rand;
            count = count + 1;
            if (flip > 0.5)
                disp('H');
                heads = heads + 1;
            else
                disp('T');
                heads = 0;
            end
        end
        while (tails ~=M)
            flip = rand;
            count = count + 1;
            if (flip < 0.5)
                disp('T');
                tails = tails + 1;
                if (tails == M)
                    ans = 1;
                end
            else
                disp('H');
                tails = 0;
            end
        end
    end
    N = count;
end