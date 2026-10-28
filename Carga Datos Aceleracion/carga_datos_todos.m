v_m=[];
Force=[];
maxForce=[];
frecuencia_acel=[];
slip=[];
datos_frenado_H9=[];
datos_frenado_H8=[];
frenado_H9=[];
frenado_H8=[];
frenado=[];
plotvalue=[];
fuerza=[];

%% Carga de datos
datos_H8 = readtable('Datos\20230208_Barrido_DLIM_Resultados.xlsx');
datos_H9 = readtable('Datos\Fuerza_Media_90.csv');
datos_H9_c = readtable('Datos\Media_Fuerzas_70_90 - 33 a 75 Hz.csv');
datos_H9_cc = readtable('Datos\Fuerza_Media_90_0,5s.csv');
datos_H9_ccc = readtable('Datos\Fuerza Media 10 - 60 A, 01-02.csv');

%% Pasar datos a limpio en un vector ordenado por i slips con j frecuencias cada una

% Datos H9          i = 9 ; j = 20
datos_H9(:,1:2) = [];
datos_H9(2:3, :) = [];
fuerza_H9 = table2array(datos_H9)*-1;

datos_H9_c(:,1:2) = [];
datos_H9_c(2:3, :) = [];
fuerza_H9_c = table2array(datos_H9_c)*-1;

datos_H9_cc(:,1:2) = [];
datos_H9_cc(2:3, :) = [];
fuerza_H9_cc = table2array(datos_H9_cc)*-1;

datos_H9_ccc(:,1:2) = [];
datos_H9_ccc(2:3, :) = [];
fuerza_H9_ccc = table2array(datos_H9_ccc)*-1;

% Datos H8          i = 10 ; j = 10      Slip de 0.1 a 0.9 y frec de 3 a 30
for i = 1:10        % slip
    for k = 1:10        % corriente
        for j = 1:10        % frecuencia
            f_H8(1, 100*(i-1) + 10*(k-1) + j) = datos_H8(1440 + 16*(k-1) - 160*(i-1) + j, 6);
        end
    end
end

fuerza_H8 = table2array(f_H8);

%% Juntar los datos de H8 y H9 en un array de fuerza con frecuencia en j y slip en i

% Traspasar fuerza H8
for i = 1:10
    for k = 1:10
        for j = 1:10
            fuerza(i+1,j,k) = fuerza_H8(100*(i-1) + 10*(k-1) + j);
        end
    end
end

% Traspasar fuerza H9 33 a 60 Hz
for i = 1:9
        for j = 1:10
            fuerza(i+1,j+10, 10) = fuerza_H9(10*(i-1) + j);
        end
end

% Traspasar fuerza H9 63 a 90 Hz
for i = 1:9
    for j = 1:10
        fuerza(i+1,j+20, 10) = fuerza_H9(90 + 10*(i-1) + j);
    end
end

% Traspasar fuerza H9 33 a 75 Hz - 70 a 90 A
for i = 1:4
    for k = 1:3
        for j = 1:15
            fuerza(i+1, j+10, 6+k) = fuerza_H9_c(45*(i-1) + 15*(k-1) + j);
        end
    end
end

% Traspasar fuerza H9 33 a 51 Hz - 90 A - 0.5 slip
for j = 1:7
    fuerza(5+1, j+10, 9) = fuerza_H9_cc(j);
end

% Traspasar fuerza H9 51 a 57 Hz - 10 a 60 A - 0.1 a 0.3 slip
for i = 1:3
    for k = 1:6
        for j = 1:3
            fuerza(i+1, j+16, k) = fuerza_H9_ccc(18*(i-1) + 3*(k-1) + j);
        end
    end
end

%% Crear vectores slip, frecuencia y corriente

for n = 0:10
    slip(n+1) = 0.1*n;
end

for n = 1:30
    frecuencia_acel(n) = 3*n;
end

for n = 1:10
    corriente(n) = 10*n;
end

for n = 1:10
    fuerza(1,:) = 0;
end

for i = 1:length(slip)
    for j = 1:length(frecuencia_acel)
        for k = 1:length(corriente)
            if fuerza(i, j, k) == 0;
                fuerza(i, j, k) = NaN;
            end
        end
    end
end

% Igualar los 0 a NaN
fuerza(1, :, :) = 0;


%% Graficas vel-fuerza
%{
 figure
 hold on
 grid

for k=1:length(frecuencia_acel)
   v_ref=7.2*0.114*frecuencia_acel(k);
    for i=1:length(slip)
        v_m(i,k)=v_ref-slip(i)*v_ref;
        Force(i,k)=fuerza(i,k);
    end
    plotvalue(k)=plot(v_m(:,k),Force(:,k),'DisplayName',string(frecuencia_acel(k))+'Hz');
end

legend
xlabel('Velocidad Mecánica (km/h)')
ylabel('Fuerza (N)')
ylim([0 1100])
hold off
%}


%% Datos frecuencia - velocidad

for j = 1:length(frecuencia_acel)
    for i = 1:10
        if fuerza(i+1, j, 10) == max(fuerza(:, j, 10))
            slip_optimo(j) = i/10;
        end
    end
end

for j = 1:length(frecuencia_acel)
    vel_m(j) = 2*(j*3)*0.114*(1-slip_optimo(j))*3.6;
end

% Constantes recta frecuencia
% a = 1.3;
% b = 8.4;


%% IMPORTANTE
init_cond = 0;      % 0 para run 1 y 3;         3/3.6 para run 2