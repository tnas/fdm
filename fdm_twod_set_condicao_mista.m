function [A, F] = fdm_twod_set_condicao_mista(pvc_def, meshing, A, F, no, hx, hy)

aI.x = aI.y = cI.x = dI.x = eI.x = fI.y = no;
cI.y = aI.y + 1;
dI.y = aI.y - 3;
eI.y = aI.y + 3;

% Calculo dos coeficientes
coef = fdm_twod_calcula_coeficientes(pvc_def, meshing, no, hx, hy);

parcela_fluxo_direita  = hx / pvc_def.coefK;
parcela_fluxo_vertical = pvc_def.c * hy / pvc_def.coefK;

if (meshing(no).x == pvc_def.L && cI.y <= pvc_def.nnos_x)	
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Aplicar o fluxo para direita
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  % Atualizando aI
  A(aI.x, aI.y) = A(aI.x, aI.y) + (A(cI.x, cI.y) * (1 - parcela_fluxo_direita));

  % Atualizando vetor de termos independentes
  F(fI.y) = F(fI.y) - (A(cI.x, cI.y) *  parcela_fluxo_direita * pvc_def.u_ref);

  % Atualizando cI
  A(cI.x, cI.y) = 0;
  
elseif (meshing(no).y == 0 && dI.y >= 1)	
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Aplicar o fluxo para baixo
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
	% Atualizando aI
	A(aI.x, aI.y) = A(aI.x, aI.y) + (A(dI.x, dI.y) * (1 - parcela_fluxo_vertical));
  
  % Atualizando vetor de termos independentes
	F(fI.y) = F(fI.y) - (A(dI.x, dI.y) *  parcela_fluxo_vertical * pvc_def.u_ref);
  
	% Atualizando dI
	A(dI.x, dI.y) = 0;
				
elseif (meshing(no).y == pvc_def.W && eI.y <= pvc_def.nnos_x)	
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%      
  % Aplicar o fluxo para cima
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
	% Atualizando aI
	A(aI.x, aI.y) = A(aI.x, aI.y) + (A(eI.x, eI.y) * (1 - parcela_fluxo_vertical));
	
  % Atualizando vetor de termos independentes
	F(fI.y) = F(fI.y) - (A(eI.x, eI.y) *  parcela_fluxo_vertical * pvc_def.u_ref);
  
	% Atualizando eI
	A(eI.x, eI.y) = 0;
		
endif
