function [betha] = fdm_twod_conveccao_dominante_coef_betha(no, meshing)
betha = [-meshing(no).y, meshing(no).x];