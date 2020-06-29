function opt_model = fluct_dist(filepath_in,folder_out,varnames,data_name)
%
% FUNCTION: fluct_dist(filepath_in,varnames,data_name,folder_out)
%
% PURPOSE: analyze the distribution of fluctuation sizes in a time series
%
% INPUT:
% - filepath_in: climate data file to read from (complete path + filename)
% - folder_out: folder in which to output Fq vs. t to (ONLY folder path; function constructs filename!)
% - varnames: column titles to access from data table (needs to be cell array of char arrays, i.e. 'Xvarname' not "Xvarname")
% - data_name: nametag of the data set you're using; used to create output filename
%
% OUTPUT:
% - opt_model: struct containing info about the best-fit distribution type for the fluctuation PDF histogram
%

    close all;

    [X,Y] = load_data(filepath_in, varnames);

    % Calculate the fluctuation steps in the time series
    fluctuations = zeros(length(Y)-1,1);
    for i=1:length(Y)-1
        fluctuations(i) = abs(Y(i+1)-Y(i));
    end
    % fluctuations = cell2mat(fluctuations);
    
    % Save fluctuation plot figure
    plot(X(1:end-1),fluctuations);
    saveas(gcf,sprintf("%s%s_FluctPlot.fig",folder_out,data_name));
    close all;

    % Make histogram
    histogram(fluctuations,50);
    
    % Set up plot
    xlabel("Fluctuation magnitude");
    ylabel("Counts");
    set(gcf, 'Position',  [0, 0, 1000, 800]);

    % Save histogram figure
    writeup_figs_folder = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\write-up\figures\";
    saveas(gcf, sprintf("%s%s_FluctHist.fig",folder_out,data_name));
    saveas(gcf, sprintf("%s%s_FluctHist.png",writeup_figs_folder,data_name));
    close all;

    % Assess which model best fits the data using 'allfitdist' from file exchange
    [D,~] = allfitdist(fluctuations,'PDF');
    opt_model = D(1);

end