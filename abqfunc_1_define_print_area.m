function [Lx,Lz,Ly,delt,x,y,z,x_mat] = abqfunc_1_define_print_area(flag_00)
switch flag_00
    case 1
        Lx      = 0.2e-3;    % bead thickness (m) 0.2mm
        Lz      = 0.4e-3;    % bead width(m) 0.4mm
        uv      = 40e-3;   % nozzle moving speeding (m/s)
        delt    = 0.02;     % unit moving time (sec. per unit)
        Ly      = uv*delt; % bead length
%         delt    = 0.1/5;   % watch out! the step increment is reduced to 1/5
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % seeding along x,y,z directions;
        x = 4+1; % element along x-direction is x-1
        x_mat = [1,1;...% 1 = PEEK
                 2,2;...
                 3,1;...
                 4,2];  % 2 = PEI
        y = 10+1;% element along y-direction is y-1 
        z = 10+1; % element along z-direction is z-1
    case 2
        inp_0   = inputdlg({'Please enter the bead width(m): ',...
                            'Please enter the bead thickness(m): ',...
                            'Please enter the nozzle moving speed(m/s): ',...
                            'Please enter the nozzle unit moving time(sec. per unit): '});
        Lx      = str2num(inp_0{1});
        Lz      = str2num(inp_0{2});
        uv      = str2num(inp_0{3});
        delt    = str2num(inp_0{4});
        Ly      = uv*delt;
        delt    = delt./10; % watch out! the step increment is reduced to 1/10
        % seeding along x,y,z directions;
        inp_1 = inputdlg({'Please enter the seeds along x-direction: ',...
                          'Please enter the seeds along y-direction: ',...
                          'Please enter the seeds along z-direction: '});
        x = str2num(inp_1{1})+1;% element along x-direction is x-1
        y = str2num(inp_1{2})+1;% element along y-direction is y-1 
        z = str2num(inp_1{3})+1;% element along z-direction is z-1
    case 0 
        error('the user did not make any dicision!');
end