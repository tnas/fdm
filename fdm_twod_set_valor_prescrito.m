function [A, F] = fdm_twod_set_valor_prescrito(pvc_def, A, F, no, valor)

for j = 1 : pvc_def.ordem
	A(no, j) = 0;
endfor

A(no, no) = 1;
F(no) = valor;
