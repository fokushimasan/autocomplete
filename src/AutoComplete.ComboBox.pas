unit AutoComplete.ComboBox;

interface

uses
  System.SysUtils,
  System.Classes,
  FMX.Types,
  FMX.Controls,
  FMX.ListBox;

type
  TAutoComboBox = class(TComboBox)
  private
    { Private declarations }
    FLastKeyPress: TDateTime;
    FKeyPressSearchDelay: Integer;
    FSearchText: string;
  protected
    { Protected declarations }
    procedure SetKeyPressSearchDelay(AValue: Integer);
     function GetKeyPressSearchDelay: Integer;
     procedure KeyDown(var Key: Word; var KeyChar: System.WideChar; Shift: TShiftState); override;
  public
    { Public declarations }
    function SearchDropDown(AText: string; AShowDropDown: Boolean = True): Integer;
  published
    { Published declarations }
    property KeyPressSearchDelay: Integer read GetKeyPressSearchDelay write SetKeyPressSearchDelay default 2;
  end;

procedure Register;

implementation

uses
  DateUtils,
  StrUtils;

procedure Register;
begin
  RegisterComponents('Auto Complete', [TAutoComboBox]);
end;

{ TAutoComboBox }

function TAutoComboBox.GetKeyPressSearchDelay: Integer;
begin
  SetKeyPressSearchDelay(FKeyPressSearchDelay);
  Result := FKeyPressSearchDelay;
end;

procedure TAutoComboBox.KeyDown(var Key: Word;
  var KeyChar: System.WideChar; Shift: TShiftState);
begin
  if KeyChar in ['a' .. 'z', 'A' .. 'Z', '0' .. '9', #32] then
  begin
    if SecondsBetween(TimeOf(Now), FLastKeyPress) <= FKeyPressSearchDelay then
    begin
      FSearchText := FSearchText + KeyChar;
    end else begin
      FSearchText := KeyChar;
    end;

    if SearchDropDown(FSearchText) <> -1 then
    begin
      FLastKeyPress := TimeOf(Now);
      KeyChar := #0;
    end;

  end else begin
    inherited;
  end;
end;

function TAutoComboBox.SearchDropDown(AText: string; AShowDropDown: Boolean): Integer;

  function FindStartsTextIndex(Strings: TStrings; const SubStr: string):
  integer;
  begin
    for Result := 0 to Pred(Strings.Count) do
    begin
      if StartsText(SubStr, Strings[Result]) then
      begin
        exit;
      end;
    end;

    Result := -1;
  end;

begin
   Result := FindStartsTextIndex(Self.Items, FSearchText);

   if (Result <> -1) then
   begin
     if (not Self.DroppedDown) and (AShowDropDown) then
     begin
       Self.DropDown;
     end;

     Self.ItemIndex := Result;
   end;
end;

procedure TAutoComboBox.SetKeyPressSearchDelay(AValue: Integer);
begin
  if (AValue > 0) and (AValue <= 10) then
   begin
     FKeyPressSearchDelay := AValue;
   end else begin
     FKeyPressSearchDelay := 2;
   end;
end;

end.
