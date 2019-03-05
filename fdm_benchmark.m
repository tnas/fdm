function fdm_benchmark(pvc)
  
  config.aprox  = 1;  
  granularity = [ 
    3, 9; 
    9, 3;
    5, 5; 
    5, 15; 
    15, 5;
    9, 9; 
    9, 31;
    31, 9;
    17, 17;
    33, 33;
    65, 17;
    17, 65;
    33, 129;
    65, 65;
    129, 33 ];
  
  [nrows, ncols] = size(granularity);
  
  if (pvc == 3)  
      config.misto = 1;
  elseif (pvc == 4)
      config.misto = 0;
  endif
    
  for i = 1 : nrows
      
    config.ordem  = granularity(i, 1) * granularity(i, 2);
    config.nnos_x = granularity(i, 1);
    config.nnos_y = granularity(i, 2);

    #runtime = cputime();
    tic();
    fdm_twod_resfriador(config);
    elapsed_time = toc();    
    
    printf("Mesh %d x %d: %f secs\n", config.nnos_x, config.nnos_y, elapsed_time);
    
    nnodes(i)   = config.ordem;
    exectime(i) = elapsed_time;
    
  endfor
  
		h = plot(nnodes, exectime);
						
		hold on;
		grid on;
		grid minor;

		xl = xlabel('Number of nodes');
		set(xl, 'FontSize', 12);
		yl = ylabel('Execution Time');
		set(yl, 'FontSize', 12);
		
		hold off;
  