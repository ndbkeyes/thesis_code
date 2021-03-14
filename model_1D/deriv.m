close all;
hold on;

obj1 = DataSet("data","NK","epica-co2");
mftwdfa_settings = {"makima",obj1.data_res,2};
[s1,F1] = read_data(obj1,mftwdfa_settings);

[t,x] = load_data(obj1);
xprime = gradient(x(1:end-1));
tprime = t(1:end-1);
figure(1);
hold on;
plot(t,x);
plot(tprime,xprime);

obj2 = DataSet("vbl", tprime, xprime, "deriv");
mftwdfa_settings = {"makima",1000,2};
[s2,F2] = read_data(obj2,mftwdfa_settings);
plot(log10(s1),log10(F1));
plot(log10(s2),log10(F2));