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


%% Crea array de frenado con j columnas de frecuencia e i filas de velocidad
array_frenado_H8 = table2array(datos_frenado_H8);

for i = 1:8
    for j = 1:16
        frenado_H8(i,j) = array_frenado_H8(16*(i-1) + j, 6);
    end
end

frenado_H8 = frenado_H8*-1;
%% Crear vector velocidad y frecuencias

for n = 1:16
    frecuencia(n) = 3*n;
end

for m = 1:max(size(frecuencia))
    for n = 1:8
        v_m(n, m) = 5 + 5*(n-1);
    end
end

%% Graficas vel-fuerza

 figure
 hold on
 grid

for k=1:max(size(frecuencia))
    for i=1:min(size(v_m))
        Force(i,k)=frenado_H8(i,k);
    end
    plotvalue(k)=plot(v_m(:,k),Force(:,k),'DisplayName',string(frecuencia(k))+'Hz');
end

legend
xlabel('Velocidad Mecánica (km/h)')
ylabel('Fuerza (N)')
ylim([0 1100])
hold off