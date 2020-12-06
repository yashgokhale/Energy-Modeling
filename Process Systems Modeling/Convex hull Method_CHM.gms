Set k 'set of vertices'/v1*v12/;
Set i 'set of wells'/w1* w6/;


Table qgas(i,k) 'Q_gas'
$ondelim
$include  injection6.csv
$offdelim;

Table qoil(i,k) 'Q_oil'
$ondelim
$include  oilrate6.csv
$offdelim;

Variables
u 'objective function';

Positive Variables
lamL(i, k)   'Left convex weight'
lamR(i, k)   'Right convex weight';

Parameters
z(i)'To count the number of vertices per well';
      
Binary Variables
y(i, k) 'Decision variable to activate a segment';

*Used in case of lower limit on gas flow rate
Binary Variables
m(i) 'Determines if a well is activated or not';
      
*'Set of all terminal zero value vertices'
Set   can_do(i,k) ;
can_do(i,k)$((qgas(i,k) <= 0)and (ord(k)<>1)) = yes;
display can_do

Scalars f 'To get the last active vertex of the well';
f = 0;

*Setting the last non zero vertex
loop (i ,loop (k $ (can_do(i,k)), f = f+1 ;); z(i)= 12- f; f =0) ;
display z;


Equation
     obj define objective function
     lambda(i, k) convex weight constraint
     ysum(i) Activating one segment per well
     gaslim Upper bound on supply of lift gas
*     lowlim(i) Lower Bound on gas supply limit
;

obj..  u =e= sum(i, sum(k, lamR(i, k)*qoil(i, k)+lamL(i, k)*qoil(i, k)));

lambda(i, k).. lamL(i, k)+ lamR(i,k)=e=y(i, k);
ysum(i).. sum(k, y(i,k))=e=1;
gaslim.. sum((i, k), lamR(i,k)*qgas(i,k)+ lamL(i,k)*qgas(i,k))=l=4600;

*lowlim(i).. sum(k,qgas(i,k))=g=1000*m(i);

Model convexhull /all/;

option optcr = 0.00001
option reslim=10000;
Solve convexhull using minlp maximizing u;

Display y.l, u.l, lamR.l, lamL.l;