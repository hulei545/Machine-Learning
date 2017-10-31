function      EM= gtrain(N,X) 
     m = size(X,1);
     d = size(X,2);
     EM = cell(1,3);
% Step 1 Initialization         
% Randomly select N data points to serve as the initial means.
indeces = randperm(m);
mu = X(indeces(1:N), :);
sigma = [];
% Use the overal covariance of the dataset as the initial variance for each cluster.
for j = 1 : N
    sigma{j} = cov(X);
end

% Assign equal prior probabilities to each cluster.
phi = ones(1, N) * (1 / N);

% Step 2 Expectation Maximazation 
W = zeros(m, N);
eta = 1e-3;

for iter = 1:500
    fprintf('EM Iteration %d\n', iter);
    pdf = zeros(m,N);
    a = mu ;
    % Expectation 
   
    for j = 1:N 
       sigma_p = sigma{j};
%        pdf(:,j) = mvnpdf(X,mu(j,:),sigma_p);
       meanDiff = bsxfun(@minus, X, mu(j,:));
       pdf(:,j) =  1 / sqrt((2*pi)^d * det(sigma_p)) * exp(-1/2 * sum((meanDiff * inv(sigma_p) .* meanDiff), 2));
%          pdf(:, j) = gaussianND(X, mu(j, :), sigma{j});
%          
       for i = 1:m
           W(i,j) = pdf(i,j)*phi(j);
           W(i,j) = W(i,j)/(pdf(i,:)*phi');
       end
       
    end
    % Maximization 
    
    for j = 1:N 
        phi(j) = mean(W(:, j), 1);
        mu(j, :) = W(:,j)'*X./sum(W(:,j));
        sigma_k = zeros(d,d);
         for i = 1 : m
             Xm = bsxfun(@minus, X, mu(j, :));
            sigma_k = sigma_k + (W(i, j) .* (Xm(i, :))' *(Xm(i,:)));
         end
        
        % Divide by the sum of weights.
        sigma{j} = sigma_k ./ sum(W(:, j));     
    end
    
    b = mu;
    if norm((b-a)) < eta 
        break;
    end;     
    
 end;
 
 if iter == 500
       fprintf('Cannot converge !!! Please run again!!!\n ');
 end
 
   EM{1} = phi;
   EM{2} = mu;
   EM{3} = sigma;
   

end