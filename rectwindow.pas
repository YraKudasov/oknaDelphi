unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, AbstractWindow; // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class(TAbstractWindow)
  private
    FRectH, FRectW: Integer;
    FImage: TImage;
    FSelected: Boolean;
    FOnWindowSelected: TNotifyEvent;
    ScaledRectWidth, ScaledRectHeight: Integer;
  public
    constructor Create(ARectH, ARectW: Integer; AImage: TImage);
    procedure DrawWindow override;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH: Integer) override;
    procedure CanvasClickHandler(Sender: TObject) override;
    property OnWindowSelected: TNotifyEvent read FOnWindowSelected write FOnWindowSelected;
  end;

implementation

constructor TRectWindow.Create(ARectH, ARectW: Integer; AImage: TImage);
begin
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;
end;

procedure TRectWindow.DrawSelectionBorder(ScaledRW, ScaledRH: Integer);
begin
  if FSelected then
  begin
    FImage.Canvas.Brush.Style := bsClear;
    // Изменение обводки окна при выделении
    FImage.Canvas.Pen.Color := clRed;
    // Можете выбрать любой другой цвет
    FImage.Canvas.Pen.Width := 2;
    FImage.Canvas.Rectangle(2, 2, ScaledRW+3, ScaledRH+3);
  end;
end;

procedure TRectWindow.CanvasClickHandler(Sender: TObject);
var
  ClickX, ClickY: Integer;
begin
    ClickX := Mouse.CursorPos.X;
    ClickY := Mouse.CursorPos.Y;

    // Преобразуем абсолютные координаты в координаты клиента
    ClickX := FImage.ScreenToClient(Point(ClickX, ClickY)).X;
    ClickY := FImage.ScreenToClient(Point(ClickX, ClickY)).Y;


  // Проверяем, находится ли клик внутри области окна
   if (ClickX >= 4) and  (ClickX <= ScaledRectWidth) and
      (ClickY >= 4) and (ClickY <= ScaledRectHeight) then
   begin
     if FSelected then
     begin
       FSelected := False;
       FImage.Canvas.Brush.Color := clWhite;
       FImage.Canvas.FillRect(FImage.ClientRect);
       DrawWindow;
     end
     else begin
       FSelected := True; // Устанавливаем значение FSelected в true
       DrawSelectionBorder(ScaledRectWidth, ScaledRectHeight);  // Перерисовываем окно для отображения выделения

        if Assigned(OnWindowSelected) then
        OnWindowSelected(Self);

     end;
   end;
 end;


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

  // Отрисовка окна с учетом коэффициентов пропорциональности
  FImage.Canvas.Brush.Color := clWhite;
  FImage.Canvas.FillRect(FImage.ClientRect);
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Pen.Width := 3;
  FImage.Canvas.Rectangle(4, 4, ScaledRectWidth, ScaledRectHeight);

  // Отрисовка меньшего синего окна внутри
  FImage.Canvas.Brush.Color := clSkyBlue;
  FImage.Canvas.Rectangle(24, 24, ScaledRectWidth-20, ScaledRectHeight-20);



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


end.

