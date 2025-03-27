filepattern = fullfile('./turbine19_asciidatfiles/','*.dat');
files = dir(filepattern);
files(1).name

flow_data = struct;

flow_data(1).theta = 0;

tic
for i = 1:size(files,1)
    CurPath = strcat('./turbine19_asciidatfiles/',files(i).name);
    [zone,var] = tec2mat(CurPath,'debug');
    x = zone.data(:,:,1);
    y = zone.data(:,:,2);
    u = zone.data(:,:,3);
    v = zone.data(:,:,4);
    vort = zone.data(:,:,5);
    flow_data(i).theta = str2double(extractBetween(files(i).name,'_','.dat'));
    flow_data(i).X = x;
    flow_data(i).Y = y;
    flow_data(i).u = u;
    flow_data(i).v = v;
    flow_data(i).vort = vort;
end
toc
T = struct2table(flow_data);
sortedT = sortrows(T,"theta");
flow_data = table2struct(sortedT);
save('TSR_1_9_Turbine19.mat',"flow_data")