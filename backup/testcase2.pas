unit TestCase2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, FullContainer, WindowContainer;

type
  TTestCase2 = class(TTestCase)
  published
    procedure TestAddOneContainer;
    procedure TestAddMoreOneContainers;
  end;

implementation

procedure TTestCase2.TestAddOneContainer;
var
  FullContainer: TFullContainer;
  WindowContainer: TWindowContainer;
begin
  FullContainer := TFullContainer.Create;
  try
    WindowContainer := TWindowContainer.Create;
    try
      FullContainer.AddContainer(WindowContainer); // Добавляем контейнер
      AssertEquals('Контейнер должен быть добавлен', 1, FullContainer.Count); // Проверяем количество контейнеров
    finally
      // Убедитесь, что вы не освобождаете WindowContainer здесь, так как FContainers будет владеть им
      // WindowContainer.Free;
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestAddMoreOneContainers;
var
  FullContainer: TFullContainer;
  WindowContainer1, WindowContainer2: TWindowContainer;
begin
  FullContainer := TFullContainer.Create;
  try
    WindowContainer1 := TWindowContainer.Create;
    WindowContainer2 := TWindowContainer.Create;
    try
      FullContainer.AddContainer(WindowContainer1); // Добавляем первый контейнер
      FullContainer.AddContainer(WindowContainer2); // Добавляем второй контейнер
      AssertEquals('Количество контейнеров должно быть 2', 2, FullContainer.Count); // Проверяем количество контейнеров
    finally
      // Не освобождаем WindowContainer1 и WindowContainer2 здесь
      // WindowContainer1.Free;
      // WindowContainer2.Free;
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

initialization

  RegisterTest(TTestCase2);

end.

