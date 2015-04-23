function [vecx, vecy, uh] = fdm_twod_conveccao_dominante(pvc_def)

% Caracteristicas do PVC
pvc_def.debug = 0;
pvc_def.coefK = 10^-3;
pvc_def.betha = @fdm_twod_conveccao_dominante_coef_betha;
pvc_def.gama = 0;

% Definicao do dominio (a, b) x (c, d)
dominio.a = -1.0; dominio.b = 1.0; dominio.c = -1.0; dominio.d = 1.0;
hx = (dominio.b - dominio.a) / (pvc_def.nnos_x - 1);
hy = (dominio.d - dominio.c) / (pvc_def.nnos_y - 1);

% Definicao da Malha
meshing = fdm_twod_meshing(pvc_def, dominio, hx, hy);

% Sistema Linear Associado
A = fdm_build_matriz_rigidez(pvc_def, meshing, hx, hy); 
F = zeros(pvc_def.ordem, 1);

% Aplicando as condições de contorno de valor prescrito
for no = 1 : pvc_def.ordem

	if (meshing(no).x == dominio.a || meshing(no).x == dominio.b ||
		meshing(no).y == dominio.c || meshing(no).y == dominio.d) 
		
		for j = 1 : pvc_def.ordem
			A(no, j) = 0;
		endfor
		A(no, no) = 1;
		F(no) = 0;
		
	elseif (meshing(no).x == 0 && meshing(no).y >= -1 && meshing(no).y <= 0) % Segmento OA

		for j = 1 : pvc_def.ordem
			A(no, j) = 0;
		endfor
		A(no, no) = 1;
		F(no) = -sin(2*pi*meshing(no).y);
	endif

endfor

% Resolvendo o PVC
uh = A\F;

% Obtendo as coordenadas (x, y, z)
vecx = vecy = zeros(pvc_def.ordem, 1);
for no = 1 : pvc_def.ordem
	vecx(no) = meshing(no).x;
	vecy(no) = meshing(no).y;
endfor


