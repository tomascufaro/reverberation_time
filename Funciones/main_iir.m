function [tr, plot_data] =  main_iir(iir, octave, fs)
%% Main 
%
% Función para la obtención por banda de los tiempos de reververancia  característicos
% de una sala
%
% inputs:
% iir = (cell_array, double) respuestas al impulso ya calculadas
% octave = (int) bandwith of filter: 1, 3. 3 representa 1/3 de octava
% fs = sample rate 
% outputs:
% results = (struct)  parametros acústicos calculados por banda y sus respectivos
% desvios  
% plot_data = (struct) estructura con los datos de la senal procesada para
% graficar 
%%

        
    if octave == 1 
       % para cada impulso
       for i = 1:length(iir)
           % filtra y obtiene cell array 
           yw = iirfilter(iir{i}, 1 , fs, false);
           field = strcat('ir_', num2str(i)); 
           % arma struct con un field para cada impulso
           data.(field) = yw; 
       end 
    end
    % struct con cada muestra por field y cada filtro como cell struct  
    if octave == 3 
       for i = 1:length(iir)
           field = strcat('ir_', num2str(i));
           yw = iirfilter(iir{i}, 3, fs, false);
           data.(field) = yw;
       end
    end
    
    % armo el struct para los ploteos, por cada field voy a tener una senal
    % filtrada 
    ploters = [];
    fields = fieldnames(data);
    for  i = 1:numel(fields)
          for x = 1:numel(data.(fields{i}))
            ploters(1).(fields{i}){x} = [];
            ploters(2).(fields{i}){x} = [];
          end
    end

    % curva de energía a ploter(1) y curva de schroeder a ploter (2)
    % y para cada field en el estruct data la curva de energía
    for  i = 1:numel(fields)
         for x = 1:numel(data.(fields{i}))
              [et, etsch] = suave(data.(fields{i}){x}, fs);
              ploters(1).(fields{i}){x} = et;
              ploters(2).(fields{i}){x} = etsch;
              %data.(fields{i}){x} = etsch;
         end 
    end 
    % del struct data con las curvas de schroeder obtengo los
    % TR por banda 
    for i = 1:numel(fields)
         for x = 1:numel(data.(fields{i}))
               [EDT,T10,T20,T30,C80,D50] = parametros(data.(fields{i}){x},...
                                                      ploters(2).(fields{i}){x},...
                                                      fs);
               data.(fields{i}){x} = [EDT,T10,T20,T30,C80,D50];
         end      
    end
    
    % armo un nuevo struct donde cada field sea una banda y cada unidad del
    % cell array una muestra para dicha banda de tal manera que al
    % promediarlos devuelva un promedio por banda por cada field del struct
    for x = 1:numel(data.(fields{1}))
        for i = 1:length(fields)
           field = strcat('banda_', num2str(x));
           tr.(field){i} = data.(fields{i}){x};
        end
    end 
    % calculo los promedios, strcut tr tiene un promedio de tr por banda y
    % sus respectivos desvios standars 
    tr_names = fieldnames(tr);
    for i = 1:numel(tr_names)
            [a, b] = promedio(tr.(tr_names{i}));
            tr.(tr_names{i}) = cat(2, a, b);

    end
    %reestructuro los sctructs de tal manera de tener las distintas
    %muestras de una banda por field del struct, en plot_data(1) va a estar
    %la energía y en plot_data(2) vamos a encontrar las curvas de schroeder
    for x = 1:numel(ploters(1).(fields{1}))
        for i = 1:length(fields)
            field = strcat('banda_', num2str(x));
            plot_data(1).(field){i} = ploters(1).(fields{i}){x};
            plot_data(2).(field){i} = ploters(2).(fields{i}){x};
        end
    end 
    
    
    %obtener muestra random para plotear las curvas de energía_
    valor = randi(numel(fields));
    for i = 1:numel(ploters(1).(fields{valor}))
        plot_data(2).(tr_names{i}) = ploters(2).(fields{valor}){i}; 
        plot_data(1).(tr_names{i}) = ploters(1).(fields{valor}){i}; 
    end

end     
    
         
         
            
        
         
        