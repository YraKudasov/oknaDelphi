unit PlasticDoorImpost;

{$mode ObjFPC}{$H+}

interface

uses
   Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls;

type
  TPlasticDoorImpost = class
  private
    ScaledFImpYOtstup: integer;
    FImage: TImage;
  public
    constructor Create(AImpYOtstup: integer; AImage: TImage);
    procedure DrawDoorImp(ScaledImpWidth, ScaledXOtstup, ScaledYOtstup: integer);
    function GetScaledFImpYOtstup: integer;
  end;

implementation

constructor TPlasticDoorImpost.Create(AImpYOtstup: integer; AImage: TImage);
begin

  ScaledFImpYOtstup := AImpYOtstup;
  FImage := AImage;
end;

// Реализация метода класса
procedure TPlasticDoorImpost.DrawDoorImp(ScaledImpWidth, ScaledXOtstup, ScaledYOtstup: integer);
begin
  FImage.Canvas.Pen.Color := clBlack;
  FImage.Canvas.Brush.Color := clWhite;
  FImage.Canvas.Pen.Width := 2;
  FImage.Canvas.Rectangle(ScaledXOtstup+37,ScaledYOtstup, ScaledXOtstup+ScaledImpWidth-33, ScaledYOtstup+20);
end;

function TPlasticDoorImpost.GetScaledFImpYOtstup: integer;
begin
  Result := ScaledFImpYOtstup;
end;

end.
