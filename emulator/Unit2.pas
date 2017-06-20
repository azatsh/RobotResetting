unit Unit2;

interface

type

  // тип данных линия
  tLine = record
    x1,y1,x2,y2: Integer;
  end;

  // тип данных фигура
  tFigur = class
    FCentrX,FCentrY, // координаты центра
    FRadius,
    Dlina1,Dlina2: Integer; // длины
    FAlpha: Real;           // угол наклона
    Line1,Line2: tLine;
    procedure RePaint(alpha: Real);
    constructor Create(CentrX,CentrY,Radius,D1,D2: Integer);
  end;

implementation

// создает объект
constructor tFigur.Create(CentrX,CentrY,Radius,D1,D2: Integer);
begin
  FCentrX:=CentrX;
  FCentrY:=CentrY;
  FRadius:=Radius;
  Dlina1:=D1;
  Dlina2:=D2;
end;

// пересчитывает координаты объекта в зависимости от угла
procedure tFigur.RePaint(alpha: Real);
begin
  FAlpha := -alpha;
  Line1.x1 := FCentrX; // начальная точка. координата X
  Line1.y1 := FCentrY; // координата Y
  // по формуле окружности подсчитываем координаты
  Line1.x2 := trunc(Dlina1*cos(FAlpha))+FCentrX;
  line1.y2 := trunc(Dlina1*sin(FAlpha))+FCentrY;
  Line2.x2 := trunc(Dlina2*cos(FAlpha))+Line1.x2;
  Line2.y2 := trunc(Dlina2*sin(FAlpha))+Line1.y2
  // ---------------------------------------------
end;

end.
 