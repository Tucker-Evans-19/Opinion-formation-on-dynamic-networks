%run through iterative changes to the network with given initial properties

function [connections, opinions] = gogo(popSize,popBeliefs,popConnections,par,iterations)

    %a,b,c theoretically determine the characteristics of the network
    a = par(1,1);
    b = par(2,1);
    c = par(3,1);
    conMut = par(4,1);
    belMut = par(5,1); 
    
    
    N = popSize;
    numMut=N;
    
    x0 = popBeliefs;
    x = x0;
    
    w0 = popConnections;
    w = w0;
        
    dCon0 = zeros(N,N,1);
    dBel0 = zeros(N,1);
    
    dConInds = zeros(iterations,numMut);
    beliefs = zeros(N,iterations);
    beliefs(:,1) = x;

    for i=2:iterations
        
        dCon = zeros(N,N,1); %change in the connections 
        dBel = zeros(N,1); %changes to the beliefs
        % both of these matrices are made the same size as the full
        % matrices so that they can be added on easily
        
        conInd1 = randi(N,numMut,1); %choosing which indices to change
        conInd2 = randi(N,numMut,1);
        %they can range up to the number of nodes, and are as long as the
        %number of mutations to be made
        dConInds(i,:) = conInd1.'; 
        
        belInd = randi(N,numMut,1);
        %the indices where changes will be made to the belief levels
        
        dCon(conInd1,conInd2) = (rand(numMut,numMut) - rand(numMut,numMut))*conMut; %making the random changes at chosen indices
        dBel(belInd) = (rand(numMut,1) - rand(numMut,1))*belMut;

        %%%%GOING THROUGH THE CHANGES TO THE CONNECTIONS
        prefit = fit(N,x,w,a,b,c); %calc the current fitness
        wn = w + dCon; %apply the changes
        for k=1:N
            for j=1:N
                if wn(k,j)<.01
                    wn(k,j)=0;
                end
            end
        end
        postfit = fit(N,x,wn,a,b,c); %calc new fitness
        improv = postfit>prefit; %check which values of the fitness were higher
        
        
        
        inds = find(improv == 0);
        dCon(inds,inds) = 0;
               
        w = clean(w + dCon + dCon0*.1); %keep the changes that improved things. 
        w = w./max(max(abs(w))); %normalizing back to one
        w = square(w);       
        
        %%%%GOING THROUGH THE CHANGES TO THE BELIEFS OF THE NODES
        prefit = fit(N,x,w,a,b,c);
        xn = x + dBel;
        postfit = fit(N,xn,w,a,b,c);
        improv = postfit>prefit;
        
        dBel = dBel.*improv;
        x = x + dBel + dBel0*.1;
        x = x./max(max(abs(x)));
        %X(:,i) = x;
        
        dCon0 = dCon;
        dBel0 = dBel;
        beliefs(:,i) = x;%saving the beliefs for later plotting
        
    end

    connections = w; %setting connections and opinions equal to the last state. 
    opinions = x;
  
end

function fitness = fit(N,Xin,Win,a,b,c)
    %finding the fitnesses of the nodes in the network:
    %determining the benefit for having strong belief
    xmag = a*abs(Xin);
    
    %benefit to having the same beliefs as those around you
    xcon = zeros(N,1);
    
    for i=1:N
        for j=1:N
            xcon(i,1) = xcon(i,1) + Xin(i,1)*Xin(j,1)*Win(i,j);
        end
    end
    
    xcon = b * xcon;
    
    %the benefit of having connections in the first place
    con = c*sum(Win,2);
    
    fitness = xmag + xcon + con;
end

function cleanW = clean(W) %set all small values in the network to zero
    pos = W>.03;
    cleanW = W.*pos;
end

function squareW = square(W) %goes through to make sure that the matrix is symmetrical
    squareW = W;
    for i = 1:size(W,1)
        for j = 1:size(W,1)
            squareW(i,j) = squareW(j,i);
        end
    end
end


