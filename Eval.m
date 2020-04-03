function [P, R] = Eval(X, Y)


num_test = size(X,2);
precs = zeros(1,num_test);
recs    = zeros(1,num_test);

RRP = (X & Y);

for j = 1:num_test
    RRN = nnz(RRP(:,j));
    ret_num = nnz(Y(:,j));
    rel_num  = nnz(X(:,j));
    if ret_num
        precs(j) = RRN / ret_num;
    else
        precs(j) = 0;
    end
    if rel_num
        recs(j) = RRN / rel_num;
    else
        recs(j) = 0;
    end
end

P = mean(precs);
R = mean(recs);