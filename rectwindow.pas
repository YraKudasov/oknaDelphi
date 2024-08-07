unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, AbstractWindow, Contnrs;
  // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class(TAbstractWindow)
  private
    FRectH, FRectW, FXOtstup, FYOtstup: integer;
    FImage: TImage;

    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledXOtstup, ScaledYOtstup: integer;
  public
    FSelected: boolean;


  public
    constructor Create(ARectH, ARectW: integer; AImage: TImage;
     AXOtstup, AYOtstup: Integer);
    procedure DrawWindow; override;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX, ScaledOtY: integer); override;
    procedure Select(Sender: TObject); override;

    property OnWindowSelected: TNotifyEvent read FOnWindowSelected
      write FOnWindowSelected;
    property OnWindowDeselected: TNotifyEvent
      read FOnWindowDeselected write FOnWindowDeselected;
    function GetSize: TPoint; override;
    procedure SetSize(const NewSize: TPoint); override;
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetYOtstup(Value: Integer);
    procedure SetXOtstup(Value: Integer);




    function GetXOtstup: integer;
    function GetSelection: boolean;
    procedure SetSelection(Value: boolean);
    function GetHeight: integer;
    function GetWidth: integer;
    function Contains(CurrentClickX, CurrentClickY: integer): boolean; override;
    function GetYOtstup: Integer;



  end;

implementation

constructor TRectWindow.Create(ARectH, ARectW: integer; AImage: TImage;
 AXOtstup, AYOtstup: integer);
begin
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;

  FXOtstup := AXOtstup;
  FYOtstup := AYOtstup;
end;

procedure TRectWindow.DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX, ScaledOtY: integer);
begin
  if FSelected then
  begin
    FImage.Canvas.Brush.Style := bsClear;
    // Изменение обводки окна при выделении
    FImage.Canvas.Pen.Color := clRed;
    // Можете выбрать любой другой цвет
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Rectangle(2 + ScaledOtX, 2 + ScaledOtY, ScaledRW + 3 + ScaledOtX, ScaledRH + 3 + ScaledOtY);
  end;
end;

procedure TRectWindow.Select(Sender: TObject);
{
var
  ClickX, ClickY: Integer;
begin


    ClickX := Mouse.CursorPos.X;
    ClickY := Mouse.CursorPos.Y;

    // Преобразуем абсолютные координаты в координаты клиента
    ClickX := FImage.ScreenToClient(Point(ClickX, ClickY)).X;
    ClickY := FImage.ScreenToClient(Point(ClickX, ClickY)).Y;


  // Проверяем, находится ли клик внутри области окна
   if (ClickX >= 4+ScaledOtstup) and  (ClickX <= ScaledRectWidth+ScaledOtstup) and
      (ClickY >= 4) and (ClickY <= ScaledRectHeight) then
      }
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


procedure TRectWindow.DrawWindow;
var
  ArrowLength: integer;
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

  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна

    FImage.Canvas.FillRect(Rect(ScaledXOtstup + 4, ScaledYOtstup + 4, ScaledRectWidth +
      ScaledXOtstup + 1, ScaledRectHeight + ScaledYOtstup + 1));
    // Очистите всю область окна

  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 3;
  FImage.Canvas.Rectangle(ScaledXOtstup + 4, ScaledYOtstup + 4, ScaledRectWidth + ScaledXOtstup,
    ScaledRectHeight + ScaledYOtstup);

  // Отрисовка меньшего синего окна внутри
  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Rectangle(ScaledXOtstup + 24, ScaledYOtstup + 24, ScaledRectWidth - 20 + ScaledXOtstup,
    ScaledRectHeight - 20 + ScaledYOtstup);


  //Отрисовка размеров
  {
  ArrowLength := 50;
  Image1.Canvas.MoveTo(FRectW, 3);
  Image1.Canvas.LineTo(FRectW + ArrowLength, 3);
  Image1.Canvas.MoveTo(FRectW, FRectH);
  Image1.Canvas.LineTo(FRectW + ArrowLength,FRectH);
  Image1.Canvas.MoveTo(FRectW, FRectH);
  Image1.Canvas.LineTo(FRectW, FRectH + ArrowLength);
  Image1.Canvas.MoveTo(3, FRectH);
  Image1.Canvas.LineTo(3, FRectH + ArrowLength);
  }
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

procedure TRectWindow.SetWidth(Value: Integer);
begin
  FRectW := Value;
end;

procedure TRectWindow.SetHeight(Value: Integer);
begin
  FRectH := Value;
end;

function TRectWindow.GetHeight: Integer;
begin
  Result := FRectH;
end;

function TRectWindow.GetWidth: Integer;
begin
  Result := FRectW;
end;

function TRectWindow.GetYOtstup: Integer;
begin
  Result := FYOtstup;
end;

procedure TRectWindow.SetYOtstup(Value: Integer);
begin
  FYOtstup := Value;
end;

procedure TRectWindow.SetXOtstup(Value: Integer);
begin
  FXOtstup := Value;
end;

end.
