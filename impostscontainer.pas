unit ImpostsContainer;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, PlasticDoorImpost;

type
  TImpostsContainer = class
  private
    FImpostsList: TList; // Список для хранения экземпляров TPlasticDoorImpost
  public
    constructor Create; // Конструктор
    destructor Destroy; override; // Деструктор для освобождения памяти

    procedure AddImpost(AImpost: TPlasticDoorImpost); // Метод добавления
    procedure RemoveImpostByIndex(Index: Integer);
    function GetImpost(Index: Integer): TPlasticDoorImpost; // Получение импоста по индексу
    function Count: Integer; // Возвращает количество импостов
  end;

implementation

{ TImpostsContainer }

// Конструктор
constructor TImpostsContainer.Create;
begin
  inherited Create;
  FImpostsList := TList.Create; // Создаем список
end;

// Деструктор
destructor TImpostsContainer.Destroy;
var
  I: Integer;
begin
  // Освобождаем память для каждого экземпляра TPlasticDoorImpost
  for I := 0 to FImpostsList.Count - 1 do
    TObject(FImpostsList[I]).Free;

  FImpostsList.Free; // Освобождаем память для списка
  inherited Destroy;
end;

// Метод добавления импоста
procedure TImpostsContainer.AddImpost(AImpost: TPlasticDoorImpost);
begin
  FImpostsList.Add(AImpost);
end;

// Метод удаления импоста по индексу
procedure TImpostsContainer.RemoveImpostByIndex(Index: Integer);
begin
  // Проверяем, что индекс находится в пределах допустимого диапазона
  if (Index >= 0) and (Index < FImpostsList.Count) then
  begin
    TObject(FImpostsList[Index]).Free; // Освобождаем память для удаляемого объекта
    FImpostsList.Delete(Index);        // Удаляем объект из списка
  end
  else
  begin
    raise Exception.CreateFmt('Индекс %d находится вне допустимого диапазона.', [Index]);
  end;
end;

// Метод получения импоста по индексу
function TImpostsContainer.GetImpost(Index: Integer): TPlasticDoorImpost;
begin
  if (Index >= 0) and (Index < FImpostsList.Count) then
    Result := TPlasticDoorImpost(FImpostsList[Index])
  else
    raise Exception.Create('Index out of bounds');
end;

// Метод получения количества импостов
function TImpostsContainer.Count: Integer;
begin
  Result := FImpostsList.Count;
end;

end.
