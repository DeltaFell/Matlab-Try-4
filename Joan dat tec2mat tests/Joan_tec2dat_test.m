%Joan Matutes
%Testing the .dat converstion and reading stuff
%7/30/24

clear;
[zone1,VARlist1] = tec2mat('time_267.dat','debug');
%%
X  = zone1.data(1).data;
Y = zone1.data(2).data;
sz = size(VARlist1,2);
%%
fields = struct('names',{'X','Y','U','V'});
newData = struct();
for i = 1:sz
    newData.(fields(i).names) = zone1.data(i).data;
end
%%
newData.Umag = hypot(newData.U,newData.V);
%%
test = struct()
for i = 1:sz
    test(i).names = VARlist1(i);
end
%forgor about the weird names for U & V