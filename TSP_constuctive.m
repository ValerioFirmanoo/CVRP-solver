function [T,distance_cluster... 
    ]=TSP_constuctive(x_cluster,y_cluster)

%calcolo distanza tra i punti nel cluster
distance_cluster = zeros(length(x_cluster), length(x_cluster));
for i = 1:length(x_cluster)
    for j = 1:length(x_cluster)
       distance_cluster(i, j) = round(10 * sqrt(((x_cluster(i) - x_cluster(j)).^2) + ((y_cluster(i) - y_cluster(j)).^2)));
    end
end

%inizializzazione degli insiemi T e V (rispettivamente punti già inseriti
%nel percorso e punti da inserire)
T=[1,1];
V=2:length(x_cluster);
%Trovo la distanza massima dal deposito per inizializzare il primo punto
[~,k]=max(distance_cluster(1,:));
T=[T(1),k,T(2)];
V(k-1)=[];

%while che cilcla il processo costruttivo fino ad avere un insieme V vuoto di
%punti "obiettivo"
while ~isempty(V)

    m_distance=ones(size(distance_cluster))*inf;
    m_distance(T,V)=distance_cluster(T,V);
    [~,k]=min(min(m_distance));

    cost_matrix=ones(length(distance_cluster),length(distance_cluster))*inf;

    for i = T(1:end-1)
        j=T(find(T(1:end-1)==i)+1);
        cost_matrix(i,j)=distance_cluster(i,k)+distance_cluster(k,j)-distance_cluster(i,j);
    end

    [~,pos_idx]=min(cost_matrix(:));
    % Identificazione degli indici (riga,colonna) del valore massimo
    [i_min,j_min]=ind2sub(size(cost_matrix),pos_idx);
    %aggiorniamo T
    pos_T=find(T==i_min);
    T=[T(1:pos_T),k,T(pos_T+1:end)];
    %aggiorniamo V
    pos_V=find(V==k);
    V(pos_V)=[];
end
