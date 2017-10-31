nodeN = 3; 
dmatrix = zeros(nodeN,nodeN);
Pr = 1; Bt = 2; Ut = 3; 
dmatrix(Pr,[Bt Ut]) = 1;
Pr_nodes = 1:nodeN;
Pr_sizes = 2*ones(1,nodeN); 
Pr_bnet = mk_bnet(dmatrix, Pr_sizes, 'names', {'Pr','Bt','Ut'},'discrete', Pr_nodes);
seed = 0;
rand('state', seed);
Pr_bnet.CPD{Pr} = tabular_CPD(Pr_bnet, Pr);
Pr_bnet.CPD{Bt} = tabular_CPD(Pr_bnet, Bt);
Pr_bnet.CPD{Ut} = tabular_CPD(Pr_bnet, Ut);

Pr_cases = 5;
% pos =1 neg =2 Yes =1 No =2 
Pr_sample = cell(nodeN,Pr_cases);
Pr_sample = { [] 1  1 ;1 2  1;1 1 []; 1 1 2 ; [] 2 [] };
Pr_engine = jtree_inf_engine(Pr_bnet);
miter = 20;
[Pr_bnet1, Pr_LLtrace] = learn_params_em(Pr_engine, Pr_sample, miter);
plot(Pr_LLtrace, 'x-');
Pr_CPT = cell(1,nodeN);
for h=1:nodeN
   g = struct(Pr_bnet1.CPD{h});
   Pr_CPT{h}=g.CPT;
end
celldisp(Pr_CPT)