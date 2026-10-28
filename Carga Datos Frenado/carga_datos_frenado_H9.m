%% Limpiar arrays

v_m=[];
Force=[];
maxForce=[];
frecuencia=[];
slip=[];
datos_frenado_H9=[];
datos_frenado_H8=[];
frenado_H9=[];
frenado_H8=[];
frenado=[];
plotvalue=[];

%% Carga datos frenado
datos_frenado_H8 = readtable('G:\Hyperloop\Control\LIM\Datos\20230227_DLIM_H8_Freno_v3.xlsx');
datos_frenado_H9 = readtable('G:\Hyperloop\Control\LIM\Datos\Frenado_Media.csv');

datos_frenado_H9(1:2, :) = [];
datos_frenado_H9(:,1) = [];

%% Crea array de frenado con j columnas de frecuencia e i filas de velocidad
array_frenado_H9 = table2array(datos_frenado_H9);

for i = 1:11
    for j = 1:6
        frenado_H9(i,j) = array_frenado_H9(6*(i-1) + j);
    end
end

frenado_H9 = frenado_H9*-1;
%% Crear vector velocidad y frecuencias

frecuencia = [1, 2, 3, 4, 6, 8];

for k = 1:max(size(frecuencia))
    v_m(k) = 1;
end

for m = 1:max(size(frecuencia))
    for n = 1:10
        v_m(n+1, m) = 5 + 5*(n-1);
    end
end

% Elimina 1 Km/h
        frenado_H9(1,:) = [];
        v_m(1,:) = [];

%% Graficas vel-fuerza

 figure
 hold on
 grid

for k=1:max(size(frecuencia))
    for i=1:max(size(v_m))
        Force(i,k)=frenado_H9(i,k);
    end
    plotvalue(k)=plot(v_m(:,k),Force(:,k),'DisplayName',string(frecuencia(k))+'Hz');
end

legend
xlabel('Velocidad Mecánica (km/h)')
ylabel('Fuerza (N)')
ylim([0 1100])
hold off
