function [] = plotty(t1,s1)
    figure(1)
    set(gcf, 'Position',  [50, 525, 450, 400])
    sgtitle("Quadrotor Position Analysis")
    % X vs. Time Graph
    subplot(3,1,1)
    plot(t1,s1(:,1))
    grid on
    hold on
    title("X vs Time")
    ylabel("x (m)")
    xlabel("Time (seconds)")
    % Y vs. Time Graph
    subplot(3,1,2)
    plot(t1,s1(:,2))
    grid on
    hold on
    title("Y vs Time")
    ylabel("y (m)")
    xlabel("Time (seconds)")
    % Z vs. Time Graph
    subplot(3,1,3)
    plot(t1,s1(:,3))
    grid on
    hold on
    title("Z vs Time")
    ylabel("z (m)")
    xlabel("Time (seconds)")
    %ylim([-1, 1]);

    % roll vs. Time Graph
    figure(2)
    set(gcf, 'Position',  [500, 525, 450, 400])
    sgtitle("Quadrotor Angular Position Analysis")
    subplot(3,1,1)
    plot(t1,s1(:,4))
    grid on
    hold on
    title("Roll vs Time")
    ylabel("phi ")
    xlabel("Time (seconds)")
    % pitch vs. Time Graph
    subplot(3,1,2)
    plot(t1,s1(:,5))
    grid on
    hold on
    title("pitch vs Time")
    ylabel("theta ")
    xlabel("Time (seconds)")
    % yaw vs. Time Graph
    subplot(3,1,3)
    plot(t1,s1(:,6))
    grid on
    hold on
    title("yaw vs Time")
    ylabel("psi ")
    xlabel("Time (seconds)")


    figure(3)
    set(gcf, 'Position',  [950, 525, 450, 400])
    sgtitle("Quadrotor Velocity (Body Frame) Analysis")
    % X vs. Time Graph
    subplot(3,1,1)
    plot(t1,s1(:,7))
    grid on
    hold on
    title("u velocity vs Time")
    ylabel("u (m/s)")
    xlabel("Time (seconds)")
    
    % Y vs. Time Graph
    subplot(3,1,2)
    plot(t1,s1(:,8))
    grid on
    hold on
    title("v velocity vs Time")
    ylabel("v (m/s)")
    xlabel("Time (seconds)")
    ylim([4 6]);
  
    % Z vs. Time Graph
    subplot(3,1,3)
    plot(t1,s1(:,9))
    grid on
    hold on
    title("w velocity vs Time")
    ylabel("w (m/s)")
    xlabel("Time (seconds)")
    

    figure(4)
    set(gcf, 'Position',  [1400, 525, 450, 400])
    sgtitle("Quadrotor Angular rates Analysis")
    % p vs. Time Graph
    subplot(3,1,1)
    plot(t1,s1(:,10))
    grid on
    hold on
    title("p vs Time")
    ylabel("p (m)")
    xlabel("Time (seconds)")
    % q vs. Time Graph
    subplot(3,1,2)
    plot(t1,s1(:,11))
    grid on
    hold on
    title("q vs Time")
    ylabel("q (m)")
    xlabel("Time (seconds)")
    % r vs. Time Graph
    subplot(3,1,3)
    plot(t1,s1(:,12))
    grid on
    hold on
    title("r vs Time")
    ylabel("r (m)")
    xlabel("Time (seconds)")

    % 3D vs. time Graph
    figure(5)
    set(gcf, 'Position',  [750, 40, 450, 400])
    grid on
    hold on
    title("3D Visualization")
    xlabel("X (m)")
    ylabel("Y (m)")
    zlabel("Z (m)")
    plot3(s1(:,1),s1(:,2),s1(:,3))
    set(gca,'ZDir','reverse');
    hold on
    plot3(s1(1,1),s1(1,2),s1(1,3),'*r')
    hold off
    view([30 30 -30])
    zlim([-5 5])
    
fh = findall(0,'Type','Figure');
txt_obj = findall(fh,'Type','text');
set(txt_obj,'FontName','Calibri','FontSize',13);

end