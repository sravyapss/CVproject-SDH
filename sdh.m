function sdh(Xtr_p,Xt_p,X_p,labels,n_low,n_high, C, rows, kind_of_loss, traingnd, testgnd)
    
    
Po = zeros(3,1);
Ro = zeros(3,1);

disp(Po);
cnt = 1;
for num_bits=n_low:32:n_high 
    disp(num_bits +' bits done');
    
    randn('seed',3);
    Zinit=sign(randn(rows,num_bits));
    maxItr = 5;
    if strcmp(kind_of_loss, 'hinge') == 1
        [F, G, H] = train_hinge(X_p,labels,Zinit, [],maxItr);
    else
        [F, G, H] = train_l2(X_p,labels,Zinit, [],maxItr);
    end
    
    [Ret,hamy] = Hamming(F,G,H,Xtr_p,Xt_p,X_p);
    [P, R] = Eval(C, Ret);

    % hamming ranking: MAP
    [~, HammingRank]=sort(hamy,1);
    MAP = calcMAP(traingnd,testgnd,HammingRank);
    I = num_bits - n_low + 1;
    disp(P);
    disp(MAP);
    Po(cnt) = P;
    Ro(cnt) = R;
    MAPo(cnt) = MAP;
    cnt=cnt+1;

end

No = n_low:32:n_high;
disp(No);
disp(Po);
plot(No,Po);
plot(No,Ro);
plot(No,MAPo);


end