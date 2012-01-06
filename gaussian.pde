import processing.video.*;


class Landcover {
  color DEVELOPED_HIGH = -5636096;
  color DEVELOPED_MEDIUM = -917504;
  color DEVELOPED_LOW = -2385534;
  color DEVELOPED_OPEN = -2044724;
  color SHRUB = -3032446;
  color FOREST_EVERGREEN = -14916045;
  color FOREST_MIXED = -4535151;
  color FOREST_DECIDUOUS = -9721242;
  color WETLAND_WOODY = -4531987;
  color WETLAND_HERB = -9395265; 
  color GRASSLAND = -1710655;
  color WATER = -11965021;
  color BARREN = -4870237;
  color BLANK = -16777216;
  color CROP = -5410776;
  color PASTURE = -2238404;
  
  PImage source;
 
  Landcover( String filename ) {
    source = loadImage( filename );
  }
  
  void correctSourceColors() {
    source.loadPixels();
    
    for(int i=0; i<source.pixels.length; i++) {
      color px = source.pixels[i];
      if( px==DEVELOPED_HIGH )
        source.pixels[i] = #B5B5B5;
      else if( px==DEVELOPED_MEDIUM )
        source.pixels[i] = #A0B0A1;
      else if( px==DEVELOPED_LOW )
        source.pixels[i] = #C5DEC6;
    }
    
    source.updatePixels();
  }
  
  void update() {
    source.loadPixels();
    
    /*
    for(int i=0; i<source.pixels.length; i++){
          if(source.pixels[i]==DEVELOPED_MEDIUM){
            if(random(0,100)<1){
              source.pixels[i]=GRASSLAND;
            }
          }
    }*/
    
    for(int x=0; x<source.width; x++) {
      for(int y=0; y<source.height; y++) {
        int i = y*source.width+x;    
          if(source.pixels[i]==DEVELOPED_HIGH){
            float chance = 50000;
            ArrayList cont = search(source, x, y, GRASSLAND, 2);
            if( cont.size() > 0 ) {
              chance=50000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=GRASSLAND;
            }
          }
          if(source.pixels[i]==DEVELOPED_MEDIUM){
            float chance = 10000;
            ArrayList cont = search(source, x, y, GRASSLAND, 2);
            if( cont.size() > 0 ) {
              chance=10000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=GRASSLAND;
            }
          }
          if(source.pixels[i]==DEVELOPED_LOW){
            float chance = 5000;
            ArrayList cont = search(source, x, y, GRASSLAND, 2);
            if( cont.size() > 0 ) {
              chance=5000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=GRASSLAND;
            }
          }
          
          if(source.pixels[i]==DEVELOPED_OPEN) {
            float chance = 10000;
            ArrayList cont = search(source, x, y, GRASSLAND, 1);
            if( cont.size() > 0 ) {
              chance=100;
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=GRASSLAND;
            }
          }
          
          if(source.pixels[i]==GRASSLAND){
            float chance = 500000;
            ArrayList cont = search(source, x, y, FOREST_EVERGREEN, 1);
            if( cont.size() > 0 ) {
              chance=10000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=FOREST_EVERGREEN;
            }
          }
          
          if(source.pixels[i]==GRASSLAND){
            float chance = 500000;
            ArrayList cont = search(source, x, y, FOREST_MIXED, 1);
            if( cont.size() > 0 ) {
              chance=10000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=FOREST_MIXED;
            }
          }
          
          if(source.pixels[i]==GRASSLAND){
            float chance = 500000;
            ArrayList cont = search(source, x, y, FOREST_DECIDUOUS, 1);
            if( cont.size() > 0 ) {
              chance=1000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=FOREST_DECIDUOUS;
            }
          }
          
          if(source.pixels[i]==FOREST_DECIDUOUS){
            float chance = 500000000;
            ArrayList cont = search(source, x, y, FOREST_EVERGREEN, 1);
            if( cont.size() > 0 ) {
              chance=1000/(cont.size()+1);
            }
            
            if(random(0,chance)<1){
              source.pixels[i]=FOREST_EVERGREEN;
            }
          }
      }  
    }
    
    source.updatePixels();
  }
}

ArrayList search(PImage lc, int curx, int cury, color type, int radius) {
  //returns an arraylsit of distances to matched pixels
  
  int bb = max(0, cury-radius);
  int tt = min(lc.height,cury+radius+1);
  int ll = max(0, curx-radius);
  int rr = min(lc.width,curx+radius+1);
  
  ArrayList ret = new ArrayList();
  for(int x=ll; x<rr; x++) {
    for(int y=bb; y<tt; y++) {
      //println( "("+curx+","+cury+") ("+ll+","+bb+","+rr+","+tt+")" );
      //println( x+" "+y+","+curx+" " +cury );
      //exit();
      
      if(x==curx && y==cury) {
        continue;
      }
      
      int ix = y*lc.width+x;
      if(lc.pixels[ix]==type){
        ret.add( dist(curx,cury,x,y) );
      }
    }
  }
  return ret;
}

PVector gaussian(float x, float y, float stddev) {
  float x1, x2, w, y1, y2;
 
  do {
    x1 = 2.0 * random(0,1) - 1.0;
    x2 = 2.0 * random(0,1) - 1.0;
    w = x1 * x1 + x2 * x2;
  } while ( w >= 1.0 );

  w = sqrt( (-2.0 * log( w ) ) / w );
  y1 = (x1 * w)*stddev+x;
  y2 = (x2 * w)*stddev+y;
         
  return new PVector(y1,y2);
}

void keyPressed() {
  save("gaussian.png");
  if( key == ' ' ) {
    mm.finish();
  }
}

Landcover lc;
MovieMaker mm;

void setup() {
  size(1000,1000);
  background(255);
  
  smooth();
  
  stroke(0);
  strokeWeight(1);
  
  frameRate(100);
  
  lc = new Landcover( "sf.bmp" );
  
  mm = new MovieMaker(this, width, height, "apocalypse.mov", 30, MovieMaker.H263, MovieMaker.BEST);
}

void draw() {
  for(int i=0; i<10; i++)
    lc.update();
  image( lc.source, 0 , 0, width, height );
  
  mm.addFrame();
}
