unit AbstractWindow;

interface

uses
  ExtCtrls;

type
  TAbstractWindow = class abstract
  public
    procedure DrawWindow; virtual; abstract;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH: Integer); virtual; abstract;
    procedure CanvasClickHandler(Sender: TObject); virtual; abstract;
  end;

implementation



end.
