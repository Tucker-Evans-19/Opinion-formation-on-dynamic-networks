function matrix = SA_B_function(id)
%sensitivity analysis program 2.0

%b versus c analysis


res = 50;
results = zeros(res,res);

for i=(res/2)+1:res
    parfor j=1:res/2
        [C,X] = gogo(30,[rand(15,1);-rand(15,1)],ones(30,30),[.5,i/res,j/res,.001,.0001].',1000000);
        results(i,j) = division(C,X);
    end
end

save(['SA_B_',num2str(id),'_3.mat'],'results');
matrix = results;
end
