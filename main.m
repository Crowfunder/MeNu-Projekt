% Define array of our PRNGs
f = cell(4,1);
f{1} = @rand_mult;
f{2} = @rand_multiadd;
f{3} = @randu;
f{4} = @middle_square;


% Generate data
  N_klas = length(f);         % number of PRNGs
  N_wzorcow = 10;     % how many sequences per one PRNG
  N_przykladow = N_klas *N_wzorcow;  % how many sequences per all PRNGs
  N_cech  = 10;               % length of single sequence of randomly generated numbers
  seed = 6969;   % Seed for our PRNGs
  X = generateDataset(seed, N_wzorcow, N_cech, f);

  % Split X into X - raw data; y - index of generator
  y = X(:,1);
  X(:,1) = [];

  X =  [ ones(N_przykladow, 1) X ];   % dodanie 1 dla w0

% Znalezienie optymalnych wartosci wag "w" na podstawie zbioru uczacego dla kazdej klasy
  N_iter_fmin = 50;                   % liczba iteracji proceduru minimalizacyjnej
  lambda = 0.01;                      % wspolczynnk regularyzacji podczas minimalizacji 
  w_all = zeros( N_klas, 1 + N_cech); % w0, w1, w2, ..., wP - poczatkowe wagi liczb

  options = optimset('GradObj', 'on', 'MaxIter', 50 );   % dla funkcji fmincg()
  for nr_klasy = 1 : N_klas           % powtorz dla kazdej klasy, cyfra 0 to klasa 10 
      y_klasy = (y == nr_klasy);      % ustaw 1 w wekt. y-klasa tylko dla wybranej klasy
      w_init = zeros(1 + N_cech, 1);  % inicjalizacja wag
      gradient_function = @(t) optim_callback( X, y_klasy, t, lambda );
      w = fmincg( gradient_function, w_init, options);
      w_all( nr_klasy, :) = w'; 
      plot(y_klasy); title('Sprawdzona klasa'); disp('Nacisnij cokolwiek ...'); pause
  end

% Rozpoznawanie cyfr ze zbioru uczacego  
  hipotezy = sigmoid( X * w_all' );             % wartosci funkcji decyzyjnej: 5000x10
  [ wartosc, indeks ] = max( hipotezy, [], 2);  % indeksy maksimow dla kazdego przykladu
  fprintf('\nDokladnosc: %f\n', mean( double( indeks == y )) * 100);

% #########################################################################
% #########################################################################
% #########################################################################
function [cost, gradients] = optim_callback( X, y, w, lambda )
  N = length( y );                                         % liczba przykladow
  y_pred = sigmoid( X * w );                               % predykcja/prognoza/hipoteza y
  cost = cost_function( X, y, y_pred, w, lambda, N );      % obliczenie funkcji kosztu
  gradients = gradient_step( X, y, y_pred, w, lambda, N ); % obliczenie gradientow dla "w"
end
% #########################################################################
function [cost] = cost_function( X, y, y_pred, w, lambda, N )
  regular = lambda/(2*N) * sum( w(2:end,1).^2 );                     % parametr regularyzacji
  cost = -(1/N) * (y'*log(y_pred) + (1-y)'*log(1-y_pred)) + regular; % funkcja kosztu/bledu
end
% #########################################################################
function [gradients] = gradient_step( X, y, y_pred, w, lambda, N )
  regular = (lambda/N) * w;                                   % parametr regularyzacji 
  gradients    = (1/N) * (X'      * (y_pred - y)) + regular;  % regularyzacja dla wszystkich w  
  gradients(1) = (1/N) * (X(:,1)' * (y_pred - y));            % oprocz w0
end  
% #########################################################################
function y = sigmoid( x )
  y = 1 ./ (1 + exp(-x));
end
