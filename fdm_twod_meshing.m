function [meshing] = fdm_twod_meshing(pvc_def, dominio, hx, hy)

no = 0;
for j = 1 : pvc_def.nnos_y
	for i = 1 : pvc_def.nnos_x
		no++;
		meshing(no).x = dominio.a + (i - 1) * hx;
		meshing(no).y = dominio.c + (j - 1) * hy;
		if (pvc_def.debug) 
			printf("no = %d, coordx = %d, coordy = %d\n", no, meshing(no).x, meshing(no).y);
		endif
	endfor
endfor