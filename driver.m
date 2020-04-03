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
[F, G, H] = train(X_p,labels,Zinit, [],maxItr);

%% evaluation
Ret = Hamming(F,G,H,Xtr_p,Xt_p,X_p);

[P, R] = Eval(cateTrainTest, Ret);
%display('Evaluation...');

disp(P);
disp(R);
%return ;

%% tot
n_low = 32; n_high = 64;
XX = sdh(Xtr_p,Xt_p,X_p,labels,n_low,n_high,cateTrainTest, rows);

return ;

%% funcs
function sqd = calcsqd(X, as)
    x = sum(X.^2,2);
%return ;
 y = sum(as.^2,2);    
    sqd = max(bsxfun(@plus,x,bsxfun(@plus,y',-2*X*as')),0);
end