function prbs_sequence = generate_prbs(initial_state, num_bits)
    %
    % Generate a Pseudo-Random Binary Sequence (PRBS) using the shift register shown in the diagram.
    %
    % Args:
    %    initial_state (vector): A vector of integers (0 or 1) representing the initial state of the 9-bit shift register.
    %    num_bits (int): The number of PRBS bits to generate.
    %
    % Returns:
    %    vector: The generated PRBS sequence.
    %

    if length(initial_state) ~= 9
        error('Initial state must be a vector of 9 bits (0 or 1).');
    end

    shift_register = initial_state;
    prbs_sequence = zeros(1, num_bits);

    for i = 1:num_bits
        % XOR the feedback bits (b5 and b9 in the diagram, which are index 5 and 9)
        feedback = xor(shift_register(5), shift_register(9));

        % Append the output bit (b9) to the PRBS sequence
        prbs_sequence(i) = shift_register(9);

        % Shift the register and insert the feedback bit at the beginning
        shift_register = [feedback, shift_register(1:end-1)];
    end
end

% Example usage
initial_state = [1, 1, 1, 1, 1, 1, 1, 1, 1]; % Example initial state (9 bits)
num_bits = 20; % Number of PRBS bits to generate
prbs = generate_prbs(initial_state, num_bits);
disp('Generated PRBS:');
disp(prbs);
