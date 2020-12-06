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

Variables
beta(i, k) 'slope of line segment'
alpha(i, k)'intercept of line segment';

Parameter
z(i)'To count the number of vertices per well';

Positive Variables
Q(i, k) 'Gas supply for every well';
      
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
     eq1(i, k) To calculate the intercept of the line segment
     eq2(i, k) To calculate the slope of the line segment
     eq3(i, k) Big M constraint 1
     eq4(i, k) Big M constraint 2
     ysum(i) Activating one segment per well
     gaslim Upper bound on supply of lift gas
*     lowlim(i) Lower Bound on gas supply limit
;

obj..  u =e= sum(i, sum(k, alpha(i,k)*y(i, k)+ beta(i, k)*Q(i, k)));

eq1(i, k).. alpha(i, k)=e= qoil(i,k)-beta(i,k)*qgas(i,k);
eq2(i, k).. beta(i, k)=e=((qoil(i, k+1)- qoil(i,k))/(qgas(i,k+1)-qgas(i,k)))$((ord(k)<z(i))and (qgas(i,k+1)<> qgas(i,k)));
eq3(i, k).. qgas(i, k)*y(i, k)=l=Q(i,k)$(ord(k)<z(i));
eq4(i, k).. Q(i,k)$(ord(k)<z(i))=l=(qgas(i, k+1)*y(i, k))$(ord(k)<z(i));
ysum(i).. sum(k, y(i,k)$(ord(k)<z(i)))=e=1;
gaslim.. sum((i, k), Q(i,k))=l=4600;

*lowlim(i).. sum(k,qgas(i,k))=g=3000*m(i);

Model LS /all/;

option optcr = 0.0001;
option reslim=100;
Solve LS using minlp maximizing u;

Display y.l, u.l;