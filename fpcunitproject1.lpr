program fpcunitproject1;

{$mode objfpc}{$H+}

uses
  Interfaces, // Добавьте этот модуль первым
  Classes,
  consoletestrunner,
  testcase2;

type
  { TMyTestRunner }
  TMyTestRunner = class(TTestRunner)
  protected
  // override the protected methods of TTestRunner to customize its behavior
  end;

var
  Application: TMyTestRunner;

begin
  Application := TMyTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'FPCUnit Console test runner';
  Application.Run;
  Application.Free;
end.
