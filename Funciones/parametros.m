function [EDT,T10,T20,T30,C80,D50] = parametros(ht,Etsch,fm)
%% parametros
%   Calcula los tiempos de reverberacion segun la normativa ISO-3382
%   y los energeticos Claridad (C80) y Definicion (D50)
%   Inputs:
%       ht = Vector respuesta al impulso.
%       Etsch = Vector de valores de la señal suavizada.
%       fm = Frecuencia de muestreo.
%   Outputs:
%       EDT = Early Decay Time en [s]
%       T10 = Parametro T10 [s]
%       T20 = Parametro T20 [s]
%       T30 = Parametro T30 [s]
%       C80 = Claridad (C80) [dB]
%       D50 = Definicion (D50) [%]

    [EDT,T10,T20,T30] = TR(Etsch,fm);
    [C80,D50] = paramEnergeticos(ht,fm);
end

%%  Tiempos de reverberacion
function [EDT,T10,T20,T30] = TR(Etsch,fm)
%%  TR
%       Esta funcion es una adaptacion de la funcion calcular_parametros,
%       creada para la asignatura Señales y Sistemas durante 
%       el 2do cuatrimestre de 2018.
%       Autoria: Corina Castelli, Nahuel Passano, Agustin Espindola, Matias
%       Lareo

    x_i = 0:1/fm:(length(Etsch)-1)/fm;
    y_i = Etsch;

    % EDT
    x1_EDT = find(y_i < max(y_i),1,'first');
    x2_EDT = find(y_i < (max(y_i)-10),1,'first');
    y_i_EDT = (y_i(x1_EDT:x2_EDT));
    x_i_EDT = (x_i(x1_EDT:x2_EDT));
    [~,a1] = regLin(x_i_EDT,y_i_EDT);
    EDT = (-60)/a1;

    % T10
    x1_T10 = find(y_i < (max(y_i)-5),1,'first');
    x2_T10 = find(y_i < (max(y_i)-15),1,'first');
    x_i_T10 = (x_i(x1_T10:x2_T10));
    y_i_T10 = (y_i(x1_T10:x2_T10));
    [~,a1] = regLin(x_i_T10,y_i_T10);
    T10 = (-60)/a1;

    %%T20
    x1_T20 = find(y_i < (max(y_i)-5),1,'first');
    x2_T20 = find(y_i < (max(y_i)-25),1,'first');
    x_i_T20 = (x_i(x1_T20:x2_T20));
    y_i_T20 = (y_i(x1_T20:x2_T20));
    [~,a1] = regLin(x_i_T20,y_i_T20);
    T20 = (-60)/a1;

    %%T30
    x1_T30 = find(y_i < (max(y_i)-5),1,'first');
    x2_T30 = find(y_i < (max(y_i)-35),1,'first');
    x_i_T30 = (x_i(x1_T30:x2_T30));
    y_i_T30 = (y_i(x1_T30:x2_T30));
    [~,a1] = regLin(x_i_T30,y_i_T30);
    T30 = (-60)/a1;
end

%%  Parametros energeticos
function [C80,D50]=paramEnergeticos(ht,fm)

    Et = ht.^2;
    t50 = round(0.05*fm);
    t80 = round(0.08*fm);

    C80 = 10*log10(trapz(Et(1:t80))/trapz(Et(t80:end)));   %C80
    D50 = trapz(Et(1:t50))/trapz(Et)*100;   %D50
    
end