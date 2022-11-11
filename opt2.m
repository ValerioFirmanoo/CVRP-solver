function [T_1,ncycles,minimum]=opt2 (T,tolerance,distance_cluster)

%inizializzazione di variabili necessarie
T_1=T;
minimum=inf;
min_old=0;
ncycles=0; %numero di iterazioni che fa il 2-opt per ogni cluster

%ciclo while che ci permette di salvare nella matrice perm_matrix tutte le
%possibili permutazioni dei punti nel percorso T (senza considerare il
%deposito che sarà sempre punto di partenza e arrivo).

while(abs(min_old-minimum)>=tolerance)
    T_1=T_1(2:end-1);
    perm_matrix=T_1;
    for i=1:length(T_1)-1
        for j=i+1:length(T_1)
            support=T_1;
            support(i)=T_1(j);
            support(j)=T_1(i);
            perm_matrix=[perm_matrix;support];
        end
    end

    %aggiungo il deposito compe punto di partenza e arrivo
    perm_matrix=[ones(size(perm_matrix,1),1),perm_matrix,ones(size(perm_matrix,1),1)];
    %calcolo delle distanze totali percorso
    costi_percorsi= zeros(size(perm_matrix,1),1);

    % Calcolo i costi di ogni percorso permutato
    for i=1:size(perm_matrix,1)
        t=0;
        for j=1:size(perm_matrix,2)-1
            t=t+distance_cluster(perm_matrix(i,j),perm_matrix(i,j+1));
        end
        costi_percorsi(i)=t;
    end

    %Trovo il percorso con il costo minimo e aggiorno le variabili
    min_old=minimum;
    [~,pos_best]=min(costi_percorsi);
    minimum=min(costi_percorsi);
    T_1=perm_matrix(pos_best,:);
    ncycles=ncycles+1;
end
