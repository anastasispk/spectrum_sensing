function H = channel(d,a,type,txPower)

% Calculate the channel matrix (path-loss + fading)
%
% H = channel(M,N,d,a)
%
% M: Number of PUs
% N: Number of SUs
% d: Euclidean distance between each PU-SU pair
% a: Path-loss exponent

d0 = 1;
H = 1;

if (nargin > 4 && strcmp(type,'ray'))
    % H = sqrt(randn(M,N).^2 + randn(M,N).^2); % Rayleigh fading
    % H = sqrt(raylrnd(0.8*txPower));
    H = 0.75;
else
    H = 1;
end

% PL = -20*log10(lambda/(4*pi*d0)) + 10*a*log10(d/d0);
% PL = PL - 30;
% H = H * 10^(-PL/10); % Fading + path-loss (amplitude loss)

% H = H * sqrt(d^(-a));

end
