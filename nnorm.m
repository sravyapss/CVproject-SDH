function X_N = nnorm(X)
    X = double(X);
    X_T = X';
    rows = size(X,1);
    norm = sqrt(sum(X_T.^2));
    %uu = ones(rows,1)*norm;
    %S = diag(uu);
    if (norm == 0)
        norm = 1;
    end
    norm = 1./norm;
    %uu = ones(rows,1)*norm;
    S = sparse((1:rows),(1:rows),norm);
    %S = diag(uu);
    X_N = (X_T*S)';
    
end