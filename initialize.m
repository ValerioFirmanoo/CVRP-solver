function [x_coord,y_coord,depo,d,distance,cost,v,capacity,numMacchine,opt_cost]=...
    initialize (filename)

data_matrix=readmatrix(filename);
x_coord=data_matrix(:,2);
y_coord=data_matrix(:,3);
depo=[x_coord(1),y_coord(1)];
d=data_matrix(:,4);
d(1)=[];

capacity=data_matrix(1,5);
numMacchine=data_matrix(1,6);
opt_cost=data_matrix(1,7);
numCostumers=size(x_coord,1);

distance = zeros(numCostumers, numCostumers);
for i = 1:numCostumers
    for j = 1:numCostumers
       distance(i, j) = round(10 * sqrt(((x_coord(i) - x_coord(j)).^2) + ((y_coord(i) - y_coord(j)).^2)));
    end
end

cost = zeros(numCostumers-1, numCostumers-1);
for i = 1:numCostumers-1
    for j = 1:numCostumers-1
       cost(i, j) = round(distance(1,i+1)+distance(i+1,j+1)-distance(1,j+1));
    end
end


v = zeros(numCostumers-1,1);
for j= 1:numCostumers-1
    v(j) = 2*distance(1,j+1);
end