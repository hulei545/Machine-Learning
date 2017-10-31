clc;clear all;
xa=2; xb=4; ya=1; yb=3;         % coordinates of the rectangle C
% rand('state',-10);
% generate positive and negative examples
N= 400;   % no of traning data points
V = 200;  % no of validation data points
ds=zeros(N,2); ls=zeros(N,1);       % labels
figure;
hold on;
% training data
for i=1:N
x=rand(1,1)*5; y=rand(1,1)*5;
ds(i,1)=x; ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) ls(i)=1;
else ls(i)=0; end;
if (ls (i)==1) plot(x,y,'+'); else plot(x,y,'go'); end;
end;
 % validation data
Vds=zeros(V,2); Vls=zeros(V,1);       % labels
for i=1:V
x=rand(1,1)*5; y=rand(1,1)*5;
Vds(i,1)=x; Vds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) Vls(i)=1;
else Vls(i)=0; end;
if (Vls (i)==1) plot(x,y,'k+'); else plot(x,y,'ko'); end;
end;

% Beyesion Network 
node_Num = 3; 
Bdag = zeros(node_Num,node_Num);
C = 1;  A = 2; B = 3; 
Bdag(C,[A B]) = 1;
B_sizes = ones(1,node_Num);
d_nodes = [C];
B_sizes(d_nodes) = 2;
B_bnet = mk_bnet(Bdag, B_sizes, 'discrete',1);
% seed = 0;
% rand('state', seed);
% seed = 0;
% randn('state',seed);
B_bnet.CPD{A} = gaussian_CPD(B_bnet, A);
B_bnet.CPD{B} = gaussian_CPD(B_bnet, B);
B_bnet.CPD{C} = tabular_CPD(B_bnet, C);
B_sample = cell(node_Num,N);
for i =1:N
   B_sample(:,i) = num2cell([ (ls(i)+1) ds(i,1) ds(i,2) ]') ;  
end
 B_bnet2 = learn_params(B_bnet, B_sample);
 engine = jtree_inf_engine(B_bnet2);

% graphs 
[B1,B2] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(B1,2)
   for j = 1:size(B2,1)
   evidence = cell(1,node_Num);
   evidence{A} = B1(i,j);
   evidence{B} = B2(i,j);
   [engine, ll] = enter_evidence(engine, evidence);
    marg = marginal_nodes(engine, C);
    BZ(i,j) =  marg.T(2) - marg.T(1);
   end
end
 contour(B1,B2,BZ,[0 0],'r');
 
 % validation part 

B_VClass = zeros(V,1);
B_Verror = 0;
for i =1:V
   evidence = cell(1,node_Num);
   evidence{A} = Vds(i,1);
   evidence{B} = Vds(i,2);
   [engine, ll] = enter_evidence(engine, evidence);
    marg = marginal_nodes(engine, C);
    BV(i) =  marg.T(2) - marg.T(1);
    if  BV(i) >= 0
         B_VClass(i) = 1;
     else 
         B_VClass(i) = 0;       
     end
     if  B_VClass(i) ~= Vls(i)
         B_Verror = B_Verror +1;
     end
end
 
 
 
 
 
 
 
 
 
 
 
