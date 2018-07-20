%REPEATED SENSITIVITY ANALYSIS RUNS
%script to run the sensitivity analysis function multiple times
%notes: the sensitivity analysis functions (SA_*_function.m) are lettered
%A,B,C,D, where each constitutes a quadrant of the plot. This allows them
%to be more easily run in parallel. 

matrixD = zeros(50,50);

parfor i=1:30

    matrixD = matrixD + SA_D_function(i);
    disp(i)
    
end

save('sensitivityAnalysisAggregateD_2.mat', 'matrixD');

