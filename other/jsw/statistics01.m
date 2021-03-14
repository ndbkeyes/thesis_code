clear all

a=load('nino34.txt');
b=load('ido.txt');

aa=a(1:148,2:13);
bb=b(1:148,2:13);

nino=aa/max(std(aa));
ido=bb/max(std(bb));

init=1;
fin=148;
tnum=40;
delt=1/12;

[a_nino,N_nino,autof,ftau_nino,Pnino,weather_nino]=findanf(nino,init,fin,tnum);
[a_ido,N_ido,autof,ftau_ido,Pido,weather_ido]=findanf(ido,init,fin,tnum);

S_nino=var(nino);
S_ido=var(ido);

for k=1:12
    summ=0.0;
    for i=1:148
        summ=summ+nino(i,k)*ido(i,k);
    end
    S_ni(k)=summ/147;
end

for k=1:12
    summ=0.0;
    for i=1:147
        if k==12
            summ=summ+nino(i+1,1)*nino(i,k);
        else
            summ=summ+nino(i,k+1)*nino(i,k);
        end
    end
    A_nn(k)=summ/146;
end

for k=1:12
    summ=0.0;
    for i=1:147
        if k==12
            summ=summ+nino(i+1,1)*ido(i,k);
        else
            summ=summ+nino(i,k+1)*ido(i,k);
        end
    end
    A_in(k)=summ/146;
end

for k=1:12
    summ=0.0;
    for i=1:147
        if k==12
            summ=summ+nino(i+1,2)*ido(i,k);
        elseif k==11
            summ=summ+nino(i+1,1)*ido(i,k);
        else
            summ=summ+nino(i,k+2)*ido(i,k);
        end
    end
    A_in2(k)=summ/146;
end

for k=1:12
    summ=0.0;
    for i=1:147
        if k==12
            summ=summ+ido(i+1,1)*ido(i,k);
        else
            summ=summ+ido(i,k+1)*ido(i,k);
        end
    end
    A_ii(k)=summ/146;
end

for k=1:12
    summ=0.0;
    for i=1:147
        if k==12
            summ=summ+ido(i+1,1)*nino(i,k);
        else
            summ=summ+ido(i,k+1)*nino(i,k);
        end
    end
    A_ni(k)=summ/146;
end

for k=1:12
    B(1,1)=S_nino(k);
    B(1,2)=S_ni(k)-S_nino(k);
    B(2,1)=S_ni(k);
    B(2,2)=S_ido(k)-S_ni(k);
    
    Y(1,1)=(A_nn(k)-S_nino(k))*12.0;
    Y(2,1)=(A_in(k)-S_ni(k))*12.0;
    
    X=inv(B)*Y;
    aN(k)=X(1);
    bN(k)=X(2);
end 

for k=1:12
    B(1,1)=S_ido(k);
    B(1,2)=S_ni(k)-S_ido(k);
    B(2,1)=S_ni(k);
    B(2,2)=S_nino(k)-S_ni(k);
    
    Y(1,1)=(A_ii(k)-S_ido(k))*12.0;
    Y(2,1)=(A_ni(k)-S_ni(k))*12.0;
    
    X=inv(B)*Y;
    aI(k)=X(1);
    bI(k)=X(2);
end 

%% calculation of the noise intensity N(t)
delt=1/12;
for k=1:12
   if k==12
       NN(k)=(S_nino(1)-A_nn(k))/delt - aN(k)*A_nn(k)-bN(k)*(A_in(k)-A_nn(k));
   else
       NN(k)=(S_nino(k+1)-A_nn(k))/delt - aN(k)*A_nn(k)-bN(k)*(A_in(k)-A_nn(k));
   end
   NN(k)=sqrt(NN(k));
end

for k=1:12
   if k==12
       NI(k)=(S_ido(1)-A_ii(k))/delt - aI(k)*A_ii(k)-bI(k)*(A_ni(k)-A_ii(k));
   else
       NI(k)=(S_ido(k+1)-A_ii(k))/delt - aI(k)*A_ii(k)-bI(k)*(A_ni(k)-A_ii(k));
   end
   NI(k)=sqrt(NI(k));
end

%% simulation and comparison

for i=1:148
    for k=1:12
        nn=12*(i-1)+k;
        ori_nino(nn)=nino(i,k);
        ori_ido(nn)=ido(i,k);
    end
end

wxn=randn(148*12);
wxi=randn(148*12);

surrxn(1)=ori_nino(1);
surrxi(1)=ori_ido(1);

tot_num = 148*12-1;
delt=1/12;

for i=1:tot_num
    k=mod(i,12);
    if k==0
        k=12;
    end
    surrxn(i+1)=surrxn(i)+aN(k)*surrxn(i)*delt+NN(k)*sqrt(delt)*wxn(i);
    surrxn(i+1)=surrxn(i+1)+bN(k)*(surrxi(i)-surrxn(i))*delt;
    
    surrxi(i+1)=surrxi(i)+aI(k)*surrxi(i)*delt+NI(k)*sqrt(delt)*wxi(i);
    surrxi(i+1)=surrxi(i+1)+bI(k)*(surrxn(i)-surrxi(i))*delt;
end

for i=1:148
    for k=1:12
        nn=12*(i-1)+k;
        simul_nino(i,k)=surrxn(nn);
        simul_ido(i,k)=surrxi(nn);
    end
end

simul_nino_std=std(simul_nino);
simul_ido_std=std(simul_ido);


for k=1:12
    summ=0.0;
    for i=1:148
        summ=summ+simul_nino(i,k)*simul_ido(i,k);
    end
    simul_cor(k)=summ/147;
end

mon=1:1:12;

figure
plot(mon,aN,'k','LineWidth',2.0)
hold
plot(mon,bN,'k-.','LineWidth',2.0)
plot(mon,aN-bN,'k--','LineWidth',2.0)
plot(mon,a_nino,'k:','LineWidth',2.0)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1 12])
legend('a_1(t)','b_{12}(t)','a_1(t)-b_{12}(t)','a_{Nino3.4}')
xlabel('Month','FontSize',18.0)

figure
plot(mon,aI,'k','LineWidth',2.0)
hold
plot(mon,bI,'k-.','LineWidth',2.0)
plot(mon,aI-bI,'k--','LineWidth',2.0)
plot(mon,a_ido,'k:','LineWidth',2.0)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1 12])
legend('a_2(t)','b_{21}(t)','a_2(t)-b_{21}(t)','a_{IOD}')
xlabel('Month','FontSize',18.0)

time=1870+1/12:1/12:1870+148;
figure
plot(time,ori_nino,'k','LineWidth',0.7)
hold
plot(time,surrxn,'k--','LineWidth',0.7)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1870 2018])
legend('Nino3.4','Simulation')
xlabel('Time','FontSize',18.0)
ylabel('Nino index','FontSize',18.0)


figure
plot(time,ori_ido,'k','LineWidth',0.7)
hold
plot(time,surrxi,'k--','LineWidth',0.7)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1870 2018])
legend('IOD','Simulation')
xlabel('Time','FontSize',18.0)
ylabel('IOD index','FontSize',18.0)

figure
plot(mon,sqrt(S_nino),'k','LineWidth',2.0)
hold
plot(mon,simul_nino_std,'k--','LineWidth',2.0)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1 12])
legend('Nino3.4','Simulation')
xlabel('Month','FontSize',18.0)
ylabel('Std','FontSize',18.0)

figure
plot(mon,sqrt(S_ido),'k','LineWidth',2.0)
hold
plot(mon,simul_ido_std,'k--','LineWidth',2.0)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1 12])
legend('IOD','Simulation')
xlabel('Month','FontSize',18.0)
ylabel('Std','FontSize',18.0)

figure
plot(mon,S_ni,'k','LineWidth',2.0)
hold
plot(mon,simul_cor,'k--','LineWidth',2.0)
grid on
set(gca,'FontSize',18.0)
xlim(gca,[1 12])
legend('Nino-IOD Covariance','Simulation')
xlabel('Month','FontSize',18.0)
ylabel('Covariance','FontSize',18.0)













