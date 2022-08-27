classdef Animation
    
    properties
    figure
    cube % plot
    target_axes % plot
    AHRS_axes % plot
    feature_plots % plot
    gray_lines %plot
    sim_text %plot
    cube_vert % coordinates
    target_axes_vect % coordinates
    AHRS_axes_vect % coordinates
    end
    
    methods
        function this = Animation(world)
            this.figure = figure;
            hold on;
            axis equal;
            view(3);
            
            Vert = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
            Vert(:,1) = (Vert(:,1)-0.5);
            Vert(:,2) = (Vert(:,2)-0.5);
            Vert(:,3) = (Vert(:,3)-0.5);
            Vert = Vert * 5;
            this.cube_vert  = Vert;
            
            Faces = [1 2 6 5; 2 3 7 6; 3 4 8 7; 4 1 5 8; 1 2 3 4; 5 6 7 8];
            ptch.Vertices = Vert;
            ptch.Faces = Faces;
            ptch.FaceVertexCData = copper(6);
            ptch.FaceColor = 'flat';
            this.cube = patch(ptch);
            
            Z = [0; 0; 10;];
            Y = [0; 10; 0;];
            X = [25; 0; 0;];
            this.target_axes_vect = [X Y Z];
            
            Center =  [0; 0; 0;];
            this.target_axes(1) = ...
                plot3([Center(1) Z(1)],[Center(2) Z(2)], [Center(3) Z(3)],'b--','linewidth', 1);
            this.target_axes(2) = ...
                plot3([Center(1) Y(1)],[Center(2) Y(2)], [Center(3) Y(3)],'g--','linewidth', 1);
            this.target_axes(3) = ...
                plot3([Center(1) X(1)],[Center(2) X(2)], [Center(3) X(3)],'r--','linewidth', 1);
        
            
            Z = [0; 0; 5;];
            Y = [0; 5; 0;];
            X = [5; 0; 0;];
            
            this.AHRS_axes_vect = [X Y Z];
            
            Center =  [0; 0; 0;];
            this.AHRS_axes(1) = ...
                plot3([Center(1) Z(1)],[Center(2) Z(2)], [Center(3) Z(3)],'b-','linewidth',3);
            this.AHRS_axes(2) = ...
                plot3([Center(1) Y(1)],[Center(2) Y(2)], [Center(3) Y(3)],'g-','linewidth',3);
            this.AHRS_axes(3) = ...
                plot3([Center(1) X(1)],[Center(2) X(2)], [Center(3) X(3)],'r-','linewidth',3);
        
            
            for i = 1:length(world)
               this.feature_plots(i) = plot3(...
                   world(i).vector(1)*25, ...
                   world(i).vector(2)*25, ...
                   world(i).vector(3)*25, 'Color', [0.5, 0.5, 0.5], ...
               'MarkerSize', 4, 'Marker', 'sq');
           
                this.gray_lines(i) = plot3(...
                  [0, world(i).vector(1)*25], ...
                  [0, world(i).vector(2)*25], ...
                  [0, world(i).vector(3)*25], 'Color', [0.7, 0.7, 0.7],...
                  'LineStyle', 'none');
            end
            
            this.sim_text = text(-40, 10,'Time ');
            set(this.sim_text,'FontSize', 20,'Color',[0.5, 0.5, 0.5],'FontWeight','bold');
            set(gcf, 'Renderer', 'OpenGl');
        end
        
        
        function this = Update(this, world, Cnb, Cnb_est, time)
            Vert_ = this.cube_vert;
            for j=1:size(Vert_,1)
                Vert_(j,:) = (Cnb*Vert_(j,:)');
            end
            set(this.cube,'Vertices',Vert_);
            
            for i = 1:3
                vect = Cnb * this.target_axes_vect(:,4-i);
                set(this.target_axes(i), 'XData', [0, vect(1)]);
                set(this.target_axes(i), 'YData', [0, vect(2)]);
                set(this.target_axes(i), 'ZData', [0, vect(3)]);
            end
            
            for i = 1:3
                vect = Cnb_est * this.AHRS_axes_vect(:,4-i);
                set(this.AHRS_axes(i), 'XData', [0, vect(1)]);
                set(this.AHRS_axes(i), 'YData', [0, vect(2)]);
                set(this.AHRS_axes(i), 'ZData', [0, vect(3)]);
            end
                
            set(this.sim_text, 'String', sprintf('%0.2f', time))
            
            for i=1:length(world)
                if world(i).visible
                    set(this.feature_plots(i), 'Color', 'r');
                    set(this.feature_plots(i), 'MarkerSize', 7);
                    set(this.feature_plots(i), 'MarkerFaceColor', 'r');
               
                else
                    set(this.feature_plots(i), 'Color', [0.5, 0.5, 0.5]);
                    set(this.feature_plots(i), 'MarkerSize', 4);
                    set(this.feature_plots(i), 'MarkerFaceColor', 'none');
                end
                
                if world(i).matched
                    set(this.gray_lines(i), 'LineStyle', '-');
                else
                    set(this.gray_lines(i), 'LineStyle', 'none');
                end
            end
            
            drawnow;
        end
    end
    
    
    
    
end