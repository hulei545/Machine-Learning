N = 4; 
dag = zeros(N,N);
C = 1; S = 2; R = 3; W = 4;
dag(C,[R S]) = 1;
dag(R,W) = 1;
dag(S,W)=1;
discrete_nodes = 1:N;
node_sizes = 2*ones(1,N); 

bnet = mk_bnet(dag, node_sizes, 'discrete', discrete_nodes);
bnet = mk_bnet(dag, node_sizes, 'names', {'cloudy','S','R','W'}, 'discrete', 1:4);
C = bnet.names('cloudy'); % bnet.names is an associative array
bnet.CPD{C} = tabular_CPD(bnet, C, [0.5 0.5]);
bnet.CPD{C} = tabular_CPD(bnet, C, [0.5 0.5]);
bnet.CPD{R} = tabular_CPD(bnet, R, [0.8 0.2 0.2 0.8]);
bnet.CPD{S} = tabular_CPD(bnet, S, [0.5 0.9 0.5 0.1]);
bnet.CPD{W} = tabular_CPD(bnet, W, [1 0.1 0.1 0.01 0 0.9 0.9 0.99]);
engine = jtree_inf_engine(bnet);


%%%%%%%%%%%%%%%  Maximum likelihood parameter estimation from complete data 
nsamples = 1000;
samples = cell(N, nsamples);
for i=1:nsamples
  samples(:,i) = sample_bnet(bnet);
end

data = cell2num(samples);

% Make a tabula rasa
bnet2 = mk_bnet(dag, node_sizes);
seed = 0;
rand('state', seed);
bnet2.CPD{C} = tabular_CPD(bnet2, C);
bnet2.CPD{R} = tabular_CPD(bnet2, R);
bnet2.CPD{S} = tabular_CPD(bnet2, S);
bnet2.CPD{W} = tabular_CPD(bnet2, W);

bnet3 = learn_params(bnet2, samples);
CPT3 = cell(1,N);
CPT = cell(1,N);
for i=1:N
  s=struct(bnet3.CPD{i});  % violate object privacy
  CPT3{i}=s.CPT;
end
for j=1:N
   p = struct(bnet.CPD{j});
   CPT{j}=p.CPT;
end
disp('Learned Parameters from complete data')
dispcpt(CPT3{4})
disp('Specified True Parameters')
dispcpt(CPT{4})

%%%%%%%%%%%%%%%%%%%%% Maximum likelihood parameter estimation with missing values
samples2 = samples;
hide = rand(N, nsamples) > 0.5;
[I,J]=find(hide);
for k=1:length(I)
  samples2{I(k), J(k)} = [];
end

engine2 = jtree_inf_engine(bnet2);
max_iter = 10;
[bnet4, LLtrace] = learn_params_em(engine2, samples2, max_iter);
plot(LLtrace, 'x-');
CPT4 = cell(1,N);
for rd=1:N
   q = struct(bnet4.CPD{rd});
   CPT4{rd}=q.CPT;
end
disp('Learned Parameters with missing values')
celldisp(CPT4)






