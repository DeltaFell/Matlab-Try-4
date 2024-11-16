theta_p=6; %preset pitch in deg
Uinf=0.91; %m/s
chord=4.06*10; 
R=17.2/2/100;
TSR=1.5;
Utan=-TSR*Uinf;
[Crop]=DataCropDaVis_Avg_EWTEC2(DATA,20,15,25,25,chord,theta_p,Utan,TSR,Uinf,R);
function [data_Avg]=DataCropDaVis_Avg_EWTEC2(DataSet_Avg,grow_TE,grow_LE,grow_Top,grow_Bot,chord,theta_p,Utan,TSR,Uinf,R)
%rotates all data to the blade-centric reference frame
%grow_TE = factor by which to grow the crop boundary past the trailing edge
%grow_LE = same by for past the leading edge
%grow_top = same but for above the blade.
%grow_bot = same but for below the blade.
%chord = chord length [m]
%theta_p = preset pitch angle [deg]
%Utan = tangential velocity of the blade [m/s]
%TSR = tip-speed ratio
%Uinf = frestream velocity [m/s]
%R = turbine radiust [m]
data_Avg=DataSet_Avg; %phase-averaged flow field data structure
names=fieldnames(data_Avg); %find the fieldnames of the structure
names=names(contains(names,'deg')); %selects field names that correspond to the phases with data
Nx=size(data_Avg.(names{1}).X,1); %number of grid-points in the x-dir
Ny=size(data_Avg.(names{1}).X,2); %number of grid-points in the y-dir
omega=TSR*Uinf/R; %rotation rat in rad/s
xgrid={};
ygrid={};
findNaN=[];
loop=1;
figure(100);
clf(100);
figure(2000);
clf(2000);
for i=1:length(names)
    %Rotate Field
        preset=theta_p;
    %determine rotation angle. We need to rotate backwards to get blade in
    %the '0' position i.e. horizontal but still has preset pitch. We then
    %need to rotate the frame forward a little by the preset pitch to get
    %the blade horizontal. We will do the exact oposite when rotating the
    %velocity components
    angle=-str2double(names{i}(strfind(names{i},'_')+1:end))+preset; 
    rot=[cosd(angle) -sind(angle); sind(angle) cosd(angle)];
    
    %move the centershaft to the origin to properly rotate
    X=data_Avg.(names{i}).X; 
    Y=data_Avg.(names{i}).Y;
    X=reshape(X',[],1); %reshape into column vectors
    Y=reshape(Y',[],1);
    X_unique=unique(X); %find the unique x and y values
    Y_unique=unique(Y);
    dx=abs(X_unique(2)-X_unique(1)); %find the width of the grid cells
    dy=abs(Y_unique(2)-Y_unique(1));
    XYrot=rot*[X';Y']; %rotate the X and Y grids
    U_Avg=data_Avg.(names{i}).U_Avg;
    V_Avg=data_Avg.(names{i}).V_Avg;
    Xrot=reshape(XYrot(1,:),[Ny Nx]); %put back into grid
    Yrot=reshape(XYrot(2,:),[Ny Nx]);
    Xrot=Xrot';
    Yrot=Yrot';
    Urot_Avg=U_Avg'.*cosd(-angle)+V_Avg'.*sind(-angle); %cooridinate transform of the U and V velocities into the blade centric reference frame
    Vrot_Avg=-U_Avg'.*sind(-angle)+V_Avg'.*cosd(-angle);
    Urot_Avg=Urot_Avg';
    Vrot_Avg=Vrot_Avg';
    %Determine the relative velocity by subtracting off the tangential velocity. preset because Utan is still at an angle (the preset pitch angle) with respect to the blade chord line. 
    Urot_rel_Avg=Urot_Avg-Utan*cosd(preset);
    Vrot_rel_Avg=Vrot_Avg-Utan*sind(preset);
    %translaste Vorticity from inertial frame to non-inertial (rotating
    %frame) we are doing this in cartesean coords or are we???? vorticity
    %is computed in the cartesian frame????? but vorticity here is all in
    %the z and in cyclindrical coords z=z so shouldn't change vorticity.
    %i.e. we should just be able to rotate the vorticity field and
    %substract off 2*omega (the solid body vorticity) to get the vorticity
    %relative to the blade... https://www.eoas.ubc.ca/~swaterma/512/LectureNotes/6_Fundamental_Theorems_Vorticity_and_Circulation.pdf
    % Vort_rel_Avg=data_Avg.(names{i}).Vort_Avg-2*omega;
    
    %Rotate Foil %rotate the polygon of the airfoil about the center of
    %ratation of the turbine ([0,0])
    foilshift=data_Avg.(names{i}).Foil;
    foilrot=rotate(foilshift,angle,[0,0]);
    
    %Crop Field
    [xbound,ybound]=boundingbox(foilrot);
    thic_c4=abs(ybound(1)-ybound(2));
    LE=min(xbound);
    bot=min(ybound);
    xbound(1)=xbound(1)+chord/grow_TE; %Grow the crop boundary and change Aspect Ratio
    xbound(2)=xbound(2)-chord/grow_LE;
    ybound(1)=ybound(1)+chord/grow_Top;
    ybound(2)=ybound(2)-chord/grow_Bot;
    
    %Produce vericies to create polyshape
    [xbound,ybound]=meshgrid(xbound,ybound);
    xbound=reshape(xbound,[],1);
    xbound(3:end)=flipud(xbound(3:end));
    ybound=reshape(ybound,[],1);
    ybound(3:end)=flipud(ybound(3:end));
    cropbound=polyshape(xbound',ybound');
    xwidth=max(xbound)-min(xbound);
    ywidth=max(ybound)-min(ybound);
    
    figure(100)
    contour(data_Avg.(names{i}).X,data_Avg.(names{i}).Y,data_Avg.(names{i}).Mask)
    hold on
    shading flat
    plot(data_Avg.(names{i}).Foil)
    axis equal
    
    %Determine Coordinates within the polyshape
    [in,out]=inpolygon(Xrot,Yrot,cropbound.Vertices(:,1)...
        ,cropbound.Vertices(:,2));
    ind=logical(in+out);
    U_trans_Avg=Urot_Avg;
    V_trans_Avg=Vrot_Avg;
    U_trans_rel_Avg=Urot_rel_Avg;
    V_trans_rel_Avg=Vrot_rel_Avg;
    Vmag_trans_Avg=sqrt(U_trans_Avg.^2+V_trans_Avg.^2);
    % Vort_trans_Avg=Vort_rel_Avg;
    Mask_trans=data_Avg.(names{i}).Mask;
        
    %Move all croped data so the blade quarter chord is at (0,0) 
    Xcrop=Xrot(ind)-min(xbound)-(LE-min(xbound)+0.25);
    Ycrop=Yrot(ind)-min(ybound)-(bot-min(ybound));
%     Xcrop=Xrot(ind)-min(xbound)*chord-(abs(abs(LE)-abs(min(xbound))))*chord;
%     Ycrop=Yrot(ind)-min(ybound)*chord-abs(bot-min(ybound))*chord;
    U_crop_Avg=U_trans_Avg(ind);
    V_crop_Avg=V_trans_Avg(ind);
    U_crop_rel_Avg=U_trans_rel_Avg(ind);
    V_crop_rel_Avg=V_trans_rel_Avg(ind);
    Vmag_crop_Avg=Vmag_trans_Avg(ind);
    % Vort_crop_Avg=Vort_trans_Avg(ind);
    Mask_crop=Mask_trans(ind);
    MaskX=Xcrop(Mask_crop==1);
    MaskY=Ycrop(Mask_crop==1);
    Maskpoly=alphaShape(MaskX,MaskY);
    Maskpoly.Alpha=0.2;
    
    %Shift the foil vertices as well
    foilrot.Vertices(:,1)=foilrot.Vertices(:,1)-min(xbound)-(LE-min(xbound))-0.25;
    foilrot.Vertices(:,2)=foilrot.Vertices(:,2)-min(ybound)-(bot-min(ybound));
    data_Avg.(names{i}).nonInterp.Foil=foilrot;
    
    %Save the coordinates of the mask (i.e. the missing data)
    data_Avg.(names{i}).nonInterp.Mask=Mask_crop;
    
    %Remove all NaN values %necessary before interpolating to a common grid
    data_Avg.(names{i}).nonInterp.Xcrop=Xcrop(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.Ycrop=Ycrop(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.U_crop=U_crop_Avg(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.V_crop=V_crop_Avg(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.U_crop_rel=U_crop_rel_Avg(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.V_crop_rel=V_crop_rel_Avg(~isnan(Vmag_crop_Avg));
    data_Avg.(names{i}).nonInterp.Vmag_crop=Vmag_crop_Avg(~isnan(Vmag_crop_Avg));
    % data_Avg.(names{i}).nonInterp.Vort_crop_rel=Vort_crop_Avg(~isnan(Vmag_crop_Avg));
    
    %Interpolate to common grid based off of the first angle: with all
    %NaN's removed NOTE: this will fill in all missing values i.e. masked data and where the
    %mask is the mask will be added in after interpolation but using the
    %inpolygon funtion to set any points in side the mask area to NaN. All
    %missing values will still be filled in.
    if loop==1
        xinterp=[min(Xcrop):dx:max(Xcrop)];
        yinterp=[min(Ycrop):dx:max(Ycrop)];
        [xgrid,ygrid]=meshgrid(xinterp,yinterp);
    end
    goodinds=inShape(Maskpoly,xgrid,ygrid); %find the positions of the interpolated regions
    %which will be outside of the mask region. I.e. the point we want to
    %keep. Those in the mask will be set to NaN
    
    data_Avg.(names{i}).Interp.foil=foilrot;
    data_Avg.(names{i}).Interp.Xcrop=xgrid(1,:);
    data_Avg.(names{i}).Interp.Ycrop=ygrid(:,1);
    clear Xcrop_temp Ycrop_temp Utemp Vtemp Ureltemp Vreltemp
    Xcrop_temp=Xcrop(~isnan(Vmag_crop_Avg));
    Ycrop_temp=Ycrop(~isnan(Vmag_crop_Avg));
    Utemp=data_Avg.(names{i}).nonInterp.U_crop;
    Vtemp=data_Avg.(names{i}).nonInterp.V_crop;
    Ureltemp=data_Avg.(names{i}).nonInterp.U_crop_rel;
    Vreltemp=data_Avg.(names{i}).nonInterp.V_crop_rel;
    % Vorttemp=data_Avg.(names{i}).nonInterp.Vort_crop_rel;
    
    data_Avg.(names{i}).Interp.U_crop=griddata(Xcrop_temp,Ycrop_temp...
        ,Utemp,xgrid,ygrid);
    data_Avg.(names{i}).Interp.U_crop(goodinds)=NaN;
    
    data_Avg.(names{i}).Interp.V_crop=griddata(Xcrop_temp,Ycrop_temp...
        ,Vtemp,xgrid,ygrid);
    data_Avg.(names{i}).Interp.V_crop(goodinds)=NaN;
    
    data_Avg.(names{i}).Interp.U_crop_rel=griddata(Xcrop_temp,Ycrop_temp...
        ,Ureltemp,xgrid,ygrid);
    data_Avg.(names{i}).Interp.U_crop_rel(goodinds)=NaN;
    
    data_Avg.(names{i}).Interp.V_crop_rel=griddata(Xcrop_temp,Ycrop_temp...
        ,Vreltemp,xgrid,ygrid);
    data_Avg.(names{i}).Interp.V_crop_rel(goodinds)=NaN;
    
    % data_Avg.(names{i}).Interp.Vort_crop_rel=griddata(Xcrop_temp,Ycrop_temp...
        % ,Vorttemp,xgrid,ygrid);
    % data_Avg.(names{i}).Interp.Vort_crop_rel(goodinds)=NaN;
    
    data_Avg.(names{i}).Interp.Vmag_crop=sqrt(data_Avg.(names{i}).Interp.U_crop.^2+...
        data_Avg.(names{i}).Interp.V_crop.^2);
    
    data_Avg.(names{i}).Interp.Vmag_crop_rel=sqrt(data_Avg.(names{i}).Interp.U_crop_rel.^2+...
        data_Avg.(names{i}).Interp.V_crop_rel.^2);
    %Save the foil
    data_Avg.(names{i}).Interp.Foil=foilrot;
    
    %Save Mask Inds
    findNaN_Vmag(:,:,i)=isnan(data_Avg.(names{i}).Interp.Vmag_crop);
    loop=loop+1;
end

end