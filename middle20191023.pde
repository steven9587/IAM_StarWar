PImage shooter;
PImage boss;
PImage titlePage;
PImage background;
int bossX = 60;
int bossY = 40;
int bossMove = 2;
int victoryX = 130;
int victoryMove = 5;
int gameoverX = 50;
int gameoverMove = 2;
int[] positionX;
int[] positionY;
boolean[] bulletLife;
int pointer = 0;
int number = 20000;
int bossBloodStar = 0;
int bossBlood;
int airplaneBloodStar = 0;
int airplaneBlood;
boolean start = false;
int transparency = 255;
int transparencyChange = 30;
int[] bossAtackX;
int[] bossAtackY;
int[] bossAtackMoveX;
int[] bossAtackMoveY;
boolean[] bossAtackLife;
int bossBallnumber = 100;
int locationX = 300;
int locationY = 670;
//transmitData
import processing.serial.*;
Serial myPort;
byte[] data = new byte[3];
int left, right, shoot;
//sound
import processing.sound.*;
SoundFile victory;
SoundFile fail;

void setup() {
  //sound
  victory = new SoundFile(this, "victorySound.mp3");
  fail = new SoundFile(this, "failSound.mp3");
  //stroke(#FEFF03);
  //rect(200, 100, 50, 50);
  background(0);
  size(600, 800);
  bossBlood = width;
  airplaneBlood = width;
  smooth();
  fill(0);
  shooter = loadImage("shooter.png");
  boss = loadImage("boss1.png");
  titlePage = loadImage("titlePage.png");
  background = loadImage("background.png");
  positionX = new int[number];
  positionY = new int[number];
  bulletLife = new boolean[number];
  bossAtackX = new int[number];
  bossAtackY = new int[number];
  bossAtackMoveX = new int[number];
  bossAtackMoveY = new int[number];
  bossAtackLife = new boolean[number];
  for (int i = 0; i<bossBallnumber; i++ ) {
    bossAtackMoveX[i] = int(random(81)-41);
    bossAtackMoveY[i] = int(random(81)-41);
    bossAtackX[i] = 300;
    bossAtackY[i] = 200;
    bossAtackLife[i] = true;
  }
  //transmitData
  String portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  getData();
  if (left == 1) {
    locationX-=10;
  }
  if (right  == 1) {
    locationX+=10;
  }
  if (start == true) {
    image(background, 0, 0, 600, 800);
    airplane();
    bossAtack();
    boss();
    bullet();
    //bossblood
    fill(255);
    rect(0, 0, width, 30);
    fill(255, 0, 0);
    rect(bossBloodStar, 0, bossBlood, 30);
    //airplaneblood  
    fill(255);
    rect(0, 770, width, 30);
    fill(#C724DE);
    rect(airplaneBloodStar, 770, airplaneBlood, 30);
    //airpainHeart
    stroke(#FEFF03);
    strokeWeight(3);
    noFill();
    //rect(mouseX-15, 710, 30, 50);
    rect(locationX-15, 710, 30, 50);
    //hitAirpainHeart

    for (int i = 0; i<bossBallnumber; i++) {
      //bullet is in the range x and y
      if (bossAtackX[i]>mouseX-15 && bossAtackX[i]<mouseX-15+30 && bossAtackY[i]>750 && bossAtackY[i]<790 && bossAtackLife[i] == true) {
        //if game is still playing
        if (bossBloodStar<600) {
          airplaneBloodStar+=60;
          airplaneBlood-=60;
          bossAtackLife[i] =false;
          break;
        }
      }
    }

    //bossHead
    //stroke(#FEFF03);
    //strokeWeight(5);
    noFill();
    rect(110, 50, 100, 60);

    //hitBossHead
    for (int i = 0; i<pointer; i++) {
      //bullet is in the range x and y
      if (positionX[i]>110 && positionX[i]<210 && positionY[i]>40 && positionY[i]<100 && bulletLife[i] == true) {
        //if game is still playing
        if (airplaneBloodStar<600) {
          bossBloodStar+=20;
          bossBlood-=20;
          bulletLife[i] =false;
          break;
        }
      }
    }

    if (airplaneBloodStar>=600) {
      lose();
    }
    if (bossBloodStar>=600) {
      win();
    }
  } else {
    image(titlePage, -65, 0, 710, 800);
    fill(255, 255, 255, transparency);
    textSize(30);
    text("Touch screen to start", 150, 700);
    if (transparency >= 255) {
      transparencyChange=-5;
    } else if (transparency <= 0) {
      transparencyChange=5;
    }
    transparency+=transparencyChange;
    if (mousePressed == true) {
      start = true;
    }
  }
}

void bossAtack() {
  fill(#FEFF03);
  noStroke();
  //create balls
  for (int i = 0; i<bossBallnumber; i++ ) {
    ellipse(bossAtackX[i], bossAtackY[i], 12, 12);
    bossAtackX[i] += bossAtackMoveX[i];
    bossAtackY[i] += bossAtackMoveY[i];
    if (bossAtackX[i]>600 || bossAtackX[i]<0 || bossAtackY[i]>800 ||bossAtackY[i]<0) {
      bossAtackX[i] = 300;
      bossAtackY[i] = 200;
      bossAtackMoveX[i] = int(random(81)-41);
      bossAtackMoveY[i] = int(random(81)-41);
      bossAtackLife[i] = true;
    }
  }
}
void boss() {
  image(boss, bossX, bossY, 500, 300);
}

void airplane() {
  frameRate(60);
  if (locationX<0) {
    locationX = 0;
  } else if (locationX>600) {
    locationX = 600;
  }
  //image(shooter, mouseX-73, 670, 140, 100);
  image(shooter, locationX-73, locationY, 140, 100);
}

void bullet() {
  //create the bullet
  if (mousePressed == true || shoot == 1) {
    positionX[pointer] = locationX;
    positionY[pointer] = 690;
    bulletLife[pointer] = true;
    pointer+=1;
    if (pointer >= number) {
      pointer = 0;
    }
  }

  //draw the bullet
  frameRate(10);
  fill(#FF0000);
  noStroke();
  for (int i = 0; i<pointer; i++) {
    noStroke();
    ellipse(positionX[i], positionY[i], 8, 12);
    positionY[i]-=40;
  }
  frameRate(60);
}

void lose() {
  if (fail.isPlaying() == false) {
    fail.play();
  }
  background(0);
  frameRate(60);
  //text(victory)
  fill(#FFD70D);
  textSize(100);
  text("game over!", gameoverX, 400);
  if (gameoverX >= 60) {
    gameoverMove=-2;
  } else if (gameoverX <= 0) {
    gameoverMove=2;
  }
  gameoverX+=gameoverMove;
  //button(next)
  fill(#2EADFF);
  stroke(255);
  rect(220, 450, 180, 60);
  fill(255);
  textSize(30);
  text("Play Again", 235, 490);
  playAgain();
}

void playAgain() {
  if (mousePressed == true) {
    if (mouseX>220 && mouseX<400 && mouseY>450 && mouseY<510) {
      bossBloodStar = 0;
      bossBlood = width;
      airplaneBloodStar = 0;
      airplaneBlood = width;
      fail.stop();
      start = false;
    }
  }
}

void win() {
  if (victory.isPlaying() == false) {
    victory.play();
  }
  background(0);
  frameRate(60);
  //text(victory)
  fill(#FFD70D);
  textSize(100);
  text("Victory!", victoryX, 400);
  if (victoryX >= 240) {
    victoryMove = -5;
  } else if (victoryX <= 0) {
    victoryMove = 5;
  }
  victoryX+=victoryMove;
  //button(play again)
  fill(#2EADFF);
  stroke(255);
  rect(260, 450, 100, 60);
  fill(255);
  textSize(30);
  text("Next", 275, 490);
  next();
}

void next() {
  if (mousePressed == true) {
    if (mouseX>220 && mouseX<400 && mouseY>450 && mouseY<510) {
      bossBloodStar = 0;
      bossBlood = width;
      airplaneBloodStar = 0;
      airplaneBlood = width;
      //draw();
      victory.stop();
    }
  }
}

void getData() {
  byte[] data = new byte[3];
  if (myPort.available()>0) {
    myPort.readBytes(data);
    left = data[0];
    right = data[1];
    shoot = data[2]; 
    println(left, right, shoot);
  }
}
