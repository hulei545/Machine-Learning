load('classGrades');
disp(namesAndGrades(1:5,:));
grades = namesAndGrades(:,2:end);
meanGrades = mean(grades)
meanGrades = nanmean(grades)
meanMatrix = ones(15,1)*meanGrades
curvedGrades = 3.5*(grades ./ meanMatrix);
nanmean(curvedGrades)
meancurved = nanmean(curvedGrades);
curvedGrades(find(curvedGrades > 5))= 5;
totalGrades = ceil(nanmean(curvedGrades,2));
letters = 'FDCBA';
letterGrades = letters(totalGrades);
disp(['Grades : ',letterGrades]);


