m_arr = linspace(1,10,10);
legend_cell = string(num2cell(m_arr));
legend_cell{end+1} = 'a_{est}';
legend(legend_cell);