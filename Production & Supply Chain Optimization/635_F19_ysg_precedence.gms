Option optcr=0.0001

Sets
      i 'set of all nodes' /0*8/
      T 'graph areas' /1*2/
      P(T) 'pickup' /1/
      D(T) 'delivery' /2/
      r   'set of rows' /1*2/
      I1(i) 'nodes excluding the depot' /1*8/
      ;
      
alias(i,j,i2,j2);

alias(I1,J1,K1);

Table c1(i,j) 'Cost'
$ondelim
$include R05_p_2x4.csv
$offdelim;

Table c2(i2,j2) 'Cost'
$ondelim
$include R05_d_2x4.csv
$offdelim;

*Parameter
*    C(i,j,P) = /cp(i,j,P)/
*    C(i,j,D) = /cd(i,j,D)/

Variables
      x(i, j,T)   'if arc is used in Graph Gp'
      y(I1, J1,T)   'if item i is handled before item j in pick up'
      z(I, r)     'if item i is placed in row r'
      u            'total cost';
      

Binary Variables x, y, z;


Scalar
      R2  number of rows /2/
      N  nodes/8/
*s       /(N/R)/
      L  /4/;
      
Equation
     cost define objective function

     flow1(j,T) flow conservation in
     flow2(i,T) flow conservation out
     precedence1(I1,J1,T) order of i and j nodes in pick up
     precedence2(I1,J1,T) order of i and j nodes in pick up
     transitivity(I1,J1,K1,T) transitivity for pick up
     lifo(I1, J1,r) last in first out
     rowp(I1) row assignment for pick up
     rowcaps(r) row capacity;
     
cost..  u =e= sum((i, j,P),c1(i,j)*x(i,j,P))+ sum((i2, j2,D),c2(i2,j2)*x(i2,j2,D));

flow1(j,T)..sum(i,x(i,j,T)$(ord(i)<>ord(j)))=e=1;

flow2(i,T)..sum(j,x(i,j,T)$(ord(i)<>ord(j)))=e=1;

precedence1(I1,J1,T)$(ord(I1)<>ord(J1)) .. y(I1,J1,T)+y(J1,I1,T)=e=1;

precedence2(I1,J1,T)$(ord(I1)<>ord(J1))..x(I1,J1,T)-y(I1,J1,T)=l=0;

transitivity(I1,J1,K1,T)$(ord(I1)<>ord(J1)and ord(I1)<>ord(K1))..y(I1,K1,T)+y(K1,J1,T)-y(I1,J1,T)=l=1;

lifo(I1, J1,r)$(ord(I1)<>ord(J1)and ord(I1)<>ord(J1))..sum(T,y(I1,J1,T))+z(I1, r)+z(J1, r)=l=3;

rowp(I1)..sum(r,z(I1, r))=e=1;
rowcaps(r)..sum(I1,z(I1, r))=l=L;

Model DTSP /all/;

Solve DTSP using mip minimizing u;

Display x.l,y.l,z.l
     