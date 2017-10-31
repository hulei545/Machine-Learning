nodeN = 3; 
dmatrix = zeros(nodeN,nodeN);
Pr = 1; Bt = 2; Ut = 3; 
dmatrix(Pr,[Bt Ut]) = 1;
Pr_nodes = 1:nodeN;
Pr_sizes = 2*ones(1,nodeN); 

Pr_bnet = mk_bnet(dmatrix, Pr_sizes, 'names', {'Pr','Bt','Ut'},'discrete', Pr_nodes);
Pr_cases = 5;
% pos =1 neg =2 Yes =1 No =2 
Pr_sample = cell(nodeN,Pr_cases);
Pr_sample = [ [] 1  1 ;1 2  1;1 1 []; 1 1 2 ; [] 2 [] ];