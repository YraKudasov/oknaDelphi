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
    constructor Create(AImpYOtstup: integer);
    procedure DrawDoorImp;
  end;

implementation

constructor TPlasticDoorImpost.Create(AImpYOtstup: integer);
begin
  ScaledFImpYOtstup := AImpYOtstup;
end;

// Реализация метода класса
procedure TPlasticDoorImpost.DrawDoorImp(ScaledImpWidth, ScaledXOtstup: integer);
begin
  // Реализация процедуры
end;


end.
