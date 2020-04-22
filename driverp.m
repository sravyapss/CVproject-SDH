load cifar_10_gist_1.mat;
%{
function sqd = calcsqd(X, Y)
    x = sum(X.^2,2);
%return ;
 y = sum(as.^2,2);    
    sqd = max(bsxfun(@plus,x,bsxfun(@plus,y',-2*X*as')),0);
    end
%}
if sum(traingnd == 0)
    traingnd = traingnd + 1;
    testgnd = testgnd + 1;
end
trainX = traindata;
testX = testdata;
trainX = double(nnorm(double(trainX))); 

testX = double(nnorm(double(testX)));

rows = size(trainX,1);
cateTrainTest = bsxfun(@eq, traingnd, testgnd');
labels = double(traingnd);
X = double(traindata);
as = X(randsample(rows, 1000),:);
disp(size(as));
disp(size(X));
sigma = 0.4;
%X = trainX;
x = sum(X.^2,2);
%return ;
y = sum(as.^2,2);
sqd = max(bsxfun(@plus,x,bsxfun(@plus,y',-2*X*as')),0);
%return ;
X_p = [exp(-sqd/(2*sigma*sigma)), ones(rows,1)];

Xt_p = exp(-calcsqd(testdata,as)/(2*sigma*sigma)); clear testdata;
Xt_p = [Xt_p, ones(size(Xt_p,1),1)];
Xtr_p = exp(-calcsqd(traindata,as)/(2*sigma*sigma)); clear traindata;
Xtr_p = [Xtr_p, ones(size(Xtr_p,1),1)];

%return ;


%% testing



%% algo
num_bits = 32;

randn('seed',3);
Zinit=sign(randn(rows,num_bits));
maxItr = 5;
%[F, G, H] = train_l2(X_p,labels,Zinit, [],maxItr);

kind_of_loss = 'l2';

if strcmp(kind_of_loss, 'hinge') == 1
	[F, G, H] = train_hinge(X_p,labels,Zinit, [],maxItr);
else
	[F, G, H] = train_l2(X_p,labels,Zinit, [],maxItr);
end

%% evaluation

%hammTrainTest = calcham(tB, B)';
% hash lookup: precision and reall
%Ret = (hammTrainTest <= hammRadius+0.00001);

[Ret,hamy] = Hamming(F,G,H,Xtr_p,Xt_p,X_p);

[P, R] = Eval(cateTrainTest, Ret);
%display('Evaluation...');

% hamming ranking: MAP
[~, HammingRank]=sort(hamy,1);
%MAP = cat_apcal(traingnd,testgnd,HammingRank);
MAP = calcMAP(traingnd,testgnd,HammingRank);
%MAP = calcMAP(traingnd,testgnd,HammingRank);

disp(P);
disp(MAP);
%return ;

%% tot
n_low = 32; n_high = 97;
%XX = l2(Xtr_p,Xt_p,X_p,labels,n_low,n_high,cateTrainTest, rows);
sdh(Xtr_p,Xt_p,X_p,labels,n_low,n_high,cateTrainTest, rows, kind_of_loss, traingnd, testgnd);
return ;

%% utils
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
