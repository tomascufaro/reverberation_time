function [Etprom, desvio] = promedio(BN)
%% promedio
% Calcula un promedio de vectores por fila, contenidos en un cell array.
% As� mismo tambi�n calcula el desv�o estandar de los valores obtenidos
%   [Etprom, desvio] = promedio(BN)
%
%   INPUTS:
%       BN = cell array de v�ctores 
%   Outputs:
%       Etprom = Valores promediados.
%       desvio = desvios estandar correspondiente a los calculos. 
%%


cant=length(BN);  %cantidad de se�ales
m=0;
%en caso de tener dimensiones variables se toma la mayor longitud
for i = 1:cant
    N = length(BN{i});  
    if N>m
        m=N;
    end
end


A = zeros(cant,N);
for i = 1:cant
    A(i,1:length(BN{i})) = BN{i};
end
Etprom = mean(A);
desvio = std(A);