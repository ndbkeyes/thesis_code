function [X,Y] = depth_to_age()

%
% FUNCTION: depth_to_age()
%
close all
% Load depth age chronology
[z,x] = load_data("C:\Users\charl\Desktop\files\summer2020 research\SP19_Depth_Age", {'Var1','Var2'},{2,1});

%Load depth d18O cm ave data
[Z,Y] = load_data("C:\Users\charl\Desktop\files\summer2020 research\SPIceCoreDatahalfcmAverage01-08-2020", {'Var1','Var2'},{});

X = makima(z,x,Z);

% hold on
% scatter(z,x)
% plot(Z,X)

plot(X,Y)

Age=-X;
d18O_cm_ave=Y;
T= table(Age,d18O_cm_ave);
writetable(T,'spice_age_d18O.csv');
end


