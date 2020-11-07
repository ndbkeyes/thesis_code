function [a,N,autof,ftau,P,weather]=findanf(x,init,fin,tnum)

    final=fin-init+1;   % number of data points? or years?
    delt=1.0/12.0;      % timegap between months

    num=12;             % number of months

    %% find inter-year autocorrelation between j years  -->  used in B(k)

    for k=1:num
        for j=1:tnum
            summ=0.0;
            nn=0;
            for i=1:final-j+1
                if (abs(x(i,k))<300.0) && (abs(x(i+j-1,k))<300.0)
                    nn=nn+1;  
                    summ=summ+x(i,k)*x(i+j-1,k);
                end
            end
            atcorr(j,k)=summ/nn;
        end
    end


    %% find S(k) = variance

    for k=1:num
        summ=0.0;
        nn=0;
        for j=1:final
            if abs(x(j,k)) < 300.0
                nn=nn+1;
                summ=summ+x(j,k)*x(j,k);
            end
        end
        S(k) = summ/(nn-1);
    end


    %% find A(k) = inter-month correlation

    for k=1:num
        summ=0.0;
        nn=0;
        for j=1:final-1 
            if k==num
                if (abs(x(j,k)) < 300.0) && (abs(x(j+1,1)) < 300.0)
                    nn=nn+1;   
                    summ=summ+x(j,k)*x(j+1,1);
                end
            else
                if (abs(x(j,k)) < 300.0) && (abs(x(j,k+1)) <300.0)
                    nn=nn+1;   
                    summ=summ+x(j,k)*x(j,k+1);
                end 
            end 
        end
        A(k) = summ/(nn-1);
    end


    %% find B(k) = inter-year autocorrelation (between m=2 years!)

    for k=1:num
        B(k)=atcorr(2,k);
    end


    %% find derived quantities G and H from A, B, S

    for k=1:num
        G(k)=1/delt*(S(k)-A(k))/S(k);
        H(k)=(S(k)-B(k))/S(k);
    end



    %% find P using RK4

    PP(1)=0.0;
    for i=1:100*num-1

        imod=mod(i,num);
        if imod==0
            ii=num;
        else
            ii=imod;
        end

        if ii==num
            k1 = -G(ii)*PP(i) + H(ii);
            k2 = -0.5 * (G(ii)+G(1)) * (PP(i)+0.5*delt*k1) + 0.5 * (H(ii)+H(1));
            k3 = -0.5 * (G(ii)+G(1)) * (PP(i)+0.5*delt*k2) + 0.5 * (H(ii)+H(1));
            k4 = -G(1) * (PP(i)+delt*k3) + H(1);
            PP(i+1) = PP(i) + delt/6.0*(k1+2*k2+2*k3+k4);
        else
            k1 = -G(ii) * PP(i) + H(ii);
            k2 = -0.5 * (G(ii)+G(ii+1)) * (PP(i)+0.5*delt*k1) + 0.5 * (H(ii)+H(ii+1));
            k3 = -0.5 * (G(ii)+G(ii+1)) * (PP(i)+0.5*delt*k2) + 0.5 * (H(ii)+H(ii+1));
            k4 = -G(ii+1) * (PP(i)+delt*k3) + H(ii+1);
            PP(i+1) = PP(i) + delt/6.0 * (k1+2*k2+2*k3+k4);
        end
    end

    for k=1:num
       P(k)=PP(num*99+k);
    end 


    
    %% find a from P

    for k=1:num
        a(k)=1/P(k)*(-G(k)*P(k)+H(k)-1.0);
    end



    %% find N(k) = noise amplitude

    for k=1:num
        if k==num
            N(k)=(S(1)-A(k))/delt+P(1)/P(k)*(S(k)-A(k))/delt;
            N(k)=N(k)-a(k)*A(k)+P(1)/P(k)*a(k)*S(k);
            if N(k) < 0
             N(k)=0.0;
            else
             N(k)=sqrt(N(k));
            end
        else
            N(k)=(S(k+1)-A(k))/delt+P(k+1)/P(k)*(S(k)-A(k))/delt;
            N(k)=N(k)-a(k)*A(k)+P(k+1)/P(k)*a(k)*S(k);
            if N(k) < 0
             N(k)=0.0;
            else
             N(k)=sqrt(N(k));
            end
        end
    end


    
    %% find f(tau) = long-term backbone forcing

    for j=1:final
        summ=0.0;
        for k=1:num
            if k==num
                summ=summ+(x(j,k)-x(j,k-1))/delt-a(k)*x(j,k);
            else
                summ=summ+(x(j,k+1)-x(j,k))/delt-a(k)*x(j,k);
            end
        end
        ftau(j)=summ/num;
    end
    
    
    
    %% idk why the following are useful / what they mean

    for k=1:num
        SB(k)=S(k)-B(k);
    end

    for j=1:tnum-1
        summ1=0.0;
        summ2=0.0;
        for k=1:num
            summ1=summ1+P(k)^4;
            summ2=summ2+atcorr(j+1,k)*P(k)^2;
        end
        autof(j)=summ2/summ1;
        log_auto(j)=log(autof(j));
    end

    for k=1:num
        summ=0.0;
        for j=1:k
            summ=summ+a(j)*delt;
        end
        summa(k)=summ;
        exp2a(k)=exp(2*summ);
    end

    for j=1:final-1
        for k=1:num
            if k==num
                weather(j,k)=(x(j+1,1)-x(j,k))/delt-a(k)*x(j,k)-ftau(j);
            else
                weather(j,k)=(x(j,k+1)-x(j,k))/delt-a(k)*x(j,k)-ftau(j);
            end
        end
    end


end

