function fdm_twod_validacao(pvc_def)

% Caracteristicas do PVC
pvc_def.debug = 0;
pvc_def.coefK = 1;
pvc_def.betha = @fdm_twod_validacao_coef_betha;
pvc_def.gama = 0;
pvc_def.temp0 = 10;

% Definicao do dominio (a, b) x (c, d)
dominio.a = -1.0; dominio.b = 1.0; dominio.c = -1.0; dominio.d = 1.0;
hx = (dominio.b - dominio.a) / (pvc_def.nnos_x - 1);
hy = (dominio.d - dominio.c) / (pvc_def.nnos_y - 1);

% Definicao da Malha
meshing = fdm_twod_meshing(pvc_def, dominio, hx, hy);

% Sistema Linear Associado
A = fdm_build_matriz_rigidez(pvc_def, meshing, hx, hy); 
F = zeros(pvc_def.ordem, 1);

% Aplicando as condicoes de contorno de valor prescrito
for no = 1 : pvc_def.ordem

	if (meshing(no).x == dominio.a || meshing(no).x == dominio.b ||
		meshing(no).y == dominio.c || meshing(no).y == dominio.d) 
		
		for j = 1 : pvc_def.ordem
			A(no, j) = 0;
		endfor
		A(no, no) = 1;
		F(no) = pvc_def.temp0;
	endif

endfor

% Resolvendo o PVC
uh = A\F;

if (pvc_def.debug)
	disp(uh);
endif

