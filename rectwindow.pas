unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, AbstractWindow, Contnrs;
  // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class(TAbstractWindow)
  private
    FRow, FColumn, FRectH, FRectW, FXOtstup, FYOtstup, FType, FTableIdx: integer;
    FMoskit: boolean;
    FImage: TImage;
    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup: integer;
  public
    FSelected: boolean;


  public
    constructor Create(ARow, AColumn, ARectH, ARectW: integer;
      AImage: TImage; AXOtstup, AYOtstup, AType: integer;
      AMoskit: boolean);
    procedure DrawWindow; override;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX, ScaledOtY: integer);
      override;
    procedure Select(Sender: TObject); override;

    property OnWindowSelected: TNotifyEvent read FOnWindowSelected
      write FOnWindowSelected;
    property OnWindowDeselected: TNotifyEvent
      read FOnWindowDeselected write FOnWindowDeselected;
    function GetSize: TPoint; override;
    procedure SetSize(const NewSize: TPoint); override;
    procedure SetWidth(Value: integer);
    procedure SetHeight(Value: integer);
    procedure SetYOtstup(Value: integer);
    procedure SetXOtstup(Value: integer);
    procedure SetType(Value: integer);
    procedure SetRow(Value: integer);
    procedure SetColumn(Value: integer);
    procedure SetTableIdx(Value: integer);
    function GetType: integer;
    function GetTableIdx: integer;
    procedure DrawGluxar;
    procedure DrawNeGluxar;
    procedure DrawImposts(FRectWidth, FRectHeight: integer);
    procedure DrawMoskit(ScaledRectW, ScaledRectH, ScaledXOt, ScaledYOt: integer);
    procedure SetMoskit(Value: boolean);



    function GetRow: integer;
    function GetColumn: integer;
    function GetXOtstup: integer;
    function GetSelection: boolean;
    procedure SetSelection(Value: boolean);
    function GetHeight: integer;
    function GetWidth: integer;
    function Contains(CurrentClickX, CurrentClickY: integer): boolean; override;
    function GetYOtstup: integer;
    function GetMoskit: boolean;


  end;

implementation

constructor TRectWindow.Create(ARow, AColumn, ARectH, ARectW: integer;
  AImage: TImage; AXOtstup, AYOtstup, AType: integer;
  AMoskit: boolean);
begin
  FRow := ARow;
  FColumn := AColumn;
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;

  FXOtstup := AXOtstup;
  FYOtstup := AYOtstup;
  FType := AType;

  FMoskit := AMoskit;
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
//end;

procedure TRectWindow.DrawMoskit(ScaledRectW, ScaledRectH, ScaledXOt, ScaledYOt : integer);
var
  x, y: Integer;
begin
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 1;

  x := ScaledXOt + 36;
  while x < ScaledXOt + ScaledRectW - 30 do
  begin
    FImage.Canvas.Line(x, ScaledYOt + 36, x, ScaledRectH - 34 + ScaledYOt);
    x := x + 6; // 6-pixel interval
  end;

  y := ScaledYOt + 36;
  while y < ScaledYOt + ScaledRectH - 30 do
  begin
    FImage.Canvas.Line(ScaledXOt + 36, y, ScaledRectW - 34 + ScaledXOt, y);
    y := y + 6; // 6-pixel interval
  end;
end;

procedure TRectWindow.DrawWindow;
var
  ScreenWidth, ScreenHeight: integer;
  ScaleFactorX, ScaleFactorY: double;
begin

  ScreenWidth := FImage.Width;
  ScreenHeight := FImage.Height;
  // Вычисление коэффициентов пропорциональности
  ScaleFactorX := ScreenWidth / 3500;
  // Замените 3500 на ширину вашего прямоугольника
  ScaleFactorY := ScreenHeight / 2000;
  // Замените 2000 на высоту вашего прямоугольника

  // Вычисление масштабированных размеров окна
  ScaledRectWidth := Round(FRectW * ScaleFactorX);
  ScaledRectHeight := Round(FRectH * ScaleFactorY);
  ScaledXOtstup := Round(FXOtstup * ScaleFactorX);
  ScaledYOtstup := Round(FYOtstup * ScaleFactorY);

  // Отрисовка окна с учетом коэффициентов пропорциональности

  if (FType = 0) then
  begin
    DrawGluxar;
  end
  else
  begin
    DrawNeGluxar;
    if(FMoskit = True) then
    DrawMoskit(ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup);
  end;
end;


procedure TRectWindow.DrawGluxar;
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

  // Отрисовка меньшего синего окна внутри
  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Rectangle(ScaledXOtstup + 24, ScaledYOtstup + 24,
    ScaledRectWidth - 20 + ScaledXOtstup,
    ScaledRectHeight - 20 + ScaledYOtstup);

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
  FImage.Canvas.Rectangle(ScaledXOtstup + 17, ScaledYOtstup + 17,
    ScaledRectWidth + ScaledXOtstup - 13,
    ScaledRectHeight + ScaledYOtstup - 13);

  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Rectangle(ScaledXOtstup + 37, ScaledYOtstup + 37,
    ScaledRectWidth + ScaledXOtstup - 33,
    ScaledRectHeight + ScaledYOtstup - 33);

  // Крепежи слева
  if ((FType = 1) or (FType = 2)) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + 16, ScaledYOtstup + 30);
    FImage.Canvas.LineTo(ScaledXOtstup + 12, ScaledYOtstup + 30);
    FImage.Canvas.LineTo(ScaledXOtstup + 12, ScaledYOtstup + 43);
    FImage.Canvas.LineTo(ScaledXOtstup + 16, ScaledYOtstup + 43);

    FImage.Canvas.MoveTo(ScaledXOtstup + 16, ScaledYOtstup + ScaledRectHeight - 30);
    FImage.Canvas.LineTo(ScaledXOtstup + 12, ScaledYOtstup + ScaledRectHeight - 30);
    FImage.Canvas.LineTo(ScaledXOtstup + 12, ScaledYOtstup + ScaledRectHeight - 43);
    FImage.Canvas.LineTo(ScaledXOtstup + 16, ScaledYOtstup + ScaledRectHeight - 43);

    // Ручка справа
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + ScaledRectWidth - 18,
      ScaledYOtstup + (ScaledRectHeight div 2) - 5,
      ScaledXOtstup + ScaledRectWidth - 28,
      ScaledYOtstup + (ScaledRectHeight div 2) + 5);


    FImage.Canvas.Rectangle(ScaledXOtstup + ScaledRectWidth - 20,
      ScaledYOtstup + (ScaledRectHeight div 2) - 2,
      ScaledXOtstup + ScaledRectWidth - 26,
      ScaledYOtstup + (ScaledRectHeight div 2) + 28);

    // Линия левого поворота
    FImage.Canvas.MoveTo(ScaledXOtstup + 37, ScaledYOtstup + 37);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 35,
      ScaledYOtstup + (ScaledRectHeight div 2));
    FImage.Canvas.LineTo(ScaledXOtstup + 37, ScaledRectHeight + ScaledYOtstup - 35);
  end;



  // Крепежи снизу

  if (FType = 3) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup - 14);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup - 10);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5) + 15, ScaledRectHeight + ScaledYOtstup - 10);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) -
      (ScaledRectWidth div 5) + 15, ScaledRectHeight + ScaledYOtstup - 14);

    FImage.Canvas.MoveTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup - 14);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5), ScaledRectHeight + ScaledYOtstup - 10);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5) - 15, ScaledRectHeight + ScaledYOtstup - 10);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2) +
      (ScaledRectWidth div 5) - 15, ScaledRectHeight + ScaledYOtstup - 14);

    // Ручка сверху
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) - 5,
      ScaledYOtstup + 22,
      ScaledXOtstup + (ScaledRectWidth div 2) + 5,
      ScaledYOtstup + 32);


    FImage.Canvas.Rectangle(ScaledXOtstup + (ScaledRectWidth div 2) - 2,
      ScaledYOtstup + 24,
      ScaledXOtstup + (ScaledRectWidth div 2) + 28,
      ScaledYOtstup + 30);
  end;


  if ((FType = 4) or (FType = 5)) then
  begin
    // Крепежи справа
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - 14, ScaledYOtstup + 30);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 10, ScaledYOtstup + 30);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 10, ScaledYOtstup + 43);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 14, ScaledYOtstup + 43);

    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - 14, ScaledYOtstup +
      ScaledRectHeight - 30);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 10, ScaledYOtstup +
      ScaledRectHeight - 30);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 10, ScaledYOtstup +
      ScaledRectHeight - 43);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 14, ScaledYOtstup +
      ScaledRectHeight - 43);

    // Ручка слева
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup + 22,
      ScaledYOtstup + (ScaledRectHeight div 2) - 5,
      ScaledXOtstup + 32,
      ScaledYOtstup + (ScaledRectHeight div 2) + 5);

    FImage.Canvas.Rectangle(ScaledXOtstup + 24,
      ScaledYOtstup + (ScaledRectHeight div 2) - 2,
      ScaledXOtstup + 30,
      ScaledYOtstup + (ScaledRectHeight div 2) + 28);

    // Линия правого поворота
    FImage.Canvas.MoveTo(ScaledXOtstup + ScaledRectWidth - 37, ScaledYOtstup + 37);
    FImage.Canvas.LineTo(ScaledXOtstup + 37, ScaledYOtstup + (ScaledRectHeight div 2));
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 37,
      ScaledRectHeight + ScaledYOtstup - 35);
  end;

  // Линия откида
  if ((FType = 1) or (FType = 3) or (FType = 4)) then
  begin
    FImage.Canvas.MoveTo(ScaledXOtstup + 37, ScaledRectHeight + ScaledYOtstup - 35);
    FImage.Canvas.LineTo(ScaledXOtstup + (ScaledRectWidth div 2), ScaledYOtstup + 37);
    FImage.Canvas.LineTo(ScaledXOtstup + ScaledRectWidth - 35,
      ScaledRectHeight + ScaledYOtstup - 35);
  end;

end;

procedure TRectWindow.DrawImposts(FRectWidth, FRectHeight: integer);
begin
  if (GetXOtstup > 0) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup - 4, ScaledYOtstup + 3,
      ScaledXOtstup + 8, ScaledRectHeight + ScaledYOtstup);
  end;
  if (GetYOtstup > 0) then
  begin
    FImage.Canvas.Pen.Width := 1;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(ScaledXOtstup+4, ScaledYOtstup - 4,
      ScaledXOtstup + ScaledRectWidth, ScaledYOtstup + 8);
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

procedure TRectWindow.SetMoskit(Value: boolean);
begin
  FMoskit := Value;
end;

end.
