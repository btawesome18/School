% Title stsmain.m
% Authors: Sean Svihla, Devon Paris, Garrett Lycett, Daniel Smith, Luca
%          Herlein, Brian Trybus
% Date Created: 17 March 2021
% Date Modified: 28 March 2021

%% Housekeeping

close all
clear
clc

%% Load Files

stsfiles = dir('stsdata');

%% Declare Variables

g = 9.81;

sampleRate = 1652; %[Hz]

samples = repmat(struct('data', [], 'tspan', [], 'bounds', []), ...
    length(stsfiles)-2, 1);

% calcs = [Isp, maxThrust, timeOfThrust]
calcs = zeros(length(stsfiles)-2, 3);

%% Specific Impulse Computations

for i = 3:length(stsfiles)    
    % Load data
    csv = strcat(stsfiles(i).folder, '\', stsfiles(i).name);
    data = convforce(load(csv), 'lbf', 'N');
    
    % Get timespan
    tspan = ((1:length(data(:, 3)))./sampleRate)';
    
    % Get maximum thrust
    [maxThrust, maxIdx] = max(data(:, 3));
    
    % Get bounds of integration
    fileName = strcat('bounds/dataset', num2str(i-2), '.txt');
    if isfile(fileName)
    % Bounds have been saved---read bounds
        bounds = load(fileName);
    else
    % Bounds have not been saved---compute and write bounds
        tic
        
        % Display current item
        disp(strcat('Currently working on data-set #', num2str(i-2), '/', ...
            num2str(length(stsfiles)-2)))
    
        % Primary bounds---change in variance
        % Note: MaxNumChanges = 5 for #6, 17
        %                     = 4 for #10, 13, 16
        %                     = 3 otherwise
        chngIdx = find(ischange(data(:, 3), 'variance', ... 
            'MaxNumChanges', 3)); 
        
        if chngIdx(2) > maxIdx
            endBound = chngIdx(2);
        else
            endBound = chngIdx(3);
        end

        % Secondary bounds---remove negatives
        if any(data(chngIdx(1):maxIdx, 3) < 0)
            negIdx = find(data(chngIdx(1):maxIdx, 3) < 0) + chngIdx(1);
            beginBound = negIdx(end);
        else
            beginBound = chngIdx(1);
        end

        % Write bounds
        bounds = [beginBound, endBound];
        writematrix(bounds, fileName)
        
        toc
    end
        
    % Get timeOfThrust
    timeOfThrust = tspan(bounds(2)) - tspan(bounds(1));
    
    % Compute Isp---mass of water is 1 kg
    I = trapz(tspan(bounds(1):bounds(2)), data(bounds(1):bounds(2), 3)) ...
        - (1/2)*timeOfThrust*(data(bounds(2), 3) - data(bounds(1), 3));
    Isp = I/g;
    
    % Assign to samples
    samples(i-2) = struct(...
        'data', data(:, 3), ...
        'tspan', tspan, ...
        'bounds', bounds ...
        );
    
    % Assign to calcs
    calcs(i-2, :) = [Isp, maxThrust, timeOfThrust];
end

%% Statistical Computations

% Calculate SEM for Specific Impulse
SEM = std(calcs(:, 1))./(1:length(calcs));

% Output confidence intervals
disp('Confidence Intervals: ')
disp(['95% --- ', num2str(mean(calcs(:, 1))), ' +/- ', ...
    num2str(1.96 * SEM(end)), ' [s]'])
disp(['97.5% --- ', num2str(mean(calcs(:, 1))), ' +/- ', ...
    num2str(2.24 * SEM(end)), ' [s]'])
disp(['99% --- ', num2str(mean(calcs(:, 1))), ' +/- ', ...
    num2str(2.58 * SEM(end)), ' [s]'])

%% Figure 1---Thrust Curves with Bounds

figure('WindowState', 'maximized');

tiledlayout(floor(sqrt(length(stsfiles)-2)), ceil(sqrt(length(stsfiles)-2)))
for i = 1:length(stsfiles)-2
    % Get axis
    ax = nexttile;
    
    % Get thrust curve
    data = samples(i).data;
    
    % Get timespan
    tspan = samples(i).tspan;
    
    % Get bounds of integration
    bounds = samples(i).bounds;
    
    % Plotting
    plot(ax, tspan((bounds(1) - 250):(bounds(2) + 250)), ...
        data((bounds(1) - 250):(bounds(2) + 250)), 'b-', 'LineWidth', 0.5)
    xline(ax, tspan(bounds(1)), 'r-', 'LineWidth', 2)
    xline(ax, tspan(bounds(2)), 'r-', 'LineWidth', 2)
    yline(ax, 0, 'k--')
    
    % Annotations
    subtitle(ax, strcat(stsfiles(i+2).name, ' (', num2str(i), ')'))
    ylabel(ax, 'Thrust [N]')
    xlabel(ax, 'Time [s]')
    grid(ax, 'on')
end

%% Figure 2---Histogram of Specific Impulse

figure

% Plotting
histfit(calcs(:, 1))

% Annotations
title('Specific Impulse')
ylabel('Count')
xlabel('I_s_p [s]')
grid on

%% Figure 3---Histogram of Max Thrust

figure

% Plotting
histfit(calcs(:, 2))

% Annotations
title('Max Thrust')
ylabel('Count')
xlabel('Thrust [N]')
grid on

%% Figure 4---Histogram of Time of Thrust

figure

% Plotting
histfit(calcs(:, 3))

% Annotations
title('Time of Thrust')
ylabel('Count')
xlabel('Time [s]')
grid on

%% Figure 5---SEM of Impulse

figure

% Plotting
plot(1:length(SEM), SEM, 'k-')
yline(SEM(end), 'k--', {'SEM', num2str(SEM(end))})

% Annotations
title('Standard Error of Mean vs. Number of Data-Sets')
subtitle('Specific Impulse')
ylabel('Standard Error of Mean SEM')
xlabel('Number of Data-Sets N')
grid on

%% Figure 6---Sample Thrust Curve 

figure

% Get thrust curve
data = samples(3).data;

% Get timespan
tspan = samples(3).tspan;

% Get bounds
bounds = samples(3).bounds;

% Plotting
plot(tspan((bounds(1) - 100) : (bounds(2) + 50)), ...
    movmean(data((bounds(1) - 100) : bounds(2) + 50), 10), 'b-')
xline(tspan(bounds(1)), 'r-', 'LineWidth', 2)
xline(tspan(bounds(2)), 'r-', {'Bounds of', 'Integration'}, 'LineWidth', 2)
yline(0, 'k--')

% Annotations
title('Sample Thrust Curve')
ylabel('Thrust [N]')
xlabel('Time [s]')
grid on
grid minor
