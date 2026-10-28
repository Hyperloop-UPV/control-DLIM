f_60kmh = 200;
v_60kmh = 60/3.6;
%%

k = 200/v_60kmh^2;
v = linspace(0,60/3.6,100);
F = k*v.^2;
plot(v*3.6,F)
xlabel("Velocidad [km/h]")
ylabel("Fuerza de resistencia Aerodinámica [N]")