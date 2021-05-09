function abN = coupling_3D_REDO(obj1,obj2,obj3,Y,M,br_win,plotting)
%
% FUNCTION: [a1, a2, b12, b21] = coupling_2D(obj1, obj2)
%
% PURPOSE: perform coupling analysis on the 2 inputted data sets
%
% INPUT: 
% - obj1, obj2: DataSet objects holding the data sets we want to analyze coupling for
%
% OUTPUT:
% - a1: stability of 1st set
% - a2: stability of 2nd set
% - b12: influence of 2nd set on 1st set
% - b21: influence of 1st set on 2nd set
%

    if nargin == 5
        br_win = 0;
        plotting = 0;
    elseif nargin == 6
        plotting = 0;
    end
    

    % get year/month averaged datasets
    % x-values should be same since Y,M are equal so just use from n1
    [~,n1_y,delt] = data2matrix(obj1,Y,M,br_win);
    [~,n2_y,~] = data2matrix(obj2,Y,M,br_win);
    [~,n3_y,~] = data2matrix(obj3,Y,M,br_win);
    

%     close all;
%     figure(1);
%     hold on;
%     plot(reshape(n1_x',[],1),reshape(n1_y',[],1));
%     plot(reshape(n2_x',[],1),reshape(n2_y',[],1));

    
    %% make empty arrays for all quantities
    
    AA = zeros(1,M);
    BB = zeros(1,M);
    CC = zeros(1,M);
    AB = zeros(1,M);
    AC = zeros(1,M);
    BC = zeros(1,M);
    
    AAdt = zeros(1,M);
    ABdt = zeros(1,M);
    ACdt = zeros(1,M);
    BAdt = zeros(1,M);
    BBdt = zeros(1,M);
    BCdt = zeros(1,M);
    CAdt = zeros(1,M);
    CBdt = zeros(1,M);
    CCdt = zeros(1,M);
    
    
    ADA = zeros(1,M);
    ADB = zeros(1,M);
    ADC = zeros(1,M);
    BDA = zeros(1,M);
    BDB = zeros(1,M);
    BDC = zeros(1,M);
    CDA = zeros(1,M);
    CDB = zeros(1,M);
    CDC = zeros(1,M);
    
    AdtDA = zeros(1,M);
    BdtDB = zeros(1,M);    
    CdtDC = zeros(1,M);    
    
    a1 = zeros(1,M);
    a2 = zeros(1,M);
    a3 = zeros(1,M);
    b12 = zeros(1,M);
    b13 = zeros(1,M);
    b21 = zeros(1,M);
    b23 = zeros(1,M);
    b31 = zeros(1,M);
    b32 = zeros(1,M);
    N1 = zeros(1,M);
    N2 = zeros(1,M);
    N3 = zeros(1,M);

    
    
    
    for k=1:M
        

    %% get quantities to use in system

        
        
        %---- make base arrays ----%

        % if month isn't last - go to month + 1
        if k ~= M
            A = n1_y(:,k);
            B = n2_y(:,k);
            C = n3_y(:,k);
            Adt = n1_y(:,k+1);
            Bdt = n2_y(:,k+1);
            Cdt = n3_y(:,k+1);
            
        % if month is last - wrap around!
        else
            A = n1_y(1:end-1,M);
            B = n2_y(1:end-1,M);
            C = n3_y(1:end-1,M);
            Adt = n1_y(2:end,1);
            Bdt = n2_y(2:end,1);
            Cdt = n3_y(2:end,1);
        end
        
        
        DA = ( Adt - A ) ./ delt;
        DB = ( Bdt - B ) ./ delt;
        DC = ( Cdt - C ) ./ delt;
        
        
        %---- derived quantities ----%

        AA(k) = mean( A .* A );
        AB(k) = mean( A .* B );
        AC(k) = mean( A .* C );
        BB(k) = mean( B .* B );
        BC(k) = mean( B .* C );
        CC(k) = mean( C .* C );
        
        
        AAdt(k) = mean( A .* Adt );
        ABdt(k) = mean( A .* Bdt );
        ACdt(k) = mean( A .* Cdt );
        BAdt(k) = mean( B .* Adt );
        BBdt(k) = mean( B .* Bdt );
        BCdt(k) = mean( B .* Cdt );
        CAdt(k) = mean( C .* Adt );
        CBdt(k) = mean( C .* Bdt );
        CCdt(k) = mean( C .* Cdt );
        
        ADA(k) = mean( A .* DA );
        BDA(k) = mean( B .* DA );
        CDA(k) = mean( C .* DA );
        ADB(k) = mean( A .* DB );
        BDB(k) = mean( B .* DB );
        CDB(k) = mean( C .* DB );
        ADC(k) = mean( A .* DC );
        BDC(k) = mean( B .* DC );
        CDC(k) = mean( C .* DC );
        
        AdtDA(k) = mean( Adt .* DA );
        BdtDB(k) = mean( Bdt .* DB );
        CdtDC(k) = mean( Cdt .* DC );
        
    
    
    %% solve system for a1,2 and b12,21
    
        %%% A MATRICES
        A1 = [ AA(k), AB(k) - AA(k), AC(k) - AA(k); 
               AB(k), BB(k) - AB(k), BC(k) - AB(k);
               AC(k), BC(k) - AC(k), CC(k) - AC(k) ];
        A2 = [ AB(k), AA(k) - AB(k), AC(k) - AB(k); 
               BB(k), AB(k) - BB(k), BC(k) - BB(k);
               BC(k), AC(k) - BC(k), CC(k) - BC(k) ];
        A3 = [ AC(k), AA(k) - AC(k), AB(k) - AC(k);
               BC(k), AB(k) - BC(k), BB(k) - BC(k);
               CC(k), AC(k) - CC(k), BC(k) - CC(k) ];

        %%% Q VECTORS
        Q1 = [ ADA(k);
               BDA(k);
               CDA(k) ];
        Q2 = [ ADB(k); 
               BDB(k);
               CDB(k) ];
        Q3 = [ ADC(k); 
               BDC(k);
               CDC(k) ];

        %%% X vectors
        X1 = A1\Q1;
        X2 = A2\Q2;
        X3 = A3\Q3;


        % unpack coefficients from X
        a1(k) = X1(1);   % set1 local stability
        b12(k) = X1(2);  % set2 -> set1 influence
        b13(k) = X1(3);  
        
        a2(k) = X2(1);   % set2 local stability
        b21(k) = X2(2);  % set1 -> set2 influence
        b23(k) = X2(3);
        
        a3(k) = X3(1);
        b31(k) = X3(2);
        b32(k) = X3(3);


        
    %% derive N1,2(k)
    
    
        N1sq = AdtDA(k) - a1(k) * AAdt(k) - b12(k) * ( BAdt(k) - AAdt(k) ) - b13(k) * ( CAdt(k) - AAdt(k) );
        N2sq = BdtDB(k) - a2(k) * BBdt(k) - b21(k) * ( ABdt(k) - BBdt(k) ) - b23(k) * ( CBdt(k) - BBdt(k) );
        N3sq = CdtDC(k) - a3(k) * CCdt(k) - b31(k) * ( ACdt(k) - CCdt(k) ) - b32(k) * ( BCdt(k) - CCdt(k) );

        if N1sq < 0
            N1(k) = 0;
        else
            N1(k) = sqrt(N1sq);
        end
        
        if N2sq < 0
            N2(k) = 0;
        else
            N2(k) = sqrt(N2sq);
        end
        
        if N3sq < 0
            N3(k) = 0;
        else
            N3(k) = sqrt(N3sq);
        end


    end

    
    % package the parameter arrays to be returned
    % (first row is a1, second row is a2, etc)
    abN = [a1; a2; a3; b12; b13; b21; b23; b31; b32; N1; N2; N3];
    
    % smoothing data
    abN = smooth_periodic(abN,M/2);
    
    
    
    %% plotting coefficient results, if desired
    
    if plotting
        
        figure(2);
        
        a1 = abN(1,:);
        a2 = abN(2,:);
        a3 = abN(3,:);
        b12 = abN(4,:);
        b13 = abN(5,:);
        b21 = abN(6,:);
        b23 = abN(7,:);
        b31 = abN(8,:);
        b32 = abN(9,:);
        N1 = abN(10,:);
        N2 = abN(11,:);
        N3 = abN(12,:);
    
        % plot for dataset 1
        
        tiledlayout("flow");
        
        nexttile
        hold on;
        plot(a1);
        plot(b12);
        plot(b13);
        plot(a1-b12-b13);
        xlim([1,M]);
        legend("a1","b12","a1 - b12 - b13");
        title(sprintf("3D coupled stability for 1) %s, coupled to 2) %s", obj1.data_name, obj2.data_name));
        %saveas(gcf, sprintf("coupling2d_%s_%s_%d-%d.jpeg", obj1.data_name, obj2.data_name, Y,M));

        % plot for dataset 2
        nexttile
        hold on;
        plot(a2);
        plot(b21);
        plot(b23);
        plot(a2-b21-b23);
        xlim([1,M]);
        legend("a2","b21","b23","a2 - b21 - b23");
        title(sprintf("3D coupled stability for 2) %s, coupled to 1) %s",  obj2.data_name, obj1.data_name));
        saveas(gcf, sprintf("coupling2d_%s_%s_%d-%d.jpeg", obj2.data_name, obj1.data_name, Y,M));
        
        % plot for dataset 3
        nexttile
        hold on;
        plot(a3);
        plot(b31);
        plot(b32);
        plot(a3-b31-b32);
        xlim([1,M]);
        legend("a3","b31","b32","a3 - b31 - b32");
        title(sprintf("3D coupled stability for 3) %s, coupled to 1) %s",  obj2.data_name, obj1.data_name));
        saveas(gcf, sprintf("coupling2d_%s_%s_%d-%d.jpeg", obj2.data_name, obj1.data_name, Y,M));
        
        
        % plot for noise quantities
        nexttile
        hold on;
        plot(N1);
        plot(N2);
        plot(N3);
        xlim([1,M]);
        legend("N1","N2","N3");
        title(sprintf("3D coupled noise"));


    end
    

end

