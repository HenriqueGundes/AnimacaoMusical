// Codigo baseado em:
// https://github.com/samuellapointe/ProcessingCubes
// Animação apartir de musica
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.video.*;
 
Minim minim;
//AudioPlayer song;
FFT fft;

int nbObjetos;
Objeto[] Objetos;
Obj[] icos;
 
AudioInput song;
 // Variaveis
float specLow = 0.15;
float specMid = 0.80;  
float specHi = 0.40; 

float scoreLow = 0;
float scoreMid = 0;
float scoreHi = 0;

float oldScoreLow = scoreLow;
float oldScoreMid = scoreMid;
float oldScoreHi = scoreHi;
float scoreDecreaseRate = 50;

void setup()
{
  //fullScreen(P3D, 1);
  size(1280, 680, P3D);
  minim = new Minim(this);
  song = minim.getLineIn(Minim.MONO); 
  //song = minim.loadFile("song.mp3");
  //song = minim.getLineIn();
  //Minim minim2 = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  //AudioInput in2 = minim.getLineIn();
  
  //Analisa a musica
  fft = new FFT(song.bufferSize(), song.sampleRate());
  //fft = new FFT(in.bufferSize(), in.sampleRate());
  //Um objeto por banda de frequencia
  nbObjetos = (int)((fft.specSize()*specHi)/3);
  Objetos = new Objeto[nbObjetos];                                                                                          

  // Cria objetos e Objetos
  for (int i = 0; i < nbObjetos; i++) {
   Objetos[i] = new Objeto(); 
  }
  
  background(0);
  
 //song.play(0);
}
 
void draw()
{
  fft.forward(song.mix);
 
  oldScoreLow = scoreLow;
  oldScoreMid = scoreMid;
  oldScoreHi = scoreHi;
  
  scoreLow = 0;
  scoreMid = 0;
  scoreHi = 0;
 
  //Calcular novos valores
  for(int i = 0; i < fft.specSize()*specLow; i++)
  {
    scoreLow += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specLow); i < fft.specSize()*specMid; i++)
  {
    scoreMid += fft.getBand(i);
  }
  
  for(int i = (int)(fft.specSize()*specMid); i < fft.specSize()*specHi; i++)
  {
    scoreHi += fft.getBand(i);
  }
  
  //Para diminuir a velocidade da descida
  if (oldScoreLow > scoreLow) {
    scoreLow = oldScoreLow - scoreDecreaseRate;
  }
  
  if (oldScoreMid > scoreMid) {
    scoreMid = oldScoreMid - scoreDecreaseRate;
  }
  
  if (oldScoreHi > scoreHi) {
    scoreHi = oldScoreHi - scoreDecreaseRate;
  }
  
  //Volume para todas as freqüências neste momento
  //permite que a animação vá mais rápido para os sons mais agudos
  float scoreGlobal = 0.66*scoreLow + 0.8*scoreMid + 1*scoreHi;
  
  //Cor de fundo
  background(scoreLow/100, scoreMid/100, scoreHi/100);
   
  //Objeto para cada banda de frequência
  for(int i = 0; i < nbObjetos; i++)
  {
    //Valor da banda de frequência
    float bandValue = fft.getBand(i);

    Objetos[i].display(scoreLow, scoreMid, scoreHi, bandValue, scoreGlobal);
  }
  
  float previousBandValue = fft.getBand(0);
  
  //Distância entre cada ponto de linha, negativa porque na dimensão z
  float dist = -25;
  
  float heightMult = 2;
  
  //Para cada banda
  for(int i = 1; i < fft.specSize(); i++)
  {
    float bandValue = fft.getBand(i)*(1 + (i/50));
    //Seleção da cor de acordo com as forças dos diferentes tipos de sons
    if( scoreLow < 10) stroke(0, 50, 0);
    else stroke(0.3*(100+scoreLow), 0.4*(100+scoreMid), 0.3*(100+scoreHi), 255-i);
    //stroke(0, 100, 0);
    strokeWeight(1 + (scoreGlobal/100));
    lights();
    //linha inferior esquerda
    line(0, height-(previousBandValue*heightMult), dist*(i-1), 0, height-(bandValue*heightMult), dist*i);

    
    //linha superior esquerda
    line(0, (previousBandValue*heightMult), dist*(i-1), 0, (bandValue*heightMult), dist*i);

    
    //linha inferior direita
    line(width, height-(previousBandValue*heightMult), dist*(i-1), width, height-(bandValue*heightMult), dist*i);

    
    //linha superior direita
    line(width, (previousBandValue*heightMult), dist*(i-1), width, (bandValue*heightMult), dist*i);
    
 

    //linha superior centro
    line(width/2, (previousBandValue*heightMult), dist*(i-1), width/2, (bandValue*heightMult), dist*i);

    //linha inferior centro
    line(width/2, height-(previousBandValue*heightMult), dist*(i-1), width/2, (height-(bandValue*heightMult)), (dist*i));

    
  }
}

//Classe para Objetos flutuando no espaço
class Objeto {
  float startingZ = -10000;
  float maxZ = 2000;
  
  float x, y, z;
  float rotX, rotY, rotZ;
  float sumRotX, sumRotY, sumRotZ;
  
  //construtor
  Objeto() {
    x = random(50, width - 50);
    y = random(50, height - 50);
    z = random(startingZ, maxZ);
    // rotacao Objeto
    rotX = random(3.14, 2 * 3.14);
    rotY = random(3.14, 2 * 3.14);
    rotZ = random(3.14, 2 * 3.14);
  }
  
  void display(float scoreLow, float scoreMid, float scoreHi, float intensity, float scoreGlobal) {
    
    //Seleção da cor, opacidade determinada pela intensidade (volume da banda)
    color displayColor = color(scoreLow*0.67, scoreMid*0.67, scoreHi*0.67, intensity*10);
    fill(displayColor, 255);
    //fill(displayColor, random(255) - displayColor, random(255), random(255));
    //Linhas de cor, elas desaparecem com a intensidade individual do Objeto
    color strokeColor = color(255, 150-(20*intensity));

    stroke(strokeColor);
    strokeWeight(1 + (scoreGlobal/300));
    //noFill();
    
    //Criando uma matriz de transformação para executar rotações, ampliações
    pushMatrix();
    
    translate(x, y, z);
    
    //Cálculo da rotação de acordo com a intensidade do Objeto
    sumRotX += intensity*(rotX/500);
    sumRotY += intensity*(rotY/500);
    sumRotZ += intensity*(rotZ/500);
    
    //rotação
    rotateX(sumRotX);
    rotateY(sumRotY);
    rotateZ(sumRotZ);

    //sphere(50);
    Obj ico = new Obj(40 + (intensity/1.5));
    ico.cria();
    //sphere(10);
  
    popMatrix();
    
    z+= (1+(intensity/5)+(pow((scoreGlobal/150), 2)));
    
    //Substitua a caixa na parte de trás quando ela não estiver mais visível
    if (z >= maxZ) {
      x = random(0, width);
      y = random(0, height);
      z = startingZ;
    }
  }
}