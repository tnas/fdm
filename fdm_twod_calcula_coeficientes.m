function [coef] = fdm_twod_calcula_coeficientes(pvc_def, meshing, no, hx, hy)

if (pvc_def.aprox == 1) % Aproximacao de primeira ordem
	coef.aI = pvc_def.gama + ((2 * pvc_def.coefK) * (1/(hx^2) + 1/(hy^2))) - (pvc_def.betha(no, meshing)(1) / hx) - (pvc_def.betha(no, meshing)(2) / hy);
	coef.cI = (-pvc_def.coefK / (hx ^2)) + (pvc_def.betha(no, meshing)(1) / hx);
	coef.bI = -pvc_def.coefK / (hx ^2);
	coef.eI = (-pvc_def.coefK / (hy ^2)) + (pvc_def.betha(no, meshing)(2) / hy);
	coef.dI = -pvc_def.coefK / (hy ^2);
	
elseif (pvc_def.aprox == 2) % Aproximacao de segunda ordem
	coef.aI = pvc_def.gama + ((2 * pvc_def.coefK) * (1/(hx^2) + 1/(hy^2)));
	coef.cI = (-pvc_def.coefK / (hx ^2)) + (pvc_def.betha(no, meshing)(1) / (2 * hx));
	coef.bI = (-pvc_def.coefK / (hx ^2)) - (pvc_def.betha(no, meshing)(1) / (2 * hx));
	coef.eI = (-pvc_def.coefK / (hy ^2)) + (pvc_def.betha(no, meshing)(2) / (2 * hy));
	coef.dI = (-pvc_def.coefK / (hy ^2)) - (pvc_def.betha(no, meshing)(2) / (2 * hy));
endif

