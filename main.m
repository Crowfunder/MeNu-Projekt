f = cell(2,1);
f{1} = @rand_mult;
f{2} = @rand_multiadd;
generateDataset(6969, 1000, 10000, f);