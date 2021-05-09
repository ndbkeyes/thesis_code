clear all
data = load("edc3-2008_ch4_DATA.txt");
ch4 = data(:,3);
xc = data(:,2);

xi = linspace(0,max(xc),2001);
ch4i = interp1(xc,ch4,xi,'linear');
ch4i = ch4i(2:end);
xi = xi(2:end);

dt = max(xc)/2000;

N = length(ch4i);

PS_ch4 = fft(ch4i);
PS_ch4 = abs(PS_ch4).^2 / N;

PS_x = [0:N-1] * 1/(N*dt);

figure
plot(PS_x,PS_ch4);
xlim([0.5*10^(-5),6*10^(-5)]);
xlabel("frequency");
ylabel("power");
title("Power spectrum");

figure
plot(xi, ch4i);

%%

M = movmean(ch4i,20);

ch4_f = ch4i - M;

PS_ch4_f = fft(ch4_f);
PS_ch4_f = abs(PS_ch4_f).^2 / N;

figure
plot(PS_x,PS_ch4_f);
xlim([0.5*10^(-5),6*10^(-5)]);
xlabel("frequency");
ylabel("power");
title("Power spectrum");

figure
plot(xi, ch4_f);

figure
hold on
plot(xi, M);
plot(xi, ch4i);

%%

% Let's define 1 "year" 100 points, which corresponds to the frequency at
% 2.5 10^{-5} in the power spectrum

dt1 = 1/100;
p1 = 100;
Np = 19;

summ1=0.0;
summ2=0.0;
for k=1:p1*Np
    summ1=summ1+ch4_f(k)*ch4_f(k);
    summ2=summ2+ch4_f(k)*ch4_f(k+1);
end
at = (summ2-summ1)/(summ1*dt1);

disp(at);

for k=1:p1*Np
    y(k)=ch4_f(k+1)-ch4_f(k)-at*ch4_f(k)*dt1;
end

summ1=0.0;
summ2=0.0;
for k=1:p1*Np-1
    summ1=summ1+y(k)*y(k);
    summ2=summ2+y(k+1)*y(k);
end
Nt = sqrt((summ1-summ2)/((p1*Np-1)*dt1));

disp(Nt)

%%

x1 = [1:1900]*dt1;

u_pred = zeros(50000,1);

for i = 2:50000
    u_pred(i) = u_pred(i-1) + at* u_pred(i-1)*dt1 + Nt*randn * sqrt(dt1);
end

disp(std(u_pred));
disp(std(ch4_f));

[PDF_1, xx_1] = ksdensity(ch4_f);
[PDF_2, xx_2] = ksdensity(u_pred);

figure
hold on
plot(xx_1, PDF_1)
plot(xx_2, PDF_2,'r')

figure
hold on
plot(x1(1:400), ch4_f(1:400));
plot(x1(1:400), u_pred(1:400),'r');

%%

u_p = zeros(1900,1);

for i = 2:1900
    u_p(i) = u_p(i-1) + at* (u_p(i-1)-M(i-1))*dt1 + Nt*randn * sqrt(dt1) ;
end

[PDF_3, xx_3] = ksdensity(ch4i);
[PDF_4, xx_4] = ksdensity(u_p);

figure
hold on
plot(xx_3, PDF_3)
plot(xx_4, PDF_4,'r')

figure
hold on
plot(x1(10:end), u_p(10:1900));
plot(x1(10:end), ch4i(10:1900),'r');

