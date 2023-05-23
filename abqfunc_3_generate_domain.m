function [Node_Set,Elem_Set,Elem_seq] = abqfunc_3_generate_domain(x,y,z,X,Y,Z)

node  = [];
% Node  = zeros(x*y*z,3);
%%%%%%%%%%%%%%%%%%%%%%%%
x1 = linspace(0,X,x);
for i = 1:x
    node((1+(y*z)*(i-1)):(y*z)*i) = x1(i)*ones(y*z,1); 
end
Node(:,1,1) = node';
%%%%%%%%%%%%%%%%%%%%%%%%
node2 = [];
x2 = linspace(0,Y,y);
for i = 1 : z
        node2((1+y*(i-1)):(y*i)) = x2';
end

for i = 1 : x
    Node((1+y*z*(i-1)):(i*y*z),2,1) = node2';
end
%%%%%%%%%%%%%%%%%%%%%%%%
node3 = [];
x3 = linspace(0,Z,z);
for i = 1 : z
    node3((1+y*(i-1)):(y*i)) = x3(i)*ones(y,1);
end

for i = 1 : x
    Node((1+y*z*(i-1)):(i*y*z),3,1) = node3';
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the nodes 
% plot3(Node(:,1,1),Node(:,2,1),Node(:,3,1),'.')

%%%%%%%%%%%%%%%%%%%%%%%%%%%
Node_Set = zeros(x*y*z,4);
Node_Set(:,2:4,1) = Node;

for i = 1:(x*y*z)
    Node_Set(i,1,1) = i;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Define elements
nod  = zeros((y-1)*(z-1),8);
nod1 = zeros((y-1),4);
for i = 1 :(y-1)
    nod1(i,1:4,1) = [(y*z+i), (y*z+i+1),...
        (y*z+i+1+y), (y*z+i+y) ];
end
nod2 = zeros((y-1),4);
for i = 1 : (y-1)
    nod2(i,1:4,1) =[ i, i+1, (1+y+i), (y+i)] ;
end
for i = 1: (z-1)
    nod( (1+(i-1)*(y-1)):(i*(y-1)),1:8,1)=[(nod1+(i-1)*y),(nod2+(i-1)*y)];
end
elem = zeros((x-1)*(y-1)*(z-1),8);
for i = 1: (x-1)
    elem((1+(i-1)*(y-1)*(z-1)):i*(y-1)*(z-1),1:8,1) = nod+(i-1)*y*z;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define Elem_Set
% change connectivity sequence
% id_change = [5 6 8 7 1 2 4 3;4 3 1 2 8 7 5 6];
for i = 1:((x-1)*(y-1)*(z-1))
    Elem_Set(i,1) = i;
    Elem_Set(i,2:9) = [elem(i,7), elem(i,8), elem(i,5), elem(i,6),...
                       elem(i,3), elem(i,4), elem(i,1), elem(i,2)];
end
% keyboard
% sort the Elem_Set along z-axis
Elem_seq = reshape(Elem_Set(:,1),[y-1 z-1 x-1]);