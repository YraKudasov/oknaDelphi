unit TestCase2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testregistry, FullContainer, WindowContainer, RectWindow, Unit1,
   Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type
  TTestCase2 = class(TTestCase)
  published
    procedure TestAddOneContainer;
    procedure TestAddMoreOneContainers;
    procedure TestAddALotContainers;
    procedure TestDeleteNotLastContainer;
    procedure TestDeleteLastContainer;
    procedure TestIndexOfOneContainer;
    procedure TestIndexOfNotOneContainer;
    procedure TestIndexOfLastContainer;
    //////////////////////////////////////
    procedure TestAddOneWindow;
    procedure TestAddMoreThanOneWindow;
    procedure TestDeleteOneWindow;
    procedure TestDeleteMoreOneWindow;
    procedure TestDeleteLastWindow;
    procedure TestIndexOfOneWindow;
    procedure TestIndexOfThirdWindow;
    procedure TestGetIndexRowColumn;
    /////////////////////////////////////
    procedure TestChooseProfileOtstup;


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
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestAddALotContainers;
var
  FullContainer: TFullContainer;
  WindowContainers: array[1..5] of TWindowContainer;
  i: Integer;
begin
  FullContainer := TFullContainer.Create;
  try
    // Create and add five containers
    for i := 1 to 5 do
    begin
      WindowContainers[i] := TWindowContainer.Create;
      FullContainer.AddContainer(WindowContainers[i]); // Добавляем контейнер
    end;
    AssertEquals('Количество контейнеров должно быть 5', 5, FullContainer.Count); // Проверяем количество контейнеров
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestDeleteNotLastContainer;
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
      FullContainer.AddContainer(WindowContainer2);
      FullContainer.RemoveContainer(0);// Добавляем второй контейнер
      AssertEquals('Количество контейнеров должно быть 1', 1, FullContainer.Count); // Проверяем количество контейнеров
    finally
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestDeleteLastContainer;
var
  FullContainer: TFullContainer;
  WindowContainer1: TWindowContainer;
begin
  FullContainer := TFullContainer.Create;
  try
    WindowContainer1 := TWindowContainer.Create;
    try
      FullContainer.AddContainer(WindowContainer1); // Добавляем первый контейнер
      FullContainer.RemoveContainer(0);// Добавляем второй контейнер
      AssertEquals('Количество контейнеров должно быть 1', 0, FullContainer.Count); // Проверяем количество контейнеров
    finally
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestIndexOfOneContainer;
var
  FullContainer: TFullContainer;
  WindowContainer1: TWindowContainer;
  ExpIdx: integer;
begin
  ExpIdx := 0;
  FullContainer := TFullContainer.Create;
  try
    WindowContainer1 := TWindowContainer.Create;
    try
      FullContainer.AddContainer(WindowContainer1); // Добавляем первый контейнер
      AssertEquals('Количество контейнеров должно быть 0', ExpIdx,  FullContainer.IndexOfContainer(WindowContainer1)); // Проверяем количество контейнеров
    finally
    end;
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestIndexOfNotOneContainer;
var
  FullContainer: TFullContainer;
  WindowContainers: array[1..5] of TWindowContainer;
  ExpIdx,i: Integer;
begin
  FullContainer := TFullContainer.Create;
  ExpIdx := 2;
  try
    // Create and add five containers
    for i := 1 to 5 do
    begin
      WindowContainers[i] := TWindowContainer.Create;
      FullContainer.AddContainer(WindowContainers[i]); // Добавляем контейнер
    end;
    AssertEquals('Количество контейнеров должно быть 3', ExpIdx, FullContainer.IndexOfContainer(WindowContainers[3])); // Проверяем количество контейнеров
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;

procedure TTestCase2.TestIndexOfLastContainer;
var
  FullContainer: TFullContainer;
  WindowContainers: array[1..5] of TWindowContainer;
  ExpIdx,i: Integer;
begin
  FullContainer := TFullContainer.Create;
  ExpIdx := 4;
  try
    // Create and add five containers
    for i := 1 to 5 do
    begin
      WindowContainers[i] := TWindowContainer.Create;
      FullContainer.AddContainer(WindowContainers[i]); // Добавляем контейнер
    end;
    AssertEquals('Количество контейнеров должно быть 4', ExpIdx, FullContainer.IndexOfContainer(WindowContainers[5])); // Проверяем количество контейнеров
  finally
    FullContainer.Free; // Освобождаем FullContainer
  end;
end;
 /////////////////////////////////////////////////////////////////////////////
 procedure TTestCase2.TestAddOneWindow;
var
  WindowContainer: TWindowContainer;
  Window: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window); // Добавляем контейнер
      AssertEquals('Кол-во окон должно быть 1', 1, WindowContainer.Count); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;

  procedure TTestCase2.TestAddMoreThanOneWindow;
var
  WindowContainer: TWindowContainer;
  Window1, Window2, Window3: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window2 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window3 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      WindowContainer.AddWindow(Window2);
      WindowContainer.AddWindow(Window3);
      AssertEquals('Кол-во окон должно быть 3', 3, WindowContainer.Count); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;


    procedure TTestCase2.TestDeleteOneWindow;
var
  WindowContainer: TWindowContainer;
  Window1, Window2, Window3: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window2 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window3 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      WindowContainer.AddWindow(Window2);
      WindowContainer.AddWindow(Window3);
      WindowContainer.RemoveWindow(1);
      AssertEquals('Кол-во окон должно быть 2', 2, WindowContainer.Count); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;

procedure TTestCase2.TestDeleteMoreOneWindow;
var
  WindowContainer: TWindowContainer;
  Window1, Window2, Window3: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window2 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window3 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      WindowContainer.AddWindow(Window2);
      WindowContainer.AddWindow(Window3);
      WindowContainer.RemoveWindow(1);
      WindowContainer.RemoveWindow(1);
      AssertEquals('Кол-во окон должно быть 1', 1, WindowContainer.Count); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;

procedure TTestCase2.TestDeleteLastWindow;
var
WindowContainer: TWindowContainer;
Window1, Window2, Window3: TRectWindow;
Image1: TImage;
begin
WindowContainer := TWindowContainer.Create;
try
    Window1 := TRectWindow.Create(1, 2,
     1, 1, Image1, 1, 1,
      1, 0, False);

  WindowContainer.AddWindow(Window1); // Добавляем контейнер
  WindowContainer.RemoveWindow(0);
  AssertEquals('Кол-во окон должно быть 0', 0, WindowContainer.Count); // Проверяем количество контейнеров
finally
end;

WindowContainer.Free; // Освобождаем FullContainer

end;

procedure TTestCase2.TestIndexOfOneWindow;
var
  WindowContainer: TWindowContainer;
  Window1: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);

      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      AssertEquals('Индекс должен быть 0', 0, WindowContainer.IndexOf(Window1)); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;

procedure TTestCase2.TestIndexOfThirdWindow;
var
  WindowContainer: TWindowContainer;
  Window1, Window2, Window3: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window2 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window3 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      WindowContainer.AddWindow(Window2);
      WindowContainer.AddWindow(Window3);
      AssertEquals('Кол-во окон должно быть 2', 2, WindowContainer.IndexOf(Window3)); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;

 procedure TTestCase2.TestGetIndexRowColumn;
var
  WindowContainer: TWindowContainer;
  Window1, Window2, Window3: TRectWindow;
  Image1: TImage;
begin
    WindowContainer := TWindowContainer.Create;
    try
        Window1 := TRectWindow.Create(1, 1,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window2 := TRectWindow.Create(1, 2,
         1, 1, Image1, 1, 1,
          1, 0, False);
          Window3 := TRectWindow.Create(1, 3,
         1, 1, Image1, 1, 1,
          1, 0, False);
      WindowContainer.AddWindow(Window1); // Добавляем контейнер
      WindowContainer.AddWindow(Window2);
      WindowContainer.AddWindow(Window3);
      AssertEquals('Индекс должен быть 1', 1, WindowContainer.GetIndexRowColumn(1,2)); // Проверяем количество контейнеров
    finally
    end;

    WindowContainer.Free; // Освобождаем FullContainer

end;




initialization

  RegisterTest(TTestCase2);

end.

