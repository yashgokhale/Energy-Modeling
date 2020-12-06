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
lam(i, k)  'convex combination weight';

Parameters
z(i) 'To count the number of vertices per well';
      
Binary Variables
y(i, k)  'Decision variable to activate a segment';

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
loop (i ,loop (k , if((can_do(i,k)), f = f+1 ;);); z(i)= 12- f; f =0) ;
display z;

Equation
     obj define objective function
     lambda1(i) Convex weight constraint for the first vertex
     lambda2(i, k) Convex weight constraint for the intermediate vertices
     lambda3(i, k) Convex weight constraint for the last vertex
     ysum(i) Activating one segment per well
     gaslim Upper bound on supply of lift gas
*    lowlim(i) Lower Bound on gas supply limit
;

obj..  u =e= sum((i, k), lam(i, k)*qoil(i, k));

lambda1(i).. lam(i, 'v1')=l= y(i, 'v1');
lambda2(i,k).. lam(i, k)$(ord(k)>=2)=l=((y(i,k-1)+y(i,k))$(ord(k)>=2)); 
lambda3(i, k)$(ord(k)>=1).. lam(i, k)$(ord(k)<=z(i))=l=y(i, k-1)$(ord(k)<=z(i));
ysum(i).. sum(k, y(i,k))=e=1;
gaslim.. sum((i, k), lam(i,k)*qgas(i,k))=l=4600;

*lowlim(i).. sum(k,qgas(i,k))=g=100*m(i);

Model classic /all/;

option optcr = 0.000001
option reslim=10000;
Solve classic using minlp maximizing u;

Display y.l, u.l, lam.l;