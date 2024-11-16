function [data_Avg]=DataCrop_start(DataSet,grow_TE,grow_LE,grow_Top,grow_Bot)
global chord theta_p Utan

%chord is the chord length in mm
%theta_p is preset pitch in deg
%Utan is the blade tangential velocity in m/s

%DataSet is the data set you want to crop and rotate. NOTE WILL NEED TO
%CHANGE HOW EVERYTHING IS ACCESSED TO MATCH THE FORMAT OF THE CFD DATA

%grow_TE,grow_LE,grow_Top,grow_Bot are denomenators to fractions which 
%define how big to make the cropped boundary around the blade from the 
%Trailing Edge, Leading Edge, above and below the blade. Typical values 
%I have used are [15,30,80,33]

data_Avg=DataSet_Avg;
names=fieldnames(data_Avg);
Nx=size(data_Avg.(names{1}).X,1);
Ny=size(data_Avg.(names{1}).X,2);

xgrid={};
ygrid={};
findNaN=[];
loop=1;
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
    
    X=data_Avg.(names{i}).X;
    Y=data_Avg.(names{i}).Y;
    X=reshape(X',[],1); 
    Y=reshape(Y',[],1);
    X_unique=unique(X);
    Y_unique=unique(Y);
    dx=abs(X_unique(2)-X_unique(1))/chord;
    dy=abs(Y_unique(2)-Y_unique(1))/chord;
    
    %rotate coordinates
    XYrot=rot*[X';Y'];

    Xrot=reshape(XYrot(1,:),[Ny Nx]); 
    Yrot=reshape(XYrot(2,:),[Ny Nx]);
    Xrot=Xrot';
    Yrot=Yrot';
    
    %rotate Velocity components
    U_Avg=data_Avg.(names{i}).U_Avg;
    V_Avg=data_Avg.(names{i}).V_Avg;
    U=data.(names{i}).U;
    V=data.(names{i}).V;
    Urot_Avg=U_Avg'.*cosd(-angle)+V_Avg'.*sind(-angle);
    Vrot_Avg=-U_Avg'.*sind(-angle)+V_Avg'.*cosd(-angle);
    Urot_Avg=Urot_Avg';
    Vrot_Avg=Vrot_Avg';
    
    %Calculate Relative Velocity Components
    Urot_rel_Avg=Urot_Avg-Utan;
    Vrot_rel_Avg=Vrot_Avg;
    
%     Rotate Foil
    %%%%USES THE ROTATE FUNCTION MATLAB TO ROTATE THE DEFINED FOIL
    foilrot=rotate(data_Avg.(names{i}).Foil,angle...
        ,[data_Avg.(names{i}).RotCenterX,data_Avg.(names{i}).RotCenterY]);
    
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
    
    %Determine Coordinates within the polyshape
    [in,out]=inpolygon(Xrot/chord,Yrot/chord,cropbound.Vertices(:,1)...
        ,cropbound.Vertices(:,2));
    ind=logical(in+out);
    U_crop_Avg=Urot_Avg(ind);
    V_crop_Avg=Vrot_Avg(ind);
    U_crop_rel_Avg=Urot_rel_Avg(ind);
    V_crop_rel_Avg=Vrot_rel_Avg(ind);
    Vmag_crop_Avg=sqrt(U_crop_Avg.^2+V_crop_Avg.^2);
    Vmag_crop_rel_Avg=sqrt(U_crop_rel_Avg.^2+V_crop_rel_Avg.^2);
    
    %Move all croped data so the blade quarter chord is at (0,0) 
    Xcrop=Xrot(ind)-min(xbound)*chord-(LE-min(xbound)+0.25)*chord;
    Ycrop=Yrot(ind)-min(ybound)*chord-(bot-min(ybound))*chord;
    
    %Shift the foil vertices as well
    foilrot.Vertices(:,1)=foilrot.Vertices(:,1)-min(xbound)-(LE-min(xbound))-0.25;
    foilrot.Vertices(:,2)=foilrot.Vertices(:,2)-min(ybound)-(bot-min(ybound));
    
    %save in output structure
    data_Avg.(names{i}).Foil=foilrot;
    data_Avg.(names{i}).U_crop_Avg=U_crop_Avg;
    data_Avg.(names{i}).V_crop_Avg=V_crop_Avg;
    data_Avg.(names{i}).U_crop_rel_Avg=U_crop_rel_Avg;
    data_Avg.(names{i}).V_crop_rel_Avg=V_crop_rel_Avg;
    data_Avg.(names{i}).Vmag_crop_Avg=Vmag_crop_Avg;
    data_Avg.(names{i}).Vmag_crop_rel_Avg=Vmag_crop_rel_Avg;
end


    
    
end









