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

SOS2 Variables
lam(i, k)   'convex weight variable';
      
Binary Variables
y(i, k)  'Decision variable to activate a segment';

*Used in case of lower limit on gas flow rate
Binary Variables
m(i) 'Determines if a well is activated or not';

Equation
     obj define objective function
     ysum(i) Activating one segment per well
     lambda(i, k) Convex weight constraint
     gaslim Upper bound on supply of lift gas
*     lowlim(i) Lower Bound on gas supply limit
;

obj..  u =e= sum(i, sum(k, lam(i, k)*qoil(i, k)));
ysum(i).. sum(k, lam(i,k))=e=1;
lambda(i, k).. lam(i, k)=g=0;
gaslim.. sum((i, k), lam(i,k)*qgas(i,k))=l=4600;

*lowlim(i).. sum(k,qgas(i,k))=g=1000*m(i);

Model SSM /all/;

option optcr = 0.00001
option reslim=10000;
Solve SSM using minlp maximizing u;