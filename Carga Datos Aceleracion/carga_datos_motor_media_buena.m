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
fuerza=[];

%% Carga de datos
datos_H8 = readtable('G:\Hyperloop\Control\LIM\Datos\20230208_Barrido_DLIM_Resultados.xlsx');
datos_H9 = readtable('G:\Hyperloop\Control\LIM\Datos\Fuerza_Media_buena.csv');

%% Pasar datos a limpio en un vector ordenado por i slips con j frecuencias cada una

% Datos H9          i = 9 ; j = 10
datos_H9(:,1:2) = [];
datos_H9(2:3, :) = [];
fuerza_H9 = table2array(datos_H9)*-1;

% Datos H8          i = 9 ; j = 10      Slip de 0.1 a 0.9 y frec de 3 a 30
for i = 1:9
    for j = 1:10
        f_H8(1, 10*(i-1) + j) = datos_H8(1584 - 160*(i-1) + j, 6);
    end
end

fuerza_H8 = table2array(f_H8);

%% Juntar los datos de H8 y H9 en un array de fuerza con frecuencia en j y slip en i

% Traspasar fuerza H8
for i = 1:9
    for j = 1:10
        fuerza(i+1,j) = fuerza_H8(10*(i-1) + j);
    end
end

% Traspasar fuerza H9
for i = 1:9
    for j = 1:10
        fuerza(i+1,j+10) = fuerza_H9(10*(i-1) + j);
    end
end

%% Crear vectores slip y frecuencias

for n = 0:9
    slip(n+1) = 0.1*n;
end

for n = 1:20
    frecuencia(n) = 3*n;
end

for n = 1:10
    fuerza(1,:) = 0;
end

%% Graficas vel-fuerza
v_m=[];
Force=[];
maxForce=[];

 figure
 hold on
 grid

for k=1:max(size(frecuencia))
   v_ref=7.2*0.114*frecuencia(k);
    for i=1:max(size(slip))
        v_m(i,k)=v_ref-slip(i)*v_ref;
        Force(i,k)=fuerza(i,k);
                                                                                              %  ForceY(i,k)=FuerzaY_acel(i,max(size(Ipeak)),k);
    end
    plotvalue(k)=plot(v_m(:,k),Force(:,k),'DisplayName',string(frecuencia(k))+'Hz');
end

legend
xlabel('Velocidad Mecánica (km/h)')
ylabel('Fuerza (N)')
ylim([0 1100])
hold off