function [T_matrix_x,T_matrix_y,T_cost_vec,tot_cost]=...
    solver (cluster_matrix,numMacchine,numCostumers,x_coord,y_coord)

%In questa funzione vengono applicati un metodo costruttivo e in seguito 
% un 2-opt per la soluzione dei problemi TSP in OGNI cluster.
% Vengono restituiti due matrici contenenti le coordinate dei percorsi
% (T_matrix_x,T_matrix_y), il vettore dei costi per ogni percorso e il
% costo totale

route_matrix=round(cluster_matrix);
route_matrix( :, ~any(route_matrix,1) ) = []; 
route_matrix=[ones(1,numMacchine);route_matrix];
matrix_x=repmat(x_coord,1,numMacchine);
matrix_y=repmat(y_coord,1,numMacchine);
tabTx=route_matrix.*matrix_x;
tabTy=route_matrix.*matrix_y;

%inizializzazioni
T_matrix=zeros(numMacchine,numCostumers+1);
vec_ncycles=zeros(numMacchine,1);
T_cost_vec=zeros(numMacchine,1);

tolerance=1;

for i=1:numMacchine
    
    %inizializzazione degli input delle funzioni
    x_cluster=tabTx(:,i);
    x_cluster(x_cluster==0)=[];
    y_cluster=tabTy(:,i);
    y_cluster(y_cluster==0)=[];
    
    %applico le funzioni
    [T,distance_cluster]=TSP_constuctive(x_cluster,y_cluster);
    [T_best,ncycles,T_cost]=opt2 (T,tolerance,distance_cluster);
    
    %salvo i risultati
    T_matrix(i,:)=[T_best, zeros(1,numCostumers-length(T_best)+1)];
    vec_ncycles(i)=ncycles;
    T_cost_vec(i)=T_cost;
    tot_cost=round(sum(T_cost_vec)/10);
   
    for j=1:length(T_best)
          T_matrix_x(i,j)=x_cluster(T_best(j));
          T_matrix_y(i,j)=y_cluster(T_best(j));
    end
    
end