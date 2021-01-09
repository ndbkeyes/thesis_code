function obj2 = deriv_obj(userid, dataname)

    obj1 = DataSet("data",userid,dataname);

    [t,x] = load_data(obj1);
    xprime = gradient(x(1:end-1));
    tprime = t(1:end-1);
    
    obj2 = DataSet("vbl", tprime, xprime, sprintf("deriv-%s",dataname));
    
%     mftwdfa_settings = {"makima",obj2.data_res,2};
%     run_mftwdfa(obj2,mftwdfa_settings);
        
end