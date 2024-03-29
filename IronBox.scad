/* IronBox.scad
Author: andimoto@posteo.de
----------------------------
for placing assambled parts and
single parts go to end of this file
 */

$fn=50;

boxHeight = 30;
boxY = 120;
boxX = 140;
wallThickness = 3;
sideThickness = 10;
edgeRadius = 2;
yMoveMagnet = 5; /* move magnet cutout in y direction */

magnetRadius = 5/2;
magnetRadiusTolerance=0.025;
magnetThickness = 1;

lockEdgeRadius = 2;
lockRadius = 10;
lockThickness = 6;

module sphereCut()
{
  translate([0,0,10])
  difference()
  {
    sphere(r=11);
    translate([0,13,0]) cube([22, 22, 22],center = true);
    translate([0,0,5.1]) cube([22, 22, 22],center = true);
  }
}

module lock(radius=lockRadius, height=lockThickness, negativ=false)
{
  difference() {
    /* lock part */
    minkowski()
    {
      difference() {
        hull()
        {
          cylinder(r=radius,h=height);
          translate([0,radius*2,0]) cylinder(r=radius,h=height);
        }
        translate([radius*2-radius/2,radius,0]) cylinder(r=radius,h=height);
        translate([-radius*2+radius/2,radius,0]) cylinder(r=radius,h=height);
      }
      cylinder(r=lockEdgeRadius,h=0.0000001, center=true);
    }


    if(negativ == false)
    {
      /* cutout for fingers */
      translate([0,0, 2.4]) sphereCut();
      translate([0,radius*2, 2.4]) rotate([0,0,180]) sphereCut();

      /* magnet holes */
      translate([0,-radius/1.5+1.5,0]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
      translate([0,radius*2+radius/1.5-1.5,0]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
    }

    /* debug cut */
    /* cube([radius*2,50,5]); */
  }
  if(negativ == true)
  {
    /* magnet holes */
    translate([0,-radius/1.5+1.5,-magnetThickness-0.7]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
    translate([0,radius*2+radius/1.5-1.5,-magnetThickness-0.7]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
  }
}


es120_dia1=19;
es120_len1=69;
es120_dia2=17;
es120_len2=64;

module es120()
{
  cylinder(r=es120_dia1/2,h=es120_len1);
  translate([0,0,es120_len1]) cylinder(r=es120_dia2/2,h=es120_len2);
}
/* temp1=es120_len1+es120_len2;
translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness,boxHeight/2+wallThickness]) rotate([0,90,0]) es120(); */

screwDriver_dia1=21;
screwDriver_dia2=19;
screwDriver_len1=65;
screwDriver_len2=35;
screwDriver_len3=22;

module hexScrewDriver()
{
  cylinder(r=screwDriver_dia1/2,h=screwDriver_len2);
  translate([0,0,screwDriver_len2]) cylinder(r1=screwDriver_dia1/2,r2=screwDriver_dia2/2,h=screwDriver_len1);
  translate([0,0,screwDriver_len1+screwDriver_len2]) cylinder(r=screwDriver_dia2/2,h=screwDriver_len3);
}

hexBitHolderX=52;
hexBitHolderY1=9;
hexBitHolderY2=14;
hexBitHolderZ=8;
hexBitHolderCnt=7;
hexBitHolderDist=20;
temp3bit=(hexBitHolderCnt-1)*hexBitHolderDist + hexBitHolderY2;
temp3=sideThickness+boxX-(boxX-temp3bit)/2;
module hexBitHolderCutout()
{
  cube([hexBitHolderX,hexBitHolderY1,hexBitHolderZ]);
  translate([0,0,hexBitHolderZ]) cube([hexBitHolderX,hexBitHolderY2,hexBitHolderZ+6]);
  translate([6,4,0]) cylinder(r=4,h=hexBitHolderZ+23);
}

boxTopSurface=wallThickness+boxHeight/2;




/* DEBUG */
  /* translate([edgeRadius,edgeRadius,0])
translate([-edgeRadius+lockThickness,
  boxY/2+wallThickness,
  (boxHeight/2+wallThickness)-lockRadius+0.5])
rotate([90,0,0]) rotate([0,-90,0]) lock(negativ=true); */


module halfCase(locks=true, magnets=true, caseCutout=true)
{
  /* move piece by edgeRadius to align it at zero */
  translate([edgeRadius,edgeRadius,0])
  difference() {
    /* complete case */
    minkowski()
    {
      cube([(boxX+sideThickness*2)-edgeRadius*2,
          (boxY+wallThickness*2)-edgeRadius*2,
          (boxHeight/2)+wallThickness]);
      cylinder(r=edgeRadius, h=0.0000001, center=false);
    }

    if(caseCutout == true)
    {
      /* case cutout */
      translate([sideThickness,wallThickness,wallThickness])
      minkowski()
      {
        cube([boxX-edgeRadius*2,
            boxY-edgeRadius*2,
            boxHeight/2]);
        cylinder(r=edgeRadius, h=0.0000001, center=false);
      }
    }

    if(magnets == true)
    {
      /* magnets */
      translate([-edgeRadius+sideThickness/2,
        -edgeRadius+wallThickness+magnetRadius+yMoveMagnet,
        boxHeight/2+wallThickness-magnetThickness])
      cylinder(r=magnetRadius, h=magnetThickness, center=false);
      translate([-edgeRadius+sideThickness/2,
        -edgeRadius+boxY-yMoveMagnet,
        boxHeight/2+wallThickness-magnetThickness])
      cylinder(r=magnetRadius, h=magnetThickness, center=false);

      translate([-edgeRadius+boxX+sideThickness+sideThickness/2,
        -edgeRadius+wallThickness+magnetRadius+yMoveMagnet,
        boxHeight/2+wallThickness-magnetThickness])
      cylinder(r=magnetRadius, h=magnetThickness, center=false);
      translate([-edgeRadius+boxX+sideThickness+sideThickness/2,
        -edgeRadius+boxY-yMoveMagnet,
        boxHeight/2+wallThickness-magnetThickness])
      cylinder(r=magnetRadius, h=magnetThickness, center=false);
    }

    if(locks == true)
    {
      color("yellow")
      translate([-edgeRadius+lockThickness,
        (boxY/2)-edgeRadius+wallThickness,
        (boxHeight/2+wallThickness)-lockRadius])
      rotate([90,0,0]) rotate([0,-90,0]) scale([1.02,1.02,1]) lock(negativ=true);

      color("yellow")
      translate([(boxX-edgeRadius*2+sideThickness*2+edgeRadius)-lockThickness,
        (boxY/2)-edgeRadius+wallThickness,
        (boxHeight/2+wallThickness)-lockRadius])
      rotate([90,0,0]) rotate([0,90,0]) scale([1.02,1.02,1]) lock(negativ=true);
    }
  }
}

module 4mmHexBit(height=15)
{
  x=4.4;
  y=2.35;
  translate([-x/2,-y/2,0]) cube([x,y,height]);
  rotate([0,0,60]) translate([-x/2,-y/2,0]) cube([x,y,height]);
  rotate([0,0,120]) translate([-x/2,-y/2,0]) cube([x,y,height]);
  translate([-4,-4,height-4]) cube([8,8,4]);
}
/* 4mmHexBit(); */

module shell(x=10,y=10,z=10,rad=0.5)
{
  cube([x,y,z]);
  translate([0,rad-0.3,z-1]) rotate([0,90,0]) cylinder(r=rad,h=x);
  translate([0,y-rad+0.3,z-1]) rotate([0,90,0]) cylinder(r=0.5,h=x);
}
/* shell(x=100,y=20,z=2); */


module screwDriverBox(top=true,bottom=true, hexBitHolder=true, hexInlets=false)
{
  if(bottom == true)
  {
    difference()
    {
      color("grey") translate([0,0,0]) halfCase(locks=true,magnets=true, caseCutout=false);

      temp1=es120_len1+es120_len2;
      translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness,boxHeight/2+wallThickness]) rotate([0,90,0]) es120();

      translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness-4,wallThickness])
        cube([es120_len1+es120_len2,8,10]);

      temp2=screwDriver_len1+screwDriver_len2+screwDriver_len3;
      translate([sideThickness+(boxX-temp2)/2,es120_dia1+screwDriver_dia1/2+wallThickness*2,boxHeight/2+wallThickness])
      rotate([0,90,0]) hexScrewDriver();

      translate([sideThickness+(boxX-temp2)/2,es120_dia1+screwDriver_dia1/2+wallThickness*2-4,wallThickness])
        cube([screwDriver_len1+screwDriver_len2+screwDriver_len3,8,10]);

      translate([sideThickness,48,wallThickness])
        shell(boxX,20,(boxHeight/2));
        /* cube([boxX,20,(boxHeight/2)]); */

      /* translate([sideThickness+20,48,wallThickness]) cube([boxX-40,20,(boxHeight/2)]); */


      if(hexBitHolder == true)
      {
        temp4=sideThickness+(boxX-temp3bit)/2;
        translate([temp4,boxY+wallThickness-hexBitHolderX,boxTopSurface-hexBitHolderZ])
        cube([temp3bit+4,hexBitHolderX,12]);

        extraX=8;
        extraZ=-3;
        translate([extraX+temp3,boxY+wallThickness-hexBitHolderX,boxTopSurface-hexBitHolderZ+extraZ])
        rotate([0,0,90])
        for (a =[1:hexBitHolderCnt])
        {
          translate([0,hexBitHolderDist*(a-1),0]) rotate([-30,0,0]) hexBitHolderCutout();
        }
      }

      if(hexInlets == true)
      {
        translate([boxX-sideThickness*2,70+53,wallThickness])
        rotate([0,0,-90])  shell(53,30,(boxHeight/2));

        translate([sideThickness+5,74,wallThickness])
        union()
        {
          for (j =[1:11])
          {
            for (i =[1:6])
            {
              translate([10*(j-1),9*(i-1),0]) 4mmHexBit();
            }
          }
        }
      }
    }
  }


  if(top == true)
  {

    mirror([1,0,0])
    difference()
    {
      color("grey")  translate([0,0,0]) halfCase(locks=true,magnets=true, caseCutout=false);

      temp1=es120_len1+es120_len2;
      translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness,boxHeight/2+wallThickness]) rotate([0,90,0]) es120();
      translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness-4,wallThickness])
        cube([es120_len1+es120_len2,8,10]);


      translate([sideThickness,48,wallThickness])
        /* cube([boxX,20,(boxHeight/2)]); */
        shell(boxX,20,(boxHeight/2));
      /* translate([sideThickness+20,48,wallThickness]) cube([boxX-40,20,(boxHeight/2)]); */

      temp2=screwDriver_len1+screwDriver_len2+screwDriver_len3;
      translate([sideThickness+(boxX-temp2)/2,es120_dia1+screwDriver_dia1/2+wallThickness*2,boxHeight/2+wallThickness])
      rotate([0,90,0]) hexScrewDriver();

      translate([sideThickness+(boxX-temp2)/2,es120_dia1+screwDriver_dia1/2+wallThickness*2-4,wallThickness])
        cube([screwDriver_len1+screwDriver_len2+screwDriver_len3,8,10]);

      /* font="Uroob:style=Regular"; */
      /* font="Gayathri:style=Bold"; */
      font="Padauk:style=Bold";
      translate([10,10,0])  linear_extrude(height = 0.6) text("IronBox - ES120", font=font);


      if(hexBitHolder == true)
      {
        extraX=1;
        extraZ=0;
        hexHolderCutoutTopZ=16;
        temp3bit=(hexBitHolderCnt-1)*hexBitHolderDist + hexBitHolderY2;
        temp4=sideThickness+(boxX-temp3bit)/2;
        translate([-extraX+temp4,boxY+wallThickness-hexBitHolderX,boxTopSurface-hexHolderCutoutTopZ+extraZ])
        cube([temp3bit+extraX*2,hexBitHolderX,16]);
      }

      if(hexInlets == true)
      {
        /* #translate([boxX-sideThickness-10,70,wallThickness]) cube([30,54,(boxHeight/2)]); */
        translate([boxX-sideThickness*2,70+53,wallThickness])
        rotate([0,0,-90])  shell(53,30,(boxHeight/2));
        translate([sideThickness,70,wallThickness]) cube([boxX-32,54,boxHeight/2]);
      }

    }
  }
}

/* shell lid */
/* #translate([sideThickness+5,48,wallThickness+boxHeight/2-2]) */
/* union()
{
  shell(boxX-0.6,19.6,(2));
  translate([10,7.5-0.2,0]) shell(5,5,7);
  translate([boxX-5-10,7.5-0.2,0]) shell(5,5,7);
} */


/* shell lid */
/* #translate([boxX-15,70+53,+wallThickness+boxHeight/2-2])
rotate([0,0,-90]) */
/* union()
{
  shell(53-0.6,30-0.2,(2));
  translate([10,12.5-0.1,0]) shell(5,5,7);
  translate([53-5-10,12.5-0.1,0]) shell(5,5,7);
} */



translate([5,0,0]) screwDriverBox(top=false,bottom=true,hexBitHolder=false,hexInlets=true);

/* mirror([0,0,0]) translate([0,0,boxHeight+wallThickness*2+1]) rotate([0,180,0]) */
translate([-5,0,0]) screwDriverBox(top=true,bottom=false,hexBitHolder=false,hexInlets=true);

module specialLock()
{
  translate([lockThickness,
    (boxY/2)+wallThickness,
    0])
  difference()
  {
    color("LightSkyBlue")
    translate([0,
      0,
      (boxHeight/2)+wallThickness-lockRadius])
    rotate([90,0,0]) rotate([0,-90,0]) lock(negativ=false);

    translate([-20,-20,-10]) cube([40,40,10]);
    translate([-20,-20,40-4]) cube([40,40,10]);
  }
}
/* specialLock(); */



intersection()
{
/* #screwDriverBox(top=false,bottom=true,hexBitHolder=false,hexInlets=true); */
/* screwDriverBox(top=false,bottom=true,hexInlets=false);
screwDriverBox(top=true,bottom=false,hexInlets=false); */
/* translate([70,0,0]) cube([20,70,40]); */
}

intersection()
{
/* screwDriverBox(top=true,bottom=false,hexBitHolder=false,hexInlets=true); */
/* screwDriverBox(top=false,bottom=true,hexInlets=false);
screwDriverBox(top=true,bottom=false,hexInlets=false); */
/* translate([-50,68,0]) cube([10,70,40]); */
}



/* ################ BUILD_LINE ################# */
/* ############################################# */
/* ########## Place keyboard case ############## */
/* ############################################# */

/* #color("grey") translate([0,0,0]) halfCase(locks=false,magnets=true, caseCutout=false); */
/* color("grey") translate([0,0,boxHeight+wallThickness*2+0.0]) mirror([0,0,1]) halfCase(locks=true,magnets=true); */


/* case locks */
/* color("LightSkyBlue") translate([lockThickness,
  (boxY/2)+wallThickness,
  (boxHeight/2)+wallThickness-lockRadius])
rotate([90,0,0]) rotate([0,-90,0]) lock(negativ=false); */

/* color("LightSkyBlue") translate([(boxX+sideThickness*2)-lockThickness,
  (boxY/2)+wallThickness,
  (boxHeight/2)+wallThickness-lockRadius])
rotate([90,0,0]) rotate([0,90,0]) lock(negativ=false); */



/*########### DEBUG ###########*/

/* test print */
/* difference()
{
  translate([0,0,0]) halfCase(locks=true,magnets=true);
  translate([0,-40,0]) cube([boxX+sideThickness*2+4,boxY+wallThickness*2+4,(boxHeight/2)+wallThickness]);
} */
