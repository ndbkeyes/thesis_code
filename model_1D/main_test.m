clear all;
close all;
clc;



co2_br = DataSet("data","NK","epica-co2");
plot(co2_br.X,co2_br.Y);


Y = 34;
M = 50;
m = Y/2;
br_win = 0;


global xx;
xx = linspace(min(co2_br.X),max(co2_br.X),Y*M);

% 
% 
% anf = findanf_epica(co2_br,Y,M,'mm',m,'plt',1,'br_win',br_win);
% [simx_br,simy_br] = epica_sim1D(co2_br,Y,M,anf,M/2,1);
% 
% [~,datay_br,~] = data2matrix(co2_br,Y,M,br_win);
% datay_br = reshape(datay_br',[],1);
% 
% disp(std(datay_br));
% disp(std(simy_br));



model_1D(co2_br,Y,M,m,0,1)


