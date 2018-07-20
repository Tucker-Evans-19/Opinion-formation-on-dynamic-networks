%REPEATED SENSITIVITY ANALYSIS RUNS
%script to run the sensitivity analysis function multiple times
%notes: the sensitivity analysis functions (SA_*_function.m) are lettered
%A,B,C,D, where each constitutes a quadrant of the plot. This allows them
%to be more easily run in parallel. 


matrixB = zeros(50,50);


parfor i=1:30

    matrixB = matrixB + SA_B_function(i);

    disp(i)
end


save('sensitivityAnalysisAggregateB.mat', 'matrixB');


