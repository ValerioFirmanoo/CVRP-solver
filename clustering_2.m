function [sol_2,GAPprob_2]=clustering_2(numCostumers,numMacchine,capacity,d,seed_pos,distance)

seed_cost = zeros(numCostumers-1, numMacchine);
for i = 1:numCostumers-1
    for k = 1:numMacchine
       seed_cost(i, k) = round(distance(1,i+1)+distance(i+1,seed_pos(k)+1)-distance(1,seed_pos(k)+1));
    end
end

%SOLVE GAP PROBLEM TO FIND CLUSTERS

GAPprob_2 = optimproblem('ObjectiveSense','min');

y_2 = optimvar('y_2',numCostumers-1,length(seed_pos),'Type','integer','LowerBound',0,'UpperBound',1);

GAPprob_2.Objective=sum(sum(seed_cost.*y_2));

cons2 = optimconstr(numMacchine);
for k = 1:numMacchine
    cons2(k)= d'*y_2(:,k) <= capacity;
end

cons3=optimconstr(numCostumers-1);
for i = 1:numCostumers-1
    cons3(i)= sum(y_2(i,:)) == 1;
end

GAPprob_2.Constraints.cons2 = cons2;

GAPprob_2.Constraints.cons3 = cons3;

sol_2=solve(GAPprob_2);