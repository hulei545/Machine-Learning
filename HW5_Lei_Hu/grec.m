function      lk = grec(X,EM) 
       mu = EM{2};
       sigma = EM{3};
       phi = EM{1};
        d = size(X,2);
        k = size(EM{1},2);
        m = size(X,1);
        lk = zeros(m,k);
      for i = 1:k
%        lk(:,i) = mvnpdf(X,mu(i,:),sigma{i});
       sigma_p = sigma{i};
       meanDiff = bsxfun(@minus, X, mu(i,:));
       lk(:,i) =  1 / sqrt((2*pi)^d * det(sigma_p)) * exp(-1/2 * sum((meanDiff * inv(sigma_p) .* meanDiff), 2));
%                    lk(:, i) = gaussianND(X, mu(i, :), sigma{i});  
      end 
end