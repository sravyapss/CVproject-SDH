function XX = sdh(Xtr_p,Xt_p,X_p,labels,n_low,n_high, C, rows)
    
    
Po = zeros(33,1);
Ro = zeros(33,1);
 
for num_bits=n_low:1:n_high 
    
    disp(num_bits +" bits done");
    
    randn('seed',3);
    Zinit=sign(randn(rows,num_bits));
    maxItr = 5;
    
    [F, G, H] = train(X_p,labels,Zinit, [],maxItr);
    Ret = Hamming(F,G,H,Xtr_p,Xt_p) ;   
    [P, R] = Eval(Ret, C);
    
    I = num_bits - n_low + 1;
    Po(I) = P;
    Ro(I) = R;

end

No = n_low:n_high;
plot(No,Po);
plot(No,Ro);


end