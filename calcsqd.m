%% funcs
function sqd = calcsqd(X, as)
    x = sum(X.^2,2);
%return ;
 y = sum(as.^2,2);    
    sqd = max(bsxfun(@plus,x,bsxfun(@plus,y',-2*X*as')),0);
end