function [Hamster,hamy] = Hamming(F,G,H,Xtr_p,Xt_p,X_p) 

AD = 0; % Use asymmetric hashing or not

if AD 
    H = H > 0; % directly use the learned bits for training data
else
    H = Xtr_p*F > 0;
end

H_T = Xt_p*F > 0;

Rad = 2;



B = Compress(H);
B_T = Compress(H_T);


hamy = calcham(B_T, B)';
% hash lookup: precision and reall
Ret = (hamy <= Rad+0.00001);

Hamster = Ret;

%% compress

function less_bits = Compress(seq)
    [n_samples, nbits] = size(seq);
N_words = ceil(nbits/8);
less_bits = zeros([n_samples N_words], 'uint8');

for j = 1:nbits
    w = ceil(j/8);
    less_bits(:,w) = bitset(less_bits(:,w), mod(j-1,8)+1, seq(:,j));
end
    
end


%% hamming distance

function ham = calcham(X, Y)
    look_up = uint16([...
    0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 ...
    3 4 2 3 3 4 3 4 4 5 1 2 2 3 2 3 3 4 2 3 3 4 ...
    3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 1 2 ...
    2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 ...
    3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 ...
    5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 1 2 2 3 ...
    2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 ...
    4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 ...
    3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 2 3 3 4 3 4 ...
    4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 ...
    5 6 6 7 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 ...
    5 6 5 6 6 7 5 6 6 7 6 7 7 8]);





N_1 = size(X,1);



[N_2, N_words] = size(Y);



ham = zeros([N_1 N_2], 'uint16');


for j = 1:N_1
    
    for n=1:N_words
        
        y = bitxor(X(j,n),Y(:,n));
        
        ham(j,:) = ham(j,:) + look_up(y+1);
    
    
    end


end

    
end

end