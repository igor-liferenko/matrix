%outputtemplate:="%j.eps"; prologues:=3;

input rboxes;

verbatimtex
\font\tenss=cmss10 \tenss
etex

beginfig(1);
u:=.7cm;
r:=.5u;

% row1
circleit.circ1(btex 1 etex);
circ1.n-circ1.c=up*r; circ1.e-circ1.c=right*r;
circ1.c=origin+right*2.5u;
drawboxed(circ1);
circleit.circ2(btex 2 etex);
circ2.n-circ2.c=up*r; circ2.e-circ2.c=right*r;
circ2.c=circ1.c+right*2u;
drawboxed(circ2);
draw circ1.c -- circ2.c cutbefore bpath.circ1 cutafter bpath.circ2;
circleit.circ3(btex 3 etex);
circ3.n-circ3.c=up*r; circ3.e-circ3.c=right*r;
circ3.c=circ2.c+right*2u;
drawboxed(circ3);
draw circ2.c -- circ3.c cutbefore bpath.circ2 cutafter bpath.circ3;
circleit.circA(btex A etex);
circA.n-circA.c=up*r; circA.e-circA.c=right*r;
circA.c=circ3.c+right*2u;
drawboxed(circA);
draw circ3.c -- circA.c cutbefore bpath.circ3 cutafter bpath.circA;
draw circ1.c -- origin cutbefore bpath.circ1 -- (0,-8u) -- (2u,-8u) -- (2u,-10u);
label.bot(btex \tt PB4 etex, (2u,-10u));

% row2
circleit.circ4(btex 4 etex);
circ4.n-circ4.c=up*r; circ4.e-circ4.c=right*r;
circ4.c=origin+right*2.5u+down*1.75u;
drawboxed(circ4);
circleit.circ5(btex 5 etex);
circ5.n-circ5.c=up*r; circ5.e-circ5.c=right*r;
circ5.c=circ4.c+right*2u;
drawboxed(circ5);
draw circ4.c -- circ5.c cutbefore bpath.circ4 cutafter bpath.circ5;
circleit.circ6(btex 6 etex);
circ6.n-circ6.c=up*r; circ6.e-circ6.c=right*r;
circ6.c=circ5.c+right*2u;
drawboxed(circ6);
draw circ5.c -- circ6.c cutbefore bpath.circ5 cutafter bpath.circ6;
circleit.circB(btex B etex);
circB.n-circB.c=up*r; circB.e-circB.c=right*r;
circB.c=circ6.c+right*2u;
drawboxed(circB);
draw circ6.c -- circB.c cutbefore bpath.circ6 cutafter bpath.circB;
draw circ4.c -- (.5u,ypart(circ4.c)) cutbefore bpath.circ4 -- (.5u,-7.5u) -- (3u,-7.5u) -- (3u,-10u);
label.bot(btex \tt PB5 etex, (3u,-10u));

% row3
circleit.circ7(btex 7 etex);
circ7.n-circ7.c=up*r; circ7.e-circ7.c=right*r;
circ7.c=origin+right*2.5u+down*3.5u;
drawboxed(circ7);
circleit.circ8(btex 8 etex);
circ8.n-circ8.c=up*r; circ8.e-circ8.c=right*r;
circ8.c=circ7.c+right*2u;
drawboxed(circ8);
draw circ7.c -- circ8.c cutbefore bpath.circ7 cutafter bpath.circ8;
circleit.circ9(btex 9 etex);
circ9.n-circ9.c=up*r; circ9.e-circ9.c=right*r;
circ9.c=circ8.c+right*2u;
drawboxed(circ9);
draw circ8.c -- circ9.c cutbefore bpath.circ8 cutafter bpath.circ9;
circleit.circC(btex C etex);
circC.n-circC.c=up*r; circC.e-circC.c=right*r;
circC.c=circ9.c+right*2u;
drawboxed(circC);
draw circ9.c -- circC.c cutbefore bpath.circ9 cutafter bpath.circC;
draw circ7.c -- (1u,ypart(circ7.c)) cutbefore bpath.circ7 -- (1u,-7u) -- (4u,-7u) -- (4u,-10u);
label.bot(btex \tt PE6 etex, (4u,-10u));

% row4
circleit.circ_ast(btex * etex);
circ_ast.n-circ_ast.c=up*r; circ_ast.e-circ_ast.c=right*r;
circ_ast.c=origin+right*2.5u+down*5.25u;
drawboxed(circ_ast);
circleit.circ0(btex 0 etex);
circ0.n-circ0.c=up*r; circ0.e-circ0.c=right*r;
circ0.c=circ_ast.c+right*2u;
drawboxed(circ0);
draw circ_ast.c -- circ0.c cutbefore bpath.circ_ast cutafter bpath.circ0;
circleit.circ_hash(btex \# etex);
circ_hash.n-circ_hash.c=up*r; circ_hash.e-circ_hash.c=right*r;
circ_hash.c=circ0.c+right*2u;
drawboxed(circ_hash);
draw circ0.c -- circ_hash.c cutbefore bpath.circ0 cutafter bpath.circ_hash;
circleit.circD(btex D etex);
circD.n-circD.c=up*r; circD.e-circD.c=right*r;
circD.c=circ_hash.c+right*2u;
drawboxed(circD);
draw circ_hash.c -- circD.c cutbefore bpath.circ_hash cutafter bpath.circD;
draw circ_ast.c -- (1.5u,ypart(circ_ast.c)) cutbefore bpath.circ_ast -- (1.5u,-6.5u) -- (5u,-6.5u) -- (5u,-10u);
label.bot(btex \tt PD7 etex, (5u,-10u));

endfig;

beginfig(2);
u:=.7cm;
r:=.5u;

% col1
circleit.circ1(btex 1 etex);
circ1.n-circ1.c=up*r; circ1.e-circ1.c=right*r;
circ1.c=origin+right*2.5u;
drawboxed(circ1);
circleit.circ4(btex 4 etex);
circ4.n-circ4.c=up*r; circ4.e-circ4.c=right*r;
circ4.c=origin+right*2.5u+down*1.75u;
drawboxed(circ4);
draw circ1.c -- circ4.c cutbefore bpath.circ1 cutafter bpath.circ4;
circleit.circ7(btex 7 etex);
circ7.n-circ7.c=up*r; circ7.e-circ7.c=right*r;
circ7.c=origin+right*2.5u+down*3.5u;
drawboxed(circ7);
draw circ4.c -- circ7.c cutbefore bpath.circ4 cutafter bpath.circ7;
circleit.circ_ast(btex * etex);
circ_ast.n-circ_ast.c=up*r; circ_ast.e-circ_ast.c=right*r;
circ_ast.c=origin+right*2.5u+down*5.25u;
drawboxed(circ_ast);
draw circ7.c -- circ_ast.c cutbefore bpath.circ7 cutafter bpath.circ_ast;
draw circ_ast.c -- (xpart(circ_ast.c),-8u) cutbefore bpath.circ_ast -- (6u,-8u) -- (6u,-10u);
label.bot(btex \tt PF4 etex, (6u,-10u));

% col2
circleit.circ2(btex 2 etex);
circ2.n-circ2.c=up*r; circ2.e-circ2.c=right*r;
circ2.c=circ1.c+right*2u;
drawboxed(circ2);
circleit.circ5(btex 5 etex);
circ5.n-circ5.c=up*r; circ5.e-circ5.c=right*r;
circ5.c=circ4.c+right*2u;
drawboxed(circ5);
draw circ2.c -- circ5.c cutbefore bpath.circ2 cutafter bpath.circ5;
circleit.circ8(btex 8 etex);
circ8.n-circ8.c=up*r; circ8.e-circ8.c=right*r;
circ8.c=circ7.c+right*2u;
drawboxed(circ8);
draw circ5.c -- circ8.c cutbefore bpath.circ5 cutafter bpath.circ8;
circleit.circ0(btex 0 etex);
circ0.n-circ0.c=up*r; circ0.e-circ0.c=right*r;
circ0.c=circ_ast.c+right*2u;
drawboxed(circ0);
draw circ8.c -- circ0.c cutbefore bpath.circ8 cutafter bpath.circ0;
draw circ0.c -- (xpart(circ0.c),-7.5u) cutbefore bpath.circ0 -- (7u,-7.5u) -- (7u,-10u);
label.bot(btex \tt PF5 etex, (7u,-10u));

% col3
circleit.circ3(btex 3 etex);
circ3.n-circ3.c=up*r; circ3.e-circ3.c=right*r;
circ3.c=circ2.c+right*2u;
drawboxed(circ3);
circleit.circ6(btex 6 etex);
circ6.n-circ6.c=up*r; circ6.e-circ6.c=right*r;
circ6.c=circ5.c+right*2u;
drawboxed(circ6);
draw circ3.c -- circ6.c cutbefore bpath.circ3 cutafter bpath.circ6;
circleit.circ9(btex 9 etex);
circ9.n-circ9.c=up*r; circ9.e-circ9.c=right*r;
circ9.c=circ8.c+right*2u;
drawboxed(circ9);
draw circ6.c -- circ9.c cutbefore bpath.circ6 cutafter bpath.circ9;
circleit.circ_hash(btex \# etex);
circ_hash.n-circ_hash.c=up*r; circ_hash.e-circ_hash.c=right*r;
circ_hash.c=circ0.c+right*2u;
drawboxed(circ_hash);
draw circ9.c -- circ_hash.c cutbefore bpath.circ9 cutafter bpath.circ_hash;
draw circ_hash.c -- (xpart(circ_hash.c),-7u) cutbefore bpath.circ_hash -- (8u,-7u) -- (8u,-10u);
label.bot(btex \tt PF6 etex, (8u,-10u));

% col4
circleit.circA(btex A etex);
circA.n-circA.c=up*r; circA.e-circA.c=right*r;
circA.c=circ3.c+right*2u;
drawboxed(circA);
circleit.circB(btex B etex);
circB.n-circB.c=up*r; circB.e-circB.c=right*r;
circB.c=circ6.c+right*2u;
drawboxed(circB);
draw circA.c -- circB.c cutbefore bpath.circA cutafter bpath.circB;
circleit.circC(btex C etex);
circC.n-circC.c=up*r; circC.e-circC.c=right*r;
circC.c=circ9.c+right*2u;
drawboxed(circC);
draw circB.c -- circC.c cutbefore bpath.circB cutafter bpath.circC;
circleit.circD(btex D etex);
circD.n-circD.c=up*r; circD.e-circD.c=right*r;
circD.c=circ_hash.c+right*2u;
drawboxed(circD);
draw circC.c -- circD.c cutbefore bpath.circC cutafter bpath.circD;
draw circD.c -- (xpart(circD.c),-6.5u) cutbefore bpath.circD -- (9u,-6.5u) -- (9u,-10u);
label.bot(btex \tt PF7 etex, (9u,-10u));

endfig;

end