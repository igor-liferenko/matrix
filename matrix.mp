outputtemplate:="%j.eps"; prologues:=3;

input rboxes;

verbatimtex
\font\tenss=cmss10 \tenss
\font\eightss=cmss8
\font\smallss=cmss8 scaled 400
etex

beginfig(1);
u:=1mm;
r:=.5u;

% row1
circleit.circ1();
circ1.n-circ1.c=up*r; circ1.e-circ1.c=right*r;
circ1.c=origin+right*2.5u;
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
circ4.c=origin+right*2.5u+down*1.75u;
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
circ7.c=origin+right*2.5u+down*3.5u;
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
circ_ast.c=origin+right*2.5u+down*5.25u;
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
arduino.n-arduino.s=up*2cm;
drawboxed(arduino);
% pins
pair arduino.B[],arduino.D[],arduino.E[],arduino.GND[],arduino.VCC,arduino.RST,arduino.TX[];
%xpart(arduino.B5)=xpart(arduino4)+2mm; ypart(arduino.B5)=ypart(arduino4);
% draw
endfig;
end

begingroup;
save A; pen A; A:=currentpen;
pickup pencircle scaled .4pt;
boxit.arduino.B0.box(btex \smallss B0 etex);
arduino.B0.box.c=1/2[arduino.B4,arduino.B5]+down*5.5mm;
arduino.B0.box.sw=arduino.B0.box.c+down*2pt+left*3pt; % TODO: use sw and ne corners to specify full width and height, like in setup-tarif.mp, use rbox_radius, use thinner line for drawing the box
drawboxed(arduino.B0.box);
boxit.arduino.D5.box(btex \smallss D5 etex);
arduino.D5.box.c=(xpart(arduino.B0.box.c),ypart(arduino1)+5.5mm);
arduino.D5.box.sw=arduino.D5.box.c+down*2pt+left*3pt;
drawboxed(arduino.D5.box);
label.bot(btex \smallss 9 etex, arduino.B5);
rboxit.arduino.B5.box(btex \smallss B5 etex);
arduino.B5.box.c=arduino.B5+down*3mm;
arduino.B5.box.sw=arduino.B5.box.c+down*2pt+left*3pt;
drawboxed(arduino.B5.box);
label.bot(btex \smallss 8 etex, arduino.B4);
rboxit.arduino.B4.box(btex \smallss B4 etex);
arduino.B4.box.c=arduino.B4+down*3mm;
arduino.B4.box.sw=arduino.B4.box.c+down*2pt+left*3pt;
drawboxed(arduino.B4.box);
label.bot(btex \smallss 7 etex, arduino.E6);
rboxit.arduino.E6.box(btex \smallss E6 etex);
arduino.E6.box.c=arduino.E6+down*3mm;
arduino.E6.box.sw=arduino.E6.box.c+down*2pt+left*3pt;
drawboxed(arduino.E6.box);
label.bot(btex \smallss 6 etex, arduino.D7);
rboxit.arduino.D7.box(btex \smallss D7 etex);
arduino.D7.box.c=arduino.D7+down*3mm;
arduino.D7.box.sw=arduino.D7.box.c+down*2pt+left*3pt;
drawboxed(arduino.D7.box);
label.bot(btex \smallss 2 etex, arduino.D1);
rboxit.arduino.D1.box(btex \smallss D1 etex);
arduino.D1.box.c=arduino.D1+down*3mm;
arduino.D1.box.sw=arduino.D1.box.c+down*2pt+left*3pt;
drawboxed(arduino.D1.box);
label.bot(btex \smallss GND etex, arduino.GND1);
label.bot(btex \smallss GND etex, arduino.GND2);
piggyback(arduino.GND2);
label.bot(btex \smallss RX1 etex, arduino.D2);
rboxit.arduino.D2.box(btex \smallss D2 etex);
arduino.D2.box.c=arduino.D2+down*3mm;
arduino.D2.box.sw=arduino.D2.box.c+down*2pt+left*3pt;
drawboxed(arduino.D2.box);
label.bot(btex \smallss TX0 etex, arduino.TX0);
piggyback(arduino.TX0);
label.top(btex \smallss 10 etex, arduino.B6);
rboxit.arduino.B6.box(btex \smallss B6 etex);
arduino.B6.box.c=arduino.B6+up*3mm;
arduino.B6.box.sw=arduino.B6.box.c+down*2pt+left*3pt;
drawboxed(arduino.B6.box);
label.top(btex \smallss 16 etex, arduino.16);
piggyback(arduino.16);
label.top(btex \smallss 14 etex, arduino.14);
piggyback(arduino.14);
label.top(btex \smallss 15 etex, arduino.15);
piggyback(arduino.15);
label.top(btex \smallss VCC etex, arduino.VCC);
label.top(btex \smallss RST etex, arduino.RST);
piggyback(arduino.RST);
label.top(btex \smallss GND etex, arduino.GND3);
piggyback(arduino.GND3);
pickup A;
endgroup;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
