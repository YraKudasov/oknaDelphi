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
    FIsRight: boolean;
    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledOtstup: integer;
    FVerticalImpost: boolean;
    FHorizontalImpost: boolean;
  public
    FSelected: boolean;


  public
    constructor Create(ARectH, ARectW: integer; AImage: TImage;
      IsRight: boolean; AXOtstup, AYOtstup: Integer);
    procedure DrawWindow; override;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOt: integer); override;
    procedure Select(Sender: TObject); override;

    property OnWindowSelected: TNotifyEvent read FOnWindowSelected
      write FOnWindowSelected;
    property OnWindowDeselected: TNotifyEvent
      read FOnWindowDeselected write FOnWindowDeselected;
    function GetSize: TPoint; override;
    procedure SetSize(const NewSize: TPoint); override;
    procedure SetWidth(Value: Integer);
    procedure SetYOtstup(Value: Integer);



    function GetIsRight: boolean;
    function GetOtstup: integer;
    function GetSelection: boolean;
    procedure SetSelection(Value: boolean);
    function GetHeight: integer;
    function GetWidth: integer;
    function Contains(CurrentClickX, CurrentClickY: integer): boolean; override;
    function GetYOtstup: Integer;



    property VerticalImpost: boolean read FVerticalImpost write FVerticalImpost;
    property HorizontalImpost: boolean read FHorizontalImpost write FHorizontalImpost;

  end;

implementation

constructor TRectWindow.Create(ARectH, ARectW: integer; AImage: TImage;
  IsRight: boolean; AXOtstup, AYOtstup: integer);
begin
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;
  FIsRight := IsRight;
  FXOtstup := AXOtstup;
  FYOtstup := AYOtstup;
end;

procedure TRectWindow.DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOt: integer);
begin
  if FSelected then
  begin
    FImage.Canvas.Brush.Style := bsClear;
    // Изменение обводки окна при выделении
    FImage.Canvas.Pen.Color := clRed;
    // Можете выбрать любой другой цвет
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Rectangle(2 + ScaledOt, 2, ScaledRW + 3 + ScaledOt, ScaledRH + 3);
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
    DrawSelectionBorder(ScaledRectWidth, ScaledRectHeight, ScaledOtstup);
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
  ScaledOtstup := Round(FXOtstup * ScaleFactorX);

  // Отрисовка окна с учетом коэффициентов пропорциональности

  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна
  if (GetIsRight = False) then
  begin
    FImage.Canvas.FillRect(Rect(ScaledOtstup + 4, 4, ScaledRectWidth +
      ScaledOtstup + 1, ScaledRectHeight));
    // Очистите всю область окна
  end
  else
  begin
    FImage.Canvas.FillRect(Rect(ScaledOtstup + 4, 4, ScaledRectWidth +
      ScaledOtstup, ScaledRectHeight));
    // Очистите всю область окна
  end;
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 3;
  FImage.Canvas.Rectangle(ScaledOtstup + 4, 4, ScaledRectWidth + ScaledOtstup,
    ScaledRectHeight);

  // Отрисовка меньшего синего окна внутри
  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Rectangle(ScaledOtstup + 24, 24, ScaledRectWidth - 20 + ScaledOtstup,
    ScaledRectHeight - 20);


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
  if (CurrentClickX >= 4 + ScaledOtstup) and (CurrentClickX <=
    ScaledRectWidth + ScaledOtstup) and (CurrentClickY >= 4) and
    (CurrentClickY <= ScaledRectHeight) then
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

function TRectWindow.GetIsRight: boolean;
begin
  Result := FIsRight;
end;


function TRectWindow.GetOtstup: integer;
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



end.
