function [x, j,fm] = sineSweep(fm,t,f1,f2)
%       Esta funcion genera una señal de sine sweep como un vector de
%       amplitudes
%
%       [x, j,fm] = sineSweep(fm,t,f1,f2)
%        inputs:
%       fm = Frecuencia de muestreo
%       t = Duracion en segundos
%       f1 = Frecuencia inferior
%       f2 = Frecuencia superior
%       outputs:
%       j = Filtro inverso 
%       x = Amplitud del sine sweep
%       fm = Frecuencia de muestreo




    if ((f1<=0) || (f2<=0) || (t<=0)) || (f2<=f1)
        error('t debe ser mayor a 0; f1, f2 deben ser mayores a 0; f2 debe ser mayor a f1')
    else
        w1 = 2*pi*f1;
        w2 = 2*pi*f2;
        N = t*fm;
        t_ = linspace(0,t,N); 

        k = (t*w1)/log(w2/w1);
        l = t/log(w2/w1);

        x = sin(k*(exp(t_./l)-1));  
        x = x/max(abs(x));  %Sine sweep logaritmico

        w = (k/l)*exp(t_./l);
        m = w1./(2*pi*w);

        j = m.*wrev(x);
        j = j/max(abs(j));      %Filtro inverso normalizado

    end
end
