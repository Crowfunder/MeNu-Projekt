%%%%%%%%%%%%%%%%%%%%%
% USAGE
%%%%%%%%%%%%%%%%%%%%%
% f = cell(2,1);
% f{1} = @rand_mult;
% f{2} = @rand_multiadd;
% generateDataset(6969, 5, 10, f)


function dataset = generateDataset(seed, N_of_sequences, nums_per_sequence, generators)
    % seed - randgen seed
    % N_of_sequences - number of sequences per generator
    % numbers per sequence - datapoints per sequence

    n_of_generators = length(generators);

    dataset = zeros(N_of_sequences*n_of_generators, nums_per_sequence+1);
    iter_offset = 0;

    % Iterate over generators
    for n=1:n_of_generators

        % Generate selected N_of_sequences
        % Has to be generated as a single sequence and split into parts
        generated_sequences = generators{n}(nums_per_sequence*N_of_sequences, seed);
        generated_sequences = reshape(generated_sequences,nums_per_sequence,[]);

        for seq=1+iter_offset:N_of_sequences+iter_offset
            dataset(seq,2:nums_per_sequence+1) = generated_sequences(:,seq-iter_offset);
            dataset(seq,1) = n;   % First column are indexes of generators
        end
        iter_offset = iter_offset + N_of_sequences;
    end


end