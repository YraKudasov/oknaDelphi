unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Contnrs, ImpostsContainer, PlasticDoorImpost;
  // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class
  TPointArray = array of TPoint;
  private
    FRow, FColumn, FRectH, FRectW, FXOtstup, FYOtstup, FType, FTableIdx, FForm: integer;
    FMoskit: boolean;
    FImage: TImage;
    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup: integer;
    ZoomIndex: double;
    IsDoor: boolean;
    UpperPoint: integer;
    DownPoint: integer;
    FImpostsContainer: TImpostsContainer;
    PolygonVerteces: array of TPoint;
  public
    FSelected: boolean;
    MaxZoom: double;

  public
    constructor Create(ARow, AColumn, ARectH, ARectW: integer;
      AImage: TImage; AXOtstup, AYOtstup, AType, AForm: integer; AMoskit: boolean);
    procedure DrawWindow;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX, ScaledOtY: integer);
    procedure Select(Sender: TObject);

    property OnWindowSelected: TNotifyEvent read FOnWindowSelected
      write FOnWindowSelected;
    property OnWindowDeselected: TNotifyEvent
      read FOnWindowDeselected write FOnWindowDeselected;
    function GetSize: TPoint;
    procedure SetSize(const NewSize: TPoint);
    procedure SetWidth(Value: integer);
    procedure SetHeight(Value: integer);
    procedure SetYOtstup(Value: integer);
    procedure SetXOtstup(Value: integer);
    procedure SetType(Value: integer);
    procedure SetRow(Value: integer);
    procedure SetColumn(Value: integer);
    procedure SetTableIdx(Value: integer);
    procedure SetForm(Value: integer);
    function GetType: integer;
    function GetTableIdx: integer;
    procedure DrawGluxar;
    procedure DrawNeGluxar;
    procedure DrawCircleWinFramuga;

    procedure DrawMoskit(ScaledRectW, ScaledRectH, ScaledXOt, ScaledYOt: integer);
    procedure SetMoskit(Value: boolean);
    procedure SetZoomIndex(Value: double);
    procedure SetImage(Value: TImage);
    procedure SetIsDoor(Value: boolean);
    procedure SetUpperPoint(Value: integer);
    procedure SetDownPoint(Value: integer);
    procedure PaintSize(ScaledConstructW, ScaledConstructH, ScaledXOt,
      ScaledYOt: integer; NoOneW, NoOneH: boolean);
    procedure DrawImposts;
    procedure DrawTriangle(Points: array of TPoint; FillColor: TColor);
    procedure FillPolygonIfEmpty;
    procedure DrawPolygon;
    procedure GetPolygonVertices(var Verteces: TPointArray);

    function GetRow: integer;
    function GetColumn: integer;
    function GetXOtstup: integer;
    function GetSelection: boolean;
    procedure SetSelection(Value: boolean);
    function GetHeight: integer;
    function GetWidth: integer;
    function Contains(CurrentClickX, CurrentClickY: integer): boolean;
    function GetYOtstup: integer;
    function GetMoskit: boolean;
    function GetZoomIndex: double;
    function GetIsDoor: boolean;
    function GetImpostsContainer: TImpostsContainer;
    function GetForm: integer;
    function GetUpperPoint: integer;
    function GetDownPoint: integer;
    function GetPolygonVerticesCount: integer;


  end;

implementation

constructor TRectWindow.Create(ARow, AColumn, ARectH, ARectW: integer;
  AImage: TImage; AXOtstup, AYOtstup, AType, AForm: integer; AMoskit: boolean);
begin
  FRow := ARow;
  FColumn := AColumn;
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;

  FXOtstup := AXOtstup;
  FYOtstup := AYOtstup;
  FType := AType;
  FForm := AForm;

  FMoskit := AMoskit;
  FImpostsContainer := TImpostsContainer.Create;
  MaxZoom := 0.24;
  UpperPoint := 0;
  DownPoint := 0;
end;

procedure TRectWindow.DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX,
  ScaledOtY: integer);
begin
  if FSelected then
  begin
    FImage.Canvas.Brush.Style := bsClear;
    // Изменение обводки окна при выделении
    FImage.Canvas.Pen.Color := clRed;
    // Можете выбрать любой другой цвет
    FImage.Canvas.Pen.Width := 3;
    FImage.Canvas.Rectangle(2 + ScaledOtX, 2 + ScaledOtY, ScaledRW +
      2 + ScaledOtX, ScaledRH + 2 + ScaledOtY);
  end;
end;

procedure TRectWindow.Select(Sender: TObject);
begin

  if FSelected then
  begin
    FSelected := False;

    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.FillRect(FImage.ClientRect);
    DrawWindow;

    if Assigned(OnWindowDeselected) then
      OnWindowDeselected(Self);
  end
  else
  begin
    FSelected := True;
    // Устанавливаем значение FSelected в true
    DrawSelectionBorder(ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup);
    // Перерисовываем окно для отображения выделения

    if Assigned(OnWindowSelected) then
      OnWindowSelected(Self);

  end;
end;

procedure TRectWindow.DrawImposts;
var
  i: integer;
  Impost: TPlasticDoorImpost;
  ScaledImpYOtstup: integer;
begin
  // Check if the container has at least one element
  if FImpostsContainer.Count > 0 then
  begin
    ScaledRectWidth := Round(FRectW * GetZoomIndex);
    ScaledXOtstup := Round(FXOtstup * GetZoomIndex);
    // Iterate through all elements in the container
    for i := 0 to FImpostsContainer.Count - 1 do
    begin
      Impost := FImpostsContainer.GetImpost(i);
      ScaledImpYOtstup := Impost.GetFImpYOtstup;
      ScaledImpYOtstup := Round(ScaledImpYOtstup * GetZoomIndex);
      if (GetForm = 1) then
        Impost.DrawDoorImp(ScaledRectWidth, ScaledXOtstup, ScaledImpYOtstup,
          ZoomIndex, MaxZoom, True)
      else
        Impost.DrawDoorImp(ScaledRectWidth, ScaledXOtstup, ScaledImpYOtstup,
          ZoomIndex, MaxZoom, False);
    end;
  end;
end;

procedure TRectWindow.DrawMoskit(ScaledRectW, ScaledRectH, ScaledXOt,
  ScaledYOt: integer);
var
  x, y: integer;
begin
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 1;

  x := ScaledXOt + Round(ZoomIndex / MaxZoom * 36);
  while x < ScaledXOt + ScaledRectW - Round(ZoomIndex / MaxZoom * 40) do
  begin
    FImage.Canvas.Line(x, ScaledYOt + Round(ZoomIndex / MaxZoom * 36),
      x, ScaledRectH - Round(ZoomIndex / MaxZoom * 34) + ScaledYOt);
    x := x + Round(ZoomIndex / MaxZoom * 10); // 6-pixel interval
  end;

  y := ScaledYOt + Round(ZoomIndex / MaxZoom * 36);
  while y < ScaledYOt + ScaledRectH - Round(ZoomIndex / MaxZoom * 40) do
  begin
    FImage.Canvas.Line(ScaledXOt + Round(ZoomIndex / MaxZoom * 36),
      y, ScaledRectW - Round(ZoomIndex / MaxZoom * 34) + ScaledXOt, y);
    y := y + Round(ZoomIndex / MaxZoom * 10); // 6-pixel interval
  end;
end;

procedure TRectWindow.DrawWindow;
begin

  // Вычисление масштабированных размеров окна
  ScaledRectWidth := Round(FRectW * GetZoomIndex);
  ScaledRectHeight := Round(FRectH * GetZoomIndex);
  ScaledXOtstup := Round(FXOtstup * GetZoomIndex);
  ScaledYOtstup := Round(FYOtstup * GetZoomIndex);

  // Отрисовка окна с учетом коэффициентов пропорциональности

  if (FType = 0) then
  begin
    DrawGluxar;
  end
  else if (FType = 3) and (FForm = 1) then
  begin
    DrawGluxar;
    DrawCircleWinFramuga;
  end
  else
  begin
    DrawNeGluxar;
    if ((GetMoskit = True) and (GetIsDoor = False)) then
      DrawMoskit(ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup);
    DrawImposts;
  end;
  if (GetForm = 1) then
    DrawImposts;
end;


procedure TRectWindow.PaintSize(ScaledConstructW, ScaledConstructH,
  ScaledXOt, ScaledYOt: integer; NoOneW, NoOneH: boolean);
begin
  FImage.Canvas.Pen.Width := 1;
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Font.Size := 8;
  FImage.Canvas.Brush.Style := bsClear;

  if (NoOneH = True) then
  begin
    //Линия высоты
    FImage.Canvas.MoveTo(ScaledConstructW + Round(ZoomIndex / MaxZoom * 10),
      Round(ZoomIndex / MaxZoom * 3));
    FImage.Canvas.LineTo(ScaledConstructW + Round(ZoomIndex / MaxZoom * 10),
      ScaledYOt + ScaledRectHeight);
    FImage.Canvas.TextOut(ScaledConstructW + Round(ZoomIndex / MaxZoom * 15),
      ScaledYOt + ScaledRectHeight div 2 - Round(ZoomIndex / MaxZoom * 10),
      IntToStr(FRectH));
    //Маленькая линия высоты (сверху)
    FImage.Canvas.MoveTo(ScaledConstructW, ScaledYOt + Round(ZoomIndex / MaxZoom * 3));
    FImage.Canvas.LineTo(ScaledConstructW + Round(ZoomIndex / MaxZoom * 20),
      ScaledYOt + Round(ZoomIndex / MaxZoom * 3));
    //Маленькая линия высоты (снизу)
    FImage.Canvas.MoveTo(ScaledConstructW, ScaledYOt + ScaledRectHeight);
    FImage.Canvas.LineTo(ScaledConstructW + Round(ZoomIndex / MaxZoom * 20),
      ScaledYOt + ScaledRectHeight);
  end;

  if (NoOneW = True) then
  begin
    //Линия высоты
    FImage.Canvas.MoveTo(Round(ZoomIndex / MaxZoom * 3),
      ScaledConstructH + Round(ZoomIndex / MaxZoom * 7));
    FImage.Canvas.LineTo(ScaledXOt + ScaledRectWidth,
      ScaledConstructH + Round(ZoomIndex / MaxZoom * 7));
    FImage.Canvas.TextOut(ScaledXOt + ScaledRectWidth div 2 -
      Round(ZoomIndex / MaxZoom * 10), ScaledConstructH +
      Round(ZoomIndex / MaxZoom * 12),
      IntToStr(FRectW));
    //Маленькая линия высоты (сверху)
    FImage.Canvas.MoveTo(ScaledXOt + Round(ZoomIndex / MaxZoom * 3), ScaledConstructH);
    FImage.Canvas.LineTo(ScaledXOt + Round(ZoomIndex / MaxZoom * 3),
      ScaledConstructH + Round(ZoomIndex / MaxZoom * 15));
    //Маленькая линия высоты (снизу)
    FImage.Canvas.MoveTo(ScaledXOt + ScaledRectWidth, ScaledConstructH);
    FImage.Canvas.LineTo(ScaledXOt + ScaledRectWidth, ScaledConstructH +
      Round(ZoomIndex / MaxZoom * 15));
  end;

end;

procedure TRectWindow.DrawCircleWinFramuga;
var
  CenterX, CenterY: integer;
  BorderRadius, Radius: integer;
begin
  if ((FForm = 1)  and (FType = 3)) then
  begin
    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Brush.Color := clWhite;

    CenterX := (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 3);
    CenterY := (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 3);
    Radius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 15);
    BorderRadius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 2);
    //Закраска половины окна
    FImage.Canvas.FillRect(3, 3, ScaledRectWidth, CenterY);

    FImage.Canvas.Pen.Color := clSkyBlue;
    FImage.Canvas.Brush.Color := clSkyBlue;

    FImage.Canvas.Ellipse(Round(ZoomIndex / MaxZoom * 36),
      Round(ZoomIndex / MaxZoom * 36),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 31),
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 31));

    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Brush.Color := clWhite;

    //Граница окна
    FImage.Canvas.Arc(CenterX - BorderRadius, CenterY - BorderRadius,
      CenterX + BorderRadius, CenterY + BorderRadius,
      CenterX + BorderRadius, CenterY, CenterX - BorderRadius, CenterY);


    //Внешняя линия створки
    FImage.Canvas.MoveTo(ScaledRectWidth - Round(ZoomIndex / MaxZoom * 30), CenterY);
    FImage.Canvas.AngleArc(CenterX, CenterY, Radius, 0, 180);


    //Внутренняя линия створки
    FImage.Canvas.AngleArc(CenterX, CenterY, BorderRadius -
      Round(ZoomIndex / MaxZoom * 30), 0, 180);

    //Линии открывания
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.Line(Round(ZoomIndex / MaxZoom * 36), CenterY,
      CenterX, Round(ZoomIndex / MaxZoom * 36));
    FImage.Canvas.Line(CenterX, Round(ZoomIndex / MaxZoom * 36),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 31), CenterY);

    //Линия импоста
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Rectangle(Round(ZoomIndex / MaxZoom * 18), CenterY -
      Round(ZoomIndex / MaxZoom * 10), ScaledRectWidth - Round(ZoomIndex / MaxZoom * 11),
      CenterY + Round(ZoomIndex / MaxZoom * 10));

    // Ручка сверху
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 32));

    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 2),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 28),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
  end;

end;


procedure TRectWindow.DrawGluxar;
var
  ScaledUpperPoint, ScaledDownPoint: integer;
  CenterX, CenterY, CenterXGlass, CenterYGlass: integer;
  BorderRadius, Radius, RadiusGlass: integer;
  Xc, Yc: integer;
  k: double;
  Points: array of TPoint;
  TrianglePoints, TrianglePointsMini: array of TPoint;
begin
  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна

  FImage.Canvas.FillRect(Rect(ScaledXOtstup + 4, ScaledYOtstup + 4,
    ScaledRectWidth + ScaledXOtstup + 1, ScaledRectHeight + ScaledYOtstup + 1));
  // Очистите всю область окна

  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 2;
  //Прямоугольник
  if (FForm = 0) then
  begin
    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4),
      ScaledRectWidth + ScaledXOtstup,
      ScaledRectHeight + ScaledYOtstup);

    FImage.Canvas.Brush.Color := clSkyBlue;
    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 20) + ScaledXOtstup,
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup);
  end
  //Круг
  else if (FForm = 1) then
  begin
    //Внешний круг
    CenterX := (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 3);
    CenterY := (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 3);
    Radius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 2);
    FImage.Canvas.Ellipse(CenterX - Radius, CenterY - Radius, CenterX +
      Radius, CenterY + Radius);
    //Внутренний круг
    FImage.Canvas.Brush.Color := clSkyBlue;
    CenterXGlass := (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 3);
    CenterYGlass := (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 3);
    RadiusGlass := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 2) -
      Round(ZoomIndex / MaxZoom * 24);
    FImage.Canvas.Ellipse(CenterXGlass - RadiusGlass, CenterYGlass -
      RadiusGlass, CenterXGlass + RadiusGlass, CenterYGlass + RadiusGlass);
  end
  //Арка
  else if (FForm = 2) then
  begin

    CenterX := (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 3);
    CenterY := (ScaledRectHeight) + Round(ZoomIndex / MaxZoom * 3);
    Radius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 15);
    BorderRadius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 2);

    if((FRectW div FRectH = 2) and (FRectW mod FRectH = 0)) then
    begin
    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Brush.Color := clWhite;

    //Закраска круглого стекла
    FImage.Canvas.FillRect(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledXOtstup + ScaledRectWidth, ScaledYOtstup + CenterY);

    FImage.Canvas.Pen.Color := clSkyBlue;
    FImage.Canvas.Brush.Color := clSkyBlue;

    FImage.Canvas.Ellipse(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 19),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 20),
      ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 19),
      ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 20));

     //Закраска нижней (ненужной) части стекла
    FImage.Canvas.Pen.Color := clWhite;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup+ Round(ZoomIndex / MaxZoom * 3), ScaledRectHeight+ScaledYOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 19),  ScaledRectHeight+ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 20));


    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Brush.Color := clWhite;

    //Граница окна
    FImage.Canvas.Arc(ScaledXOtstup+CenterX - BorderRadius, ScaledYOtstup+CenterY - BorderRadius,
      ScaledXOtstup + CenterX + BorderRadius, ScaledYOtstup + CenterY + BorderRadius,
      ScaledXOtstup + CenterX + BorderRadius, ScaledYOtstup + CenterY, ScaledXOtstup + CenterX - BorderRadius, ScaledYOtstup + CenterY);


    //Внешняя линия створки

    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - Round(ZoomIndex / MaxZoom * 30), ScaledYOtstup + CenterY);
    FImage.Canvas.AngleArc(ScaledXOtstup+CenterX, ScaledYOtstup+CenterY, Radius, 0, 180);

    //Нижний импост
    FImage.Canvas.Rectangle(ScaledXOtstup+Round(ZoomIndex / MaxZoom * 3), ScaledRectHeight+ScaledYOtstup+Round(ZoomIndex / MaxZoom * 4), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 33), ScaledRectHeight+ScaledYOtstup -Round(ZoomIndex / MaxZoom * 10))

    //Внутренняя линия створки
    {
    FImage.Canvas.AngleArc(ScaledXOtstup+CenterX, ScaledYOtstup+CenterY, BorderRadius -
      Round(ZoomIndex / MaxZoom * 30), 0, 180);
     }

    end
    else if (FRectH > (FRectW div 2)) then
    begin


              //Закраска круглого стекла
    FImage.Canvas.Pen.Color := clSkyBlue;
    FImage.Canvas.Brush.Color := clSkyBlue;

    FImage.Canvas.Ellipse(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 23),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 20),
      ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 14),
      ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 8));

          //Закраска нижней (ненужной) части стекла
    FImage.Canvas.Pen.Color := clWhite;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 23), (ScaledRectWidth div 2) + ScaledYOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 14),  ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 8));


        //Две линии арки
    FImage.Canvas.Pen.Color := clBlack;
    // Первая арка
    FImage.Canvas.Arc(ScaledXOtstup + CenterX - (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledYOtstup + (ScaledRectWidth div 2) - (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledXOtstup + CenterX + (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledYOtstup + (ScaledRectWidth div 2) + (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledXOtstup + CenterX + (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledYOtstup + (ScaledRectWidth div 2),
                      ScaledXOtstup + CenterX - (Radius - Round(ZoomIndex / MaxZoom * 2)),
                      ScaledYOtstup + (ScaledRectWidth div 2));

    // Вторая арка
    FImage.Canvas.Arc(ScaledXOtstup + CenterX - (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledYOtstup + (ScaledRectWidth div 2) - (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledXOtstup + CenterX + (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledYOtstup + (ScaledRectWidth div 2) + (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledXOtstup + CenterX + (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledYOtstup + (ScaledRectWidth div 2),
                      ScaledXOtstup + CenterX - (Radius + Round(ZoomIndex / MaxZoom * 13)),
                      ScaledYOtstup + (ScaledRectWidth div 2));


      //Нижняя часть окна (прямоугольная)
         FImage.Canvas.Pen.Color := clBlack;
         FImage.Canvas.Pen.Width := 2;

         FImage.Canvas.Brush.Color := clWhite;
         FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4)+(ScaledRectWidth div 2));
         FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4), ScaledRectHeight + ScaledYOtstup);
         FImage.Canvas.LineTo(ScaledRectWidth + ScaledXOtstup, ScaledRectHeight + ScaledYOtstup);
         FImage.Canvas.LineTo(ScaledRectWidth + ScaledXOtstup, ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4)+(ScaledRectWidth div 2));


      //Контур
      if(ScaledYOtstup + (ScaledRectWidth div 2)<ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup)then
      begin
      //Нижняя часть окна (прямоугольная) продолжение
      //Стекло
      FImage.Canvas.Pen.Color := clSkyBlue;
      FImage.Canvas.Brush.Color := clSkyBlue;
      FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+(ScaledRectWidth div 2),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup);
      //Контур
      FImage.Canvas.Pen.Color := clBlack;
      FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+(ScaledRectWidth div 2));
      FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup);
      FImage.Canvas.LineTo(ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup);
      FImage.Canvas.LineTo(ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+(ScaledRectWidth div 2));
      end
      else
      begin
        FImage.Canvas.Brush.Color := clWhite;
        //Нижний импост
           FImage.Canvas.Rectangle(ScaledXOtstup+Round(ZoomIndex / MaxZoom * 3), ScaledRectHeight+ScaledYOtstup+Round(ZoomIndex / MaxZoom * 4), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 33), ScaledRectHeight+ScaledYOtstup - Round(ZoomIndex / MaxZoom * 13))
        end;

    end
    else if (FRectH <= (FRectW div 2)) then
    begin

    //Куглая часть стекла
         FImage.Canvas.Brush.Color := clSkyBlue;
   FImage.Canvas.Pen.Color := clSkyBlue;
   FImage.Canvas.Ellipse( ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
   ScaledYOtstup + (ScaledRectWidth div 2) - (Radius - Round(ZoomIndex / MaxZoom * 2)),
   ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
   ScaledYOtstup + 2*ScaledRectHeight - Round(ZoomIndex / MaxZoom * 55));

   //Закраска ненужной части круглого стекла
   FImage.Canvas.Brush.Color := clWhite;
   FImage.Canvas.Pen.Color := clWhite;
   FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),                           // X4 (конец слева)
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2) + ScaledRectHeight - Round(GetZoomIndex * 120),
       ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
   ScaledYOtstup + 2*ScaledRectHeight - Round(ZoomIndex / MaxZoom * 55));

      //Нижняя часть окна (прямоугольная)
      FImage.Canvas.Pen.Color := clBlack;
      FImage.Canvas.Brush.Color := clWhite;
      FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4), ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));
      FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),ScaledRectHeight + ScaledYOtstup);
      FImage.Canvas.LineTo(ScaledRectWidth + ScaledXOtstup+Round(ZoomIndex / MaxZoom * 2),ScaledRectHeight + ScaledYOtstup);
      FImage.Canvas.LineTo(ScaledRectWidth + ScaledXOtstup+Round(ZoomIndex / MaxZoom * 2),ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));
      FImage.Canvas.LineTo(ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));
      FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4), ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));
      FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));

      //Голубая часть нижнего стекла
       FImage.Canvas.Pen.Color := clSkyBlue;
       FImage.Canvas.Brush.Color := clSkyBlue;
      FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 14) + ScaledYOtstup);

      //Внутренний прямоугольник
      FImage.Canvas.Pen.Color := clBlack;
      FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));
      FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),  ScaledRectHeight - Round(ZoomIndex / MaxZoom * 14) + ScaledYOtstup);
      FImage.Canvas.LineTo( ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,ScaledRectHeight - Round(ZoomIndex / MaxZoom * 14) + ScaledYOtstup);
      FImage.Canvas.LineTo(ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2)+ScaledRectHeight-Round(GetZoomIndex * 120));



              //Две линии арки
    FImage.Canvas.Pen.Color := clBlack;
    // Первая арка
    FImage.Canvas.Arc(
      // Верхний левый угол ограничивающего прямоугольника
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),     // X1
      ScaledYOtstup + (ScaledRectWidth div 2) - (Radius - Round(ZoomIndex / MaxZoom * 2)), // Y1

      // Нижний правый угол ограничивающего прямоугольника
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,      // X2
      ScaledYOtstup + 2*ScaledRectHeight - Round(ZoomIndex / MaxZoom * 55), // Y2

      // Новая начальная точка дуги (верхняя сторона)
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 14) + ScaledXOtstup,        // X3 (начало теперь сверху справа)
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2) + ScaledRectHeight - Round(GetZoomIndex * 120), // Y3 (наверху)

      // Новая конечная точка дуги (нижняя сторона)
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),                           // X4 (конец слева)
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2) + ScaledRectHeight - Round(GetZoomIndex * 120) // Y4 (остается неизменной)
    );

    // Вторая арка
    FImage.Canvas.Arc(
      // Верхний левый угол ограничивающего прямоугольника
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),     // X1
      ScaledYOtstup + (ScaledRectWidth div 2) - (Radius + Round(ZoomIndex / MaxZoom * 13)), // Y1

      // Нижний правый угол ограничивающего прямоугольника
       ScaledRectWidth + ScaledXOtstup+Round(ZoomIndex / MaxZoom * 2),      // X2
      ScaledYOtstup + 2*ScaledRectHeight - Round(ZoomIndex / MaxZoom * 55), // Y2

      // Новая начальная точка дуги (верхняя сторона)
      ScaledRectWidth + ScaledXOtstup+Round(ZoomIndex / MaxZoom * 2),        // X3 (начало сверху справа)
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 2) + ScaledRectHeight - Round(GetZoomIndex * 120), // Y3 (начало сверху)

      // Новая конечная точка дуги (нижняя сторона)
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),                            // X4 (конец слева)
      ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2) + ScaledRectHeight - Round(GetZoomIndex * 120) // Y4 (конец внизу)
    );

      end;
  end
  //Треугольник
  else if (FForm = 3) then
  begin
    ScaledUpperPoint := Round(UpperPoint * GetZoomIndex);
    ScaledDownPoint := Round(DownPoint * GetZoomIndex);

    SetLength(TrianglePoints, 3); // Устанавливаем длину массива
    TrianglePoints[0] := Point(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),
       ScaledDownPoint + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2));  // Вершина 1
    TrianglePoints[1] := Point(ScaledRectWidth + ScaledXOtstup,
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2));
    // Вершина 2
    TrianglePoints[2] := Point( ScaledUpperPoint  + ScaledXOtstup,
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4));  // Вершина 3

    DrawTriangle(TrianglePoints, clWhite);

    Xc := Round((TrianglePoints[0].X + TrianglePoints[1].X + TrianglePoints[2].X)/3);
    Yc := Round((TrianglePoints[0].Y + TrianglePoints[1].Y + TrianglePoints[2].Y)/3);
    k := 0.7;
     SetLength(TrianglePointsMini, 3); // Устанавливаем длину массива
    TrianglePointsMini[0] := Point(Xc + Round(k*(TrianglePoints[0].X - Xc)),
     Yc + Round(k*(TrianglePoints[0].Y - Yc)));
    // Вершина 1
    TrianglePointsMini[1] := Point(Xc + Round(k*(TrianglePoints[1].X - Xc)),
     Yc + Round(k*(TrianglePoints[1].Y - Yc)));
    // Вершина 2
    TrianglePointsMini[2] := Point(Xc + Round(k*(TrianglePoints[2].X - Xc)),
     Yc + Round(k*(TrianglePoints[2].Y - Yc)));  // Вершина 3

    DrawTriangle(TrianglePointsMini, clSkyBlue);

  end
  else if (FForm = 4) then
  DrawPolygon;
end;

procedure TRectWindow.DrawTriangle(Points: array of TPoint; FillColor: TColor);
begin
  // Устанавливаем цвет пера и кисти
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 2;
  FImage.Canvas.Brush.Color := FillColor;

  // Рисуем треугольник
  FImage.Canvas.Polygon(Points);
end;





procedure TRectWindow.DrawNeGluxar;
var
  CenterX, CenterY, Radius, BorderRadius: integer;
  ScaledUpperPoint, ScaledDownPoint: integer;
  Xc, Yc, WidthHandle: integer;
  k: double;
  TrianglePoints, TrianglePointsMiddle, TrianglePointsMini: array of TPoint;
begin

  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна

  FImage.Canvas.FillRect(Rect(ScaledXOtstup + 4, ScaledYOtstup + 4,
    ScaledRectWidth + ScaledXOtstup + 1, ScaledRectHeight + ScaledYOtstup + 1));
  // Очистите всю область окна
if(FForm = 0) then
begin
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 2;
  FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),
    ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4),
    ScaledRectWidth + ScaledXOtstup,
    ScaledRectHeight + ScaledYOtstup);

  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 17),
    ScaledYOtstup + Round(ZoomIndex / MaxZoom * 17),
    ScaledRectWidth + ScaledXOtstup - Round(ZoomIndex / MaxZoom * 13),
    ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 13));

  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
    ScaledYOtstup + Round(ZoomIndex / MaxZoom * 37),
    ScaledRectWidth + ScaledXOtstup - Round(ZoomIndex / MaxZoom * 33),
    ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 33));
 end;
  if ((FForm = 3) and (FType = 3)) then
    begin
    ScaledUpperPoint := Round(UpperPoint * GetZoomIndex);
    ScaledDownPoint := Round (DownPoint * GetZoomIndex);

    SetLength(TrianglePoints, 3); // Устанавливаем длину массива
    TrianglePoints[0] := Point(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 4),
      ScaledDownPoint + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2));  // Вершина 1
    TrianglePoints[1] := Point(ScaledRectWidth + ScaledXOtstup,
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 2));
    // Вершина 2
    TrianglePoints[2] := Point( ScaledUpperPoint  + ScaledXOtstup,
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 4));  // Вершина 3

    DrawTriangle(TrianglePoints, clWhite);

    Xc := Round((TrianglePoints[0].X + TrianglePoints[1].X + TrianglePoints[2].X)/3);
    Yc := Round((TrianglePoints[0].Y + TrianglePoints[1].Y + TrianglePoints[2].Y)/3);
    k := 0.85;

    SetLength(TrianglePointsMiddle, 3); // Устанавливаем длину массива
    TrianglePointsMiddle[0] := Point(Xc + Round(k*(TrianglePoints[0].X - Xc)),
     Yc + Round(k*(TrianglePoints[0].Y - Yc)));
    // Вершина 1
    TrianglePointsMiddle[1] := Point(Xc + Round(k*(TrianglePoints[1].X - Xc)),
     Yc + Round(k*(TrianglePoints[1].Y - Yc)));
    // Вершина 2
    TrianglePointsMiddle[2] := Point(Xc + Round(k*(TrianglePoints[2].X - Xc)),
     Yc + Round(k*(TrianglePoints[2].Y - Yc)));  // Вершина 3

    DrawTriangle(TrianglePointsMiddle, clWhite);

    SetLength(TrianglePointsMini, 3); // Устанавливаем длину массива
    k := 0.65;
    TrianglePointsMini[0] := Point(Xc + Round(k*(TrianglePoints[0].X - Xc)),
     Yc + Round(k*(TrianglePoints[0].Y - Yc)));
    // Вершина 1
    TrianglePointsMini[1] := Point(Xc + Round(k*(TrianglePoints[1].X - Xc)),
     Yc + Round(k*(TrianglePoints[1].Y - Yc)));
    // Вершина 2
    TrianglePointsMini[2] := Point(Xc + Round(k*(TrianglePoints[2].X - Xc)),
     Yc + Round(k*(TrianglePoints[2].Y - Yc)));  // Вершина 3

    DrawTriangle(TrianglePointsMini, clSkyBlue);

    // Ручка справа
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle((TrianglePointsMiddle[1].X + TrianglePointsMiddle[2].X) div 2,
      (TrianglePointsMiddle[1].Y + TrianglePointsMiddle[2].Y) div 2,
      (TrianglePointsMini[1].X + TrianglePointsMini[2].X) div 2,
       (TrianglePointsMini[1].Y + TrianglePointsMini[2].Y) div 2);

    WidthHandle := (TrianglePointsMiddle[1].X + TrianglePointsMiddle[2].X) div 2 - (TrianglePointsMini[1].X + TrianglePointsMini[2].X) div 2;

    FImage.Canvas.Rectangle((TrianglePointsMini[1].X + TrianglePointsMini[2].X) div 2 + WidthHandle div 4,
      (TrianglePointsMiddle[1].Y + TrianglePointsMiddle[2].Y) div 2 + Round(ZoomIndex / MaxZoom * 2),
      (TrianglePointsMiddle[1].X + TrianglePointsMiddle[2].X) div 2 - WidthHandle div 4,
      (TrianglePointsMini[1].Y + TrianglePointsMini[2].Y) div 2 + Round(ZoomIndex / MaxZoom * 28));
      end;

  // Крепежи слева
  if ((FType = 1) or (FType = 2)) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 16),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 12),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 12),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 43));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 16),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 43));

    FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 16),
      ScaledYOtstup + ScaledRectHeight - Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 12),
      ScaledYOtstup + ScaledRectHeight - Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 12),
      ScaledYOtstup + ScaledRectHeight - Round(ZoomIndex / MaxZoom * 43));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 16),
      ScaledYOtstup + ScaledRectHeight - Round(ZoomIndex / MaxZoom * 43));

    // Ручка справа
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 18),
      ScaledYOtstup + (ScaledRectHeight div 2) - Round(ZoomIndex / MaxZoom * 5),
      ScaledXOtstup + ScaledRectWidth - Round(ZoomIndex / MaxZoom * 28),
      ScaledYOtstup + (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 5));


    FImage.Canvas.Rectangle(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 20),
      ScaledYOtstup + (ScaledRectHeight div 2) - Round(ZoomIndex / MaxZoom * 2),
      ScaledXOtstup + ScaledRectWidth - Round(ZoomIndex / MaxZoom * 26),
      ScaledYOtstup + (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 28));

    // Линия левого поворота
    FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 37));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 35),
      ScaledYOtstup + (ScaledRectHeight div 2));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 35));
  end;



  // Крепежи снизу

  if ((FType = 3) and (FForm = 0)) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup -
      Round(ZoomIndex / MaxZoom * 14));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup -
      Round(ZoomIndex / MaxZoom * 10));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5) + Round(ZoomIndex / MaxZoom * 15),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 10));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5) + Round(ZoomIndex / MaxZoom * 15),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 14));

    FImage.Canvas.MoveTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup -
      Round(ZoomIndex / MaxZoom * 14));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup -
      Round(ZoomIndex / MaxZoom * 10));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5) - Round(ZoomIndex / MaxZoom * 15),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 10));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5) - Round(ZoomIndex / MaxZoom * 15),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 14));
    if(FForm = 0) then
    begin
    // Ручка сверху
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle (ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 32));


    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 2),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 28),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
    end;
    end;


  if((FForm = 2)and(FType = 3)) then
  begin
      CenterX := (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 3);
    CenterY := (ScaledRectHeight) + Round(ZoomIndex / MaxZoom * 3);
    Radius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 15);
    BorderRadius := (ScaledRectWidth div 2) - Round(ZoomIndex / MaxZoom * 2);

    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Brush.Color := clWhite;

    //Закраска круглого стекла
    FImage.Canvas.FillRect(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledXOtstup + ScaledRectWidth, ScaledYOtstup + CenterY);

    FImage.Canvas.Pen.Color := clSkyBlue;
    FImage.Canvas.Brush.Color := clSkyBlue;

    FImage.Canvas.Ellipse(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 32),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 35),
      ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 4),
      ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 20));

     //Закраска нижней (ненужной) части стекла
    FImage.Canvas.Pen.Color := clWhite;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup, ScaledRectHeight+ScaledYOtstup + Round(ZoomIndex / MaxZoom * 3), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 19),  ScaledRectHeight+ScaledYOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 20));


    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Brush.Color := clWhite;

    //Граница окна
    FImage.Canvas.Arc(ScaledXOtstup+CenterX - BorderRadius, ScaledYOtstup+CenterY - BorderRadius,
      ScaledXOtstup + CenterX + BorderRadius, ScaledYOtstup + CenterY + BorderRadius,
      ScaledXOtstup + CenterX + BorderRadius, ScaledYOtstup + CenterY, ScaledXOtstup + CenterX - BorderRadius, ScaledYOtstup + CenterY);


    //Внешняя линия створки

    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - Round(ZoomIndex / MaxZoom * 30), ScaledYOtstup + CenterY);
    FImage.Canvas.AngleArc(ScaledXOtstup+CenterX, ScaledYOtstup+CenterY, Radius, 0, 180);
    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - Round(ZoomIndex / MaxZoom * 45), ScaledYOtstup + CenterY);
    FImage.Canvas.AngleArc(ScaledXOtstup+CenterX, ScaledYOtstup+CenterY, Radius- Round(ZoomIndex / MaxZoom * 15), 0, 180);


    //Нижний импост
    FImage.Canvas.Rectangle(ScaledXOtstup+Round(ZoomIndex / MaxZoom * 3), ScaledRectHeight+ScaledYOtstup+Round(ZoomIndex / MaxZoom * 4), ScaledXOtstup + 2*Radius+Round(ZoomIndex / MaxZoom * 33), ScaledRectHeight+ScaledYOtstup -Round(ZoomIndex / MaxZoom * 10));

     // Ручка сверху
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle (ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 5),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 32));


    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) -
      Round(ZoomIndex / MaxZoom * 2),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledXOtstup + (ScaledRectWidth div 2) + Round(ZoomIndex / MaxZoom * 28),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));

    //Линия откида
    FImage.Canvas.Pen.Width:=1;
    FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 10));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 37));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 32),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 10));
  end;

  if ((FType = 4) or (FType = 5)) then
  begin
    // Крепежи справа
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 14), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 10), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 10), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 43));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 14), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 43));

    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 14), ScaledYOtstup + ScaledRectHeight -
      Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 10), ScaledYOtstup + ScaledRectHeight -
      Round(ZoomIndex / MaxZoom * 30));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 10), ScaledYOtstup + ScaledRectHeight -
      Round(ZoomIndex / MaxZoom * 43));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 14), ScaledYOtstup + ScaledRectHeight -
      Round(ZoomIndex / MaxZoom * 43));

    // Ручка слева
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 22),
      ScaledYOtstup + (ScaledRectHeight div 2) - Round(ZoomIndex / MaxZoom * 5),
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 32),
      ScaledYOtstup + (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 5));

    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledYOtstup + (ScaledRectHeight div 2) - Round(ZoomIndex / MaxZoom * 2),
      ScaledXOtstup + Round(ZoomIndex / MaxZoom * 30),
      ScaledYOtstup + (ScaledRectHeight div 2) + Round(ZoomIndex / MaxZoom * 28));

    // Линия правого поворота
    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 37), ScaledYOtstup + Round(ZoomIndex / MaxZoom * 37));
    FImage.Canvas.LineTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
      ScaledYOtstup + (ScaledRectHeight div 2));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 37),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 35));
  end;

  // Линия откида
  if ((FType = 1) or ((FType = 3) and (FForm = 0)) or (FType = 4)) then
  begin
    FImage.Canvas.MoveTo(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 37),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 35));
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 37));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth -
      Round(ZoomIndex / MaxZoom * 35),
      ScaledRectHeight + ScaledYOtstup - Round(ZoomIndex / MaxZoom * 35));
  end;

end;



function TRectWindow.Contains(CurrentClickX, CurrentClickY: integer): boolean;
begin
  // Проверяем, находится ли клик внутри области окна
  if (CurrentClickX >= 4 + ScaledXOtstup) and (CurrentClickX <=
    ScaledRectWidth + ScaledXOtstup) and (CurrentClickY >= 4 + ScaledYOtstup) and
    (CurrentClickY <= ScaledRectHeight + ScaledYOtstup) then
  begin
    Result := True;
  end
  else
    Result := False;
end;



function TRectWindow.GetSize: TPoint;
begin
  Result := TPoint.Create(FRectH, FRectW);
end;

procedure TRectWindow.SetSize(const NewSize: TPoint);
begin
  FRectH := NewSize.X;
  FRectW := NewSize.Y;
  DrawWindow; // Перерисовка окна с новыми размерами
end;


procedure TRectWindow.FillPolygonIfEmpty;
begin
    SetLength(PolygonVerteces, 4);
    PolygonVerteces[0] := Point(FXOtstup, FYOtstup);                  // верхний левый угол
    PolygonVerteces[1] := Point(FXOtstup + FRectW, FYOtstup);        // верхний правый угол
    PolygonVerteces[2] := Point(FXOtstup + FRectW, FYOtstup + FRectH); // нижний правый угол
    PolygonVerteces[3] := Point(FXOtstup, FYOtstup + FRectH);        // нижний левый угол
end;

procedure TRectWindow.DrawPolygon;
var
  i, n: Integer;
begin
  n := Length(PolygonVerteces);
  if n < 3 then Exit;  // для полигона нужно минимум 3 точки
  FImage.Canvas.Pen.Color:= clBlack;
  FImage.Canvas.Brush.Color:= clWhite;
  FImage.Canvas.Pen.Width:= 2;
  // Начинаем рисовать линию от первой точки
  if((PolygonVerteces[0].X = FXOtstup) and (PolygonVerteces[0].Y = FYOtstup))then
  FImage.Canvas.MoveTo(Round(PolygonVerteces[0].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[0].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else if ((PolygonVerteces[0].X = FXOtstup) and (PolygonVerteces[0].Y <> FYOtstup))then
  FImage.Canvas.MoveTo(Round(PolygonVerteces[0].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[0].Y* GetZoomIndex))
  else if ((PolygonVerteces[0].X <> FXOtstup) and (PolygonVerteces[0].Y = FYOtstup))then
  FImage.Canvas.MoveTo(Round(PolygonVerteces[0].X* GetZoomIndex), Round(PolygonVerteces[0].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else
  FImage.Canvas.MoveTo(Round(PolygonVerteces[0].X* GetZoomIndex), Round(PolygonVerteces[0].Y* GetZoomIndex));

  // Рисуем линии между точками
  for i := 1 to n - 1 do
    if((PolygonVerteces[i].X = FXOtstup) and (PolygonVerteces[i].Y = FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[i].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[i].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else if ((PolygonVerteces[i].X = FXOtstup) and (PolygonVerteces[i].Y <> FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[i].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[i].Y* GetZoomIndex))
  else if ((PolygonVerteces[i].X <> FXOtstup) and (PolygonVerteces[i].Y = FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[i].X* GetZoomIndex), Round(PolygonVerteces[i].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else
  FImage.Canvas.LineTo(Round(PolygonVerteces[i].X* GetZoomIndex), Round(PolygonVerteces[i].Y* GetZoomIndex));

  // Замыкаем многоугольник линией от последней точки к первой
 if((PolygonVerteces[0].X = FXOtstup) and (PolygonVerteces[0].Y = FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[0].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[0].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else if ((PolygonVerteces[0].X = FXOtstup) and (PolygonVerteces[0].Y <> FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[0].X* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4), Round(PolygonVerteces[0].Y* GetZoomIndex))
  else if ((PolygonVerteces[0].X <> FXOtstup) and (PolygonVerteces[0].Y = FYOtstup))then
  FImage.Canvas.LineTo(Round(PolygonVerteces[0].X* GetZoomIndex), Round(PolygonVerteces[0].Y* GetZoomIndex)+Round(ZoomIndex / MaxZoom * 4))
  else
  FImage.Canvas.LineTo(Round(PolygonVerteces[0].X* GetZoomIndex), Round(PolygonVerteces[0].Y* GetZoomIndex));
end;

function TRectWindow.GetPolygonVerticesCount: Integer;
begin
  Result := Length(PolygonVerteces);
end;

function TRectWindow.GetXOtstup: integer;
begin
  Result := FXOtstup;
end;

function TRectWindow.GetSelection: boolean;
begin
  Result := FSelected;
end;

procedure TRectWindow.SetSelection(Value: boolean);
begin
  FSelected := Value;
end;

procedure TRectWindow.SetWidth(Value: integer);
begin
  FRectW := Value;
end;

procedure TRectWindow.SetHeight(Value: integer);
begin
  FRectH := Value;
end;

procedure TRectWindow.SetType(Value: integer);
begin
  FType := Value;
end;

procedure TRectWindow.SetRow(Value: integer);
begin
  FRow := Value;
end;

procedure TRectWindow.SetColumn(Value: integer);
begin
  FColumn := Value;
end;

function TRectWindow.GetType: integer;
begin
  Result := FType;
end;

function TRectWindow.GetHeight: integer;
begin
  Result := FRectH;
end;

function TRectWindow.GetWidth: integer;
begin
  Result := FRectW;
end;

function TRectWindow.GetYOtstup: integer;
begin
  Result := FYOtstup;
end;

function TRectWindow.GetRow: integer;
begin
  Result := FRow;
end;

function TRectWindow.GetColumn: integer;
begin
  Result := FColumn;
end;

procedure TRectWindow.SetYOtstup(Value: integer);
begin
  FYOtstup := Value;
end;

procedure TRectWindow.SetXOtstup(Value: integer);
begin
  FXOtstup := Value;
end;

function TRectWindow.GetTableIdx: integer;
begin
  Result := FTableIdx;
end;

procedure TRectWindow.SetTableIdx(Value: integer);
begin
  FTableIdx := Value;
end;

function TRectWindow.GetMoskit: boolean;
begin
  Result := FMoskit;
end;

function TRectWindow.GetIsDoor: boolean;
begin
  Result := IsDoor;
end;

procedure TRectWindow.SetMoskit(Value: boolean);
begin
  FMoskit := Value;
end;

function TRectWindow.GetZoomIndex: double;
begin
  Result := ZoomIndex;
end;

procedure TRectWindow.SetZoomIndex(Value: double);
begin
  ZoomIndex := Value;
end;

procedure TRectWindow.SetIsDoor(Value: boolean);
begin
  IsDoor := Value;
end;

procedure TRectWindow.SetUpperPoint(Value: integer);
begin
  UpperPoint := Value;
end;

function TRectWindow.GetUpperPoint: integer;
begin
  Result := UpperPoint;
end;

procedure TRectWindow.SetDownPoint(Value: integer);
begin
  DownPoint := Value;
end;

function TRectWindow.GetDownPoint: integer;
begin
  Result := DownPoint;
end;

function TRectWindow.GetImpostsContainer: TImpostsContainer;
begin
  Result := FImpostsContainer;
end;


procedure TRectWindow.SetImage(Value: TImage);
begin
  FImage := Value;
end;

procedure TRectWindow.SetForm(Value: integer);
begin
  FForm := Value;
end;

function TRectWindow.GetForm: integer;
begin
  Result := FForm;
end;

procedure TRectWindow.GetPolygonVertices(var Verteces: TPointArray);
var
  I: Integer;
begin
  SetLength(Verteces, Length(PolygonVerteces));
  for I := Low(PolygonVerteces) to High(PolygonVerteces) do
    Verteces[I] := PolygonVerteces[I];
end;



end.
