program fpcunitproject1;

{$mode objfpc}{$H+}

uses
  Classes, consoletestrunner, testcase2; // Убедитесь, что все необходимые модули подключены

var
  Application: TTestRunner;

begin
  Application := TTestRunner.Create(nil);
  Application.Initialize;
  Application.Title := 'FPCUnit Console test runner';
  Application.Run;
  Application.Free;
end.
