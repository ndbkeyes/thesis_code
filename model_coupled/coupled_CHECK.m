close all;
[x_co2,co2,~] = data2matrix(obj_arr{1},Y,M);
[x_ch4,ch4,dt] = data2matrix(obj_arr{2},Y,M);
x_co2 = reshape(x_co2',[],1);
co2 = reshape(co2',[],1);
x_ch4= reshape(x_ch4',[],1);
ch4 = reshape(ch4',[],1);

M_co2 = movmean(co2,20);
A = co2 - M_co2;
M_ch4 = movmean(ch4,20);
B = ch4 - M_ch4;




% figure
% hold on
% plot(x_ch4,ch4)
% plot(x_co2,co2)
%%
DA = (A(2:end) - A(1:end-1)) ./ dt;
DB = (B(2:end) - B(1:end-1)) ./ dt;

ADA = mean(A(1:999).*DA);
ADB = mean(A(1:999).*DB);
BDA = mean(B(1:999).*DA);
BDB = mean(B(1:999).*DB);

AA = mean(A.^2);   
AB = mean(A.*B);
BB = mean(B.^2);

A1 = [AA, AB-AA; AB, BB-AB];
A2 = [BB, AB-BB; AB, AA-AB];

Q1 = [ADA; BDA];
Q2 = [BDB; ADB];

X1 = A1\Q1;
X2 = A2\Q2;

disp(X1)
disp(X2)
%%

AdtDA = mean(A(2:1000).*DA(1:999));
BdtDB = mean(B(2:1000).*DB(1:999));

AAdt = mean(A(1:999).*A(2:1000));   
ABdt = mean(A(1:999).*B(2:1000));
BAdt = mean(A(2:1000).*B(1:999));
BBdt = mean(B(1:999).*B(2:1000));

N1 = sqrt(AdtDA - X1(1)*AAdt - X1(2)*(BAdt - AAdt));
N2 = sqrt(BdtDB - X2(1)*BBdt - X2(2)*(ABdt - BBdt));

disp(N1)
disp(N2)

%%
u_ch4 = zeros(1000,1);
u_co2 = zeros(1000,1);

for i = 2:1000
    u_co2(i) = u_co2(i-1) +  ((X1(1)-X1(2))*u_co2(i-1) + X1(2)*u_ch4(i-1))*dt + N1*randn*sqrt(dt);
    u_ch4(i) = u_ch4(i-1) +  ((X2(1)-X2(2))*u_ch4(i-1) + X2(2)*u_co2(i-1))*dt + N2*randn*sqrt(dt);
end

figure
hold on
plot(u_co2);
plot(A);


figure
hold on
plot(u_ch4);
plot(B);



[PDF_co2, xx3] = ksdensity(A);
[PDF_u_co2, xx4] = ksdensity(u_co2);

[PDF_ch4, xx1] = ksdensity(B);
[PDF_u_ch4, xx2] = ksdensity(u_ch4);



figure
hold on
plot(xx1, PDF_ch4,'b')
plot(xx2, PDF_u_ch4,'r')



figure
hold on
plot(xx3, PDF_co2,'b')
plot(xx4, PDF_u_co2,'r')



fprintf("std A data: %.3e, std A sim: %.3e\nstd B data: %.3e, std B sim: %.3e\n\n",std(A),std(u_co2),std(B),std(u_ch4));


fprintf("Ludovico check: a1 = %.3e, a2 = %.3e, b12 = %.3e, b21 = %.3e, N1 = %.3e, N2 = %.3e\nNash 2D code:   a1 = %.3e, a2 = %.3e, b12 = %.3e, b21 = %.3e, N1 = %.3e, N2 = %.3e\n", X1(1), X2(1), X1(2), X2(2), N1, N2,abN_br2D(1,:), abN_br2D(2,:), abN_br2D(3,:), abN_br2D(4,:), abN_br2D(5,:), abN_br2D(6,:));
