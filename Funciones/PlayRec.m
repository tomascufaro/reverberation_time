function PlayRec(fm)

%     Función para grabar y reproducir un sine sweep en tiempo real.
%     Para la reproduccion se utiliza un archivo de audio previamente generado por MainGUI.
%     La adquisicion se realiza mediante un stream de bits hacia un archivo
%     de audio localizado en el directorio principal de MainGUI.
%     El numero de muestras perdidas en el input esta representado por
%     nOverrun.
%     El numero de muestras perdidas en el output esta representado por
%     nUnderrun.
%     fm = Frecuencia de muestreo

    %Construcción de objetos
    fileReader = dsp.AudioFileReader([pwd '\Sinesweep\sine_sweep.wav']);
    fileWriter = dsp.AudioFileWriter([pwd '\MicRecorded.wav'], 'SampleRate', fm);
    aPR = audioPlayerRecorder('SampleRate',fm);
    release(aPR)

    try
        while ~isDone(fileReader)          %Loop de adquisicion de señal
            audioToPlay = fileReader();

            [audioRecorded,nUnderruns,nOverruns] = aPR(audioToPlay);

            fileWriter(audioRecorded)

            if nUnderruns > 0
                fprintf('Audio player queue was underrun by %d samples.\n',nUnderruns);
            end
            if nOverruns > 0
                fprintf('Audio recorder queue was overrun by %d samples.\n',nOverruns);
            end
        end

    release(fileReader);
    release(fileWriter);
    release(aPR);

    catch ME   %Control de error por incompatibilidad de la placa
        switch ME.identifier()
            case 'audio:audioPlayerRecorder:noDevice'
                warning('Sound Device no soporta grabar y reproducir al mismo tiempo');
            otherwise
                rethrow(ME)
        end
    end
end

