function fout = mftwdfa_filepath(folder_out,data_name,settings)
% filepath_out: generates FULL path for file to write MFTWDFA data to
%
% INPUT:
% - folder_out: folder to put file in
% - data_name: the name of the data series being used (e.g. "CO2")
% - settings: cell array of settings for MFTWDFA - {interp_scheme, data_res, q}
%
% OUTPUT:
% - full path of output file, of form (folder_out + data_name +
% "_mftwdfa_" + interp_scheme + data_res + q + ".txt")

    interp_scheme = settings{1};
    data_res = settings{2};
    q = settings{3};

    fout = sprintf("%s%s_mftwdfa_%s-%d-%d.txt",folder_out,data_name,interp_scheme,data_res,q);

end