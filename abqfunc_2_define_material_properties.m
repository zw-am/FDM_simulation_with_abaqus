function [cp,rho,conduc,E,mu,CTE,convec,Te,Tm,Ts] = abqfunc_2_define_material_properties(flag_0)
switch flag_0
    case 1 % properties from Zhang and Chou (2006) Proc. IMechE Vol. 220 Part B: J. Engineering Manufacture
        format compact
        cp      = [1.62e3, 0;1.62e3 105;3e3 130;1.68e3 280]       % special heat at 130 degC, (J/(kg*K))
        rho     = [1200]       % density, (kg/m^3)
        conduc  = [0.19]       % conductivity, (W/(m*K))
        convec  = [120]         % convection coefficient (W/m^2 K)
        Te      = 260        % extrusion temperature (K)
        Tm      = 40         % ambient chamber temperature (K)
        Ts      = 40         % subtrate temperature (K)
    case 2
        format compact
        cp      = [2000;2000]       % special heat at 130 degC, (J/(kg*K))
        rho     = [1320;1270]       % density, (kg/m^3)
        conduc  = [0.25;0.2]       % conductivity, (W/(m*K))
        E       = [3.9e9;2.78e9];
        mu      = [0.38;0.36];
        CTE     = [150e-6;45e-6];
        convec  = [86]         % convection coefficient (W/m^2 K)
        Te      = 400          % extrusion temperature (K)
        Tm      = 100         % ambient chamber temperature (K)
        Ts      = 100         % subtrate temperature (K)

    case 3
        inp_01  = inputdlg({'Please enter the material specific heat (J/kg K): ',...
                            'Please enter the material density (kg/m^3): ',...
                            'Please enter the material thermal conductivity (W/m K): ',...
                            'Please enter the material thermal convection coefficient (W/m^2 K): ',...
                            'Please enter the material extrusion temperature (T): ',...
                            'Please enter the ambient air temperature (T): ',...
                            'Please enter the material substrate temperature (T): '});
        cp      = str2num(inp_01{1}); % special heat, (J/(kg*K))
        rho     = str2num(inp_01{2}); % density, (kg/m^3)
        conduc  = str2num(inp_01{3}); % conductivity, (W/(m*K))
        convec  = str2num(inp_01{4}); % convection, (W/(m^2*K))
        Te      = str2num(inp_01{5}); % extrusion temperature (K)
        Tm      = str2num(inp_01{6}); % ambient chamber temperature (K)
        Ts      = str2num(inp_01{7}); % subtrate temperature (K)
    case 0
        error('the user did not make any dicision!');
end