clc;clear all;
xa=2; xb=4; ya=1; yb=3;         % coordinates of the rectangle C
% hold on;
% plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
count = 1;
G = zeros(1,10);
S = zeros(1,10);
A = zeros(1,10);

for N = 50:50:500
    
averageG = 0;
averageA = 0;
averageS = 0; 

% Uncomment the line below if you want repeatable data each run of the program
rand('state',20);
% generate positive and negative examples
% N=50;   % no of data points
ds=zeros(N,2); ls=zeros(N,1);       % labels
for i=1:N
x=rand(1,1)*5; y=rand(1,1)*5;
ds(i,1)=x; ds(i,2)=y;
% +ve if falls in the rectangle, -ve otherwise
if ((x > xa) && (y > ya) && (y < yb) && ( x < xb)) ls(i)=1;
else ls(i)=0; end;
% if (ls (i)==1) plot(x,y,'+'); else plot(x,y,'go');end;
end;

% initilization 
xg1=0;xg2=0;
yg1=0;yg2=0;
xs1=0;xs2=0;
ys1=0;ys2=0;
xh1=0;yh1=0;
xh2=0;yh2=0;

% K-fold cross validation 
F = 5 ;
Gerror = zeros(1,F);
Serror = zeros(1,F);
Aerror = zeros(1,F);
fnum = 1;  
for fnum = 1:F
    
V  = round((fnum-1)*N/F + 1):round(fnum*N/F);
m = N - size(V,2); % training number of points 

% graph for training data 
if fnum  == F 
  if N == 50
     figure(1);
     title('N = 50');
     hold on;
     plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
     for pnum = 1:N
      if  pnum < round((fnum-1)*N/F + 1) || pnum > round(fnum*N/F)
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'+'); else plot(ds(pnum,1),ds(pnum,2),'go'); 
        end;
      else
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'k+'); else plot(ds(pnum,1),ds(pnum,2),'ko'); 
        end; 
      end
     end
  end
  if N == 100
     figure(2);
      title('N = 100');
     hold on;
     plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
     for pnum = 1:N
        if  pnum < round((fnum-1)*N/F + 1) || pnum > round(fnum*N/F)
           if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'+'); else plot(ds(pnum,1),ds(pnum,2),'go'); 
           end;
        else
           if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'k+'); else plot(ds(pnum,1),ds(pnum,2),'ko'); 
           end; 
        end
     end
  end     
  if N == 250
     figure(3);
      title('N = 250');
     hold on;
     plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
     for pnum = 1:N
      if  pnum < round((fnum-1)*N/F + 1) || pnum > round(fnum*N/F)
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'+'); else plot(ds(pnum,1),ds(pnum,2),'go'); 
        end;
      else
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'k+'); else plot(ds(pnum,1),ds(pnum,2),'ko'); 
        end; 
      end
     end
  end     
  
  if N == 500
     figure(4);
      title('N = 500');
     hold on;
     plot([xa xb xb xa xa],[ya ya yb yb ya],'-');    % draw it
     for pnum = 1:N
      if  pnum < round((fnum-1)*N/F + 1) || pnum > round(fnum*N/F)
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'+'); else plot(ds(pnum,1),ds(pnum,2),'go'); 
        end;
      else
        if (ls (pnum)==1) 
             plot(ds(pnum,1),ds(pnum,2),'k+'); else plot(ds(pnum,1),ds(pnum,2),'ko'); 
        end; 
       end
     end
  end
end

positive = zeros(1,m);
negative = zeros(1,m);
pct = 0; % number of 1
nct = 0; % number of 0 

% find the index for two class of points 
for i = 1:N
  if  i < round((fnum-1)*N/F + 1) || i > round(fnum*N/F)
     if ls(i) == 1;
        pct = pct + 1; 
        positive(pct) = i;
     else 
        nct = nct + 1;
        negative(nct) =i;      
     end
  end
end

% find the cooridnation for two class of points
pmatrix = zeros(pct,2);
for j = 1: pct 
    pmatrix(j,:) = ds(positive(j),:);
end
nmatrix = zeros(nct,2);
for k = 1: nct 
    nmatrix(k,:) = ds(negative(k),:);
end

[xs1,ys1,xs2,ys2] = bound(pmatrix);
if fnum ==F 
     if N ==50
       figure(1);
       plot([xs1 xs2 xs2 xs1 xs1],[ys1 ys1 ys2 ys2 ys1],'r--');
     end
    if N ==100
       figure(2);
       plot([xs1 xs2 xs2 xs1 xs1],[ys1 ys1 ys2 ys2 ys1],'r--');
    end
     if N ==250
       figure(3);
       plot([xs1 xs2 xs2 xs1 xs1],[ys1 ys1 ys2 ys2 ys1],'r--');
     end
    if N ==500
       figure(4);
       plot([xs1 xs2 xs2 xs1 xs1],[ys1 ys1 ys2 ys2 ys1],'r--');
    end
end
% find the most general hypothesis
xg1 = 0;
xg2 = 5;
for j = 1:nct
    if  nmatrix(j,1) <= xs1 && nmatrix(j,2) >= ys1 && nmatrix(j,2) <= ys2
        if nmatrix(j,1) > xg1
            xg1 = nmatrix(j,1);
        end
    end
    if nmatrix(j,1) >= xs2 && nmatrix(j,2) >= ys1 && nmatrix(j,2) <= ys2
        if nmatrix(j,1) < xg2
            xg2 = nmatrix(j,1);           
        end
    end            
end

yg1 = 0;
yg2 = 5;
for w = 1:nct 
    if nmatrix(w,2) >= ys2 && nmatrix(w,1) >= xg1 && nmatrix(w,1) <= xg2
        if nmatrix(w,2) < yg2
            yg2 = nmatrix(w,2);          
        end        
    end
    if nmatrix(w,2) <= ys1 && nmatrix(w,1) >= xg1 && nmatrix(w,1) <= xg2
        if nmatrix(w,2) > yg1
            yg1 = nmatrix(w,2);
        end             
    end
    
end
if fnum == F 
    if N ==50
       figure(1);
       plot([xg1 xg2 xg2 xg1 xg1],[yg1 yg1 yg2 yg2 yg1],'y--');
    end
    if N ==100
       figure(2);
       plot([xg1 xg2 xg2 xg1 xg1],[yg1 yg1 yg2 yg2 yg1],'y--');
    end
    if N ==250
       figure(3);
       plot([xg1 xg2 xg2 xg1 xg1],[yg1 yg1 yg2 yg2 yg1],'y--');
    end
    if N ==500
       figure(4);
       plot([xg1 xg2 xg2 xg1 xg1],[yg1 yg1 yg2 yg2 yg1],'y--');
    end
end
% find another most general hypothesis
yh1 = 0;
yh2 = 5;
for p = 1:nct
    if  nmatrix(p,2) <= ys1 && nmatrix(p,1) >= xs1 && nmatrix(p,1) <= xs2
        if nmatrix(p,2) > yh1
            yh1 = nmatrix(p,2);
        end
    end
    if nmatrix(p,2) >= ys2 && nmatrix(p,1) >= xs1 && nmatrix(p,1) <= xs2
        if nmatrix(p,2) < yh2
            yh2 = nmatrix(p,2);           
        end
    end            
end

xh1 = 0;
xh2 = 5;
for q = 1:nct 
    
     if nmatrix(q,1) <= xs1 && nmatrix(q,2) >= yh1 && nmatrix(q,2) <= yh2
        if nmatrix(q,1) > xh1
            xh1 = nmatrix(q,1);
        end             
     end
    
    if nmatrix(q,1) >= xs2 && nmatrix(q,2) >= yh1 && nmatrix(q,2) <= yh2
        if nmatrix(q,1) < xh2
            xh2 = nmatrix(q,1);          
        end        
    end
   
end

% graph for H
% plot([xh1 xh2 xh2 xh1 xh1],[yh1 yh1 yh2 yh2 yh1],'k--');

if fnum == F 
    if   N ==50
% check if there are two most general hypothesis 
        if xg1 == xh1 && xg2 == xh2 && yh1 == yg1 && yh2 == yg2
           fprintf('Just one G \n');
        else
           fprintf('There are two G\n');   
        end
% graph for A    
        figure(1);
        plot([(xs1 + xg1)/2 (xs2 + xg2)/2 (xs2 + xg2)/2 (xs1 + xg1)/2 (xs1 + xg1)/2],[(ys1 + yg1)/2 (ys1 + yg1)/2 (ys2 + yg2)/2 (ys2 + yg2)/2 (ys1 + yg1)/2],'m--');
        hold off;
    end
    if   N ==100
% check if there are two most general hypothesis 
        if xg1 == xh1 && xg2 == xh2 && yh1 == yg1 && yh2 == yg2
           fprintf('Just one G \n');
        else
           fprintf('There are two G\n');   
        end
% graph for A    
        figure(2);
        plot([(xs1 + xg1)/2 (xs2 + xg2)/2 (xs2 + xg2)/2 (xs1 + xg1)/2 (xs1 + xg1)/2],[(ys1 + yg1)/2 (ys1 + yg1)/2 (ys2 + yg2)/2 (ys2 + yg2)/2 (ys1 + yg1)/2],'m--');
        hold off;
    end
 if   N ==250
% check if there are two most general hypothesis 
      if xg1 == xh1 && xg2 == xh2 && yh1 == yg1 && yh2 == yg2
          fprintf('Just one G \n');
      else
          fprintf('There are two G\n');   
      end
% graph for A    
      figure(3);
      plot([(xs1 + xg1)/2 (xs2 + xg2)/2 (xs2 + xg2)/2 (xs1 + xg1)/2 (xs1 + xg1)/2],[(ys1 + yg1)/2 (ys1 + yg1)/2 (ys2 + yg2)/2 (ys2 + yg2)/2 (ys1 + yg1)/2],'m--');
      hold off;
 end
    if   N ==500
% check if there are two most general hypothesis 
        if xg1 == xh1 && xg2 == xh2 && yh1 == yg1 && yh2 == yg2
        fprintf('Just one G \n');
        else
         fprintf('There are two G\n');   
        end
% graph for A    
        figure(4);
        plot([(xs1 + xg1)/2 (xs2 + xg2)/2 (xs2 + xg2)/2 (xs1 + xg1)/2 (xs1 + xg1)/2],[(ys1 + yg1)/2 (ys1 + yg1)/2 (ys2 + yg2)/2 (ys2 + yg2)/2 (ys1 + yg1)/2],'m--');
        hold off;
        
    end
end

% Validation Part 
% for G 
for pointer = 1:size(V,2)
    if ds(V(pointer),1) > xg1 && ds(V(pointer),1) < xg2 && ds(V(pointer),2) > yg1 && ds(V(pointer),2) < yg2
        if ls(V(pointer)) == 0
            Gerror(fnum) = Gerror(fnum) + 1;
        end
           
    else
        if ls(V(pointer)) == 1
            Gerror(fnum) = Gerror(fnum) + 1;
        end
    end
     
end
% for S 
for pointer = 1:size(V,2)
    if ds(V(pointer),1) >= xs1 && ds(V(pointer),1) <= xs2 && ds(V(pointer),2) >= ys1 && ds(V(pointer),2) <= ys2
        if ls(V(pointer)) == 0
            Serror(fnum) = Serror(fnum) + 1;
        end
         
    else
        if ls(V(pointer)) == 1
           Serror(fnum) = Serror(fnum) + 1;
        end
    end
     
end

% for any other hypothesis A between S and G 
for pointer = 1:size(V,2)
    if ds(V(pointer),1) >= (xs1 + xg1)/2 && ds(V(pointer),1) <= (xs2 + xg2)/2 && ds(V(pointer),2) >= (ys1 + yg1)/2 && ds(V(pointer),2) <= (ys2 + yg2)/2
        if ds(V(pointer),1) ~= (xs1 + xg1)/2 && ds(V(pointer),1) ~= (xs2 + xg2)/2 && ds(V(pointer),2) ~= (ys1 + yg1)/2 && ds(V(pointer),2) ~= (ys2 + yg2)/2
          if ls(V(pointer)) == 0
            Aerror(fnum) = Aerror(fnum) + 1;
          end
        end 
    else
        if ls(V(pointer)) == 1
            Aerror(fnum) = Aerror(fnum) + 1;
        end
    end
     
end

end % cross validation 

for nnum = 1:F
    averageG = averageG + Gerror(nnum);
    averageS = averageS + Serror(nnum);
    averageA = averageA + Aerror(nnum);
    
end

G(count) = averageG/(F*N);
S(count) = averageS/(F*N);
A(count) = averageA/(F*N);
count = count + 1; 
end % number of data points

Nm = 50:50:500;

figure
title('Generalization error');
hold on ;
plot(Nm,G,'-y^');
plot(Nm,S,'-ro');
plot(Nm,A,'-m*');
legend('G','S','M');
hold off;