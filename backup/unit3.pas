unit Unit3;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls, RectWindow;

type
  TPointArray = array of TPoint;

  { TForm3 }

  TForm3 = class(TForm)
    ComboBox1: TComboBox;
    procedure FormShow(Sender: TObject);
  private
    CurrWin: TRectWindow;
  public
        procedure LoadWindow(Value: TRectWindow);
  end;

var
  Form3: TForm3;

implementation



{$R *.lfm}

procedure TForm3.FormShow(Sender: TObject);
var
  Points: TPointArray;
  I: Integer;
begin
  ComboBox1.Items.Clear;
  CurrWin.GetPolygonVertices(Points);
  for I := 0 to High(Points) do
    ComboBox1.Items.Add(Format('(%d, %d)', [Points[I].X, Points[I].Y]));
end;

procedure TForm3.LoadWindow(Value: TRectWindow);
begin
  CurrWin := Value;
end;

end.
