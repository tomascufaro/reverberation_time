function yw = iirfilter(x, l, fs, plot_response)
%% iirfilter
% Funcíon para realizar un filtrado pasa banda por octava o tercio de octava.
% el filtrado responde a las reglas IEC 61260 
% inputs:
% x = (double, cell_array). senal a filtrar 
% fs = (int). Frecuencia de muestreo 
% l = (int). ancho de banda puede ser de '1', o '1/3'. Se deben ingresar
% dichos valores 
%plot_response = ((bool )mostrar grafico de respuesta al impulso si se desea para
%corroborar el funcionamiento del filtro. 


%% 
% frecuencia central referencia 
    Fc = 1000;

        
    if l == 1    
        octFilt = octaveFilter('FilterOrder', 6, ...
                    'CenterFrequency', Fc, 'Bandwidth', '1 octave', 'SampleRate', fs);
        Fc = getANSICenterFrequencies(octFilt); %frecuencias centrales
        Fc(Fc<125) = [];
        Fc(Fc>20e3) = [];
        Nfc = length(Fc); %cantidad de bandas
        
        irFiltbank = cell(1,Nfc);
        for i = 1:Nfc 
            f1 = Fc(i)/2^(1/2);
            f2 = Fc(i)*2^(1/2);
            
            irFiltbank{i} = designfilt('bandpassiir','FilterOrder',6, ...
                                'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2, ...
                                'SampleRate',fs);
        end
        yw = {zeros(length(x),Nfc)};                
        for i=1:Nfc
            filt = irFiltbank{i};
            yw{:, i} = filtfilt(filt, x);
        end
       
    else
        octFilt = octaveFilter('FilterOrder', 8, ...
                    'CenterFrequency', Fc, 'Bandwidth', '1/3 octave', 'SampleRate', fs);
        Fc = getANSICenterFrequencies(octFilt); %frecuencias centrales
        Fc(Fc<100) = [];
        Fc(Fc>20e3) = [];
        Nfc = length(Fc); %cantidad de bandas
        
        irFiltbank = cell(1,Nfc);
        for i = 1:Nfc       
            l = 1/3;
            f1 = Fc(i)/2^(1/6);
            f2 = f1*2^(l);
            irFiltbank{i} = designfilt('bandpassiir','FilterOrder',8, ...
                    'HalfPowerFrequency1',f1,'HalfPowerFrequency2',f2, ...
                    'SampleRate',fs);
        end 
        
        yw = {zeros(length(x),Nfc)};
        for i=1:Nfc
            filt = irFiltbank{i};
            yw{:, i} = filtfilt(filt, x);
        end
    end
    
    if plot_response == true 
        
        plotter = fvtool(irFiltbank{1}, ...
        irFiltbank{2}, ...
        irFiltbank{3}, ...
        irFiltbank{4}, ...
        irFiltbank{5}, ...
        irFiltbank{6}, ...
        irFiltbank{7}, ...
        'Fs',fs);
        set(plotter,'FrequencyScale','Log')
    end
  
          

end
