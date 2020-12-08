
function [punto]=lundeby(varargin)
%% lundeby
%
%   Implementa el metodo de Lundeby para determinar el extremo de
%   integracion de la integral de Schroeder.
%
%   [punto]=lundeby(Et,fm)
%
%   INPUTS:
%       Et = Energia de la RI, en escala logaritmica
%       fm = Frecuencia de muestreo
%   OUTPUT:
%       punto = Limite de integracion de Schroeder
% 
%   Esta funcion es una adaptacion de la funcion lundeby,
%   creada para la Universidad de San Pablo por Bruno S. Masiero (2006). 
%   https://www.mathworks.com/matlabcentral/fileexchange/11392-acmus-room-acoustic-parameters

    Et = varargin{1};
    fm = varargin{2};

    %Calcula el nivel de ruido del 10% final de la señal

    ruidodb = mean(Et(round(.9*length(Et)):end));

    %Divide en intervalos y obtiene la media
    t = floor(length(Et)/fm/0.01);
    v = floor(length(Et)/t);
    media = zeros(1,t);
    tiempo = zeros(1,t);
    for n=1:t
        media(n) = mean(Et((((n-1)*v)+1):(n*v)));
        tiempo(n) = ceil(v/2)+((n-1)*v);
    end
    
    mediadB = media;

    %Calcula la regresion lineal al intervalo desde 0dB y la media mas cercana de rms+10dB
    r = find(mediadB > ruidodb+10, 1, 'last' );
    if any (mediadB(1:r) < ruidodb+10)
        r = find(mediadB(1:r) < ruidodb+10, 1 );
    end
    if isempty(r)
        r=10;
    elseif r<10
        r=10;
    end
    [A,B] = regLin(tiempo(1:r),mediadB(1:r));
    encuentro = (ruidodb-A)/B;
    if ruidodb > -20
        %Relacion señal/ruido insuficiente
        punto = length(Et);
        
    else

        %%%%%%%%%%%%%%%%%%%%%%%%INICIA LA PARTE ITERATIVA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        error=1;
        INTMAX=50;
        veces=1;
        while (error > 0.0001 && veces <= INTMAX)

            %Calcula nuevos intervalos de tiempo para la media, con aproximadamente p pasos cada 10dB
            clear r t v n media tiempo;
            p = 5;                          %Numero de pasos cada 10 dB
            delta = abs(10/B);              %Numero de muestras para que la linea de tendencia decaiga 10dB
            v = floor(delta/p);             %Intervalo para obtencion de media
            t = floor(length(Et(1:round(encuentro-delta)))/v);
            if t < 2                        %Numero de intervalos para obtencion de la nueva media en el intervalo
                t=2;                        %desde el inicio hasta 10dB antes del punto de encuentro.
            elseif isempty(t)
                t=2;
            end

            for n=1:t
                media(n) = mean(Et((((n-1)*v)+1):(n*v)));
                tiempo(n) = ceil(v/2)+((n-1)*v);
            end
            mediadB = media;

            clear A B noise energia_ruido rms_dB;
            [A,B] = regLin(tiempo,mediadB);
            %Nueva media de la energia del ruido, iniciando en el punto de la linea de tendencia 10dB por debajo del encuentro.
            noise = Et(round(encuentro+delta):end);
            if (length(noise) < round(.1*length(Et)))
                noise = Et(round(.9*length(Et)):end); 
            end       
            ruidodb = mean(noise);
            %Nuevo punto de encuentro
            error = abs(encuentro - (ruidodb-A)/B)/encuentro;
            encuentro = round((ruidodb-A)/B);
            veces = veces + 1;
        end
    end

    if encuentro > length(Et)     %En caso de que la señal no alcance el nivel del ruido de fondo
        punto = length(Et);       %en las muestras previstas, se considera el punto
    else                          %de encuentro la ultima muestra, que equivale a no
        punto = encuentro;        %truncar la señal.
    end
end
