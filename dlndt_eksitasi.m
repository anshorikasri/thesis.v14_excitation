function dlndt = dlndt_eksitasi(t, lg10n)
    global T L1 R1 sigmvl sigmvr S

    % === Safety checks ===
    if any(isnan(lg10n))
        error('? NaN found in lg10n');
    end

    % === Reaction source terms ===
    S = sigmvl .* 10.^(L1 * lg10n) - sigmvr .* 10.^(R1 * lg10n);
    dndt = (R1 - L1)' * S;

    n = 10.^lg10n;
    dndtcorr = dndt - n * (T * dndt / (T * n + eps));  % +eps for safety

    % === Prevent overflow/underflow in division ===
    x = max(lg10n, -30);  % Clamp to avoid NaN/Inf

    dlndt = dndtcorr ./ (log(10) * 10.^x);

    if any(isnan(dlndt)) || any(isinf(dlndt))
        error('? NaN or Inf found in dlndt');
    end
end

