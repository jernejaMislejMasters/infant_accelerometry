function  new_signal = baseline_extraction(signal, weight)
% Estimate baseline with asymmetric least squares

    signal_length = length(signal);

    D = diff(speye(signal_length), 2);

    W = spdiags(ones(signal_length, 1), 0, signal_length, signal_length);
    C = chol(W + weight * D' * D);
    new_signal = C \ (C' \ signal);
