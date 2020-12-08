function [ht] = RI(y,j)
%% RI
%   Generacion de una respuesta al impulso segun el metodo propuesto por
%   A. Farina(2000).
%
%   [ht] = RI(y,j)
%
%   INPUTS:
%       y = Vector toma grabada
%       j = filtro inverso logaritmico
%   OUTPUTS:
%       ht = Vector de respuesta al impulso

    if isnumeric(y)==0 || isnumeric(j)==0
        error('Datos de entrada no validos. Los datos deben ser del tipo numerico.')
    end
    
    j = [j zeros(1,(length(y)-length(j)))];
        
    Yf = fft(y');
    Jf = fft(j');

    Hf = Yf.*Jf;
    ht = ifft(Hf);
    ht = (ht/max(abs(ht)));

    inicio = find(abs(ht) == max(abs(ht)),1,'first');   %Recorte del impulso
    ht = ht(inicio:end);

end