{
  Falta Implementar:
    - Salvar a resolução em um arquivo BMP ou JPG
    - Permitir o usuário escolher o nome do arquivo
    - Permitir o usuário jogar também. 
}
unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, StrUtils, ComCtrls, WinSkinData,
  Menus;

type
  TfrRainhas = class(TForm)
    Image1: TImage;
    BitBtn1: TBitBtn;
    Button1: TButton;
    Edit2: TEdit;
    Label2: TLabel;
    UpDown1: TUpDown;
    ColorBox1: TColorBox;
    ColorBox2: TColorBox;
    Label1: TLabel;
    Label3: TLabel;
    Button2: TButton;
    Shape1: TImage;
    Shape2: TImage;
    Shape4: TImage;
    Shape3: TImage;
    Shape8: TImage;
    Shape7: TImage;
    Shape6: TImage;
    Shape5: TImage;
    imgMatriz: TImage;
    SkinData1: TSkinData;
    PopupMenu1: TPopupMenu;
    CapturaCor1: TMenuItem;
    ColorDialog1: TColorDialog;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function ExisteDiagonal:Boolean;
    procedure IniciaBusca( Posicao : integer ; Inicial : integer = 1 );
    procedure Button1Click(Sender: TObject);
    procedure DesenhaTabuleiro;
    procedure Button2Click(Sender: TObject);
    procedure CarregaRainha;
    procedure FormResize(Sender: TObject);
    procedure Image1DblClick(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CapturaCor1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frRainhas: TfrRainhas;

implementation

{$R *.dfm}

var
  feito : Boolean = False;
  parar : Boolean = False;
  PosicaoY : integer = 367;
  pXMouse, pYMouse: Integer;

procedure TfrRainhas.BitBtn1Click(Sender: TObject);
begin
  Feito := False;
  Parar := False;
  IniciaBusca(0);
  if Feito then
    Showmessage('Solução Encontrada!');
end;

procedure TfrRainhas.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  DesenhaTabuleiro;
  CarregaRainha;
end;

function TfrRainhas.ExisteDiagonal: Boolean;
var
  i : integer;
begin
  Result := False;
  for i := 1 to 8 do begin
    if i <> Tag then
      if TShape( FindComponent( 'Shape'+IntToStr(i) ) ).Visible then begin
        if TShape( FindComponent( 'Shape'+IntToStr(i) ) ).Top = TShape( FindComponent( 'Shape'+IntToStr(frRainhas.Tag) ) ).Top then begin
          Result := True;
          Break;
        end
        else
        if TShape( FindComponent( 'Shape'+IntToStr(i) ) ).Top = TShape( FindComponent( 'Shape'+IntToStr(frRainhas.Tag) ) ).Top + ((Image1.Height div 8)*(frRainhas.Tag-i)) then begin
          Result := True;
          Break;
        end
        else
        if TShape( FindComponent( 'Shape'+IntToStr(i) ) ).Top = TShape( FindComponent( 'Shape'+IntToStr(frRainhas.Tag) ) ).Top - ((Image1.Height div 8)*(frRainhas.Tag-i)) then begin
          Result := True;
          Break;
        end;
      end;
  end;
end;

procedure TfrRainhas.IniciaBusca(Posicao:Integer ; Inicial : integer = 1);
var
  c:boolean;
  p,i:integer;
  o:TImage;
begin
  if Posicao = 0 then
    Shape1.Top := PosicaoY;
  case Posicao of
    0 : Posicao := 1;
    1 : Posicao := 8;
    2 : Posicao := 7;
    3 : Posicao := 6;
    4 : Posicao := 5;
    5 : Posicao := 4;
    6 : Posicao := 3;
    7 : Posicao := 2;
    8 : Posicao := 1;
  end;
  p := 1;
  for i := 1 to 8 do begin
    if i <> Inicial then begin
      TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Top := PosicaoY;
      TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Visible := False;
    end;
  end;
  TImage( FindComponent( 'Shape'+IntToStr(Inicial) ) ).Top := PosicaoY - ( (Image1.Height div 8) * ( Posicao - 1 ) );
  c := true;
  while c do begin
    if p > 8 then begin
//      c := False;
      Feito := True;
      Break;
    end;
    o := TImage( FindComponent( 'Shape'+IntToStr(p) ) );
    if p = Inicial then begin
      o.Visible := True;
      p := p + 1;
      Continue;
    end;
    if not o.Visible then
      o.Visible := True
    else begin
      if o.Top < ( Image1.Top + ( (Image1.Height div 8)-Shape1.Height)/2 )+9 then begin
        if (TImage( FindComponent( 'Shape'+IntToStr(Inicial) ) ).Top >= ( Image1.Top + ( (Image1.Height div 8)-Shape1.Height)/2 )-9) and (TImage( FindComponent( 'Shape'+IntToStr(Inicial) ) ).Top <= ( Image1.Top + ( (Image1.Height div 8)-Shape1.Height)/2 )+9) then
          IniciaBusca( 8 , Inicial+1)
        else
          IniciaBusca( ((TImage( FindComponent( 'Shape'+IntToStr(Inicial) ) ).Top-(Image1.Height div 8)) div (Image1.Height div 8)) + 1 , Inicial);
//        c := False;
        Break;
      end
      else
        o.Top := o.Top - (Image1.Height div 8);
    end;
    frRainhas.Tag := p;
    Update;
    Application.ProcessMessages;
    sleep( StrToInt(Edit2.Text));
    if Parar then
      Exit;
    if ExisteDiagonal then
      Continue
    else
      p := p + 1;
  end;
end;

procedure TfrRainhas.Button1Click(Sender: TObject);
begin
  Parar := True;
end;

procedure TfrRainhas.DesenhaTabuleiro;
var
  i , j , x , y : integer;
  t : boolean;
  bmp : TBitmap;
  tm : integer;
begin
  tm := 50;
  t := True;
  bmp := TBitmap.Create;
  bmp.Width := Image1.Width;
  bmp.Height := Image1.Height;
//  bmp.Canvas.Pen.Color := ColorBox1.Selected;
  bmp.Canvas.Pen.Color := StringToColor(ColorBox1.Items[ColorBox1.ItemIndex] );
  for i := 1 to 8 do begin
    t := not t;
    for j := 1 to 8 do begin
      t := not t;
      y := (i-1) * tm;
      x := (j-1) * tm;
      if t then begin
        bmp.Canvas.Brush.Color := StringToColor(ColorBox1.Items[ColorBox1.ItemIndex] );
//        bmp.Canvas.Brush.Color := ColorBox1.Selected;
      end
      else begin
        bmp.Canvas.Brush.Color := ColorBox2.Selected;
      end;
      bmp.Canvas.Rectangle( x , y , x+tm , y+tm );
    end;
  end;
  Image1.Canvas.Draw(0,0,bmp);
  bmp.Free;
end;

procedure TfrRainhas.Button2Click(Sender: TObject);
begin
  DesenhaTabuleiro;
end;

procedure TfrRainhas.CarregaRainha;
var
  i : integer;
  m : TMemoryStream;
begin
  m := TMemoryStream.Create;
  imgMatriz.Picture.Bitmap.SaveToStream(m);
  for i := 1 to 8 do begin
    m.Position := 0;
    TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Picture.Bitmap.LoadFromStream(m);
  end;
  m.Free;
end;

procedure TfrRainhas.FormResize(Sender: TObject);
var
  tmx, tmy, px, py, i : Integer;
begin

  Feito := False;
  Parar := True;
  Application.ProcessMessages;
  tmx := Image1.Width div 8;
  tmy := Image1.Height div 8;

  for i := 1 to 8 do begin
    TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Height := tmy;
    TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Width := tmx;
    TImage( FindComponent( 'Shape'+IntToStr(i) ) ).Visible := False;
  end;

  for i := 1 to 8 do begin
    px := Image1.Left + ( (i-1) * tmx ) + ( (tmx - TImage(FindComponent( 'Shape'+IntToStr(i) )).Width ) div 2 );
    py := Image1.Top + Image1.Height - tmy + (( tmy - TImage(FindComponent( 'Shape'+IntToStr(i) )).Height ) div 2);
    TImage(FindComponent( 'Shape'+IntToStr(i) )).Left  := px;
    TImage(FindComponent( 'Shape'+IntToStr(i) )).Top  := py;
    PosicaoY := Py;
  end;


end;

procedure TfrRainhas.Image1DblClick(Sender: TObject);
var
  lim_Col:array[1..8] of array [1..2] of integer;
  lim_Row:array[1..8] of array [1..2] of integer;
  inic, fimc, inir, fimr, i: integer;
  fCol, fRow:integer;
begin
  inic := Image1.Left;
  inir := Image1.Top;
  for i := 1 to 8 do begin
    fimc := inic + (Image1.Width div 8);
    fimr := inir + (Image1.Width div 8);
    lim_Col[i,1] := inic;
    lim_Col[i,2] := fimc;
    lim_Row[i,1] := inir;
    lim_Row[i,2] := fimr;
    inic := fimc;
    inir := fimr;
  end;
  fCol := 0;
  for i := 1 to 8 do
    if (pXMouse >= lim_Col[i,1]) and (pXMouse <= lim_Col[i,2]) then begin
      fCol := i;
      Break;
    end;

  fRow := 0;
  for i := 1 to 8 do
    if (pyMouse >= lim_Row[i,1]) and (pyMouse <= lim_Row[i,2]) then begin
      fRow := i;
      Break;
    end;

  if (fCol>0) and (fRow>0) then begin
    Canvas.Brush.Color := clYellow;
    Canvas.Pen.Color := clYellow;
    Canvas.Rectangle(lim_Col[fCol,1],lim_Row[fRow,1],lim_Col[fCol,2],lim_Row[fRow,2] );
    sleep(200);
    Repaint;
  end;
end;

procedure TfrRainhas.Image1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  pXMouse := X;
  pYMouse := Y;
end;

procedure TfrRainhas.CapturaCor1Click(Sender: TObject);
begin
  ColorDialog1.Color := ColorBox1.Selected;
  if ColorDialog1.Execute then begin
    ColorBox1.Items.Add( ColorToString(ColorDialog1.Color) );
    ColorBox1.Selected := ColorDialog1.Color;
  end;
end;

end.
