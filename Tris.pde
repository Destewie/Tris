int[][] campo; //ogni casella occupata conterrà il numero corrispondente al proprio giocatore oppure zero nel caso in cui sia libera //<>// //<>//
int mosseCompiute;
int giocatoreIniziale = 1; //Serve per far iniziare ad ogni partita un giocatore diverso
int turno; //tiene conto del giocatore a cui tocca.
int vincitore; //in caso di nessun vincitore dopo quella giocata sarà -1; nel caso vinca il giocatore zero, diventerà 0; nel caso vinca il giocatore uno, diventerà uno.
boolean finita; //se, quando diventa true, l'utente preme di nuovo sullo schermo inizia una nuova partita
int l; //è il lato di una singola celletta 
int offset = 20; //per evitare che i disegni della X e del O siano a ridosso della griglia
int miniOffset = offset - offset/4; //serve per il fattore estetico della linea di fine partita
int c1, c2, c3, c4; // "c" sta per "coordinata". Vengono usate per disegnare nel punto giusto e con la grandezza giusta tutte le X e i O
ArrayList<Integer> Vittorie = new ArrayList<Integer>(); //Si annota tutte le vittorie finchè non si chiude il gioco

//----------------------------------------------------------------------------------------------------------

void setup()
{
  size(300, 380);
  l = width / 3;

  PreparaIlTavolo();
}

//----------------------------------------------------------------------------------------------------------

void draw()
{

  //disegna in base ai dati nella matrice
  for (int i=0; i<3; i++)
  {
    for (int j=0; j<3; j++)
    {
      if (campo[i][j] == 0)
      {
        DisegnaUnCerchio(i, j);
      } else if (campo[i][j] == 1)
      {
        DisegnaUnaCroce(i, j);
      }
    }
  }
}

//----------------------------------------------------------------------------------------------------------

void mouseClicked() //Qui mi basta modificare la matrice e fare i calcoli
{
  if (finita)
  {
    PreparaIlTavolo(); //nel caso si dovesse cominciare una nuova partita
  } else
  {
    RegistraMossa(mouseX, mouseY);

    if (mosseCompiute >= 5 && mosseCompiute <= 9) // prima della quinta mossa non ha senso controllare se uno dei due ha vinto
    {
      vincitore = ControllaVincita();

      if (vincitore != -1)
      {
        Vittorie.add(vincitore);

        if (vincitore == 0)
          print("Vincono le O!!\n");
        if (vincitore == 1)
          print("Vincono le X!!\n");

        StampaLeVittorie();
        finita = true;
      }
    }

    if (mosseCompiute >= 9  &&  vincitore == -1 && finita == false)   //nel caso di pareggio
    {
      print("E' un pareggio!\n");
      background(210, 0, 0);
      finita = true;

      textSize(20);
      fill(0);
      textAlign(CENTER, TOP);
      text(StampaLeVittorie(), width/2, width + offset);

      textSize(10);
      if (turno == 0)
      {
        text("Iniziano le O", width/2, width + offset * 2 + 10);
      } else
      {
        text("Iniziano le X", width/2, width + offset * 2 + 10);
      }
    }
  }
}

//----------------------------------------------------------------------------------------------------------

void PreparaIlTavolo()
{
  giocatoreIniziale = 1 - giocatoreIniziale;
  mosseCompiute = 0;
  turno = giocatoreIniziale;
  vincitore = -1;
  finita = false;
  campo = new int [3][3];

  for (int i=0; i<3; i++)
  {
    for (int j=0; j<3; j++)
    {
      campo[i][j] = -1;    //inizializzo tutte le celle del campo a 0
    }
  }

  background(255);

  //Disegna la griglia
  strokeWeight(1);
  line(l, 0, l, width);
  line(l*2, 0, l*2, width);
  line(0, l, width, l);
  line(0, l*2, width, l*2);

  textSize(20);
  fill(0);
  textAlign(CENTER, TOP);
  text(StampaLeVittorie(), width/2, width + offset);

  textSize(10);
  if (turno == 0)
  {
    text("Iniziano le O", width/2, width + offset * 2 + 10);
  } else
  {
    text("Iniziano le X", width/2, width + offset * 2 + 10);
  }
}

//----------------------------------------------------------------------------------------------------------

void DisegnaUnaLinea(int x1, int y1, int x2, int y2)
{
  strokeWeight(6);
  stroke(255, 0, 0);
  line (x1, y1, x2, y2);
  stroke(0);
}

//----------------------------------------------------------------------------------------------------------

void DisegnaUnaCroce(int i, int j)
{
  c1 = (l * i) + offset;
  c2 = (l * j) + offset;
  c3 = (l * (i+1)) - offset;
  c4 = (l * (j+1)) - offset;

  strokeWeight(4);
  line (c1, c2, c3, c4);
  line (c3, c2, c1, c4);
}

//----------------------------------------------------------------------------------------------------------

void DisegnaUnCerchio(int i, int j)
{  
  int diametro = l-(offset*2);


  noFill();
  strokeWeight(4);
  ellipse((i*l) + (l/2), (j*l) + (l/2), diametro, diametro);
}

//----------------------------------------------------------------------------------------------------------

void RegistraMossa(int x, int y)
{
  if (x < width && y < width)
  {
    int i, j;

    i = x / l;
    j = y / l;

    if (campo[i][j] == -1)
    {
      campo[i][j] = turno;
      mosseCompiute ++;

      turno = 1 - turno;
    } else
    {
      print ("Casella già occupata\n");
    }
  } else
  {
    print ("Sei fuori dal campo!\n");
  }
}

//----------------------------------------------------------------------------------------------------------

int ControllaVincita()
{  

  //controllo le colonne
  for (int i=0; i<3; i++)
  {
    if (campo[i][0] == campo[i][1] && campo[i][1] == campo[i][2] && campo[i][0] != -1)
    {
      int xLinea = l*i + l/2;
      DisegnaUnaLinea(xLinea, miniOffset, xLinea, width - miniOffset);
      return campo[i][0];
    }
  }

  //controllo le righe
  for (int j=0; j<3; j++)
  {
    if (campo[0][j] == campo[1][j] && campo[1][j] == campo[2][j] && campo[0][j] != -1)
    {
      int yLinea = l*j + l/2;
      DisegnaUnaLinea(miniOffset, yLinea, width - miniOffset, yLinea);
      return campo[0][j];
    }
  }

  //controllo la diagonale altoSinistra -> bassoDestra
  if (campo[0][0] == campo[1][1] && campo[1][1] == campo[2][2] && campo[0][0] != -1)
  {
    DisegnaUnaLinea(miniOffset, miniOffset, width - miniOffset, width - miniOffset);
    return campo[0][0];
  }

  //controllo la diagonale altoDestra -> bassoSinistra
  if (campo[2][0] == campo[1][1] && campo[1][1] == campo[0][2] && campo[2][0] != -1)
  {
    DisegnaUnaLinea(width - miniOffset, miniOffset, miniOffset, width - miniOffset);
    return campo[2][0];
  }

  return -1; // se nessuna di queste è vera, allora la partita non è ancora finita o è in pareggio
}

//----------------------------------------------------------------------------------------------------------

String StampaLeVittorie()
{
  int vitt0 = 0, vitt1 = 0;

  for (int i : Vittorie)
  {
    if (i == 0)
      vitt0++;
    else
      vitt1++;
  }

  return ("Cerchi "+ vitt0 + " - " + vitt1 + " Croci\n");
}

//----------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------
