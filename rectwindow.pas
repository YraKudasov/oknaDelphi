unit RectWindow;

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls; // Убедитесь, что используемый модуль совпадает с указанным здесь

type
  TRectWindow = class
  private
    FRectH, FRectW: Integer;
    FImage: TImage;
  public
    constructor Create(ARectH, ARectW: Integer; AImage: TImage);
    procedure DrawWindow;
  end;

implementation

constructor TRectWindow.Create(ARectH, ARectW: Integer; AImage: TImage);
begin
  FRectH := ARectH;
  FRectW := ARectW;
  FImage := AImage;
end;

procedure TRectWindow.DrawWindow;
var
  ArrowLength: Integer;
  ScreenWidth, ScreenHeight: Integer;
  ScaleFactorX, ScaleFactorY: Double;
  ScaledRectWidth, ScaledRectHeight: Integer;
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

