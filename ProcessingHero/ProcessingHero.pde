import processing.sound.*;
SoundFile file;

Scene scena;
Hero rycerz;
Target zamek;
Scenario level1;
Message m;

ArrayList<PImage> im = new ArrayList<PImage>();
PImage img_zamek, img_win, img_lost;

void setup() {

  //fullScreen();
  //frameRate(1);
  size(600, 600);
  im.add(loadImage("data/tonyk_right_up.png"));
  im.add(loadImage("data/tonyk_left_up.png"));
  im.add(loadImage("data/tonyk.png"));
  img_zamek = loadImage("data/mystica-Castle-color.png");
  img_win = loadImage("data/win.png");
  img_lost = loadImage("data/lost.png");
  scena = new Scene(50);
  rycerz = new Hero(new PVector(500, 500), im);
  zamek = new Target(new PVector(100, 100), img_zamek);
  m = new Message(new PVector(width/2, height/2), "ZWYCIESTWO!", img_win, img_lost);
  level1 = new Scenario(rycerz, zamek, m);

  for (int i=0; i<200; i++) {
    scena.addSpot();
  }
  file = new SoundFile(this, "Lobo_Loco_-_03_-_Do_You_Remember_ID_356.mp3");
  file.play();
}

void draw() {
scena.display();
zamek.display();
level1.play();

if (rycerz.location.y>150) {
    rycerz.goUp();
  } else {
    rycerz.goLeft();
  }
  
}

class Spot {

  PVector location;
  int radius, clr;

  Spot() {
    location = new PVector(random(width), random(height));
    radius = int(5+random(30));
    clr = int(180+random(50));
  }

  void display() {
    fill(150, clr, 120);
    noStroke();
    ellipse(location.x, location.y, radius, radius);
  }
}

//----------------------------------
class Scene {
  ArrayList<Spot> spots;
  PVector origin;

  int n;
  int d;
  int dst;

  Scene(int d) {
    spots = new ArrayList<Spot>();

    n=width/d;
    dst=d;
  }

  void addSpot() {
    spots.add(new Spot());
  }

  void display() {
    background(170, 204, 130);
    for (int i = spots.size()-1; i >= 0; i--) {
      Spot p = spots.get(i);
      p.display();
    }

    for (int i=0; i<n; i++){
      stroke(255);
      line(0, i*dst, width, i*dst);
      line(i*dst, 0, i*dst, height);
      fill(0, 0, 0);
      text(i*dst, i*dst+2, 10);
      if (i>0) {
        text(i*dst, 2, i*dst+12);
      }
    }
  }
}

//----------------------------------
class Target{
  
  PVector location;
  PImage img;
  
  Target(PVector l, PImage images){
    location = l.copy(); 
    img = images;
  }
  
  void display(){
   image(img, location.x-img.width/30, location.y-img.height/30, img.width/15, img.height/15); 
  }
  
}

//----------------------------------
class Scenario{
  Hero hro;
  Target trg;
  Message msg;
  float distance;
  int counter;
  float x, y, wdh, hgt;
  float c1, c2, c3, c4, c5, c6, c7, sin, freq, cst;
  
  Scenario(Hero h, Target t, Message m){
    hro = h;
    trg = t;
    msg = m;
    
    cst=3;
    freq = 0.1;
    
    wdh = msg.img1.width/cst;
    hgt = msg.img1.height/cst;
    
    x = msg.location.x-0.5*wdh;
    y = msg.location.y-0.5*hgt;
    
    sin = 0;
    
    counter=0;
  }
  
  
  void play(){
   distance = pow(trg.location.x-hro.location.x, 2)+pow(trg.location.y-hro.location.y, 2);
   if(sqrt(distance)<60){ 
   hro.amp=0;
   fill(255);
   sin = sin(freq*counter);
   image(msg.img1, x-10*sin, y-5*sin, wdh+20*sin, hgt+10*sin);
   counter++;
   }
  
  }
  
}

//----------------------------------
class Message{
  PVector location;
  String msg;
  PImage img1, img2;
  
  Message(PVector l, String sentence, PImage im1, PImage im2){
    location = l.copy(); 
    msg = sentence;
    img1 = im1;
    img2 = im2;
    
  }
  
  
}

//----------------------------------
class Hero {
  PVector location;
  ArrayList<PImage> img;
  PImage pimg;
  int iterator, indeks;
  int amp;

  Hero(PVector l, ArrayList<PImage> images) {
    location = l.copy(); 
    img = images; //nie jestem pewien czy to dobry sposob kopiowania ArrayList
    iterator=0;
    indeks=0;
    amp = 1;
  }

  void walk() {
    indeks=(iterator/10)%2*amp;
    pimg=img.get(indeks);
    image(pimg, location.x-pimg.width/2, location.y-pimg.height/2, pimg.width, pimg.height);
    iterator=(iterator+1);
  }
  
   void show() {
    indeks=2;
    pimg=img.get(indeks);
    image(pimg, location.x-pimg.width/2, location.y-pimg.height/2, pimg.width, pimg.height);
  }

  void goRight() {
    location.add(amp*1, 0);  
    walk();
  }

  void goLeft() {
    location.add(-amp*1, 0); 
    walk();
  }

  void goDown() {
    location.add(0, amp*1);  
    walk();
  }

  void goUp() {
    location.add(0, -amp*1); 
    walk();
  }
  
  void goPeriodicRight() {
    location.add(amp*1, 0);  
    walk();
    location.x = (width+location.x) % width;
    location.y = (height+location.y) % height;
  }

  void goPeriodicLeft() {
    location.add(-amp*1, 0); 
    walk();
    location.x = (width+location.x) % width;
    location.y = (height+location.y) % height;
  }

  void goPeriodicDown() {
    location.add(0, amp*1);  
    walk();
    location.x = (width+location.x) % width;
    location.y = (height+location.y) % height;
  }

  void goPeriodicUp() {
    location.add(0, -amp*1); 
    walk();
    location.x = (width+location.x) % width;
    location.y = (height+location.y) % height;
  }
  
}