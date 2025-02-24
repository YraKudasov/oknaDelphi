unit PlasticDoorImpost;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls;

type
  TPlasticDoorImpost = class
  private
    FImpYOtstup: integer;
    FImage: TImage;
  public
    constructor Create(AImpYOtstup: integer; AImage: TImage);
    procedure DrawDoorImp(ScaledImpWidth, ScaledXOtstup, ScaledYOtstup: integer; ZoomIndex, MaxZoom: double);
    function GetScaledFImpYOtstup: integer;
  end;

implementation

constructor TPlasticDoorImpost.Create(AImpYOtstup: integer; AImage: TImage);
begin

  FImpYOtstup := AImpYOtstup;
  FImage := AImage;

end;

// Реализация метода класса
procedure TPlasticDoorImpost.DrawDoorImp(ScaledImpWidth, ScaledXOtstup, ScaledYOtstup: integer; ZoomIndex, MaxZoom: double);
begin
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Brush.Color := clWhite;
  FImage.Canvas.Pen.Width := 2;
  FImage.Canvas.Rectangle(ScaledXOtstup+Round(ZoomIndex / MaxZoom * 37),ScaledYOtstup, ScaledXOtstup+ScaledImpWidth-Round(ZoomIndex / MaxZoom * 33), ScaledYOtstup+Round(ZoomIndex / MaxZoom * 20));
end;

function TPlasticDoorImpost.GetFImpYOtstup: integer;
begin
  Result := FImpYOtstup;
end;

end.
