function [a0,a1] = regLin(x,y)
%% regLin
%   Realiza una regresion lineal mediante un ajuste por cuadrados
%   minimos.
%
%   [a0,a1] = regLin(x,y)
%
%   Inputs: x e y son coordenadas de cada muestra de la señal a procesar.
%   Output: a0 y a1 son los coeficientes de una recta de ajuste definida 
%           como a0+01*x

    if isnumeric(x)==0 || isnumeric(y)==0
    error('Datos de entrada no validos. Los datos deben ser del tipo numerico.')
    end

    A = ones(length(x),2);
    A(:,2) = x;
    B = y';
        
    try
        coef = (A'*A)\(A'*B);
        a0 = coef(1);
        a1 = coef(2);
    catch
        switch length(x)==length(y)
            case 1                      %Si y es ingresado como vector columna
               B = B';
               coef = (A'*A)\(A'*B);
               a0 = coef(1);
               a1 = coef(2);
            case 0
                error('x e y no tienen la misma longitud')
                
        end
    end
   
end