function [obj_arr,mset_arr] = make_objs()

    % make object for each dataset
    data_names = ["epica-co2", "epica-ch4", "epica-temp"];
    user_id = "NK";
    obj_arr = {};
    mset_arr = {};

    for j=1:length(data_names)
        obj_arr{j} = DataSet("data",user_id, data_names(j));
        mset_arr{j} = {"makima", obj_arr{j}.data_res, 2};
    end

end

