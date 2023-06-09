%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function helps  the user defining an abaqus input file to simulate
% the fused filament fabrication (FFF) thermal-mechanical process in abaqus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Log
% initialized in Nov 2014 by Zhaogui Wang
% revised Dr Zhaogui Wang on Apr 2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% version 1.000, edited on Apr 21, 2021 by DRZW
% Note, this version only analysis the transient thermal history (e.g.,
% temperature) of the print-area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clean screen and workspace 
clear all; close all; clc; fclose all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Header
fprintf('This function helps you generating a .inp file to simulate the fused filament fabrication process via ABAQUS\n');
fprintf('\n');
% Define constants
% dimensions of printed area
fprintf('The default print-area is in 6by10, where 10 beads printed along y axis sequentially, and then repeat along x axis 6 times\n'); 
flag_00  = menu('Would you like to use the default print-area setting?','Yes','No');
[Lx,Lz,Ly,delt,x,y,z,x_mat] = abqfunc_1_define_print_area(flag_00); % check the subroutine for detail

% material properties and printing info.
flag_0  = menu('Would you like to use the default material settings(i.e., ABS)?','Yes','PEEK&PEI','No');
[cp,rho,conduc,E,mu,CTE,convec,Te,Tm,Ts] = abqfunc_2_define_material_properties(flag_0); % check the subroutine for detail
cp_1 = cp(1);cp_2 = cp(2);
rho_1= rho(1);rho_2=rho(2);
conduc_1=conduc(1);conduc_2=conduc(2);
E_1 = E(1); E_2 = E(2);
mu_1=mu(1);mu_2 = mu(2);
CTE_1=CTE(1);CTE_2=CTE(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create the finite element domain
% define the dimensions of print-area
X = Lx*x; % length of printed area along x-direction
Y = Ly*y; % length of printed area along y-direction
Z = Lz*z; % length of printed area along z-direction
% generate nodes and elements
% define Nodes
[Node_Set,Elem_Set,Elem_seq] = abqfunc_3_generate_domain(x,y,z,X,Y,Z);
% Display Elem_Set (see your elements)
% figure; hold on;                    % create a figure window
% patchHEX(Node_Set,Elem_Set);        % plot the elements in 3D space
% xlabel('x');ylabel('y');zlabel('z');% labeling the x,y,z axis
% view([45 60]);                      % change the position of view
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create a .inp file for ABAQUS simulation
fid = fopen(['FFF_Simulation_',date,'.inp'],'w'); % open a new file (blank file), the name of the file is defined in "[xxx]"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% write the heading info. of the input file 
fprintf(fid,'*Heading\n');
fprintf(fid,'** Job name: print_a_block Model name: Model-1\n');
fprintf(fid,'** Generated by: Abaqus/CAE 6.14-2\n');
fprintf(fid,'*Preprint, echo=NO, model=NO, history=NO, contact=NO\n');
fprintf(fid,'**\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% generate a Part 
fprintf(fid,'** PARTS\n');
fprintf(fid,'**\n');
fprintf(fid,'*Part, name=block\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the node information into abaqus, note that the set Node_Set is
% created from Line 33, abqfunc_3_generate_domain
fprintf(fid,'*NODE, NSET=All_Node\n');
for i = 1:(x*y*z)
    fprintf(fid,'%5.0f, %3.12f, %3.12f, %3.12f\n',...
    Node_Set(i,1,1),Node_Set(i,2:4,1));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load the element information into abaqus,note that the set Elem_Set is
% created from Line 33, abqfunc_3_generate_domain
fprintf(fid,'*ELEMENT, TYPE=C3D8RT\n');
for i = 1:((x-1)*(y-1)*(z-1))
    fprintf(fid,...
    '%5.0f, %5.0f, %5.0f, %5.0f, %5.0f, %5.0f, %5.0f, %5.0f, %5.0f\n',...
    i,Elem_Set(i,2:9,1));
end

n_elem = 0;
for j = 1:(x-1)
    fprintf(fid,'*ELSET, elset=All_Elem_z%d, generate\n',j);
    fprintf(fid,'%5.0f, %5.0f, 1\n',1+(y-1)*(z-1)*(j-1),j*(y-1)*(z-1));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Section assignment
for j = 1:(x-1)
fprintf(fid,'** Section: Section-block\n');
fprintf(fid,'*Solid Section, elset=All_Elem_z%d, material=mat_%d\n',x_mat(j,1),x_mat(j,2));% I name my material as ABS, it could be changed as you wish.
fprintf(fid,',\n');
end
% % % for j = 1:(z-1)
% % % fprintf(fid,'** Section: Section-block\n');
% % % if mat_flag(j,2) == 1
% % %     fprintf(fid,'*Solid Section, elset=All_Elem_z%d, material=PEEK\n',j);% I name my material as ABS, it could be changed as you wish.
% % % elseif mat_flag(j,2) == 2
% % %     fprintf(fid,'*Solid Section, elset=All_Elem_z%d, material=PEI\n', j);% I name my material as ABS, it could be changed as you wish.
% % % end
% % % fprintf(fid,',\n');
% % % end
fprintf(fid,'*End Part\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parts assembly
fprintf(fid,'** \n');
fprintf(fid,'** ASSEMBLY\n');
fprintf(fid,'** \n');
fprintf(fid,'*Assembly, name=Assembly\n');
fprintf(fid,'** \n');
fprintf(fid,'*Instance, name=block-1, part=block\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define print sequence. !!This step is important, it determines how you
% want your elements being printed out, we control this by controlling the
% numbers of each element
fprintf(fid,'**\n');
abqfunc_4_define_print_pattern(Elem_Set,Elem_seq,fid); %check subroutine for detail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define contact surface nodes (deposited beads contact to material substrate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%#!#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% NOTE: I changed here from previous code
bottom_nodes = Node_Set(find(Node_Set(:,2) == 0),1); % %find nodes whose x-coordinates are zero
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf(fid,['*Nset, nset=N_bottom,  instance=block-1\n']); % create a node set for "bottom_nodes"
for i = 1:length(bottom_nodes)
  fprintf(fid,[' ',num2str(bottom_nodes(i,1)),',\n']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define convection surfaces of each element, note that each element will
% have heat convection due to the air flow along its top and side surfaces
for i = 1:size(Elem_Set,1)
  fprintf(fid,['*Surface, type=ELEMENT, name=conv_surf_',num2str(i),'\n']);
  fprintf(fid,[' E',num2str(i),', S1\n']); % top surface
  fprintf(fid,[' E',num2str(i),', S2\n']); % left hand side surface
  fprintf(fid,[' E',num2str(i),', S3\n']); % right hand side surface
end
fprintf(fid,'*End Instance\n');
fprintf(fid,'** \n');
fprintf(fid,'*End Assembly\n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load material properties into Abaqus
fprintf(fid,'** \n');
fprintf(fid,'** MATERIALS\n');
fprintf(fid,'** \n');
% mat_1 = PEEK
fprintf(fid,'*Material, name=mat_1\n');
fprintf(fid,'*Conductivity\n');
fprintf(fid,'%6.6f,\n',conduc_1);
fprintf(fid,'*Density\n');
fprintf(fid,'%6.3f,\n',rho_1);
fprintf(fid,'*Specific Heat\n');
% Notice, cp (specific heat) is a temperature-dependent properties, and thus we need a loop to load all its data
fprintf(fid,'%6.6f,\n',cp_1);
fprintf(fid,'*Elastic\n');
fprintf(fid,'%6.6f, %6.6f\n',E_1,mu_1);
fprintf(fid,'*Expansion\n');
fprintf(fid,'%6.6f,\n',CTE_1);
% mat_2 = PEI
fprintf(fid,'*Material, name=mat_2\n');
fprintf(fid,'*Conductivity\n');
fprintf(fid,'%6.6f,\n',conduc_2);
fprintf(fid,'*Density\n');
fprintf(fid,'%6.3f,\n',rho_2);
fprintf(fid,'*Specific Heat\n');
% Notice, cp (specific heat) is a temperature-dependent properties, and thus we need a loop to load all its data
fprintf(fid,'%6.6f,\n',cp_2);
fprintf(fid,'*Elastic\n');
fprintf(fid,'%6.6f, %6.6f\n',E_2,mu_2);
fprintf(fid,'*Expansion\n');
fprintf(fid,'%6.6f,\n',CTE_2);
fprintf(fid,'** \n');
fprintf(fid,'** PHYSICAL CONSTANTS\n');
fprintf(fid,'** \n');
fprintf(fid,...
'*Physical Constants, absolute zero=-273.15, stefan boltzmann=5.67e-08\n');% consider 1E-6 as zero temperature (degC)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize the temperature for deposited beads
fprintf(fid,'** \n');
fprintf(fid,'** PREDEFINED FIELDS\n');
fprintf(fid,'** \n');
fprintf(fid,'Name: Field-1   Type: Temperature\n');
fprintf(fid,'*Initial Conditions, type=TEMPERATURE\n');
fprintf(fid,'block-1.All_Node, %6.4f\n',Te); % Te = Temperature at extrusion
fprintf(fid,'** \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Define analysis steps
% First step: deactive all elements
fprintf(fid,'** \n');
fprintf(fid,'** STEP: Step-killALL\n');
fprintf(fid,'** \n');
fprintf(fid,'*Step, name=Step-killALL, nlgeom=NO, inc=10000 \n');
% fprintf(fid,'*Heat Transfer, end=PERIOD, deltmx=%6.10f\n',1);% step time setting
fprintf(fid,'*Coupled Temperature-displacement, creep=none, deltmx=%6.10f\n',10);% step time setting
fprintf(fid,'1e-06, 1e-06, 1e-11, 1e-06,\n');
fprintf(fid,'** \n');
fprintf(fid,'** BOUNDARY CONDITIONS\n');
fprintf(fid,'** \n');
fprintf(fid,'** Name: Temp-BC-1 Type: Temperature\n');% set subtrate temperature
fprintf(fid,'*Boundary\n');
fprintf(fid,'BLOCK-1.N_BOTTOM, 11, 11, %0.4f\n',Ts); % Ts = Temperature at substrate
fprintf(fid,'** Name: Temp-BC-k Type: Displacement/Rotation\n');% set subtrate temperature
fprintf(fid,'*Boundary\n');
for i = 1:6
    fprintf(fid,'BLOCK-1.N_BOTTOM, %0.0f, %0.0f\n',i,i);
end
fprintf(fid,'BLOCK-1.N_BOTTOM, 11, 11, %0.4f\n',Ts); % Ts = Temperature at substrate

fprintf(fid,'** \n');
fprintf(fid,'** INTERACTIONS\n'); % create an interaction
fprintf(fid,'** \n');
for j = 1:(x-1)
fprintf(fid,'** Interaction: Model_Change-z%d\n',j); % deactivate all elements
fprintf(fid,'*Model Change, remove \n');
fprintf(fid,'block-1.All_Elem_z%d,\n',j);
fprintf(fid,'**\n');
end
fprintf(fid,'** OUTPUT REQUESTS\n');
fprintf(fid,'*NODE PRINT \n');% request output of temperature for all nodes
fprintf(fid,'NT,\n');
fprintf(fid,'** \n');
fprintf(fid,'*Restart, write, frequency=0\n');
fprintf(fid,'** \n');
fprintf(fid,'** FIELD OUTPUT: F-Output-1 \n');
fprintf(fid,'** \n');
fprintf(fid,'*Output, field, variable=PRESELECT \n');
fprintf(fid,'*Output, history, frequency=0 \n');
fprintf(fid,'*End Step \n');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reactive elements one by one, here we adopt a for loop, in which each
% time one analysis step is generate in corresponding to activating one
% element
for i = 1 : ((x-1)*(y-1)*(z-1))
    fprintf(fid,'** \n');
    fprintf(fid,['** STEP: Step-',num2str(i),'\n']);
    fprintf(fid,'** \n');
    fprintf(fid,['*Step, name=Step-',num2str(i),', nlgeom=NO, inc=10000 \n']);
    fprintf(fid,'*Coupled Temperature-displacement, creep=none, deltmx=%6.10f\n',10);% step time setting
    fprintf(fid,'%6.10f, %6.10f, %6.10f, %6.10f,\n',...
                (delt/10),delt,(delt/100000),delt); % step time setting
    fprintf(fid,'** \n');
    fprintf(fid,'** INTERACTIONS\n');
    fprintf(fid,'** \n');
    fprintf(fid,['** Interaction: Model_Change-',num2str(i),'\n']);% activate one element, note that the sequence of element activation has been determined at line 90
    fprintf(fid,'*Model Change, add\n');
    fprintf(fid,['block-1.E',num2str(i),',\n']);
    fprintf(fid,['** Interaction: SURFFILM-1',num2str(i),'\n']);
    fprintf(fid,'*Sfilm \n'); % define heat convection for each element
    fprintf(fid,['block-1.conv_surf_',num2str(i),', F, %0.4f,  %0.4f \n'],Tm,convec);
    fprintf(fid,'** \n');
    fprintf(fid,'** OUTPUT REQUESTS\n');
    fprintf(fid,'*NODE PRINT \n');% request output of temperature for all nodes
    fprintf(fid,'NT,\n');
    fprintf(fid,'** \n');
    fprintf(fid,'*Restart, write, frequency=0\n');
    fprintf(fid,'** \n');
    fprintf(fid,['** FIELD OUTPUT: F-Output-',num2str(i),'\n']);
    fprintf(fid,'** \n');
    fprintf(fid,'*Output, field, variable=PRESELECT\n');
    fprintf(fid,'*Output, history, frequency=0\n');
    fprintf(fid,'*End Step\n');
    fprintf(fid,'** \n');
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stop writing the .inp file 
status = fclose(fid);
disp('The .inp file is generated, please put it into your abaqus working folder.');
disp('You can test the .inp file by importing it into your ABAQUS CAE solver, and then create a Job for simulation.');
fprintf('\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('Please feel free to contact DRZW at zhaogui_wang@dlmu.edu.cn if you had any further question.')
disp('Copyright 2021 by Zhaogui Wang   All rights reserved')
fprintf('\n')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Hidden features
% if you would like to directly run the .inp file through ABAQUS solver,
% please drop all your matlab files into your abaqus working folder, e.g.,
% C:\SIMULIA\Abaqus\6.14-2\code\bin, you can uncomment the following codes
% and matlab will run abaqus automatically for you 
filename= ['FFF_Simulation_',date,];
cmd_str = ['abaqus job=',filename,' input=',filename,'.inp interactive'];
disp(cmd_str);
system(cmd_str);
fclose all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a built-in subroutine that shows the domain you created using
% matlab script
function patchHEX(NODE,ELEM,showsteps)
if nargin < 3 % if not define showsteps, assign it as zero
 showsteps = 0;
end
seq  = [5 6 7 8;...
        1 2 3 4;...
        5 6 2 1;...
        6 7 3 2;...
        7 3 4 8;...
        8 4 1 5];
 for i= 1:size(ELEM,1)
  e_con= ELEM(i,2:end);% element connectivity
  for j = 1:size(seq,1)
      id_facet = seq(j,:);
      patch([NODE(e_con(id_facet(1)),2) NODE(e_con(id_facet(2)),2) NODE(e_con(id_facet(3)),2) NODE(e_con(id_facet(4)),2)],...
            [NODE(e_con(id_facet(1)),3) NODE(e_con(id_facet(2)),3) NODE(e_con(id_facet(3)),3) NODE(e_con(id_facet(4)),3)],...
            [NODE(e_con(id_facet(1)),4) NODE(e_con(id_facet(2)),4) NODE(e_con(id_facet(3)),4) NODE(e_con(id_facet(4)),4)],...
            [1 1 1 1]*0.5);
  end  
  if showsteps == 1
   keyboard;
  end
 end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

