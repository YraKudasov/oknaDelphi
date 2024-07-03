unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, AbstractWindow, Contnrs ; // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class(TAbstractWindow)
  private
    FRectH, FRectW, FOtstup: Integer;
    FImage: TImage;
    FIsRight: Boolean;
    FOnWindowSelected: TNotifyEvent;
    FOnWindowDeselected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight, ScaledOtstup: Integer;
    FVerticalImpost: Boolean;
    FHorizontalImpost: Boolean;
  public
    FSelected: Boolean;


  public
    constructor Create(ARectH, ARectW: Integer; AImage: TImage; IsRight: Boolean; AOtstup:Integer);
    procedure DrawWindow; override;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOt: Integer); override;
    procedure Select(Sender: TObject); override;
    procedure AddVerticalImpost (Sender: TObject); override;
    procedure AddHorizontalImpost(Sender: TObject); override;
    property OnWindowSelected: TNotifyEvent read FOnWindowSelected write FOnWindowSelected;
    property OnWindowDeselected: TNotifyEvent read FOnWindowDeselected write FOnWindowDeselected;
    function GetSize: TPoint; override;
    procedure SetSize(const NewSize: TPoint); override;
    function GetIsRight: Boolean;
    function GetOtstup: Integer;
    function Contains(CurrentClickX, CurrentClickY: Integer): Boolean; override;


    property VerticalImpost: Boolean read FVerticalImpost write FVerticalImpost;
    property HorizontalImpost: Boolean read FHorizontalImpost write FHorizontalImpost;

  end;

implementation

constructor TRectWindow.Create(ARectH, ARectW: Integer; AImage: TImage; IsRight: Boolean; AOtstup:Integer);
begin
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;
  FIsRight := IsRight;
  FOtstup := AOtstup;
end;

procedure TRectWindow.DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOt: Integer);
begin
  if FSelected then
  begin
    FImage.Canvas.Brush.Style := bsClear;
    // Изменение обводки окна при выделении
    FImage.Canvas.Pen.Color := clRed;
    // Можете выбрать любой другой цвет
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Rectangle(2+ScaledOt, 2, ScaledRW+3+ScaledOt, ScaledRH+3);
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
     else begin
       FSelected := True; // Устанавливаем значение FSelected в true
       DrawSelectionBorder(ScaledRectWidth, ScaledRectHeight, ScaledOtstup);  // Перерисовываем окно для отображения выделения

       if Assigned(OnWindowSelected) then
       OnWindowSelected(Self);

     end;
   end;
 //end;


procedure TRectWindow.DrawWindow;
var
  ArrowLength: Integer;
  ScreenWidth, ScreenHeight: Integer;
  ScaleFactorX, ScaleFactorY: Double;

begin

  ScreenWidth := FImage.Width;
  ScreenHeight := FImage.Height;
  // Вычисление коэффициентов пропорциональности
  ScaleFactorX := ScreenWidth / 3500; // Замените 3500 на ширину вашего прямоугольника
  ScaleFactorY := ScreenHeight / 2000; // Замените 2000 на высоту вашего прямоугольника

  // Вычисление масштабированных размеров окна
  ScaledRectWidth := Round(FRectW * ScaleFactorX);
  ScaledRectHeight := Round(FRectH * ScaleFactorY);
  ScaledOtstup := Round(FOtstup * ScaleFactorX);

  // Отрисовка окна с учетом коэффициентов пропорциональности

  FImage.Canvas.Brush.Color := clWhite; // Задайте цвет фона окна
  if (GetIsRight = False) then
  begin
  FImage.Canvas.FillRect(Rect(ScaledOtstup+4, 4, ScaledRectWidth+ScaledOtstup+2, ScaledRectHeight)); // Очистите всю область окна
  end
  else
  begin
  FImage.Canvas.FillRect(Rect(ScaledOtstup+4, 4, ScaledRectWidth+ScaledOtstup, ScaledRectHeight)); // Очистите всю область окна
  end;
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 3;
  FImage.Canvas.Rectangle(ScaledOtstup+4, 4, ScaledRectWidth+ScaledOtstup, ScaledRectHeight);

  // Отрисовка меньшего синего окна внутри
  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Rectangle(ScaledOtstup+24, 24, ScaledRectWidth-20+ScaledOtstup, ScaledRectHeight-20);


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

procedure TRectWindow.AddVerticalImpost(Sender: TObject);
 begin


   if not FVerticalImpost then
   begin
     FVerticalImpost := True;

   end
   else
   begin
     FVerticalImpost := False;

   end;
  // Рисуем разделитель между окнами
   {
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 3;
  FImage.Canvas.Brush.Color := clWhite;
  FImage.Canvas.Rectangle(Trunc((ScaledRectWidth/2)-8), 24, Trunc((ScaledRectWidth/2)+12), ScaledRectHeight-20);
    }
end;

  function TRectWindow.Contains(CurrentClickX, CurrentClickY: Integer): Boolean;
begin
  // Проверяем, находится ли клик внутри области окна
   if (CurrentClickX >= 4+ScaledOtstup) and  (CurrentClickX <= ScaledRectWidth+ScaledOtstup) and
      (CurrentClickY >= 4) and (CurrentClickY <= ScaledRectHeight) then
   begin
  Result := True;
  end
   else
   Result := False;
end;

procedure TRectWindow.AddHorizontalImpost(Sender: TObject);
  begin
    FImage.Canvas.Pen.Color := clBlack;
    FImage.Canvas.Pen.Width := 3;
    FImage.Canvas.Brush.Color := clWhite;
    FImage.Canvas.Rectangle(24, Trunc((ScaledRectHeight/2)-8), Trunc(ScaledRectWidth - 20), Trunc(ScaledRectHeight/2)+12);
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

  function TRectWindow.GetIsRight: Boolean;
begin
  Result := FIsRight;
end;


  function TRectWindow.GetOtstup: Integer;
begin
  Result := FOtstup;
end;

end.

