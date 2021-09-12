/* IronBox.scad
Author: andimoto@posteo.de
----------------------------
for placing assambled parts and
single parts go to end of this file
 */

$fn=70;

boxHeight = 40;
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
      translate([0,-radius/1.5,0]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
      translate([0,radius*2+radius/1.5,0]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
    }

    /* debug cut */
    /* cube([radius*2,50,5]); */
  }
  if(negativ == true)
  {
    /* magnet holes */
    translate([0,-radius/1.5,-magnetThickness-0.7]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
    translate([0,radius*2+radius/1.5,-magnetThickness-0.7]) cylinder(r=magnetRadius+magnetRadiusTolerance, h=magnetThickness+0.7, center=false);
  }
}


es120_dia1=18;
es120_len1=69;
es120_dia2=16;
es120_len2=64;

module es120()
{
  cylinder(r=es120_dia1/2,h=es120_len1);
  translate([0,0,es120_len1]) cylinder(r=es120_dia2/2,h=es120_len2);
}
temp1=es120_len1+es120_len2;
translate([sideThickness+(boxX-temp1)/2,es120_dia1/2+wallThickness,boxHeight/2+wallThickness]) rotate([0,90,0]) es120();

screwDriver_dia1=20;
screwDriver_dia2=18;
screwDriver_len1=65;
screwDriver_len2=35;
screwDriver_len3=22;

module hexScrewDriver()
{
  cylinder(r=screwDriver_dia1/2,h=screwDriver_len2);
  translate([0,0,screwDriver_len2]) cylinder(r1=screwDriver_dia1/2,r2=screwDriver_dia2/2,h=screwDriver_len1);
  translate([0,0,screwDriver_len1+screwDriver_len2]) cylinder(r=screwDriver_dia2/2,h=screwDriver_len3);
}
temp2=screwDriver_len1+screwDriver_len2+screwDriver_len3;
translate([sideThickness+(boxX-temp2)/2,es120_dia1+screwDriver_dia1/2+wallThickness*2,boxHeight/2+wallThickness]) rotate([0,90,0]) hexScrewDriver();

hexBitHolderX=52;
hexBitHolderY1=9;
hexBitHolderY2=14;
hexBitHolderZ=8;

module hexBitHolderCutout()
{
  cube([hexBitHolderX,hexBitHolderY1,hexBitHolderZ]);
  translate([0,0,hexBitHolderZ]) cube([hexBitHolderX,hexBitHolderY2,hexBitHolderZ]);
}
boxTopSurface=wallThickness+boxHeight/2;
translate([hexBitHolderY2+sideThickness,boxY+wallThickness-hexBitHolderX,boxTopSurface-hexBitHolderZ]) rotate([0,0,90]) hexBitHolderCutout();

module customCutout()
{


}

/* customCutout(); */


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
    }else{
      customCutout();
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

/* ################ BUILD_LINE ################# */
/* ############################################# */
/* ########## Place keyboard case ############## */
/* ############################################# */

color("grey") translate([0,0,0]) halfCase(locks=true,magnets=true, caseCutout=false);
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
