clc;close all;clear all;
load('112_A_hmm');
O = 3;
LK = zeros(20,5);
for Q = 2:20
prior1 = normalise(rand(Q,1));
transmat1 = mk_stochastic(rand(Q,Q));
obsmat1 = mk_stochastic(rand(Q,O));
[LL, prior2, transmat2, obsmat2] = dhmm_em(data1, prior1, transmat1, obsmat1, 'max_iter', 5);
LK((Q-1),:) = LL;
end