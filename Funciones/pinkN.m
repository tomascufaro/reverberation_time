function [x,fm] = pinkN(fm,t)
%       Esta funcion genera una señal de ruido rosa como un vector de
%       amplitudes
%
%       [x,fm] = pinkN(fm,t)
%       inputs:
%       fm = Frecuencia de muestreo
%       t = Duracion en segundos
%       outputs:
%       x = Amplitud del ruido rosa

    if (fm<=0) || (t<=0)   %Control de errores
        error('t debe ser mayor a 0; fm debe ser mayores a 0')
    else
        Nx = fm*t;
        B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
        A = [1 -2.494956002   2.017265875  -0.522189400];
        nT60 = round(log(1000)/(1-max(abs(roots(A))))); %
        v = randn(1,Nx+nT60); % ruido blanco gaussiano: N(0,1)
        x = filter(B,A,v);    
        x = x(nT60+1:end);    

    end
end
