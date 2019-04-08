%outputtemplate:="%j.eps"; prologues:=3;

input rboxes;

verbatimtex
\font\tenss=cmss10 \tenss
\font\eightss=cmss8
\font\smallss=cmss8 scaled 400
etex

beginfig(1);
u:=1mm;
r:=.5u;
pair matrix_origin; matrix_origin:=(-3.3cm,-1cm);
% row1
circleit.circ1();
circ1.n-circ1.c=up*r; circ1.e-circ1.c=right*r;
circ1.c=matrix_origin+right*2.5u;
drawboxed(circ1);
circleit.circ2();
circ2.n-circ2.c=up*r; circ2.e-circ2.c=right*r;
circ2.c=circ1.c+right*2u;
drawboxed(circ2);
circleit.circ3();
circ3.n-circ3.c=up*r; circ3.e-circ3.c=right*r;
circ3.c=circ2.c+right*2u;
drawboxed(circ3);
circleit.circA();
circA.n-circA.c=up*r; circA.e-circA.c=right*r;
circA.c=circ3.c+right*2u;
drawboxed(circA);

% row2
circleit.circ4();
circ4.n-circ4.c=up*r; circ4.e-circ4.c=right*r;
circ4.c=matrix_origin+right*2.5u+down*1.75u;
drawboxed(circ4);
circleit.circ5();
circ5.n-circ5.c=up*r; circ5.e-circ5.c=right*r;
circ5.c=circ4.c+right*2u;
drawboxed(circ5);
circleit.circ6();
circ6.n-circ6.c=up*r; circ6.e-circ6.c=right*r;
circ6.c=circ5.c+right*2u;
drawboxed(circ6);
circleit.circB();
circB.n-circB.c=up*r; circB.e-circB.c=right*r;
circB.c=circ6.c+right*2u;
drawboxed(circB);

% row3
circleit.circ7();
circ7.n-circ7.c=up*r; circ7.e-circ7.c=right*r;
circ7.c=matrix_origin+right*2.5u+down*3.5u;
drawboxed(circ7);
circleit.circ8();
circ8.n-circ8.c=up*r; circ8.e-circ8.c=right*r;
circ8.c=circ7.c+right*2u;
drawboxed(circ8);
circleit.circ9();
circ9.n-circ9.c=up*r; circ9.e-circ9.c=right*r;
circ9.c=circ8.c+right*2u;
drawboxed(circ9);
circleit.circC();
circC.n-circC.c=up*r; circC.e-circC.c=right*r;
circC.c=circ9.c+right*2u;
drawboxed(circC);

% row4
circleit.circ_ast();
circ_ast.n-circ_ast.c=up*r; circ_ast.e-circ_ast.c=right*r;
circ_ast.c=matrix_origin+right*2.5u+down*5.25u;
drawboxed(circ_ast);
circleit.circ0();
circ0.n-circ0.c=up*r; circ0.e-circ0.c=right*r;
circ0.c=circ_ast.c+right*2u;
drawboxed(circ0);
circleit.circ_hash();
circ_hash.n-circ_hash.c=up*r; circ_hash.e-circ_hash.c=right*r;
circ_hash.c=circ0.c+right*2u;
drawboxed(circ_hash);
circleit.circD();
circD.n-circD.c=up*r; circD.e-circD.c=right*r;
circD.c=circ_hash.c+right*2u;
drawboxed(circD);

draw (circ1.c+up*1mm+left*1mm) -- (circA.c+up*1mm+right*1mm) -- (circD.c+right*1mm+down*1mm) -- (circ_ast.c+down*1mm+left*1mm) -- cycle;

boxit.arduino(btex \eightss Arduino Micro etex);
arduino.c=(-3cm,0);
arduino.e-arduino.w=right*4cm;
arduino.n-arduino.s=up*1.4cm;
drawboxes(arduino); draw pic(arduino) shifted (up*2mm+left*6mm);
% pins
pair arduino.B[],arduino.D[],arduino.C[];
arduino.B7=arduino.se+left*4.25mm;
arduino.B6=arduino.B7+left*2.5mm;
arduino.B5=arduino.B6+left*2.5mm;
arduino.B4=arduino.B5+left*2.5mm;
arduino.B2=arduino.sw+right*1.75mm;
arduino.D3=arduino.B2+right*5mm;
arduino.D2=arduino.D3+right*2.5mm;
arduino.D1=arduino.D2+right*7.5mm;
% draw
begingroup;
interim rbox_radius:=1bp;
save A; pen A; A:=currentpen;
pickup pencircle scaled .1pt;
boxit.arduino.B0(btex \smallss B0 etex);
arduino.B0.c=arduino.e+left*.5u;
arduino.B0.ne=arduino.B0.sw+right*.2u+up*.15u; % TODO: do the rest like this
drawboxed(arduino.B0);
boxit.arduino.D5.box(btex \smallss D5 etex);
arduino.D5.box.c=arduino.B0.c+left*3mm;
arduino.D5.box.sw=arduino.D5.box.c+down*2pt+left*3pt;
drawboxed(arduino.D5.box);
boxit.arduino.C7.box(btex \smallss C7 etex);
arduino.C7.box.c=arduino.D5.box.c+left*3mm;
arduino.C7.box.sw=arduino.C7.box.c+down*2pt+left*3pt;
drawboxed(arduino.C7.box);
label.top(btex \smallss 11 etex, arduino.B7);
rboxit.arduino.B7.box(btex \smallss B7 etex);
arduino.B7.box.c=arduino.B7+up*3mm;
arduino.B7.box.sw=arduino.B7.box.c+down*2pt+left*3pt;
drawboxed(arduino.B7.box);
label.top(btex \smallss 10 etex, arduino.B6);
rboxit.arduino.B6.box(btex \smallss B6 etex);
arduino.B6.box.c=arduino.B6+up*3mm;
arduino.B6.box.sw=arduino.B6.box.c+down*2pt+left*3pt;
drawboxed(arduino.B6.box);
label.top(btex \smallss 9 etex, arduino.B5);
rboxit.arduino.B5.box(btex \smallss B5 etex);
arduino.B5.box.c=arduino.B5+up*3mm;
arduino.B5.box.sw=arduino.B5.box.c+down*2pt+left*3pt;
drawboxed(arduino.B5.box);
label.top(btex \smallss 8 etex, arduino.B4);
rboxit.arduino.B4.box(btex \smallss B4 etex);
arduino.B4.box.c=arduino.B4+up*3mm;
arduino.B4.box.sw=arduino.B4.box.c+down*2pt+left*3pt;
drawboxed(arduino.B4.box);
label.top(btex \smallss MOSI etex, arduino.B2);
rboxit.arduino.B2.box(btex \smallss B2 etex);
arduino.B2.box.c=arduino.B2+up*3mm;
arduino.B2.box.sw=arduino.B2.box.c+down*2pt+left*3pt;
drawboxed(arduino.B2.box);
label.top(btex \smallss TX etex, arduino.D3);
rboxit.arduino.D3.box(btex \smallss D3 etex);
arduino.D3.box.c=arduino.D3+up*3mm;
arduino.D3.box.sw=arduino.D3.box.c+down*2pt+left*3pt;
drawboxed(arduino.D3.box);
label.top(btex \smallss RX etex, arduino.D2);
rboxit.arduino.D2.box(btex \smallss D2 etex);
arduino.D2.box.c=arduino.D2+up*3mm;
arduino.D2.box.sw=arduino.D2.box.c+down*2pt+left*3pt;
drawboxed(arduino.D2.box);
label.top(btex \smallss 2 etex, arduino.D1);
rboxit.arduino.D1.box(btex \smallss D1 etex);
arduino.D1.box.c=arduino.D1+up*3mm;
arduino.D1.box.sw=arduino.D1.box.c+down*2pt+left*3pt;
drawboxed(arduino.D1.box);
pickup A;
endgroup;

path wire[];
pair wire[][];

wire1[1]=circ_ast.c+down*1mm+left*.5mm;
wire1[2]=wire1[1]+down*1mm;
xpart(wire1[3])=xpart(arduino.D1); ypart(wire1[3])=ypart(wire1[2]);
wire1[4]=arduino.D1;
draw wire1[1]--wire1[2]--wire1[3]--wire1[4];

wire2[1]=circ_ast.c+down*1mm+right*.5mm;
wire2[2]=wire2[1]+down*2mm;
xpart(wire2[3])=xpart(arduino.D2); ypart(wire2[3])=ypart(wire2[2]);
wire2[4]=arduino.D2;
draw wire2[1]--wire2[2]--wire2[3]--wire2[4];

wire3[1]=circ_ast.c+down*1mm+right*1.5mm;
wire3[2]=wire3[1]+down*3mm;
xpart(wire3[3])=xpart(arduino.D3); ypart(wire3[3])=ypart(wire3[2]);
wire3[4]=arduino.D3;
draw wire3[1]--wire3[2]--wire3[3]--wire3[4];

wire4[1]=circ_ast.c+down*1mm+right*2.5mm;
wire4[2]=wire4[1]+down*4mm;
xpart(wire4[3])=xpart(arduino.B2); ypart(wire4[3])=ypart(wire4[2]);
wire4[4]=arduino.B2;
draw wire4[1]--wire4[2]--wire4[3]--wire4[4];

wire5[1]=circ_ast.c+down*1mm+right*6.5mm;
wire5[2]=wire5[1]+down*1mm;
xpart(wire5[3])=xpart(arduino.B4); ypart(wire5[3])=ypart(wire5[2]);
wire5[4]=arduino.B4;
draw wire5[1]--wire5[2]--wire5[3]--wire5[4];

wire6[1]=circ_ast.c+down*1mm+right*5.5mm;
wire6[2]=wire6[1]+down*2mm;
xpart(wire6[3])=xpart(arduino.B5); ypart(wire6[3])=ypart(wire6[2]);
wire6[4]=arduino.B5;
draw wire6[1]--wire6[2]--wire6[3]--wire6[4];

wire7[1]=circ_ast.c+down*1mm+right*4.5mm;
wire7[2]=wire7[1]+down*3mm;
xpart(wire7[3])=xpart(arduino.B6); ypart(wire7[3])=ypart(wire7[2]);
wire7[4]=arduino.B6;
draw wire7[1]--wire7[2]--wire7[3]--wire7[4];

wire8[1]=circ_ast.c+down*1mm+right*3.5mm;
wire8[2]=wire8[1]+down*4mm;
xpart(wire8[3])=xpart(arduino.B7); ypart(wire8[3])=ypart(wire8[2]);
wire8[4]=arduino.B7;
draw wire8[1]--wire8[2]--wire8[3]--wire8[4];

endfig;

beginfig(2);
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

beginfig(3);
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
