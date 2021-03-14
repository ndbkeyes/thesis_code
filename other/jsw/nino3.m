clear all

temp=load('nino34.txt');

init=1;
fin=148;
criterion=40;
tnum=fin-init+1-criterion;
final=fin-init+1;
num=12;
delt=1/12;
mon=1:1:12;

for k=1:final
    yr(k)=temp(k,1);
end

nino=temp(1:148,2:13);

for k=1:final
    for j=1:num
        nn=num*(k-1)+j;
        ori(nn)=nino(k,j);
    end
end

[a,N,autoft,ft,P,weather_nino]=findanf(nino,init,fin,tnum);

for j=1:final-1
    for k=1:num
        nn=num*(j-1)+k;
        weather(nn)=weather_nino(j,k);
    end
end

Nlevel=mean(N.^2)/num;
Nlevel=sqrt(Nlevel);

Y=fft(ft(1:final-1));
P2=abs(Y/(final-1));
P1=P2(1:(final-1)/2+1);
P1(2:end-1)=2*P1(2:end-1);

rec=zeros(size(Y));
for k=1:(final-1)/2+1
    if k==1
     if P1(k) > Nlevel
        rec(k)=1.0; 
     end
    else
     if P1(k) > Nlevel
        rec(k)=1.0;
        rec(final-1-k+2)=1.0;
     end
    end 
end

YT=Y.*rec;

fil_ftau=ifft(YT);

%% covariance
for k=1:num
    summ=0.0;
    for j=1:k
        summ=summ+a(j)*delt;
    end
    sumat(k)=summ;
end

gamma=-sumat(num);

for k=1:num
    summ=0.0;
    for j=1:k
        summ=summ+N(j)^2*exp(-2.0*sumat(j))*delt;
    end
    A(k)=summ;
end

for k=1:num
    S(k)=exp(2.0*sumat(k))*(A(k)+1/(exp(2*gamma)-1)*A(num));
end

% for k=1:num
%     summ=0.0;
%     for j=1:k
%         if j==1
%             summ=summ+delt*0.5*(a(j)+a(num));
%         else
%             summ=summ+delt*0.5*(a(j-1)+a(j));
%         end
%     end
%     sumat(k)=summ;
% end
% 
% gamma=-sumat(num);
% 
% for k=1:num
%     summ=0.0;
%     for j=1:k
%         if j==1
%             summ=summ+delt*0.5*(N(j)^2*exp(-2.0*sumat(j))+N(num)^2*exp(-2.0*sumat(num)));
%         else
%             summ=summ+delt*0.5*(N(j)^2*exp(-2.0*sumat(j))+N(j-1)^2*exp(-2.0*sumat(j-1)));
%         end
%     end
%     A(k)=summ;
% end
% 
% for k=1:num
%     S(k)=exp(2.0*sumat(k))*(A(k)+1/(exp(2*gamma)-1)*A(num));
% end


for k=1:num
    for j=k:k+2*num-1
      if j==k
        summ=0.0;
        cor(j-k+1,k)=1.0;
      else  
        summ=0.0;
        for i=k:j-1
            mm=mod(i+1,num);
            if mm==0
             mm=12;
            end
            summ=summ+a(mm)*delt;
        end
        nn=mod(j,num);
        if nn==0
          nn=12;
        end
        cor(j-k+1,k)=exp(summ)*sqrt(S(k))/sqrt(S(nn));
      end  
    end
end

for k=1:num
    summ=0.0;
    for j=1:final
        summ=summ+nino(j,k)*nino(j,k);
    end
    S_nino(k)=sqrt(summ/(final-1));
end

for k=1:num
    for j=k:k+2*num-1
        if j==k
            cor_nino(j-k+1,k)=1.0;
        else
            h=mod(j,num);
            if h==0
               h=12; 
               g=floor(j/num);
               if g==1
                   g=0;
               else
                   g=1;
               end
            else
               h=h;
               g=floor(j/num);
            end
            summ=0.0;
            for i=1:final-g
                summ=summ+nino(i,k)*nino(i+g,h);
            end
            cor_nino(j-k+1,k)=summ/(final-g-1)/S_nino(h)/S_nino(k);
        end
    end
end


%%


for k=1:num
    ath(k)=-2.0-2.5*sin(2*3.141592*k/12);
end

 wx=randn(length(yr)*12*10);
 
 surrx(1)=ori(1);
 
 tot_num=length(yr)*12*10-1;
 tot_yr=length(yr)*10;
 
 for i=1:tot_num
     k=mod(i,12);
     m=floor(i/12+1);
     if k==0
        k=12;
     end
     surrx(i+1)=surrx(i)+a(k)*surrx(i)*delt+N(k)*sqrt(delt)*wx(i);%+ft(m)*delt;
     
 end
 
 wx1=randn(length(yr)*12);
 tot_num1=length(yr)*12-1;
 
 surrx1(1)=ori(1);
 for i=1:tot_num1
    k=mod(i,12);
    m=floor(i/12+1);
    if k==0
        k=12;
    end
    surrx1(i+1)=surrx1(i)+a(k)*surrx1(i)*delt+N(k)*sqrt(delt)*wx1(i)+ft(m)*delt;
 end
 
  m=12;
for j=1:tot_yr
    for i=1:m
        nni=m*(j-1)+i;
        surx(j,i)=surrx(nni);
    end
end

for k=1:num
    summ=0.0;
    for j=1:tot_yr
        summ=summ+surx(j,k)*surx(j,k);
    end
    S_surx(k)=sqrt(summ/(final-1));
end

for k=1:num
    for j=k:k+2*num-1
        if j==k
            cor_surx(j-k+1,k)=1.0;
        else
            h=mod(j,num);
            if h==0
               h=12; 
               g=floor(j/num);
               if g==1
                   g=0;
               else
                   g=1;
               end
            else
               h=h;
               g=floor(j/num);
            end
            summ=0.0;
            for i=1:final-g
                summ=summ+surx(i,k)*surx(i+g,h);
            end
            cor_surx(j-k+1,k)=summ/(final-g-1);
        end
    end
end



figure
plot(mon,a,'LineWidth',1.5)
set(gca,'FontSize',14.0)
xlabel('Month','FontSize',14.0)
ylabel('a(t)','FontSize',14.0)

figure
plot(mon,N,'LineWidth',1.5)
set(gca,'FontSize',14.0)
xlabel('Month','FontSize',14.0)
ylabel('N(t)','FontSize',14.0)

figure
plot(yr,ft,'LineWidth',1.5)
set(gca,'FontSize',14.0)
grid on
xlabel('Year','FontSize',14.0)
ylabel('f(\tau)','FontSize',14.0)


yy=1870+1/12:1/12:2018;
figure
plot(yy,ori,'k','LineWidth',0.7)
hold
plot(yy,surrx(1:1776),'k--','LineWidth',0.7)
grid on
set(gca,'FontSize',14.0)
legend('NINO3.4 Index','Simulation')
xlim(gca,[1870 2018])
xlabel('Year','FontSize',14.0)
ylabel('NINO3','FontSize',14.0)

[px_o1,f]=pwelch(ori,480,120,240,12);
[px_s1,f]=pwelch(surrx,480,120,240,12);
[px_s2,f]=pwelch(surrx1,480,120,240,12);

figure
loglog(f,px_o1,'LineWidth',2.0)
hold
loglog(f,px_s1,'r','LineWidth',2.0)
grid on
legend('NINO3.4 Index','Simulation')
set(gca,'FontSize',18.0)
xlim(gca,[0.045 10])
ylim(gca,[0.0004,10])
xlabel('Frequency','FontSize',18.0)
ylabel('Power','FontSize',18.0)


xc=1:1:24;
yc=1:1:12;

figure
[C,h]=contourf(xc,yc,cor');
%colormap(darkb2r(0.2,1.0))
%set(gca,'XTickLabel',{'30','80','130','180','-130','-80','-30'})
set(h,'levelstep',0.02)
set(h,'LineColor','none')
colorbar
set(gca,'FontSize',18.0)
xlabel('Months Elapsed','FontSize',18.0)
ylabel('Start Month','FontSize',18.0)

figure
[C,h]=contourf(xc,yc,cor_nino');
%colormap(darkb2r(-0.2,1.0))
%set(gca,'XTickLabel',{'30','80','130','180','-130','-80','-30'})
set(h,'levelstep',0.02)
set(h,'LineColor','none')
colorbar
set(gca,'FontSize',18.0)
xlabel('Months Elapsed','FontSize',18.0)
ylabel('Start Month','FontSize',18.0)

figure
plot(yc,std(nino),'k','LineWidth',1.5)
hold
plot(yc,std(surx),'k--','LineWidth',1.5)
grid on
set(gca,'FontSize',18.0)
legend('NINO3.4 Index','Simulation')
xlim(gca,[1 12])
ylim(gca,[0.5,1.1])
xlabel('Month','FontSize',18.0)
ylabel('Std','FontSize',18.0)

figure
[hAx,hLine1,hLine2]=plotyy(yc,a,yc,N)
grid on
set(hAx,'xlim',[1 12])
xlabel('Month','FontSize',18.0)
ylabel(hAx(1),'a(t)','FontSize',18.0)
ylabel(hAx(2),'N(t)','FontSize',18.0)
set(hAx,'FontSize',18.0)
















