unit AbstractWindow;

interface

uses
  ExtCtrls, Types;

type
  TAbstractWindow = class abstract
  public
    procedure DrawWindow; virtual; abstract;
    procedure DrawSelectionBorder(ScaledRW, ScaledRH, ScaledOt: Integer); virtual; abstract;
    procedure CanvasClickHandler(Sender: TObject); virtual; abstract;
    procedure AddVerticalImpost(Sender: TObject);virtual; abstract;
    procedure AddHorizontalImpost(Sender: TObject);virtual; abstract;
    function GetSize: TPoint; virtual; abstract;
    procedure SetSize(const NewSize: TPoint); virtual; abstract;
    function Contains(CurrentClickX, CurrentClickY: Integer): Boolean; virtual; abstract;
  end;

implementation



end.
