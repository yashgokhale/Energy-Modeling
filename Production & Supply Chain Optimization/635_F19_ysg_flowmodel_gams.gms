Sets
      i 'set of all nodes' /0*8/
      T 'graph areas' /p, d/
      P(T) 'pickup' /p/
      D(T) 'delivery' /d/
      r   'set of rows' /1*2/
      I1(i) 'nodes excluding the depot' /1*8/
      dep(i) 'depot' /0/  
      ;
alias(i,j,i11, j11);

alias(r, p1,q1,p2,q2)

alias(I1,J1)

Table c1(i,j) 'Cost'
$ondelim
$include  R05_p_2x4.csv
$offdelim;

Table c2(i,j) 'Cost'
$ondelim
$include  R05_d_2x4.csv
$offdelim;

Binary Variables
      xp(i, j,p1,q1)   'if arc is used in pickup'
      xd(i, j,p1,q1)   'if arc is used in delivery'
      v(i,j, r, p)      'if item i is placed in row r'
      
Variables
u            'total cost';


Scalar
      R2  number of rows /2/

      L  /4/;
      
Equations

cost objective function
flowbalp(i)'flowbalance for pickup'
flowbald(i) 'flowbalance for delivery'
xflowbalp(i) 'xflow for pickup'
xflowbald(i) 'xflow for delivery'
vbalp(i, p1) 'v balance for pickup'
vbald(i, p1) 'v balance for delivery'
arc(I1, r, p) 'arc equation'
rowlength(r, p) 'row capacity'
xv1(i, p1, p, I1) 'x and v balance for pickup'
xv2(i, p1, p, I1) 'x and v balance for delivery'
depot(dep, p1, p) 'depot constraint'
vcon1(I1, p) 'one customer once in pickup'
vcon2(I1, p) 'one customer once in delivery';

cost..u =e= sum((i, j),c1(i,j)*sum((p1,q1),xp(i,j,p1,q1)))+sum((i11, j11),c2(i11,j11)*sum((p2,q2),xd(i11,j11,p2,q2)));
flowbalp(i).. sum((j, p1, q1), xp(i, j,p1, q1)$(ord(i)<>ord(j)))=e=1;
flowbald(i).. sum((j, p1, q1), xd(i, j,p1, q1)$(ord(i)<>ord(j)))=e=1;
xflowbalp(i).. sum((j, p1, q1), xp(j, i, p1, q1)$(ord(i)<>ord(j)))=e=1;
xflowbald(i).. sum((j, p1, q1), xd(j, i, p1, q1)$(ord(i)<>ord(j)))=e=1;
vbalp(i,p1).. sum((j, q1), xp(i, j, p1, q1)$(ord(i)<>ord(j)))=e=sum((j, q1), xp(j,i,q1, p1)$(ord(i)<>ord(j)));
vbald(i,p1).. sum((j, q1), xd(i, j, p1, q1)$(ord(i)<>ord(j)))=e=sum((j, q1), xd(j,i,q1, p1)$(ord(i)<>ord(j)));
arc(I1, r, p).. sum((J1), v(I1, J1,r, p)$(ord(I1)<>ord(J1)))=e=sum(J1, v(J1, I1,r, p)$(ord(I1)<>ord(J1)));
rowlength(r, p).. sum((I1, J1), v(I1, J1, r, p)$(ord(I1)<>ord(J1)))=l= L + 1;
xv1(i, p1, p, I1).. sum((j,q1), xp(j,i,p1, q1)$(ord(i)<>ord(j)))=e= sum((J1),v(i,J1,p1,p)$(ord(i)<>ord(J1)));
xv2(i, p1,p,I1).. sum((j,q1), xd(j,i, p1, q1)$(ord(i)<>ord(j)))=e= sum((J1),v(i,J1,p1, p)$(ord(i)<>ord(J1)));
depot(dep,p1,p).. sum(J1,v(dep, J1, p1, p)) =e=1;
vcon1(I1, p).. sum((J1,p1),v(I1,J1,p1, p)$(ord(I1)<>ord(J1)))=e=1;
vcon2(I1, p).. sum((J1,p1),v(J1,I1,p1, p)$(ord(I1)<>ord(J1)))=e=1;

Model DTSP /all/;

Solve DTSP using mip minimizing u;

Set
   ste1         'possible subtour elimination cuts' / c1*c1000 /
   ste2         'possible subtour elimination cuts' / c1*c1000 /
   a1(ste1)      'active cuts'
   a2(ste2)      'active cuts'
   tour1(i,j) 'possible subtour'
   tour2(i,j)
   n1(j)       'nodes visited by subtour'
   n2(j)       'nodes visited by subtour';

Parameter
   proceed1       'indicator to continue to eliminate subtours' / 1 /
   proceed2 /1/
   cc1(ste1,i,j) 'cut coefficients'
   cc2(ste2,i,j) 'cut coefficients'
   rhs1(ste1)      'right hand side of cut'
   rhs2(ste2)      'right hand side of cut';

Equation defste1(ste1) 'subtour elimination cut';
Equation defste2(ste2) 'subtour elimination cut';


defste1(a1).. sum((i,j, p1, q1), cc1(a1,i,j)*xp(i,j,p1, q1)) =l= rhs1(a1);
defste2(a2).. sum((i,j, p1, q1), cc2(a2,i,j)*xd(i,j,p1, q1)) =l= rhs2(a2);

Model DSE / all /;

     a1(ste1) = no;
     cc1(a1,i,j) =  0;
     rhs1(a1) =  0;

    a2(ste2) = no;
    cc2(a2,i,j) =  0;
    rhs2(a2) =  0;
    
    loop(ste1$ proceed1,
   if(proceed1 = 1,
      solve DSE min u using mip;
      proceed1 = 2;
   );

*  Check for subtours
   tour1(i,j) = no;
   n1(j)      = no;
   loop((i,j,p1, q1)$(card(n1) = 0 and xp.l(i,j,p1, q1)), n1(i) = yes);

*  Found all subtours, resolve with new cuts
   if(card(n1) = 0,
      proceed1 = 1; 
   else
*  Construct a single subtour and remove it by setting x.l=0 for its edges
      while(sum((j, n1, p1, q1), xp.l(j, n1, p1, q1)),
         loop((i,j,p1, q1)$(n1(i) and xp.l(i,j,p1, q1)),
            tour1(i,j) = yes;
            xp.l(i,j,p1, q1)  =   0;
            n1(j)      = yes;
         );
         );
      if(card(n1) < card(j),
         a1(ste1)   = 1;
         rhs1(ste1) = card(n1) - 1;
         cc1(ste1,i,j)$(n1(i) and n1(j)) = 1;
      else
         proceed1 = 0;
         );
   );
); 
if(proceed1 = 0,
   display 'Optimal tour found', tour1;
else
   abort 'Out of subtour cuts, enlarge set ste';
);
    
    proceed1 = 1;
    loop(ste2$ proceed1,
   if(proceed1 = 1,
      solve DSE min u using mip;
      proceed1 = 2;
   );

*  Check for subtours
   tour2(i,j) = no;
   n2(j)      = no;
   loop((i,j,p1 ,q1)$(card(n2) = 0 and xd.l(i,j,p1, q1)), n2(i) = yes);

*  Found all subtours, resolve with new cuts
   if(card(n2) = 0,
      proceed1 = 1; 
   else
*  Construct a single subtour and remove it by setting x.l=0 for its edges
      while(sum((j, n2, p1, q1), xd.l(j, n2, p1, q1)),
         loop((i,j,p1, q1)$(n2(i) and xd.l(i,j,p1, q1)),
            tour2(i,j) = yes;
            xd.l(i,j,p1, q1)  =   0;
            n2(j)      = yes;
         );
         );
      if(card(n2) < card(j),
         a2(ste2)   = 1;
         rhs2(ste2) = card(n2) - 1;
         cc2(ste2,i,j)$(n2(i) and n2(j)) = 1;
      else
         proceed1 = 0;
         );
   );
); 
if(proceed1 = 0,
   display 'Optimal tour found', tour2;
else
   abort 'Out of subtour cuts, enlarge set ste';
);
;

