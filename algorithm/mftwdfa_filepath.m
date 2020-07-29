function filepath_out = mftwdfa_filepath(obj,mftwdfa_settings)
%
% FUNCTION: mftwdfa_filepath(folder_out,data_name,mftwdfa_settings)
%
% PURPOSE: create full filepath for MFTWDFA data file to be outputted
%
% INPUT:
% - folder_out: folder in which the MFTWDFA data is located
% - data_name: nametag of the data series to be read
% - mftwdfa_settings: array of settings for the MFTWDFA run desired -- cell array in form {interp_scheme, data_res, q}
% 
% OUTPUT:
% - filepath_out: full filepath for MFTWDFA data file with given settings for input dataset and MFTWDFA run
%

    interp_scheme = mftwdfa_settings{1};
    data_res = mftwdfa_settings{2};
    q = mftwdfa_settings{3};

    filepath_out = sprintf("%s%s_mftwdfa_%s-%d-%d.txt", obj.folder_out, obj.data_name, interp_scheme,data_res,q);

end