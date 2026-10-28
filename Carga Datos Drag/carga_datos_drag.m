datos_drag = [];
airgap = [];

%% Carga Datos

datos_drag = readtable('Datos\Drag.xlsx');

datos_drag = fliplr(datos_drag);

fuerza_drag = table2array(datos_drag);

%% Asignacion vectores

airgap = 14.5:1:16.5;

velocidad_drag = 5:5:60;