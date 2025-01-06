% Define array of our PRNGs
f = cell(6,1);
f{1} = @rand_mult;
f{2} = @rand_multiadd;
f{3} = @randu;
f{4} = @middle_square;
f{5} = @xorshift32;
f{6} = @xorshift128;

% Generate data
  N_klas = length(f);         % number of PRNGs
  N_wzorcow = 10;     % how many sequences per one PRNG
  N_przykladow = N_klas *N_wzorcow;  % how many sequences per all PRNGs
  N_cech  = 10;               % length of single sequence of randomly generated numbers
  seed = 6969;   % Seed for our PRNGs
  shuffle = 0;   % whether to shuffle the data randomly or not
  X = generateDataset(seed, N_wzorcow, N_cech, f, shuffle);

  % Split X into X - raw data; y - index of generator
  y = X(:,1);
  X(:,1) = [];
  X =  [ ones(N_przykladow, 1) X ]; 


% Calculate weights
  N_iter_fmin = 50;  % Minimization iterations
  lambda = 0.01;     % Minimization lambda parameter
  w_all = zeros( N_klas, 1 + N_cech);  % Initalize general model weights

  options = optimset('GradObj', 'on', 'MaxIter', 50 );   % fmincg() parameters
  for nr_klasy = 1 : N_klas
      y_klasy = (y == nr_klasy);      % ustaw 1 w wekt. y-klasa tylko dla wybranej klasy
      w_init = zeros(1 + N_cech, 1);  % initalize weights
      gradient_function = @(t) optim_callback( X, y_klasy, t, lambda );
      w = fmincg( gradient_function, w_init, options);
      w_all( nr_klasy, :) = w'; 
      %plot(y_klasy); title("Generator " + nr_klasy); pause
  end

% Apply pattern recognition
  hipotezy = sigmoid( X * w_all' );             % wartosci funkcji decyzyjnej: 5000x10
  [ wartosc, indeks ] = max( hipotezy, [], 2);  % indices of thresholded results
  fprintf('\nDokladnosc: %f\n', mean( double( indeks == y )) * 100);



function [cost, gradients] = optim_callback( X, y, w, lambda )
  N = length( y );                                         
  y_pred = sigmoid( X * w );                               
  cost = cost_function( X, y, y_pred, w, lambda, N );  
  gradients = gradient_step( X, y, y_pred, w, lambda, N );
end

function [cost] = cost_function( X, y, y_pred, w, lambda, N )
  regular = lambda/(2*N) * sum( w(2:end,1).^2 );                     
  cost = -(1/N) * (y'*log(y_pred) + (1-y)'*log(1-y_pred)) + regular; 
end

function [gradients] = gradient_step( X, y, y_pred, w, lambda, N )
  regular = (lambda/N) * w;                                   
  gradients    = (1/N) * (X'      * (y_pred - y)) + regular; 
  gradients(1) = (1/N) * (X(:,1)' * (y_pred - y));   
end  

function y = sigmoid( x )
  y = 1 ./ (1 + exp(-x));
end
