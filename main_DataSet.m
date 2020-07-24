warning('off','all');
close all;


results_folder = "C:\Users\Nash\Dropbox\_NDBK\Research\mftwdfa\results\";

CO2_Data = DataSet("co2", results_folder);
CH4_Data = DataSet("ch4", results_folder);
Temperature_Data = DataSet("temperature", results_folder);

hold on;
plot(CO2_Data.X, CO2_Data.Y);
plot(CH4_Data.X, CH4_Data.Y);
plot(Temperature_Data.X, Temperature_Data.Y);
legend("CO2", "CH4", "Temperature");