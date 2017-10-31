clc;clear all;close all;
xa=2; xb=4; ya=1; yb=3;         % coordinates of the rectangle C

% plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it

% Uncomment the line below if you want repeatable data each run of the program
% rand('state',-10);
% generate positive and negative examples
N= 50;   % no of traning data points
V = 200;  % no of validation data points
Train_error1 = zeros(4,1);
Train_error2 = zeros(4,1);
Train_error3 = zeros(4,1);
Train_error4 = zeros(4,1);
Train_errorBNT = zeros(4,1);
Val_error1 = zeros(4,1);
Val_error2 = zeros(4,1);
Val_error3 = zeros(4,1);
Val_error4 = zeros(4,1);
Val_errorBNT = zeros(4,1);
cnt =0;
for N = [50 100 200 400]
ds=zeros(N,2); ls=zeros(N,1);       % labels
figure;
title(['N = ',num2str(N)]);
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

% parametric learing
 P1=0;
 P2=0;
 m1 = zeros(1,2);
 m2 = zeros(1,2);
 for j = 1:N
     if ls(j) ==1;
     P1 = 1+P1;
     m1 = m1 + ds(j,:);
     elseif ls(j) ==0 
         P2 =1+P2;
         m2  = m2 + ds(j,:);
     end
 end
 r1 = P1;
 r2 = P2;
 m1 = m1/r1;
 m2 = m2/r2;
 P1 = P1/N;
 P2 = P2/N;

S1 = zeros(2,2);
S2 = zeros(2,2);

for k = 1:N
     if ls(k) ==1;
     S1 = S1 + (ds(k,:)-m1)'*(ds(k,:)-m1);
     else
      S2 = S2 + (ds(k,:)-m2)'*(ds(k,:)-m2); 
     end
end
 S1 = S1/r1;
 S2 = S2/r2;
 
 %%%%%%%%%%%%%%%%%%%%%%% Different ,Hyperellipsoidal %%%%%%%%%%%%%
 Class = zeros(N,1);
 g1 = zeros(N,1);
 g2 = zeros(N,1);
 Terror1 = 0;

 % discriminat function 
 for i = 1:N
     g1(i) = -(1/2)*log(det(S1)) - (1/2)*(ds(i,:)-m1)*pinv(S1)*(ds(i,:)-m1)' + log(P1);
     g2(i) = -(1/2)*log(det(S2)) - (1/2)*(ds(i,:)-m2)*pinv(S2)*(ds(i,:)-m2)' + log(P2);
     if g1(i) >= g2(i)
         Class(i) = 1;      
      else 
         Class(i) = 0;       
     end
     if Class(i) ~= ls(i)
         Terror1 = Terror1 +1;
     end
 end
 
 % graphs 
[X1,X2] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(X1,2)
   for j = 1:size(X2,1)
        Zg1(i,j) =  -(1/2)*log(det(S1)) - (1/2)*([X1(i,j) X2(i,j)] - m1)*pinv(S1)*([X1(i,j) X2(i,j)]-m1)' + log(P1); 
        Zg2(i,j) =  -(1/2)*log(det(S2)) - (1/2)*([X1(i,j) X2(i,j)]-m2)*pinv(S2)*([X1(i,j) X2(i,j)]-m2)' + log(P2); 
        Z(i,j) = Zg1(i,j) - Zg2(i,j);
   end
end
[ c1, h1] = contour(X1,X2,Z,[0 0],'r','LineWidth',2);

%  
% validation 
Vg1 = zeros(V,1);
Vg2 = zeros(V,1);
VClass = zeros(V,1);
Verror1 = 0;
for i =1:V
   Vg1(i) = -(1/2)*log(det(S1)) - (1/2)*(Vds(i,:)-m1)*pinv(S1)*(Vds(i,:)-m1)' + log(P1);
   Vg2(i) = -(1/2)*log(det(S2)) - (1/2)*(Vds(i,:)-m2)*pinv(S2)*(Vds(i,:)-m2)' + log(P2);
    if Vg1(i) >= Vg2(i)
         VClass(i) = 1;
     else 
         VClass(i) = 0;       
     end
     if VClass(i) ~= Vls(i)
         Verror1 = Verror1 +1;
     end
end

%%%%%%%%%%%%%%%% Shared, Hyperellipsoidal %%%%%%%%%%%%%%%%%%%%%%
S_S = P1*S1 + P2*S2 ;
S_Class = zeros(N,1);
S_g1 = zeros(N,1);
S_g2 = zeros(N,1);
S_Terror = 0;
 % discriminat function 
 for i = 1:N
     S_g1(i) =  - (1/2)*(ds(i,:)-m1)*pinv(S_S)*(ds(i,:)-m1)' + log(P1);
     S_g2(i) =  - (1/2)*(ds(i,:)-m2)*pinv(S_S)*(ds(i,:)-m2)' + log(P2);
     if S_g1(i) >= S_g2(i)
         S_Class(i) = 1;
     else 
         S_Class(i) = 0;       
     end
     if S_Class(i) ~= ls(i)
         S_Terror = S_Terror +1;
     end
 end
 
  % graphs 
[X3,X4] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(X3,2)
   for j = 1:size(X4,1)
        Zg3(i,j) = - (1/2)*([X3(i,j) X4(i,j)] - m1)*pinv(S_S)*([X3(i,j) X4(i,j)]-m1)' + log(P1); 
        Zg4(i,j) = - (1/2)*([X3(i,j) X4(i,j)] - m2)*pinv(S_S)*([X3(i,j) X4(i,j)]-m2)' + log(P2); 
        Z2(i,j) = Zg3(i,j) - Zg4(i,j);
   end
end
 [ c2, h2] = contour(X3,X4,Z2,[0 0],'M','LineWidth',2);


% validation
S_Vg1 = zeros(V,1);
S_Vg2 = zeros(V,1);
S_VClass = zeros(V,1);
S_Verror = 0;
for i =1:V
   S_Vg1(i) =  - (1/2)*(Vds(i,:)-m1)*pinv(S_S)*(Vds(i,:)-m1)' + log(P1);
   S_Vg2(i) =  - (1/2)*(Vds(i,:)-m2)*pinv(S_S)*(Vds(i,:)-m2)' + log(P2);
    if S_Vg1(i) >= S_Vg2(i)
         S_VClass(i) = 1;
     else 
         S_VClass(i) = 0;       
     end
     if S_VClass(i) ~= Vls(i)
         S_Verror = S_Verror +1;
     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Shared Axis-aligned %%%%%%%%%%%%%%%%
SA_S = S_S;
SA_S (1,2) = 0;
SA_S (2,1) = 0;

SA_Class = zeros(N,1);
SA_g1 = zeros(N,1);
SA_g2 = zeros(N,1);
SA_Terror = 0;
 % discriminat function 
 for i = 1:N
     SA_g1(i) =  - (1/2)*(ds(i,:)-m1)*pinv(SA_S)*(ds(i,:)-m1)' + log(P1);
     SA_g2(i) =  - (1/2)*(ds(i,:)-m2)*pinv(SA_S)*(ds(i,:)-m2)' + log(P2);
     if SA_g1(i) >= SA_g2(i)
         SA_Class(i) = 1;
     else 
         SA_Class(i) = 0;       
     end
     if SA_Class(i) ~= ls(i)
         SA_Terror = SA_Terror +1;
     end
 end
 
% graphs 
[X5,X6] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(X5,2)
   for j = 1:size(X6,1)
        Zg5(i,j) = - (1/2)*([X5(i,j) X6(i,j)] - m1)*pinv(SA_S)*([X5(i,j) X6(i,j)]-m1)' + log(P1); 
        Zg6(i,j) = - (1/2)*([X5(i,j) X6(i,j)] - m2)*pinv(SA_S)*([X5(i,j) X6(i,j)]-m2)' + log(P2); 
        Z3(i,j) = Zg5(i,j) - Zg6(i,j);
   end
end
[ c3, h3] = contour(X5,X6,Z3,[0 0],'y','LineWidth',2);

% validation
SA_Vg1 = zeros(V,1);
SA_Vg2 = zeros(V,1);
SA_VClass = zeros(V,1);
SA_Verror = 0;
for i =1:V
   SA_Vg1(i) =  - (1/2)*(Vds(i,:)-m1)*pinv(SA_S)*(Vds(i,:)-m1)' + log(P1);
   SA_Vg2(i) =  - (1/2)*(Vds(i,:)-m2)*pinv(SA_S)*(Vds(i,:)-m2)' + log(P2);
    if SA_Vg1(i) >= SA_Vg2(i)
         SA_VClass(i) = 1;
     else 
         SA_VClass(i) = 0;       
     end
     if SA_VClass(i) ~= Vls(i)
         SA_Verror = SA_Verror +1;
     end
end

%%%%%%%%%%%%%%%%%%%%%% Shared Hyperspheric
%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
var = SA_S(1,1)*P1 + SA_S(2,2)*P2;
SH_S = [var 0 ;0 var];
SH_Class = zeros(N,1);
SH_g1 = zeros(N,1);
SH_g2 = zeros(N,1);
SH_Terror = 0;
 % discriminat function 
 for i = 1:N
     SH_g1(i) =  - (1/2)*(ds(i,:)-m1)*pinv(SH_S)*(ds(i,:)-m1)' + log(P1);
     SH_g2(i) =  - (1/2)*(ds(i,:)-m2)*pinv(SH_S)*(ds(i,:)-m2)' + log(P2);
     if SH_g1(i) >= SH_g2(i)
         SH_Class(i) = 1;
     else 
         SH_Class(i) = 0;       
     end
     if SH_Class(i) ~= ls(i)
         SH_Terror = SH_Terror +1;
     end
 end
 
 % graphs 
[X7,X8] = meshgrid(0:0.1:5,0:0.1:5); 
for i = 1:size(X7,2)
   for j = 1:size(X8,1)
        Zg7(i,j) = - (1/2)*([X7(i,j) X8(i,j)] - m1)*pinv(SH_S)*([X7(i,j) X8(i,j)]-m1)' + log(P1); 
        Zg8(i,j) = - (1/2)*([X7(i,j) X8(i,j)] - m2)*pinv(SH_S)*([X7(i,j) X8(i,j)]-m2)' + log(P2); 
        Z4(i,j) = Zg7(i,j) - Zg8(i,j);
   end
end
[ c4, h4] = contour(X7,X8,Z4,[0 0],'K','LineWidth',2);


% validation
SH_Vg1 = zeros(V,1);
SH_Vg2 = zeros(V,1);
SH_VClass = zeros(V,1);
SH_Verror = 0;
for i =1:V
   SH_Vg1(i) =  - (1/2)*(Vds(i,:)-m1)*pinv(SH_S)*(Vds(i,:)-m1)' + log(P1);
   SH_Vg2(i) =  - (1/2)*(Vds(i,:)-m2)*pinv(SH_S)*(Vds(i,:)-m2)' + log(P2);
    if SH_Vg1(i) >= SH_Vg2(i)
         SH_VClass(i) = 1;
     else 
         SH_VClass(i) = 0;       
     end
     if SH_VClass(i) ~= Vls(i)
         SH_Verror = SH_Verror +1;
     end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Baysian Network %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a Baysian Network
node_Num = 3; 
Bdag = zeros(node_Num,node_Num);
C = 1;  A = 2; B = 3; 
Bdag(C,[A B]) = 1;
B_sizes = ones(1,node_Num);
d_nodes = [C];
B_sizes(d_nodes) = 2;
B_bnet = mk_bnet(Bdag, B_sizes, 'discrete',1);

% specify random parameters
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
  [ c5, h5] = contour(B1,B2,BZ,[0 0],'c','LineWidth',2);
legend([h1,h2,h3,h4,h5],'Most Complex','Shared-Hyperellipsoidal','Shared-Axis-aligned','Shared-Hyperspheric','Bayesian');
  
  
 hold off;
 
 % compute training error 
 B_TClass = zeros(N,1);
 B_Terror = 0;
for i =1:N
   evidence = cell(1,node_Num);
   evidence{A} = ds(i,1);
   evidence{B} = ds(i,2);
   [engine, ll] = enter_evidence(engine, evidence);
    marg = marginal_nodes(engine, C);
    BT(i) =  marg.T(2) - marg.T(1);
    if  BT(i) >= 0
         B_TClass(i) = 1;
     else 
         B_TClass(i) = 0;       
     end
     if  B_TClass(i) ~= ls(i)
         B_Terror = B_Terror +1;
     end
end
  
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

cnt = cnt +1 ;
Train_error1(cnt) = Terror1/N;
Train_error2(cnt) = S_Terror/N;
Train_error3(cnt) = SA_Terror/N;
Train_error4(cnt) = SH_Terror/N;
Train_errorBNT(cnt) = B_Terror/N;
Val_error1(cnt) =  Verror1/V;
Val_error2(cnt) = S_Verror/V;
Val_error3(cnt)  = SA_Verror/V;
Val_error4(cnt)  = SH_Verror/V;
Val_errorBNT(cnt) = B_Verror/V;
end

T = [50 100 200 400];
figure ;
title(' Empirical Erorr for Training');
hold on ;
plot(T,Train_error1,'-r*','LineWidth',3);
plot(T,Train_error2,'-ms','LineWidth',3);
plot(T,Train_error3,'-yp','LineWidth',3);
plot(T,Train_error4,'-ko','LineWidth',3);
plot(T,Train_errorBNT,'-cd','LineWidth',3);
legend('Most Complex','Shared-Hyperellipsoidal','Shared-Axis-aligned','Shared-Hyperspheric','Bayesian');
hold off;

figure ;
title(' Empirical Erorr for Validation');
hold on;
plot(T,Val_error1,'-r*','LineWidth',3);
plot(T,Val_error2,'-ms','LineWidth',3);
plot(T,Val_error3,'-yp','LineWidth',3);
plot(T,Val_error4,'-ko','LineWidth',3);
plot(T,Val_errorBNT,'-cd','LineWidth',3);
legend('Most Complex','Shared-Hyperellipsoidal','Shared-Axis-aligned','Shared-Hyperspheric','Bayesian');
hold off;













