unit WKComboBox;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,Graphics, Windows, Messages, Forms;

type
  TWKComboBox = class(TComboBox)
  private
    { Private declarations }
    FOldBackColor : Tcolor;
    FColorEnter   : Tcolor;
    FTabOnEnter   : boolean;
    FBolehNull    : boolean;
    FWarnaPerhatian : Tcolor;
    FisPerhatianDipanggil : boolean;
    FBackColorSebelumPerhatian : Tcolor;
    FAlignment : TAlignment;
    FLicenseFeature: string;
    FPrimaryKey1 : TStringList;
    procedure SetAlignment(Const Value : TAlignment);
  protected
    { Protected declarations }

    procedure CreateParams(Var Params : TCreateParams); override;
    Procedure DoEnter; override;
    Procedure DoExit; override;
    Procedure KeyPress(Var Key : Char); Override;
  public
    { Public declarations }
    constructor Create(AOwner : Tcomponent);override;
    destructor Destroy; override;
    function GetPrimaryKey(piComboIndex: Integer): string;
    Procedure SetWarnaPerhatian;
    procedure KembalikanWarnaBackground;
    procedure SetItemIndexByText(psText: string; pisCaseSensitive: Boolean = False);

  published
    { Published declarations }
    Property ColorEnter : Tcolor read FColorEnter write FColorEnter;
    Property TabOnEnter : Boolean read FTabOnEnter write FTabOnEnter;
    Property BolehNull : Boolean read FBolehNull write FBolehNull;
    Property ColorWarning : Tcolor read FWarnaPerhatian write FWarnaPerhatian;
    Property Alignment : TAlignment read FAlignment write SetAlignment;
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    property PrimaryKey1 : TStringList read FPrimaryKey1 write FPrimaryKey1;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKComboBox]);
end;
constructor TWKComboBox.Create(AOwner : Tcomponent);
begin
  inherited;
  FColorEnter := $004AE3F0;
  FWarnaPerhatian := clRed;
  Alignment := taLeftJustify;
  FPrimaryKey1 := TStringList.Create;
  Tag := 9;
end;

destructor TWKComboBox.Destroy;
begin
  inherited;
  if FPrimaryKey1 <> nil then
  begin
    FreeAndNil(FPrimaryKey1);
  end;
end;

Procedure TWKComboBox.SetWarnaPerhatian;
begin
    FBackColorSebelumPerhatian := Color; //ini duluan
    Color := FWarnaPerhatian;            //baru ini
    FisPerhatianDipanggil := True;
end;

Procedure TWKComboBox.KeyPress(Var Key : Char);
begin
   inherited KeyPress(Key);

   if FTabOnEnter and (Owner is TWinControl) then
   begin
     if Key = Char(VK_RETURN) then
     begin
      if HiWord(GetKeyState(VK_SHIFT)) <> 0 then
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 1, 0)
      else
        PostMessage((Owner as TWinControl).Handle, WM_NEXTDLGCTL, 0, 0);
      end;
   end;
end;
procedure TWKComboBox.DoEnter;
begin
  FOldBackColor := Color;
  Color := FColorEnter;
  inherited;
end;

procedure TWKComboBox.DoExit;
begin
   Color := FOldBackColor;
   if FisPerhatianDipanggil then
   begin
     Color := FBackColorSebelumPerhatian;
     FisPerhatianDipanggil := False;
   end;
end;
procedure TWKComboBox.CreateParams(Var Params : TCreateParams);
const
    Alignments : array [TAlignment] of DWORD =(ES_LEFT,ES_RIGHT,ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or Alignments[FAlignment];
  end;
end;

function TWKComboBox.GetPrimaryKey(piComboIndex: Integer): string;
begin
  Result :='';

  if PrimaryKey1.Count < 1 then
  begin
    raise Exception.Create('Primary key is empty');
  end;

  if piComboIndex > PrimaryKey1.Count -1 then
  begin
    raise Exception.Create('Index is out of range of primary key stringlist');
  end else
  begin
    Result := PrimaryKey1.Strings[piComboIndex];
  end;

end;

procedure TWKComboBox.SetAlignment(Const Value : TAlignment);
begin
   if FAlignment <> Value then
   begin
     FAlignment := Value;
     RecreateWnd;
   end;
end;
procedure TWKComboBox.KembalikanWarnaBackground;
begin
  //fungsi ini berguna setelah pemanggilan terhadap setwarnaperhatian
  //coz, bila setelah pemanggilan fungsi tsb,fungsi ni tdk dipanggil, maka
  //color-nya akn sama dengan warna perhatian (misalnya Merah)
  if FisPerhatianDipanggil then
   begin
     Color := FBackColorSebelumPerhatian;
     FisPerhatianDipanggil := False;
   end;
end;

procedure TWKComboBox.SetItemIndexByText(psText: string; pisCaseSensitive:
    Boolean = False);
var
  I: Integer;
begin
    for I := 0 to Self.Items.Count - 1 do
    begin
      if not pisCaseSensitive then
      begin
        if LowerCase(Self.Items[i]) = LowerCase(psText) then
        begin
          self.ItemIndex := i;
          Break;
        end;
      end else
      begin
        if (Self.Items[i] = psText) then
        begin
          self.ItemIndex := i;
          Break;
        end;
      end;
    end;
end;

end.
