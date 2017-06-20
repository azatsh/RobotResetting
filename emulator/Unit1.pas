unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Spin, Unit2, Buttons, BCPort;

type

  TForm1 = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    TrackBar1: TTrackBar;
    seA: TSpinEdit;
    Label1: TLabel;
    Panel2: TPanel;
    Image2: TImage;
    Label2: TLabel;
    TrackBar2: TTrackBar;
    seB: TSpinEdit;
    Panel3: TPanel;
    Image3: TImage;
    Label3: TLabel;
    seC: TSpinEdit;
    Panel4: TPanel;
    Image4: TImage;
    Label4: TLabel;
    TrackBar3: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    seZ: TSpinEdit;
    TrackBar4: TTrackBar;
    Button1: TSpeedButton;
    ComPort: TBComPort;
    ComboBox: TComboBox;
    btnOpen: TSpeedButton;
    btnClose: TSpeedButton;
    procedure ShowFigur(Fig: tFigur; alpha: Real; Image: TImage);
    procedure ShowFigurA(alpha: Real);
    procedure ShowFigurB(alpha: Real);
    procedure ShowFigurC(alpha: Real);
    procedure ShowFigurZ(x: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure seCChange(Sender: TObject);
    procedure seBChange(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure seZChange(Sender: TObject);
    procedure seAChange(Sender: TObject);
    procedure ComPortRxChar(Sender: TObject; Count: Integer);
    procedure btnOpenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

var
  tA,tB,tC: Real; // углы положения основных трех вирт. объектов

  // виртуальные объекты для всех 4х осей
  FigurA,FigurB,FigurC,FigurZ: tFigur;

  PortB,PortD: Byte;

  IsReceive: Boolean;

// прорисовывает объект на экране
procedure TForm1.ShowFigur(Fig: tFigur; alpha: Real; Image: TImage);
const
  cWidth1 = 10; //10
  cWidth2 = 30; //30
  cColor1 = clMaroon; // цвет объекта
  cColor2 = clMaroon;
var
  OldDlina1,OldDlina2: Integer;
begin
  with image do begin  // работаем с компонентом image
    // затираем старое изображение
    canvas.Pen.Width := cWidth1; // задаем ширину линии
    canvas.pen.Color := clwhite; // цвет линии белый
    canvas.MoveTo(Fig.FCentrX,Fig.FCentrY); // перемещаемся в точку с этими кооординатами
    canvas.LineTo(Fig.Line1.x2,Fig.Line1.y2); // рисуем линию
    canvas.Pen.Width := cWidth2; // меняем ширину линии
    canvas.LineTo(Fig.Line2.x2,Fig.Line2.y2); // рисуем вторую линию
    // --------------------------

    // и рисуем новое
    canvas.pen.Color := cColor1; // устанавливаем нужный цвет линии
    Fig.RePaint(alpha);  // пересчет координат объекта
    canvas.Pen.Width := cWidth1;
    canvas.MoveTo(Fig.FCentrX,Fig.FCentrY);
    canvas.LineTo(Fig.Line1.x2,Fig.Line1.y2);
    canvas.pen.Color := cColor2;
    canvas.Pen.Width := cWidth2;
    canvas.LineTo(Fig.Line2.x2,Fig.Line2.y2);

    OldDlina1 := Fig.Dlina1; // сохраняем значение длины
    OldDlina2 := Fig.Dlina2; // тоже
    Fig.Dlina1 := Fig.Dlina1 + 15; // изменяем длину
//    Fig.Dlina2 := Fig.Dlina2;
    Fig.RePaint(alpha); // пересчет
    canvas.Pen.Width := 10;
    canvas.Pen.Color := clWhite;
    canvas.MoveTo(Fig.Line1.x2,Fig.Line1.y2);
    canvas.LineTo(Fig.Line2.x2,Fig.Line2.y2);
    Fig.Dlina1 := OldDlina1; // возвращаем старое значение длины
    Fig.Dlina2 := OldDlina2;
    Fig.RePaint(alpha); // пересчет
    // --------------------------------------
  end;
end;

procedure TForm1.ShowFigurA(alpha: Real);
var
  x1,x2,y1,y2: Integer;
begin
    ShowFigur(FigurA,alpha,Image1);
    image1.Canvas.Pen.Width := 10;
    IMAGE1.Canvas.Pen.Color := clMaroon;
    IMAGE1.Canvas.Brush.Color := clMaroon;

    x1 := figurA.FCentrX-10;
    x2 := figurA.FCentrX+10;
    y1 := figurA.FCentrY-10;
    y2 := figurA.FCentrY+10;
    image1.Canvas.Pie(x1,y1,x2,y2,x2,figurA.FCentrY,x1,figurA.FCentrY);
end;

procedure TForm1.ShowFigurB(alpha: Real);
var
  x1,x2,y1,y2: Integer;
begin
    ShowFigur(FigurB,alpha,Image2);
    image2.Canvas.Pen.Width := 10;
    IMAGE2.Canvas.Pen.Color := clMaroon;
    IMAGE2.Canvas.Brush.Color := clMaroon;

    x1 := figurB.FCentrX-10;
    x2 := figurB.FCentrX+10;
    y1 := figurB.FCentrY-10;
    y2 := figurB.FCentrY+10;
    image2.Canvas.Pie(x1,y1,x2,y2,x2,figurB.FCentrY,x1,figurB.FCentrY);
end;

procedure TForm1.ShowFigurC(alpha: Real);
var
  x1,x2,y1,y2: Integer;
begin
    ShowFigur(FigurC,alpha,Image3);
    image3.Canvas.Pen.Width := 10;
    IMAGE3.Canvas.Pen.Color := clMaroon;
    IMAGE3.Canvas.Brush.Color := clMaroon;

    x1 := figurC.FCentrX-10;
    x2 := figurC.FCentrX+10;
    y1 := figurC.FCentrY-10;
    y2 := figurC.FCentrY+10;
    image3.Canvas.Pie(x1,y1,x2,y2,x1,figurC.FCentrY,x2,figurC.FCentrY);
end;

// прорисовывает объект Z
procedure TForm1.ShowFigurZ(x: Integer);
const
  cWidth1 = 10;
  cWidth2 = 30;
  cColor1 = clMaroon;
  cColor2 = clMaroon;
var
  OldDlina1,OldDlina2: Integer;
begin

  with Image4 do begin
    canvas.Pen.Width := cWidth1;
    canvas.pen.Color := clwhite;
    canvas.MoveTo(FigurZ.FCentrX,FigurZ.FCentrY);
    canvas.LineTo(FigurZ.Line1.x2,FigurZ.Line1.y2);
    canvas.Pen.Width := cWidth2;
    canvas.LineTo(FigurZ.Line2.x2,FigurZ.Line2.y2);

    canvas.pen.Color := cColor1;
    FigurZ.FCentrX := x;
    FigurZ.RePaint(Pi*0.5);
    canvas.Pen.Width := cWidth1;
  canvas.MoveTo(Image4.Width div 2-80,FigurZ.FCentrY);
  canvas.LineTo(Image4.Width div 2+70,FigurZ.FCentrY);
    canvas.MoveTo(FigurZ.FCentrX,FigurZ.FCentrY);
    canvas.LineTo(FigurZ.Line1.x2,FigurZ.Line1.y2);
    canvas.pen.Color := cColor2;
    canvas.Pen.Width := cWidth2;
    canvas.LineTo(FigurZ.Line2.x2,FigurZ.Line2.y2);


    OldDlina1 := FigurZ.Dlina1; // сохраняем значение длины
    OldDlina2 := FigurZ.Dlina2; // тоже
    FigurZ.Dlina1 := FigurZ.Dlina1 + 15; // изменяем длину
//    Fig.Dlina2 := Fig.Dlina2;
    FigurZ.RePaint(Pi*0.5); // пересчет
    canvas.Pen.Width := 10;
    canvas.Pen.Color := clWhite;
    canvas.MoveTo(FigurZ.Line1.x2,FigurZ.Line1.y2);
    canvas.LineTo(FigurZ.Line2.x2,FigurZ.Line2.y2);
    FigurZ.Dlina1 := OldDlina1; // возвращаем старое значение длины
    FigurZ.Dlina2 := OldDlina2;
    FigurZ.RePaint(Pi*0.5); // пересчет
    // --------------------------------------
  end;
end;

// процедура работает при запуске программы
procedure TForm1.FormCreate(Sender: TObject);
var
  CentrX,CentrY: Integer; // координаты центра
begin
  // инициализация объекта А
  CentrX := Image1.Width div 2; // коорд X=(ширина компонента image / 2)
  CentrY := Image1.Height div 2 + 30; // а здесь (высота / 2)
  // создаем объект с заданными параметрами
  figurA := tFigur.Create(CentrX+30,CentrY+30,40,60,30);
  tA := TrackBar1.Position*Pi/180; // угол наклона в радианах (берется из объекта seA)
  FigurA.RePaint(0);
  ShowFigurA(tA); // прорисовываем объект
  // --------------------------


  // инициализация объекта B
  CentrX := Image2.Width div 2;
  CentrY := Image2.Height div 2 + 30;
  figurB := tFigur.Create(CentrX,CentrY+30,40,60,30);
  tB := seB.Value*Pi/180;
  FigurB.RePaint(0);
  ShowFigurB(tB);
  // -------------------------

  // инициализация объекта C
  CentrX := Image3.Width div 2;
  CentrY := Image3.Height div 2 - 30;
  figurC:=tFigur.Create(CentrX,CentrY-30,40,60,30);
  tC := seC.Value*Pi/180;
  FigurC.RePaint(0);
  ShowFigurC(tC);
  // -------------------------


  // инициализация объекта Z
  figurZ := tFigur.Create(Image4.Width div 2,(Image4.Height div 2) + 70,40,60,30);
//  TrackBar4.Min := (Image4.Width - 80) div 2; // минимальное значение по x
//  TrackBar4.Max := (Image4.Width - 80) div 2 + 80; // максимальное знач по x
  FigurZ.RePaint(0);
  TrackBar4.Position := Image4.Width div 2; // устанавливаем объект в середину

  // -----------------------------

  TrackBar3.Max := -10; // максимальное значение бегунка равно -10
end;

// нулирование
procedure TForm1.Button1Click(Sender: TObject);
const
  // угол наклона относительно точки нулирования, по оси B
  cAlpha = 15; // 15 градусов
  HighSpeed = 40;
  LoSpeed = 100;
var
  cShag,eps,Predel: Real;
  cNulZ: Integer;
  cSleep: Integer;
begin
  // выключаем возможность изменения положения объектов
  TrackBar1.Enabled := False;
  TrackBar2.Enabled := False;
  TrackBar3.Enabled := False;
  TrackBar4.Enabled := False;
  seA.ReadOnly := True;
  seB.ReadOnly := True;
  seC.ReadOnly := True;
  // ---------------------------

  cShag := 0.01;
  eps := cShag;

  cNulZ := TrackBar4.Max - 50;
  repeat
    PortB := 0;
    if tC > -Pi*0.5 then
    begin
      Predel := TrackBar3.Max;
      PortB := (PortB or (1 shl 5));
    end
    else // PortB = 0
      Predel := TrackBar3.Min;
    if abs(tC-Predel*Pi/180) < eps then
      PortB := (PortB or (1 shl 4));

    if seB.Value > 90 then
    begin
      PortB := (PortB or (1 shl 2));
    end
    else;
    if abs(tB-Pi*0.5) < eps then
      PortB := (PortB or (1 shl 3));


    if TrackBar1.Position < 90 then
      PortB := (PortB or 1);
    if abs(tA-Pi*0.5) < eps then
      PortB := (PortB or (1 shl 1));
    if abs(tA-TrackBar1.Min*Pi/180) < eps then
      PortB := (PortB or (1 shl 1));

    if FigurZ.FCentrX < cNulZ then
      PortB := (PortB or (1 shl 6));
    if FigurZ.FCentrX = cNulZ then
      PortB := (PortB or (1 shl 7));
    if FigurZ.FCentrX = TrackBar4.Min then
      PortB := (PortB or (1 shl 7)); // достигнут левый предел


    IsReceive := False;
    ComPort.WriteStr(Chr(PortB));
    while (not IsReceive) do
      Application.ProcessMessages;

    if PortD = 1 then
    begin
      tA := tA + 0.01;
      Sleep(HighSpeed);
    end;
    if PortD = (1 shl 1) then
    begin
      tA := tA - 0.01;
      Sleep(LoSpeed);
    end;

    if PortD = (1 shl 2) then
    begin
      tB := tB + 0.01;
      Sleep(HighSpeed);
    end;
    if PortD = (1 shl 3) then
    begin
      tB := tB - 0.01;
      Sleep(LoSpeed);
    end;

    if PortD = (1 shl 4) then
    begin
      tC := tC + 0.01;
      Sleep(LoSpeed);
    end;
    if PortD = (1 shl 5) then
    begin
      tC := tC - 0.01;
      Sleep(HighSpeed);
    end;

    if PortD = (1 shl 6) then
    begin
      TrackBar4.Position := TrackBar4.Position - 1;
      Sleep(LoSpeed);
    end;
    if PortD = (1 shl 7) then
    begin
      TrackBar4.Position := TrackBar4.Position + 1;
      Sleep(HighSpeed);
    end;

    if PortD <> 0 then
    begin
      TrackBar1.Position := Round(tA*180/Pi);
      TrackBar2.Position := Round(tB*180/Pi);
      TrackBar3.Position := Round(tC*180/Pi);
    end;

  until (PortD = 0);

  ComPort.WriteStr(Chr(0));

  // включаем возможность изменения положения объектов
  TrackBar1.Enabled := True;
  TrackBar2.Enabled := True;
  TrackBar3.Enabled := True;
  TrackBar4.Enabled := True;
  seA.ReadOnly := False;
  seB.ReadOnly := False;
  seC.ReadOnly := False;
  // ------------------------
end;

// процедура начинает работать после изменения положения бегунка
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  tA := TrackBar1.Position*Pi/180; // переводим угол в радианы записав значение в tA
  seA.Value := 180-TrackBar1.Position; // отображаем значение угла в компоненте seA
//  ShowFigurA(tA); // прорисовываем фигуру (манипулятор)
end;

// процедура начинает работать после измения значения угла в компоненте seA
procedure TForm1.TrackBar2Change(Sender: TObject);
begin
  seB.Value := TrackBar2.Position;
  tB := TrackBar2.Position*Pi/180;
  ShowFigurB(tB);
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
  seC.Value := TrackBar3.Position;
  tC := TrackBar3.Position*Pi/180;
  ShowFigurC(tC);
end;

procedure TForm1.seCChange(Sender: TObject);
begin
  if TrackBar3.Position <> seC.Value then
    TrackBar3.Position := seC.Value;
//  ShowFigurC(TrackBar3.Position*Pi/180);
end;

procedure TForm1.seBChange(Sender: TObject);
begin
  if TrackBar2.Position <> seB.Value then
    TrackBar2.Position := seB.Value;
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
  seZ.Value := TrackBar4.Position-20;
  ShowFigurZ(TrackBar4.Position);
end;

procedure TForm1.seZChange(Sender: TObject);
begin
  if seZ.Value+20 <> TrackBar4.Position then
    TrackBar4.Position := seZ.Value+20;
end;

procedure TForm1.seAChange(Sender: TObject);
begin
  if TrackBar1.Position <> 180-seA.Value then
    TrackBar1.Position := 180-seA.Value; // меняем положение бегунка
  ShowFigurA(TrackBar1.Position*Pi/180); // прорисовываем фигуру (манипулятор)
end;

procedure TForm1.ComPortRxChar(Sender: TObject; Count: Integer);
var
  buf: array [0..100] of byte;
begin
  ComPort.Read(buf,1);
  PortD := buf[0];
  IsReceive := True;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  ComPort.Port := ComboBox.Items[ComboBox.ItemIndex];
  if ComPort.Open then
  begin
    btnOpen.Enabled := False;
    Button1.Enabled := True;
    btnClose.Enabled := True;
  end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ComPort.Close;
end;

procedure TForm1.btnCloseClick(Sender: TObject);
begin
  if ComPort.Close then
  begin
    btnOpen.Enabled := True;
    btnClose.Enabled := False;
    Button1.Enabled := False;
  end;
end;

end.
