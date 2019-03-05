function [vecx, vecy, uh] = fdm_twod_resfriador(pvc_def)

% Parametros fisicos
pvc_def.c = 1;
pvc_def.T = 2;
pvc_def.L = 1;
pvc_def.W = 1;
pvc_def.u_ref = 70;

% Caracteristicas do PVC
pvc_def.debug = 0;
pvc_def.coefK = 1;
pvc_def.betha = @fdm_twod_validacao_coef_betha;
pvc_def.gama = 2*pvc_def.c/pvc_def.T;

% Definicao do dominio (a, b) x (c, d)
dominio.a = 0.0; dominio.b = pvc_def.L; dominio.c = 0.0; dominio.d = pvc_def.W;
hx = (dominio.b - dominio.a) / (pvc_def.nnos_x - 1);
hy = (dominio.d - dominio.c) / (pvc_def.nnos_y - 1);

% Definicao da Malha
meshing = fdm_twod_meshing(pvc_def, dominio, hx, hy);

% Sistema Linear Associado
A = fdm_build_matriz_rigidez(pvc_def, meshing, hx, hy); 
F = zeros(pvc_def.ordem, 1);
for i = 1 : pvc_def.ordem
	F(i) = pvc_def.gama * pvc_def.u_ref;
endfor


% Aplicando as condições de contorno de valor prescrito
valor_prescrito = 0;
for no = 1 : pvc_def.ordem

	if (meshing(no).y == 0 || meshing(no).y == pvc_def.W) 
		valor_prescrito = 70;
		[A, F] = fdm_twod_set_valor_prescrito(pvc_def, A, F, no, valor_prescrito);
		
	elseif (meshing(no).x == 0)
		valor_prescrito = 200;
		[A, F] = fdm_twod_set_valor_prescrito(pvc_def, A, F, no, valor_prescrito);
	endif

endfor

if (pvc_def.misto) 
	% Condição de contorno mista adicional
	for no = 1 : pvc_def.ordem
		if (meshing(no).x == pvc_def.L)
			[A, F] = fdm_twod_set_condicao_mista(pvc_def, meshing, A, F, no, hx, hy);
		endif
	endfor
else
	% Condição de Valor prescrito adicional
	valor_prescrito = 70;
	for no = 1 : pvc_def.ordem
		if (meshing(no).x == pvc_def.L)
			[A, F] = fdm_twod_set_valor_prescrito(pvc_def, A, F, no, valor_prescrito);
		endif
	endfor
endif

if (pvc_def.debug)
  printf("hx = %d, hy = %d\n",  hx, hy);
  for i = 1 : pvc_def.nnos_x
    for j = 1 : pvc_def.nnos_y
        printf("%d ", A(i,j));
    endfor
    printf("\n");
  endfor
endif

% Resolvendo o PVC
uh = A\F;

% Obtendo as coordenadas (x, y, z)
vecx = vecy = zeros(pvc_def.ordem, 1);
for no = 1 : pvc_def.ordem
	vecx(no) = meshing(no).x;
	vecy(no) = meshing(no).y;
endfor


