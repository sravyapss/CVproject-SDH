function [P, G, B] = train_hinge(X , y, B, loss, maxItr)
    U = unique(y);
    Y = zeros(length(y),length(U));
    for i=1:length(y)
        Y(i,y(i)) = 1;
    end
    
    function P = calcP(X, B)
        X_1 = X';
        P_int = (X_1*X)\X_1;
        P = P_int*B;
    end

    %G step
    disp("Hinge loss");
    svm_option = ['-q -s 4 -c ', num2str(1.0)];
    model = train(double(y),sparse(B),svm_option);
    W = model.w';

    % F step
    P = calcP(X, B); %1001*l P
    FX = P'*X'; %l*n  
    for i = 1:maxItr 
       P_start = P;
       for i = 1 : size(B,1)
           w_ki = bsxfun(@minus, W(:,y(i)), W);
           %disp(size(w_ix_z));
           a1 = 2*1e-5*FX(:,i);
           a2 = 1e5*sum(w_ki,2)';
           B(i,:) = sign(a1' + a2);
       end
       
       % G step
       model = train(double(y),sparse(B),svm_option);
       W = model.w';
       
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