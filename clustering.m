function [sol,GAPprob]=clustering(numCostumers,numMacchine,capacity,d,cost,v)

%SOLVE GAP PROBLEM TO FIND CLUSTERS

GAPprob = optimproblem('ObjectiveSense','min');

y = optimvar('y',numCostumers-1,numCostumers-1,'Type','integer','LowerBound',0,'UpperBound',1);
z = optimvar('z',numCostumers-1,1,'Type','integer','LowerBound',0,'UpperBound',1);

GAPprob.Objective=sum(sum(cost.*y))+sum(v.*z);

cons1 = sum(z) == numMacchine;

% cons2 = optimconstr(numCostumers-1);
% for j = 2:numCostumers
%     cons2(j)= d'*y(:,j) <= 100;
% end

cons2 = optimconstr(numCostumers-1);
for j = 1:numCostumers-1
    cons2(j)= d'*y(:,j) <= capacity;
end

cons3=optimconstr(numCostumers-1);
for i = 1:numCostumers-1
    cons3(i)= sum(y(i,:)) == 1;
end

cons4=optimconstr(numCostumers-1,numCostumers-1);
for i = 1:numCostumers-1
    for j = 1:numCostumers-1
        cons4(i,j)= y(i,j) <= z(j);

    end
end

GAPprob.Constraints.cons1 = cons1;

GAPprob.Constraints.cons2 = cons2;

GAPprob.Constraints.cons3 = cons3;

GAPprob.Constraints.cons4 = cons4;




sol=solve(GAPprob);