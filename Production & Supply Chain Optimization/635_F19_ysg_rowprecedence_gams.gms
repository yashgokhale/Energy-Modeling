Sets
      i    'set of all nodes' /0*8/
      T 'graph areas' /p, d/
      P(T) 'pickup' /p/
      D(T) 'delivery' /d/
      r   'set of rows' /1*2/
      I1(i) 'nodes excluding the depot' /1*8/
      ;

alias(i,j,i2,j2,k);

alias (I1,J1,K1);

Table c1(i,j) 'Cost'
$ondelim
$include  R05_p_2x4.csv
$offdelim;

Table c2(i2,j2) 'Cost'
$ondelim
$include  R05_d_2x4.csv
$offdelim;

Binary Variables
      xp(i, j)   'if arc is used in Pickup'
      xd(i, j)   'if arc is used in Delivery'
      w(I1, J1, r)   'if item item i is picked up before item j and both are in r'
      z(I, r)      'if item i is placed in row r';



Variables
u            'total cost';


Scalar
      R2  number of rows /2/

      L  /4/;

Equation
     cost define objective function

     flow1p(j) flow conservation in
     flow2p(i) flow conservation out
     flow1d(j) flow conservation in
     flow2d(i) flow conservation out
     rowp(I1) row assignment for pick up
     rowcaps(r) row capacity
     samerow(I1,J1, r) if the items are in the same row
     diffrow(I1, J1, r) if the items are in different rowsq;
*     cut1(r,I1,J1)
*     cut2(r,I1,J1);

cost..  u =e= sum((i, j, P),c1(i,j)*xp(i,j))+ sum((i2, j2,D),c2(i2,j2)*xd(i2,j2));

flow1p(j)..sum(i,xp(i, j)$(ord(i)<>ord(j)))=e=1;
flow2p(i)..sum(j,xp(i, j)$(ord(i)<>ord(j)))=e=1;
flow1d(j)..sum(i,xd(i, j)$(ord(i)<>ord(j)))=e=1;
flow2d(i)..sum(j,xd(i, j)$(ord(i)<>ord(j)))=e=1;
rowp(I1)..sum(r,z(I1, r))=e=1;
rowcaps(r)..sum(I1,z(I1, r))=l=L;
samerow(I1, J1, r)$(ord(I1)<>ord(J1))..w(I1,J1,r)+ w(J1,I1,r)=g=z(I1, r)+z(J1,r)-1;
diffrow(I1, J1, r)$(ord(I1)<>ord(J1)).. 2*(w(I1, J1, r)+ w(J1, I1, r))=l= z(I1, r)+z(J1, r);
*cut1(r,I1,J1)$(ord(I1)<>ord(J1))..xp('7','5')+xp('5','4')+z('7','1')+z('4','1')=l=2+1+w('7','4','1');
*cut2(r,I1,J1)$(ord(I1)<>ord(J1))..xp('7','5')+xp('5','4')+z('7','1')+z('4','1')=l=2+1+w('4','7','1');

Model DTSP /all/;

Solve DTSP using mip minimizing u;

*$ontext
Set
   ste         'possible subtour elimination cuts' / c1*c1000 /
   a(ste)      'active cuts'
   tour(i,j) 'possible subtour'
   n(i)       'nodes visited by subtour';

Parameter
   proceed       'indicator to continue to eliminate subtours' / 1 /
   cc(ste,i,j) 'cut coefficients'
   rhs(ste)      'right hand side of cut';

Equation defste(ste) 'subtour elimination cut';

defste(a).. sum((i,j), cc(a,i,j)*xp(i,j)) =l= rhs(a);

Model DSE / all /;

a(ste)    = no;
cc(a,i,j) =  0;
rhs(a)    =  0;

Set
       ste2         'possible subtour elimination cuts' / c1*c1000 /
       a2(ste2)      'active cuts'
       tour2(i,j) 'possible subtour'
       n2(i)       'nodes visited by subtour';
    
Parameter
       proceed2       'indicator to continue to eliminate subtours' / 1 /
       cc2(ste2,i,j) 'cut coefficients'
       rhs2(ste2)      'right hand side of cut';
       
Equation defste2(ste2) 'subtour elimination cut';
    
defste2(a2).. sum((i,j), cc2(a2,i,j)*xd(i,j)) =l= rhs2(a2);
    
Model DSE2 / all /;
    
a2(ste2)    = no;
cc2(a2,i,j) =  0;
rhs2(a2)    =  0;

a(ste)    = no;
cc(a,i,j) =  0;
rhs(a)    =  0;

$ontext
Set
       ste3         'possible subtour elimination cuts' / c1*c1000 /
       a3(ste3)      'active cuts'
       tour3(I1,J1) 'possible subtour'
       n3(I1)       'nodes visited by subtour';
    
Parameter
       proceed3       'indicator to continue to eliminate subtours' / 1 /
       cc3(ste3,I1,J1) 'cut coefficients'
       rhs3(ste3)      'right hand side of cut';
       
Equation defste3(ste3,r,I1,J1) 'subtour elimination cut';

alias(I1,I11,J11);
    
defste3(a3,r,I1,J1) .. sum((I11,J11), cc3(a3,I1,J1)*xp(I1,J1))+z(I1,r)+z(J1,r)-1-w(I1,J1,r) =l= rhs3(a3);
    
Model DSE3 / all /;
    
a3(ste3)    = no;
cc3(a3,I1,J1) =  0;
rhs3(a3)    =  0;


a3(ste3)    = no;
cc3(a3,I1,J1) =  0;
rhs3(a3)    =  0;

Set
       ste4         'possible subtour elimination cuts' / c1*c1000 /
       a4(ste4)      'active cuts'
       tour4(I1,J1) 'possible subtour'
       n4(I1)       'nodes visited by subtour';
    
Parameter
       proceed4       'indicator to continue to eliminate subtours' / 1 /
       cc4(ste4,I1,j1) 'cut coefficients'
       rhs4(ste4)      'right hand side of cut';
       
Equation defste4(ste4,r,I1,J1) 'subtour elimination cut';
    
defste4(a4,r,I1,J1) .. sum((I11,J11), cc4(a4,I1,J1)*xp(I1,J1))+z(I1,r)+z(J1,r)-1-w(I1,J1,r) =l= rhs4(a4);
    
Model DSE4 / all /;
    
a4(ste4)    = no;
cc4(a4,i1,j1) =  0;
rhs4(a4)    =  0;
$offtext

loop(ste$proceed,
   if(proceed = 1,
      solve DSE min u using mip;
      abort$(DSE.modelStat <> %modelStat.optimal%) 'problems with MIP solver';
      xp.l(i,j) = round(xp.l(i,j));
      proceed = 2;
   );

*  Check for subtours
   tour(i,j) = no;
   n(j)      = no;
   loop((i,j)$(card(n) = 0 and xp.l(i,j)), n(i) = yes);
*   loop((i,j,T)$(card(n) = 0 and x.l(i,j,T)$(n(i,T) and ord(T)=2)), n(i,T) = yes);

*  Found all subtours, resolve with new cuts
   if(card(n) = 0,
      proceed = 1;
   else
*  Construct a single subtour and remove it by setting x.l=0 for its edges
      while (sum((i,j), xp.l(i,j)$(n(i))),
         loop((i,j)$(n(i) and xp.l(i,j)),
            tour(i,j) = yes;
            xp.l(i,j)  =   0;
            n(j)      = yes;
         );
      if(card(n) < card(j),
         a(ste)   = 1;
         rhs(ste) = card(n) - 1;
         cc(ste,i,j)$(n(i) and n(j)) = 1;
      else
         proceed = 0;
      );
   );
   );
);
if(proceed = 0,
  
    loop(ste2$proceed2,
       if(proceed2 = 1,
          solve DSE2 min u using mip;
          abort$(DSE2.modelStat <> %modelStat.optimal%) 'problems with MIP solver';
          xd.l(i,j) = round(xd.l(i,j));
          proceed2 = 2;
       );
    
*    *  Check for subtours
       tour2(i,j) = no;
       n2(j)      = no;
       loop((i,j)$(card(n2) = 0 and xd.l(i,j)), n2(i) = yes);
*    *   loop((i,j,T)$(card(n) = 0 and x.l(i,j,T)$(n(i,T) and ord(T)=2)), n(i,T) = yes);
    
*    *  Found all subtours, resolve with new cuts
       if(card(n2) = 0,
          proceed2 = 1;
       else
*    *  Construct a single subtour and remove it by setting x.l=0 for its edges
          while (sum((i,j), xd.l(i,j)$(n2(i))),
             loop((i,j)$(n2(i) and xd.l(i,j)),
                tour2(i,j) = yes;
                xd.l(i,j)  =   0;
                n2(j)      = yes;
             );
          if(card(n2) < card(j),
             a2(ste2)   = 1;
             rhs2(ste2) = card(n2) - 1;
             cc2(ste2,i,j)$(n2(i) and n2(j)) = 1;
          else
             proceed2 = 0;
          );
       );
       );
    );
    if(proceed2 = 0,
       xp.l(i,j)=tour(i,j);
       xd.l(i,j)=tour2(i,j);
    else
       abort 'Out of subtour cuts, enlarge set ste';
    );
    );              
Display xp.l,xd.l,w.l,z.l;