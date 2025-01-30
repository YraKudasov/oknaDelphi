unit PlasticDoor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, RectWindow;

type
  TPlasticDoor = class(TRectWindow)

public
    procedure DrawWindow; override;
end;

implementation

    procedure TPlasticDoor.DrawWindow;
begin
  // Вызываем метод родительского класса, если нужно
  inherited DrawWindow;

  // Добавляем свою логику
  WriteLn('Adding a plastic frame to the window...');
end;

end.

