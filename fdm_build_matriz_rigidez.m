function [A] = fdm_build_matriz_rigidez(pvc_def, meshing, hx, hy)

% Matriz rigidez iniciada
A = zeros(pvc_def.ordem, pvc_def.ordem); 

% Calculando os coeficientes
for no = 1 : pvc_def.ordem
		vec_coef(no) = fdm_twod_calcula_coeficientes(pvc_def, meshing, no, hx, hy);
endfor

% Diagonal Principal (aI)
a_I = pvc_def.gama + ((2 * pvc_def.coefK) * (1/(hx^2) + 1/(hy^2)));
for i = 1 : pvc_def.ordem
	%A(i,i) = a_I;
	A(i,i) = vec_coef(i).aI;
endfor

% Diagonal Superior (cI)
for i = 1 : pvc_def.ordem-1
	%A(i,i+1) = (-pvc_def.coefK / (hx ^2)) + (pvc_def.betha(i, meshing)(1) / (2 * hx));
	A(i,i+1) = vec_coef(i).cI;
endfor

% Diagonal Inferior (bI)
for i = 2 : pvc_def.ordem
	%A(i,i-1) = (-pvc_def.coefK / (hx ^2)) - (pvc_def.betha(i, meshing)(1) / (2 * hx));
	A(i,i-1) = vec_coef(i).bI;
endfor

% Diagonal Superior Afastada (eI)
for i = 1 : pvc_def.ordem - pvc_def.nnos_x
	%A(i,i+pvc_def.nnos_x) = (-pvc_def.coefK / (hy ^2)) + (pvc_def.betha(i, meshing)(2) / (2 * hy));
	A(i,i+pvc_def.nnos_x) = vec_coef(i).eI;
endfor

% Diagonal Inferior Afastada (dI)
for i = pvc_def.nnos_x + 1 : pvc_def.ordem
	%A(i,i-pvc_def.nnos_x) = (-pvc_def.coefK / (hy ^2)) - (pvc_def.betha(i, meshing)(2) / (2 * hy));
	A(i,i-pvc_def.nnos_x) = vec_coef(i).dI;
endfor
