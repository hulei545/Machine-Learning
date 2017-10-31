function [xmin,ymin,xmax,ymax] = bound(matrix)
     num = size(matrix,1);
     xmin = matrix(1,1);
     xmax = matrix(1,1);
     ymin = matrix(1,2);
     ymax = matrix(1,2);
     
     for i = 1:num 
         if matrix(i,1) < xmin 
             xmin = matrix(i,1);
         end
         if matrix(i,1) > xmax
             xmax = matrix(i,1);
         end
         if matrix(i,2) < ymin
             ymin = matrix(i,2);
         end
         if matrix(i,2) > ymax
             ymax = matrix(i,2);
         end
     end

end