function [Us] = VelocityShift(flow_data)
% flow_data - the raw data struct
    X = flow_data(1).X;
    Y = flow_data(1).Y;
    theta = zeros(length(flow_data),1);
    for i = 1:length(flow_data)
        theta(i) = flow_data(i).theta;
    end
    Us = struct;
    for k = 1:num%length(theta)
        alpha = theta(k);
        U = flow_data(k).u;
        V = flow_data(k).v;
        sz = length(X);
        % XY = [X(:) Y(:)];
        % Rot = [cosd(-alpha) sind(-alpha); -sind(-alpha) cosd(-alpha)];
        % res = XY*Rot;
        % Xrot3 = reshape(res(:,1), size(X,1), []);
        % Yrot3 = reshape(res(:,2), size(Y,1), []);
        % Yrot4 = Yrot3-2.042;
        % foiltest = plot_foil(theta(k),1);
        % res = Rot*foiltest';
        % foiltest(:,:) = res';
        % qc = 2.042*[sind(theta(k));cosd(theta(k))];
        % qc = Rot*qc;
        % 
        % radius = [1.6 1.7 1.8 1.9 2]./2;
        % sizes = [1 1.3 1.6 1.9 2.2];
        % Cin = zeros(length(X),length(X),length(radius));
        % Ca = zeros(66,2,length(radius));
        % for i = 1:length(radius)
        %     [Cin(:,:,i),Ca(:,:,i)] = Circle2(qc,radius(i),Xrot3,Yrot3);
        % end
        % Rin2 = zeros(length(X),length(X),length(Rqcs));
        % Ra2 = zeros(5,2,length(Rqcs));
        % for i = 1:length(Rqcs)
        %     [Rin2(:,:,i),Ra2(:,:,i)] = Rect2(Rqcs(:,i),0.1,2,Xrot3,Yrot3);
        % end
        % 
        % [Pin, Pa] = Points2(qc,1,0.5,Xrot3,Yrot3);
        % 
        % qc(1) = qc(1)-1;
        % [Rin,Ra] = Rect2(qc,0.25,2,Xrot3,Yrot3);
        % foiltest2 = plot_foil(theta(k),1.5);
        % 
        % res = Rot*foiltest2';
        % foiltest2(:,:) = res';
        % Bin = inpolygon(Xrot3,Yrot3,foiltest2(:,1),foiltest2(:,2));
        
        UV = [U(:) V(:)];
        res = UV*Rot;
        u3 = reshape(res(:,1), size(X,1), []);
        v3 = reshape(res(:,2), size(Y,1), []);
        
        rRef = hypot(XY(:,1),XY(:,2));
        pv = Omega*rRef.*[-cosd(alpha),-sind(alpha)];
        UV4 = [u3(:) v3(:)];
        UV4 = UV4+pv;
        u4 = reshape(UV4(:,1), size(X,1), []);
        v4 = reshape(UV4(:,2), size(Y,1), []);
        
        % for i = 1:length(radius)
        %     Umeans.Circle(i) = mean(u4(logical(Cin(:,:,i))));
        %     Umeans.Rec(i) = mean(u4(logical(Rin2(:,:,i))));
        % end
        % Umeans.Point = mean(u4(logical(Pin)));
        % Vmeans.Point = mean(v4(logical(Pin)));
        % 
        % for i = 1:length(radius)
        %     Vmeans.Circle(i) = mean(v4(logical(Cin(:,:,i))));
        %     Vmeans.Rec(i) = mean(v4(logical(Rin2(:,:,i))));
        % end
        % 
        % rbv = Rqcs*0;
        % for i = 1:length(Rqcs)
        %     rRef = hypot(Rqcs(1,i),Rqcs(2,i));
        %     rbv(:,i) = Omega*rRef.*[-cosd(alpha);-sind(alpha)];
        % end
        % 
        % rRefP = hypot(mean(Pa(1,:)),mean(Pa(2,:)));
        % pbv = Omega*rRefP.*[-cosd(alpha);-sind(alpha)];
        % 
        % rbvs(:,:,k) = rbv;
        % 
        % dThetas(:,:,k) = (Umeans.Rec(:,:)+rbv(1,:))./abs(Rqcs(1,:))*Omega;
        % 
        % bv = Omega*rt.*[-cosd(alpha);-sind(alpha)];
        % bvs(:,:,k) = bv;
        % 
        % for i = 1:length(radius)
        %     Urels(k).C(i,:) = [Umeans.Circle(i);Vmeans.Circle(i)]+bv;
        %     Urels(k).R(i,:) = [Umeans.Rec(i);Vmeans.Rec(i)]+rbv(:,i);
        % end
        %Urels(k).P = [Umeans.Point;Vmeans.Point]+pbv;
        Us(k).u3 = u3;
        Us(k).v3 = v3;
        Us(k).u4 = u4;
        Us(k).v4 = v4;
    end
end