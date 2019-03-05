function fdm_twod(pvc, aprox, plot, nnos_x, nnos_y)

pvc_def.ordem  = nnos_x * nnos_y;
pvc_def.nnos_x = nnos_x;
pvc_def.nnos_y = nnos_y;
pvc_def.aprox  = aprox;

if (pvc == 1)
	printf("Problema de validacao selecionado.\n");
	fdm_twod_validacao(pvc_def);

elseif (pvc == 2)
	printf("Problema com conveccao dominante - Ordem %d - Selecionado.\n", aprox);
	initial_time = cputime();
	[vecx, vecy, vecz] = fdm_twod_conveccao_dominante(pvc_def);
	printf("Tempo de execucao: %f segundos\n", cputime() - initial_time);

elseif (pvc == 3)
	printf("Problema do resfriador bidimensional com condicao de contorno mista - Ordem %d - selecionado.\n", aprox);
	pvc_def.misto = 1;
	initial_time = cputime();
	[vecx, vecy, vecz] = fdm_twod_resfriador(pvc_def);
	printf("Tempo de execucao: %f segundos\n", cputime() - initial_time);
	
elseif (pvc == 4)
	printf("Problema do resfriador bidimensional com condicao de contorno de valor prescrito - Ordem %d - selecionado\n.", aprox);
	pvc_def.misto = 0;
	initial_time = cputime();
	[vecx, vecy, vecz] = fdm_twod_resfriador(pvc_def);
	printf("Tempo de execucao: %f segundos\n", cputime() - initial_time);

end

% ***********************************
% Plotagem da Solução
% ***********************************
if (plot && pvc != 1)
	tri = delaunay(vecx, vecy);
	trimesh(tri, vecx, vecy, vecz);
endif