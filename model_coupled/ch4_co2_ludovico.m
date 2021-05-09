clear all
% data_ch4 = load('edc3-2008_ch4_DATA.txt');
% data_co2 = load('edc3-2008_co2_DATA-series3-composite.txt');
data_ch4 = readtable("edc3-2008_ch4_DATA.txt",'MultipleDelimsAsOne', true);
data_co2 = readtable("edc3-2008_co2_DATA-series3-composite.txt",'MultipleDelimsAsOne', true);

data_ch4 = cell2mat(table2cell(data_ch4(:,1:4)));
data_co2 = cell2mat(table2cell(data_co2(:,1:2)));

ch4_val = data_ch4(:,3);
x_ch4 = data_ch4(:,2);
co2_val = data_co2(:,2);
x_co2 = data_co2(:,1);

dt = max(x_co2)/1000;

x = linspace(0,max(x_co2),1001);
ch4 = interp1(x_ch4,ch4_val,x,'linear');
co2 = interp1(x_co2,co2_val,x,'linear');
ch4 = ch4(2:end);
co2 = co2(2:end);
x = x(2:end);

M_ch4 = movmean(ch4,20);
ch4 = ch4 - M_ch4;

M_co2 = movmean(co2,20);
co2 = co2 - M_co2;


%%

figure
hold on
plot(x,ch4)
plot(x,co2)
%%
DA = (ch4(2:end) - ch4(1:end-1)) ./ dt;
DB = (co2(2:end) - co2(1:end-1)) ./ dt;

ADA = mean(ch4(1:999).*DA);
ADB = mean(ch4(1:999).*DB);
BDA = mean(co2(1:999).*DA);
BDB = mean(co2(1:999).*DB);

AA = mean(ch4.^2);   
AB = mean(ch4.*co2);
BB = mean(co2.^2);

A1 = [AA, AB-AA; AB, BB-AB];
A2 = [BB, AB-BB; AB, AA-AB];

Q1 = [ADA; BDA];
Q2 = [BDB; ADB];

X1 = A1\Q1;
X2 = A2\Q2;

disp(X1)
disp(X2)
%%

AdtDA = mean(ch4(2:1000).*DA(1:999));
BdtDB = mean(co2(2:1000).*DB(1:999));

AAdt = mean(ch4(1:999).*ch4(2:1000));   
ABdt = mean(ch4(1:999).*co2(2:1000));
BAdt = mean(ch4(2:1000).*co2(1:999));
BBdt = mean(co2(1:999).*co2(2:1000));

N1 = AdtDA - X1(1)*AAdt - X1(2)*(BAdt - AAdt);
N2 = BdtDB - X2(1)*BBdt - X2(2)*(ABdt - BBdt);

disp(N1)
disp(N2)

%%
u_ch4 = zeros(10000,1);
u_co2 = zeros(10000,1);

for i = 2:10000
    u_ch4(i) = u_ch4(i-1) +  ((X1(1)-X1(2))*u_ch4(i-1) + X1(2)*u_co2(i-1))*dt + N1*randn*sqrt(dt);
    u_co2(i) = u_co2(i-1) +  ((X2(1)-X2(2))*u_co2(i-1) + X2(2)*u_ch4(i-1))*dt + N2*randn*sqrt(dt);
end

[PDF_ch4, xx1] = ksdensity(ch4);
[PDF_u_ch4, xx2] = ksdensity(u_ch4);

[PDF_co2, xx3] = ksdensity(co2);
[PDF_u_co2, xx4] = ksdensity(u_co2);

figure
hold on
plot(xx1, PDF_ch4,'b')
plot(xx2, PDF_u_ch4,'r')

figure
hold on
plot(xx3, PDF_co2,'b')
plot(xx4, PDF_u_co2,'r')

% figure
% hold on
% plot(x, u_ch4,'b');
% plot(x, u_co2,'r');

disp(std(ch4))
disp(std(u_ch4))
disp(std(co2))
disp(std(u_co2))

