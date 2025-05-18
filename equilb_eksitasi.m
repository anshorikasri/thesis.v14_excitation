%uploaded at (mai 18th, 2025)
clear all
clc

global T L1 R1 sigmvl sigmvr S ratell raterr

% === Load Constants ===
phycon
X = e / kappa;

% === Load Plasma Data ===
nthdata_eksitasi

[k, l] = size(react);
s = l - 3;
p = 1:2:k-1;
q = 2:2:k;

L1 = react(p, 1:s);
R1 = react(q, 1:s);

for i = 1:k
    [~, b] = sort(react(i, 1:s));
    Treact(i) = X * (react(i, 1) > 0) + X * T(b(s)) * (react(i, 1) == 0);
end

sigmvl = react(p, l-2) .* (Treact(p)' / 300).^react(p, l-1) .* exp(-react(p, l) ./ Treact(p)');
sigmvr = react(q, l-2) .* (Treact(q)' / 300).^react(q, l-1) .* exp(-react(q, l) ./ Treact(q)');

% === Safer Initial Conditions ===
%        e,       Ar,   Ar^+,   Ar(^3P_2),   Ar(^3P_1), Ar(^3P_0), Ar(^1P_1)
n0 = [1e15, 1e12, 10e14,       1.5e14,          1e13,         1e14,         1e13];


n0= n0'  ;
lg10n0 = log10(n0);

% === Time span ===
tspan = linspace(1e-5, 1e-3, 1000);
eps = 1;
tol = 5e-4;

% === Storage for evolution ===
err = zeros(0, 7);

while eps > tol
    [t, lg10n] = ode45(@dlndt_eksitasi, tspan, lg10n0);
    u = abs(lg10n0 - lg10n(end, :)');
    eps = norm(u, inf);
    lg10n0 = lg10n(end, :)';
    err(end+1, :) = lg10n0';
    fprintf( 'proses %.6f menuju 0.0005%s', eps, char(10));
end

% Define colors manually (MATLAB default 'lines(7)' equivalent)
colors = ...
  [ 0.9290    0.6940    0.1250; % yellow 
  0    0.4470    0.7410;  % Blue
  0.6350    0.0780    0.1840; %red
  0.4660    0.6740    0.1880; %green
  0            1            1;        %cyan
  0.75        0.75        0.75;  % Light gray
  1            0             1      ];  %magenta

% Plot each species explicitly
figure; hold on;

% 1. Electrons (e): Blue dashed line + diamond markers every 100 steps
plot(   err(:, 1), '-', 'Color', colors(1,:),  'LineWidth', 2   );

% 2. Argon (Ar): Red dashed line
plot(err(:, 2), '-', 'Color', colors(2,:), 'LineWidth', 2);

% 3. Ar+ (Ar^+): Yellow solid line
plot(err(:, 3), '--', 'Color', colors(3,:), 'LineWidth', 2);

% 4. Ar(3P2): Purple solid line
plot(err(:, 4), '-', 'Color', colors(4,:), 'LineWidth', 2);

% 5. Ar(3P1): Green solid line
plot(err(:, 5), '-', 'Color', colors(5,:), 'LineWidth', 2);

% 6. Ar(3P0): Red solid line
plot(err(:, 6), '-', 'Color', colors(6,:), 'LineWidth', 2);

% 7. Ar(1P1): Light blue solid line
plot(err(:, 7), '-', 'Color', colors(7,:), 'LineWidth', 2);

hold off;

% Add legend and labels
legend({'e', 'Ar', 'Ar^+', 'Ar(^3P_2)', 'Ar(^3P_1)', 'Ar(^3P_0)', 'Ar(^1P_1)'}, 'Interpreter', 'tex');
xlabel('Iteration');
ylabel('log_{n} (m^{ -3})');
title('Densitas Selama Reaksi');
grid on;
box on;

%{
colors = lines(7);
species = {'e', 'Ar', 'Ar^+', 'Ar(^3P_2)', 'Ar(^3P_1)', 'Ar(^3P_0)', 'Ar(^1P_1)'};

figure;
hold on;
for i = 1:7
    if i==1
        % Full dashed line with no markers
        plot(err(:, i), 'LineStyle', '--', 'Color', 'b', 'LineWidth', 2); hold on;
        
        % Diamond markers every 50 steps
        idx = 1:100:length(err(:, i));
        plot(idx, err(idx, i), 'bd', 'MarkerSize', 8, 'MarkerFaceColor', 'b', 'LineStyle', 'none');
    elseif  i==2
        % Full dashed line with no markers
        plot(err(:, i), 'LineStyle', '--', 'Color', 'r', 'LineWidth', 2); hold on;
    else
        plot(err(:, i), 'Color', colors(i, :), 'LineWidth', 2);
    end
end
%}
    

