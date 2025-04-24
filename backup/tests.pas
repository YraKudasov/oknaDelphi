unit tests;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, FPCUnit, SysUtils;

type
  TMyTests = class(TTestCase)
  published
    procedure TestExample;
  end;

implementation

procedure TMyTests.TestExample;
begin
  CheckEquals(2 + 2, 4, '2 + 2 должно быть равно 4');
end;

initialization
  RegisterTest(TMyTests);

end.
