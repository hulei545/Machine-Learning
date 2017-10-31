function      EM = gtrain(N,X) 
     m = size(X,1);
     EM = cell(1,3);
% Step 1 Initialization         
% Randomly select N data points to serve as the initial means.
indeces = randperm(m);
mu = X(indeces(1:N), :);
sigma = [];
% Use the overal covariance of the dataset as the initial variance for each cluster.
for (j = 1 : N)
    sigma{j} = cov(X);
end

% Assign equal prior probabilities to each cluster.
phi = ones(1, N) * (1 / N);

% Step 2 Expectation Maximazation 
W = zeros(m, N);
eta = 1e-5;

for iter = 1:1000
    fprintf('  EM Iteration %d\n', iter);
    pdf = zeros(m,N);
    a = mu ;
    % Expectation 
    for j = 1:N 
       pdf(:,j) = mvnpdf(X,mu(j,:),sigma{j});
       for i = 1:m
           W(i,j) = pdf(i,j)*phi(j);
           W(i,j) = W(i,j)/(pdf(m,:)*phi');
       end
    end
    % Maximization 
    for j = 1:N 
        phi(j) = mean(W(:, j), 1);
        mu(j, :) = W(:,j)'*X./sum(W(:,j));
         for i = 1 : m
            sigma_k = sigma_k + (W(i, j) .* (X(i, :)-m(j,:))' *(X(i, :)-m(j,:)));
         end
        
        % Divide by the sum of weights.
        sigma{j} = sigma_k ./ sum(W(:, j));     
    end
    
    b = mu;
    if norm((b-a)) < eta 
        break;
    end;     
     
 end;
 
 if iter == 1000 
       fprintf('cannot converge');
 end
 
   EM{1} = phi;
   EM{2} = mu;
   EM{3} = sigma;
   

end