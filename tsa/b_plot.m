function b_plot(obj,Y,M)

    [~,data,~,~] = data2matrix(obj,Y,M);

    %% find B(m) = inter-year autocorrelation of month m (between years y and y+i)

    hold on;
    for i=1:floor(Y/2)
        B = zeros(M,1);
        for m=1:M
            summ = 0;
            for y=1:Y-i
                summ = summ + data(y,m) * data(y+i,m);
            end
            B(m) = summ / (Y-i-1);
        end
        plot(B);
    end
    legend("1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19");

end