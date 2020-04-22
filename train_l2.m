function [P, G, B] = train_l2(X , y, B, loss, maxItr)
    disp("l2 loss");
    U = unique(y);
    Y = zeros(length(y),length(U));
    for i=1:length(y)
        Y(i,y(i)) = 1;
    end
    
    function W = calcW(B, Y, lambda)
        B_1 = B';
        W_int = (B_1*B + lambda*eye(size(B,2)))\B_1;
        W = W_int*Y;
    end
    
    function P = calcP(X, B)
        X_1 = X';
        P_int = (X_1*X)\X_1;
        P = P_int*B;
    end

    %G step
    W = calcW(B, Y, 1); % W  -> l*c
    % F step
    P = calcP(X, B); %1001*l P
    FX = P'*X'; %l*n  
    for i = 1:maxItr 
       P_start = P;
       Q = W*Y' + 1e-5*FX; % l*n
       Q = Q';
       % B step
       for j= 1:10
           B_start = B;
           for k=1:size(B,2)
               q = Q(:,k);
               B1 = B; B1(:,k) = [];
               v = W(k,:);
               W1 = W; W1(k,:) = [];
               z = sign(q-B1*W1*v');
               B(:, k) = z;
           end
           diff = B-B_start;
           if(norm(diff, 'fro') < 1e-6*norm(B_start, 'fro'))
               break
           end
       end
       % G step
       W = calcW(B, Y, 1); % W  -> l*c
       % F step
       P = calcP(X, B); %1001*l P
       FX = P'*X'; %l*n
       % Break conditions
       diff = norm(B - FX', 'fro');
       G = W;
       if(diff<1e-5*norm(B, 'fro'))
           break
       end
       if(norm(P-P_start, 'fro') < 1e-5*norm(P_start, 'fro'))
           break
       end
    end
end