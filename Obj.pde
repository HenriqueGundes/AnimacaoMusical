 class Obj extends Shape3D{

  PVector tPonto;
  PVector[] tPent = new PVector[5];
  PVector bPonto;
  PVector[] bPent = new PVector[5];
  float angulo = 0, raio = 100;
  float triDist;
  float triHt;
  float a, b, c;

  // CONSTRUTOR
  Obj(float raio){
    this.raio = raio;
    inicia();
  }

  Obj(PVector v, float raio){
    super(v);
    this.raio = raio;
    inicia();
  }

  // CALCULO
  void inicia(){
    c = dist(cos(0)*raio, sin(0)*raio, cos(radians(72))*raio,  sin(radians(72))*raio);
    b = raio;
    a = (float)(Math.sqrt(((c*c)-(b*b))));

    triHt = (float)(Math.sqrt((c*c)-((c/2)*(c/2))));

    for (int i=0; i<tPent.length; i++){
      tPent[i] = new PVector(cos(angulo)*raio, sin(angulo)*raio, triHt/2.0f);
      angulo+=radians(72);
    }
    tPonto = new PVector(0, 0, triHt/2.0f+a);
    angulo = 72.0f/2.0f;
    for (int i=0; i<tPent.length; i++){
      bPent[i] = new PVector(cos(angulo)*raio, sin(angulo)*raio, -triHt/2.0f);
      angulo+=radians(72);
    }
    bPonto = new PVector(0, 0, -(triHt/2.0f+a));
  }

  // DESENHA 
  void cria(){
    for (int i=0; i<tPent.length; i++){
      // Obj topo
      beginShape();
      if (i<tPent.length-1){
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+tPonto.x, y+tPonto.y, z+tPonto.z);
        vertex(x+tPent[i+1].x, y+tPent[i+1].y, z+tPent[i+1].z);
      } 
      else {
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+tPonto.x, y+tPonto.y, z+tPonto.z);
        vertex(x+tPent[0].x, y+tPent[0].y, z+tPent[0].z);
      }
      endShape(CLOSE);

      // Obj inferior
      beginShape();
      if (i<bPent.length-1){
        vertex(x+bPent[i].x, y+bPent[i].y, z+bPent[i].z);
        vertex(x+bPonto.x, y+bPonto.y, z+bPonto.z);
        vertex(x+bPent[i+1].x, y+bPent[i+1].y, z+bPent[i+1].z);
      } 
      else {
        vertex(x+bPent[i].x, y+bPent[i].y, z+bPent[i].z);
        vertex(x+bPonto.x, y+bPonto.y, z+bPonto.z);
        vertex(x+bPent[0].x, y+bPent[0].y, z+bPent[0].z);
      }
      endShape(CLOSE);
    }

    // Obj corpo
    for (int i=0; i<tPent.length; i++){
      if (i<tPent.length-2){
        beginShape();
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+bPent[i+1].x, y+bPent[i+1].y, z+bPent[i+1].z);
        vertex(x+bPent[i+2].x, y+bPent[i+2].y, z+bPent[i+2].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bPent[i+2].x, y+bPent[i+2].y, z+bPent[i+2].z);
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+tPent[i+1].x, y+tPent[i+1].y, z+tPent[i+1].z);
        endShape(CLOSE);
      } 
      else if (i==tPent.length-2){
        beginShape();
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+bPent[i+1].x, y+bPent[i+1].y, z+bPent[i+1].z);
        vertex(x+bPent[0].x, y+bPent[0].y, z+bPent[0].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bPent[0].x, y+bPent[0].y, z+bPent[0].z);
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+tPent[i+1].x, y+tPent[i+1].y, z+tPent[i+1].z);
        endShape(CLOSE);
      }
      else if (i==tPent.length-1){
        beginShape();
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+bPent[0].x, y+bPent[0].y, z+bPent[0].z);
        vertex(x+bPent[1].x, y+bPent[1].y, z+bPent[1].z);
        endShape(CLOSE);

        beginShape();
        vertex(x+bPent[1].x, y+bPent[1].y, z+bPent[1].z);
        vertex(x+tPent[i].x, y+tPent[i].y, z+tPent[i].z);
        vertex(x+tPent[0].x, y+tPent[0].y, z+tPent[0].z);
        endShape(CLOSE);
      }
    }
  }

  // overrided metodos de Shape3D
  void rotZ(float theta){
    float tx=0, ty=0, tz=0;
    // topo ponto
    tx = cos(theta)*tPonto.x+sin(theta)*tPonto.y;
    ty = sin(theta)*tPonto.x-cos(theta)*tPonto.y;
    tPonto.x = tx;
    tPonto.y = ty;

    // inferior ponto
    tx = cos(theta)*bPonto.x+sin(theta)*bPonto.y;
    ty = sin(theta)*bPonto.x-cos(theta)*bPonto.y;
    bPonto.x = tx;
    bPonto.y = ty;

    // topo e inferior pentagonos
    for (int i=0; i<tPent.length; i++){
      tx = cos(theta)*tPent[i].x+sin(theta)*tPent[i].y;
      ty = sin(theta)*tPent[i].x-cos(theta)*tPent[i].y;
      tPent[i].x = tx;
      tPent[i].y = ty;

      tx = cos(theta)*bPent[i].x+sin(theta)*bPent[i].y;
      ty = sin(theta)*bPent[i].x-cos(theta)*bPent[i].y;
      bPent[i].x = tx;
      bPent[i].y = ty;
    }
  }

  void rotX(float theta){
  }

  void rotY(float theta){
  }


}

abstract class Shape3D{
  float x, y, z;
  float w, h, d;

  Shape3D(){
  }

  Shape3D(float x, float y, float z){
    this.x = x;
    this.y = y;
    this.z = z;
  }

  Shape3D(PVector p){
    x = p.x;
    y = p.y;
    z = p.z;
  }


  Shape3D(Dimensao dim){
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  Shape3D(float x, float y, float z, float w, float h, float d){
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
    this.h = h;
    this.d = d;
  }

  Shape3D(float x, float y, float z, Dimensao dim){
    this.x = x;
    this.y = y;
    this.z = z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  Shape3D(PVector p, Dimensao dim){
    x = p.x;
    y = p.y;
    z = p.z;
    w = dim.w;
    h = dim.h;
    d = dim.d;
  }

  void setLoc(PVector p){
    x=p.x;
    y=p.y;
    z=p.z;
  }

  void setLoc(float x, float y, float z){
    this.x=x;
    this.y=y;
    this.z=z;
  }


  void rotX(float theta){
  }

  void rotY(float theta){
  }

  void rotZ(float theta){
  }


  abstract void inicia();
  abstract void cria();
}

 class Dimensao{
   float w, h, d;
   
   Dimensao(float w, float h, float d){
     this.w=w;
     this.h=h;
     this.d=d;
  }
}