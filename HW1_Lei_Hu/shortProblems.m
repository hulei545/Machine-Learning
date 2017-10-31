% problem 1
a = 10;
b = 2.5e23;
c = 2 + 3*i;
d = exp(j*(2*pi/3));

% problem 2
aVec = [3.14 15 9 26];
bVec = [2.71;8;28;182];
cVec = 5:-0.2:-5;
dVec = logspace(0,1,101);
eVec = 'Hello';

% problem 3
aMat = 2*ones(9);
v = [ 1 2 3 4 5 4 3 2 1];
bMat = diag(v);
u = 1:100;
cMat = reshape(u,10,10);
dMat = nan(3,4);
eMat = [ 13 -1 5 ;-22 10 -87];
fMat = floor(6*rand(5,3)-3);

% problem 4
x = 1/(1 + exp(-(a-15)/6));
y = (sqrt(a) + b^(1/21))^pi;
z = log(real((c + d)*(c - d))*sin(a*pi/3))/c*conj(c);

% problem 5
xVec = exp(-(cVec.^2)./(2 + (2.5).^2))./sqrt(2*pi*(2.5).^2);
yVec = ( (aVec').^2 + bVec.^2 ).^(1/2) ;
zVec = log10(1./dVec);

% problem 6
xMat = (aVec*bVec)*(aMat^2);
yMat = bVec*aVec;
zMat = det(cMat)*((aMat*bMat)');

% problem 7
cSum = sum(cMat);
eMean = mean(eMat,2);
eMat(1,:)= [ 1 1 1];
cSub = cMat(2:9,2:9);
lin = 1:20;
lin(2:2:20) = -lin(2:2:20);
r = rand(1,5);
sr = find(r<0.5);
r( find(r<0.5)) = 0;




