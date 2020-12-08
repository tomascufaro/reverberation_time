function [Et,Etsch] = suave(ht,fm)
%% suave
%   Suavizado y recorte de una RI mediante la integral de schroeder.
%   Se calcula su limite de integracion aplicando el metodo de Lundeby a la
%   señal previamente suavizada mediante la transformada de Hilbert y un
%   filtro de media movil.
%
%   [Et,Etsch] = suave(ht,fm)
%
%   INPUTS:
%       ht = Respuesta al impulso
%       fm = Frecuencia de muestreo
%   Outputs:
%       Et = Curva de energia(dB)
%       Etsch = Curva de Schroeder(dB)

    hthilb = abs(hilbert(ht));
    Ethilb = 10*log10(hthilb.^2/max(hthilb.^2));   %Suavizado de la señal para 
    Etlund = medMov(Ethilb);                       %el metodo de Lundeby

    Et = 20*log10(abs(ht)/max(abs(ht)));     %Energia del impulso 
    Etsch = schr(ht,Etlund,fm);              %normalizada en dB
end

%%  Filtro de media movil
function htmm = medMov(ht)

    movavgWindow = dsp.MovingAverage(501);
    htmm = movavgWindow(ht);

end

%%  Integral de Schroeder
function Etsch = schr(ht,Etlund,fs)

    enc = lundeby(Etlund,fs);   %Limite de integracion
    htsch(enc:-1:1) = (cumsum(ht(enc:-1:1).^2)/...
                      (sum(ht(1:length(ht))).^2));   
    Etsch = 10*log10(htsch/max(abs(htsch)));

end
