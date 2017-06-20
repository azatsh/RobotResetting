unit Unit2;

interface

type

  // ��� ������ �����
  tLine = record
    x1,y1,x2,y2: Integer;
  end;

  // ��� ������ ������
  tFigur = class
    FCentrX,FCentrY, // ���������� ������
    FRadius,
    Dlina1,Dlina2: Integer; // �����
    FAlpha: Real;           // ���� �������
    Line1,Line2: tLine;
    procedure RePaint(alpha: Real);
    constructor Create(CentrX,CentrY,Radius,D1,D2: Integer);
  end;

implementation

// ������� ������
constructor tFigur.Create(CentrX,CentrY,Radius,D1,D2: Integer);
begin
  FCentrX:=CentrX;
  FCentrY:=CentrY;
  FRadius:=Radius;
  Dlina1:=D1;
  Dlina2:=D2;
end;

// ������������� ���������� ������� � ����������� �� ����
procedure tFigur.RePaint(alpha: Real);
begin
  FAlpha := -alpha;
  Line1.x1 := FCentrX; // ��������� �����. ���������� X
  Line1.y1 := FCentrY; // ���������� Y
  // �� ������� ���������� ������������ ����������
  Line1.x2 := trunc(Dlina1*cos(FAlpha))+FCentrX;
  line1.y2 := trunc(Dlina1*sin(FAlpha))+FCentrY;
  Line2.x2 := trunc(Dlina2*cos(FAlpha))+Line1.x2;
  Line2.y2 := trunc(Dlina2*sin(FAlpha))+Line1.y2
  // ---------------------------------------------
end;

end.
 