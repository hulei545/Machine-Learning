clc;close all;clear all;
addpath(genpath('.\HMMall'));
load('112_A_hmm');
O = 3;
row1 = size(data1,1);
row2 = size(data2,1);
cnt = 1;
for Q = 2:30
    trans_A = [];
    trans_B = [];
    obs_A =[];
    obs_B = [];
    pr_A = [];
    pr_B =[];
   for times =1:3          % do cross validation for 3 times for average prameters
    T_trans_A = [];
    T_trans_B = [];
    T_obs_A =[];
    T_obs_B = [];
    T_pr_A = [];
    T_pr_B =[];
    T_A = [];
    T_B =[];
 for n = 1:5
    % data for process 1
    vl_data1 = data1((round((n-1)*row1/5) + 1):round(n*row1/5),:);
    tr_data1 = data1;
    tr_data1(((n-1)*row1/5 + 1):n*row1/5,:) = []; 
    % data for process 2
    vl_data2 = data2((round((n-1)*row2/5) + 1):round(n*row2/5),:);
    tr_data2 = data2;
    tr_data2(((n-1)*row2/5 + 1):n*row2/5,:) = []; 
    % training for hidden states
     prior1 = normalise(rand(Q,1));
     transmat1 = mk_stochastic(rand(Q,Q));
     obsmat1 = mk_stochastic(rand(Q,O));
     [LL1, prior2, transmat2, obsmat2] = dhmm_em(tr_data1, prior1, transmat1, obsmat1, 'max_iter',50);
     loglik_A = dhmm_logprob(vl_data1, prior2, transmat2, obsmat2);
     
     prior3 = normalise(rand(Q,1));
     transmat3 = mk_stochastic(rand(Q,Q));
     obsmat3 = mk_stochastic(rand(Q,O));
     [LL2, prior4, transmat4, obsmat4] = dhmm_em(tr_data2, prior3, transmat3, obsmat3, 'max_iter',50);
     loglik_B = dhmm_logprob(vl_data2, prior4, transmat4, obsmat4);
     A(n) = loglik_A;
     B(n) = loglik_B;
     pr_A{n} = prior2 ;
     trans_A{n} = transmat2;
     obs_A{n} = obsmat2;
     pr_B{n} = prior4;
     trans_B{n} = transmat4;
     obs_B{n} = obsmat4;
 end
  T_A(times) = sum(A,2)/5;
  T_B(times) = sum(B,2)/5;
  T_pr_A{times} = sum(cat(3,pr_A{:}),3)/5;
  T_pr_B{times} = sum(cat(3,pr_B{:}),3)/5;
  T_trans_A{times} =  sum(cat(3,trans_A{:}),3)/5;
  T_trans_B{times} =  sum(cat(3,trans_B{:}),3)/5;
  T_obs_A{times} = sum(cat(3,obs_A{:}),3)/5;
  T_obs_B{times} = sum(cat(3,obs_B{:}),3)/5;
 end
 avg_lk1 = sum(T_A,2)/3;
 avg_lk2 = sum(T_B,2)/3;
 LK1(cnt) = avg_lk1;
 LK2(cnt) = avg_lk2;
 pr1{cnt} = sum(cat(3,T_pr_A{:}),3)/3;
 pr2{cnt} = sum(cat(3,T_pr_B{:}),3)/3;
 trans1{cnt} = sum(cat(3,T_trans_A{:}),3)/3;
 trans2{cnt} = sum(cat(3,T_trans_B{:}),3)/3;
 obs1{cnt} = sum(cat(3,T_obs_A{:}),3)/3;
 obs2{cnt} = sum(cat(3,T_obs_B{:}),3)/3;
 cnt = cnt + 1;
end

Q = 2:30;
figure;
plot(Q, LK1,'gs-');
title('Process 1');
figure;
plot (Q, LK2,'ro--');
title('Process 2');

% The parameters 
[val1,index1] = max(LK1);
[val2,index2] = max(LK2);
prior_A = pr1{index1};
prior_B = pr2{index2};
transmat_A = trans1{index1};
transmat_B = trans2{index2};
obsmat_A = obs1{index1};
obsmat_B = obs2{index2};

% classifier
 A_loglik_X1 = dhmm_logprob(X1, prior_A, transmat_A, obsmat_A);
 B_loglik_X1 = dhmm_logprob(X1, prior_B, transmat_B, obsmat_B);
 if A_loglik_X1 >= B_loglik_X1
    Class_X1 = 1;
 else
     Class_X1 = 2;
 end

  A_loglik_X2 = dhmm_logprob(X2, prior_A, transmat_A, obsmat_A);
  B_loglik_X2 = dhmm_logprob(X2, prior_B, transmat_B, obsmat_B);
 if A_loglik_X2 >= B_loglik_X2
    Class_X2 = 1;
 else
     Class_X2 = 2;
 end

  A_loglik_X3 = dhmm_logprob(X3, prior_A, transmat_A, obsmat_A);
  B_loglik_X3 = dhmm_logprob(X3, prior_B, transmat_B, obsmat_B);
 if A_loglik_X3 >= B_loglik_X3
    Class_X3 = 1;
 else
     Class_X3 = 2;
 end

  A_loglik_X4 = dhmm_logprob(X4, prior_A, transmat_A, obsmat_A);
  B_loglik_X4 = dhmm_logprob(X4, prior_B, transmat_B, obsmat_B);
 if A_loglik_X4 >= B_loglik_X4
    Class_X4 = 1;
 else
     Class_X4 = 2;
 end

  A_loglik_X5 = dhmm_logprob(X5, prior_A, transmat_A, obsmat_A);
  B_loglik_X5 = dhmm_logprob(X5, prior_B, transmat_B, obsmat_B);
 if A_loglik_X5 >= B_loglik_X5
    Class_X5 = 1;
 else
     Class_X5 = 2;
 end

  A_loglik_X6 = dhmm_logprob(X6, prior_A, transmat_A, obsmat_A);
  B_loglik_X6 = dhmm_logprob(X6, prior_B, transmat_B, obsmat_B);
 if A_loglik_X6 >= B_loglik_X6
    Class_X6 = 1;
 else
     Class_X6 = 2;
 end

