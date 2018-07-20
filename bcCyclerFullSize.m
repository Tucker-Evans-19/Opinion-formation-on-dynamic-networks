file = load('NewCongressData.mat');
mat = file.NewCongressData;

%for every year of congress data available, this uses the characteristics
%of the congress and runs through different combinations of the initial
%values to determine how the behavior changes. 

inc = 20; %how many divisions to break 1 into
num = 40; %how many times to go up by a division (could go above one)
CBMat = zeros(32,num);

parfor i=1:32 %cycling through the sessions of congress
    disp(i)
    for j=1:num
        D = mat(i,1);
        R = mat(i,2);
        N = D+R;
        [C,X] = gogo(N, [rand(D,1);-rand(R,1)],ones(N,N),[.5,j/inc,1,.001,0].',500000); %holding b steady and cycling through c
        CBMat(i,j) = division(C,X);
        disp(j)
    end
end

save('cbmat-fullSize.mat','CBMat');