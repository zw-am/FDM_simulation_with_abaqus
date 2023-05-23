function abqfunc_4_define_print_pattern(Elem_Set,Elem_seq,fid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% show the print pattern
% figure; hold on; 
% subplot(1,3,1);image(imread('.\abqfigs\s_lines.png','png'));title('straight lines');
% subplot(1,3,2);image(imread('.\abqfigs\flip_lines.png','png'));title('back and forth lines');
% subplot(1,3,3);image(imread('.\abqfigs\central_lines.png','png'));title('central lines');
% set the figure window to be more clear
% x0=500; y0=500; width=1288;height = width*0.318;
% set(gcf,'position',[x0,y0,width,height])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ask the user to select a pattern to print
flag_pattern = menu('what FFF pattern you would like to simulate?','straight lines','back and forth lines','central lines');
switch flag_pattern
  case 1
      for i = 1:size(Elem_Set,1)
       fprintf(fid,['*ELSET, ELSET=E',num2str(i),',  instance=block-1\n']);
       fprintf(fid,[' ',num2str(Elem_Set(i,1)),',\n']);
      end
  case 2
      warning('this pattern only works when you employ the default settings');
      seq   = [Elem_seq(:,:,1);flip(Elem_seq(:,:,2)) ;...
               Elem_seq(:,:,3);flip(Elem_seq(:,:,4)) ;...
               Elem_seq(:,:,5);flip(Elem_seq(:,:,6))];
      for i = 1:size(Elem_seq,3)*size(Elem_seq,1)
       fprintf(fid,['*ELSET, ELSET=E',num2str(i),',  instance=block-1\n']);
       fprintf(fid,[' ',num2str(seq(i,1)),',\n']);
      end
  case 3
      warning('this pattern only works when you employ the default settings');
      seq1  = zeros(size(Elem_seq,1),size(Elem_seq,3));
      for j = 1:size(Elem_seq,3)
          seq1(:,j) = Elem_seq(:,1,j);
      end
      seq2   = [seq1(:,1);       seq1(end,2:end)';     flip(seq1(1:end-1,end));   flip(seq1(1,2:end-1))' ;...
                seq1(2:end-1,2); seq1(end-1,3:end-1)'; flip(seq1(2:end-2,end-1)); flip(seq1(2,3:end-2))' ;...
                seq1(3:end-2,3); seq1(end-2,4:end-2)'; flip(seq1(3:end-3,end-2)); []                    ];
      for p = 1:length(seq2)
       fprintf(fid,['*ELSET, ELSET=E',num2str(p),',  instance=block-1\n']); 
       fprintf(fid,[' ',num2str(seq2(p)),',\n']);
      end      
  case 0
      warning('the user close the menu with make any selection, we will use straight line pattern');
      for i = 1:size(Elem_Set,1)
       fprintf(fid,['*ELSET, ELSET=E',num2str(Elem_Set(i,1)),',  instance=block-1\n']);
       fprintf(fid,[' ',num2str(Elem_Set(i,1)),',\n']);
      end
end