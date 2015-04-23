function [A, F] = fdm_twod_set_condicao_mista(pvc_def, meshing, A, F, no, hx, hy)

% Calculo dos coeficientes
coef = fdm_twod_calcula_coeficientes(pvc_def, meshing, no, hx, hy);

% Aplicar o fluxo para direita
parcela_fluxo_direita = pvc_def.c * hx / pvc_def.coefK;
	
% Atualizando aI
A(no, no) = A(no, no) + (coef.cI * (1 - parcela_fluxo_direita));

% Atualizando cI
if (no + 1 <= pvc_def.ordem)
	A(no, no + 1) = 0;
endif
	
% Atualizando vetor de termos independentes
F(no) = F(no) - (coef.cI *  parcela_fluxo_direita * pvc_def.u_ref);

parcela_fluxo_vertical = pvc_def.c * hy / pvc_def.coefK;

if (meshing(no).y == 0)	% Aplicar o fluxo para baixo
		
	% Atualizando aI
	A(no, no) = A(no, no) + (coef.dI * (1 - parcela_fluxo_vertical));
		
	% Atualizando dI
	if (no - pvc_def.nnos_x > 0)
		A(no, no - pvc_def.nnos_x) = 0;
	endif
		
	% Atualizando vetor de termos independentes
	F(no) = F(no) - (coef.dI *  parcela_fluxo_vertical * pvc_def.u_ref);
		
elseif (meshing(no).y == pvc_def.W)	% Aplicar o fluxo para cima
	% Atualizando aI
	A(no, no) = A(no, no) + (coef.eI * (1 - parcela_fluxo_vertical));
		
	% Atualizando eI
	if (no + pvc_def.nnos_x <= pvc_def.ordem)
		A(no, no + pvc_def.nnos_x) = 0;
	endif
		
	% Atualizando vetor de termos independentes
	F(no) = F(no) - (coef.eI *  parcela_fluxo_vertical * pvc_def.u_ref);	
	
endif