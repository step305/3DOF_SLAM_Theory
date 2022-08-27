function run_me()
    close all; clear; clc;

    % cd /Users/sergeyzotov/Projects/2022/11_My_Study_SLAM/04_3DOF_My_SLAM_MATLAB

    %% Global initialization - Done
    time = 1000;
    dt = 1e-2;
    N_sim = time/dt;
    N_features = 1000;
    map_size = 100;
    n_random_points_for_camera = 100000;
    %% Trajectory Simulator - Done

    % AHRS-motion model cone trajectory
    % Output:
    %   thee ideal Euler angles for camera simulation
    %   three gyros outputs dtheta with ARW, RRW, bias

    % Input:
    %    dt - time step
    %    time - simulation time

    [Euler, dthe] = trajectory_simulator(time, dt);

    % plot(Euler'); grid on;

    %% Feature (World) Simulator - Done

    % Simulation for future in space around AHRS. All futures are stable.
    % Output:
    %   feature array

    % Input:
    %    futures number, N

    [ideal_world] = feature_simulator(N_features);

    %% Animation Inicialization - almost Done

    % Output:
     % animation - frame

    % Input:
    %   ideal_world (our simulated world)

    animation = Animation(ideal_world);

    %% THIS BLOCK IS SLAM

    %% SLAM initialization

    % Output:
    %   initial quaternion
    %   initial state vector for Kalman
    %   initial covariance matrix, P
    %   initial map (zero-size map), we need a map stracture only

    % Input:
    %   map_size

    [q, gyr_errors, P, map] = SLAM_init(map_size);

    %% Camera initialization
    % Output:
    %   camera.resolution
    %   camera.angles
    %   camera.white_noise

    % Input:
    %   -

    cam = Camera(n_random_points_for_camera);

    %% Memory reservation for history

    global q_hist;
    global bias_hist;
    global P_hist;
    global Euler_hist;
    global Euler_est_hist;
    q_hist = zeros(4, N_sim);
    bias_hist = zeros(3, N_sim);
    P_hist = zeros(6, 6, N_sim);
    Euler_est_hist = zeros(3, N_sim);
    Euler_hist = zeros(3, N_sim);
    q_hist(:,:) = NaN;
    bias_hist(:,:) = NaN;
    P_hist(:,:) = NaN;
    Euler_est_hist(:,:) = NaN;
    Euler_hist(:,:) = NaN;

    %% Main Cycle
    q_ref = Quat();

    % performance profiling turn om
    profile off;
    profile on;
    cleanupObj = onCleanup(@UserBreakEvent);

    for i=1:N_sim
        dthe_current = dthe(:, i); % - current data from gyroscope
        % camera measurement 2D coordinates + ID;
        % check feature visibility


        q_ref = q_ref.from_angle(Euler(:,i));
        Cnb = q_ref.to_dcm();
        Cbn = Cnb';
        N_meas = 0;
        % check feature visibility
        for j=1:length(ideal_world)
            ideal_world(j).vector_body = Cnb*ideal_world(j).vector;
            ideal_world(j).visible = cam.visible(ideal_world(j).vector_body);
            N_meas = N_meas + ideal_world(j).visible;
        end

        measured_features.coord = zeros(N_meas, 2);
        measured_features.id = zeros(N_meas, 1);
        k = 1;
        for j=1:length(ideal_world)
            if ideal_world(j).visible
                [u, v] = cam.to_frame(ideal_world(j).vector_body);
                measured_features.coord(k, :) = [u,v];
                measured_features.id(k) = ideal_world(j).id;
                k=k+1;
            end
        end

        % main SLAM function
        [q, gyr_errors, P, map] = ...
            slam(q, gyr_errors, dthe_current, measured_features, P, map, cam, dt);

        q_hist(:,i) = q.value;
        bias_hist(:, i) = gyr_errors(1:3);
        P_hist(:, :, i) = P(1:6, 1:6);
        Euler_hist(:, i) = Euler(:, i);
        Euler_est_hist(:, i) = q.to_angle();

        % call update plot to animation update
        % q to Cnb_est
        % Euler to Cnb
        Cnb_est = q.to_dcm();
        Cbn_est = Cnb_est';
        if mod(i, 10) == 0
            animation.Update(ideal_world, Cbn, Cbn_est, (i-1)*dt);
        end
    end

    UserBreakEvent(true);
end


function UserBreakEvent(usual_end)
    profile viewer;
    profile off;
    if ~exist('usual_end')
        disp('User stop requested!');
    end
    global q_hist;
    global bias_hist;
    global P_hist;
    global Euler_hist;
    global Euler_est_hist;
    figure;
    plot(Euler_hist', '-');
    hold on;
    plot(Euler_est_hist','--');
    save('log.mat', 'q_hist', 'bias_hist', 'P_hist', 'Euler_hist', 'Euler_est_hist');
end