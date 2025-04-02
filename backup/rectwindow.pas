unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Contnrs, ImpostsContainer, PlasticDoorImpost;
  // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class
  private
    FRow, FColumn, FRectH, FRectW, FXOtstup, FYOtstup, FType, FTableIdx, FForm: integer;
    FMoskit: boolean;
    FImage: TImage;
    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup: integer;
    ZoomIndex: double;
    IsDoor: boolean;
    FImpostsContainer: TImpostsContainer;
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

    procedure DrawMoskit(ScaledRectW, ScaledRectH, ScaledXOt, ScaledYOt: integer);
    procedure SetMoskit(Value: boolean);
    procedure SetZoomIndex(Value: double);
    procedure SetImage(Value: TImage);
    procedure SetIsDoor(Value: boolean);
    procedure PaintSize(ScaledConstructW, ScaledConstructH, ScaledXOt,
      ScaledYOt: integer; NoOneW, NoOneH: boolean);
    procedure DrawImposts;


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
      Impost.DrawDoorImp(ScaledRectWidth, ScaledXOtstup, ScaledImpYOtstup,
        ZoomIndex, MaxZoom);
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
  else
  begin
    DrawNeGluxar;
    if ((GetMoskit = True) and (GetIsDoor = False)) then
      DrawMoskit(ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup);
    DrawImposts;
  end;
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


procedure TRectWindow.DrawGluxar;
var
  CenterX, CenterY, CenterXGlass, CenterYGlass: integer;
  Radius, RadiusGlass: integer;
begin
  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна

  FImage.Canvas.FillRect(Rect(ScaledXOtstup + 4, ScaledYOtstup + 4,
    ScaledRectWidth + ScaledXOtstup + 1, ScaledRectHeight + ScaledYOtstup + 1));
  // Очистите всю область окна

  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 2;

  if (FForm = 0) then
  begin
    FImage.Canvas.Rectangle(ScaledXOtstup + 4, ScaledYOtstup + 4,
      ScaledRectWidth + ScaledXOtstup,
      ScaledRectHeight + ScaledYOtstup);

    // Отрисовка меньшего синего окна внутри
    FImage.Canvas.Brush.Color := clSkyBlue;
    FImage.Canvas.Rectangle(ScaledXOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledYOtstup + Round(ZoomIndex / MaxZoom * 24),
      ScaledRectWidth - Round(ZoomIndex / MaxZoom * 20) + ScaledXOtstup,
      ScaledRectHeight - Round(ZoomIndex / MaxZoom * 20) + ScaledYOtstup);
  end
  else if (FForm = 1) then
  begin
    CenterX := (ScaledRectWidth div 2)+3;
    CenterY := (ScaledRectHeight div 2)+3;
    Radius := (ScaledRectWidth div 2)-2;
    FImage.Canvas.Ellipse(CenterX - Radius, CenterY - Radius, CenterX + Radius, CenterY + Radius);

    CenterXGlass := (ScaledRectWidth div 2)+3;
    CenterYGlass := (ScaledRectHeight div 2)+3;
    RadiusGlass := (ScaledRectWidth div 2)- 2 -Round(ZoomIndex / MaxZoom * 24);
    FImage.Canvas.Ellipse(CenterXGlass - RadiusGlass, CenterYGlass - RadiusGlass, CenterXGlass + RadiusGlass, CenterYGlass + RadiusGlass);
  end;
end;

procedure TRectWindow.DrawNeGluxar;
begin

  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна

  FImage.Canvas.FillRect(Rect(ScaledXOtstup + 4, ScaledYOtstup + 4,
    ScaledRectWidth + ScaledXOtstup + 1, ScaledRectHeight + ScaledYOtstup + 1));
  // Очистите всю область окна

  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 2;
  FImage.Canvas.Rectangle(ScaledXOtstup + 4, ScaledYOtstup + 4,
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

  if (FType = 3) then
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
  if ((FType = 1) or (FType = 3) or (FType = 4)) then
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

end.
