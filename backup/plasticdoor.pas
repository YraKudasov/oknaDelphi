unit PlasticDoor;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, RectWindow;

type
  TPlasticDoor = class(TRectWindow)

public
    procedure DrawWindow(Index: double); override;
end;

implementation

    procedure TPlasticDoor.DrawWindow(Index: double);
begin
  // Вызываем метод родительского класса, если нужно
  inherited DrawWindow(Index);

  // Добавляем свою логику
  WriteLn('Adding a plastic frame to the window...');
end;

end.

