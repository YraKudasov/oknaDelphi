unit AbstractWindow;

interface

uses
  ExtCtrls, Types;

type
  TAbstractWindow = class abstract
  public
    procedure DrawWindow; virtual; abstract;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOtX, ScaledOtY: Integer); virtual; abstract;
    procedure Select(Sender: TObject); virtual; abstract;
    function GetSize: TPoint; virtual; abstract;
    procedure SetSize(const NewSize: TPoint); virtual; abstract;
    function Contains(CurrentClickX, CurrentClickY: Integer): Boolean; virtual; abstract;
  end;

implementation



end.
