unit WKMemo;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,Graphics, Windows, Messages, Forms;
type
  TWKMemo = class(TMemo)
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
    FDefaultEmpty: String;
    FLicenseFeature: string;
    FMaxLengthPerLine: Integer;
    FPlaceHolder: String;
    FScrollToLast: Boolean;
    FScrollToTop: Boolean;
    FPrimaryKey: String;
    FTagObject: TObject;
    procedure SetAlignment(Const Value : TAlignment);
    function SetCueBanner(const Edit: TMemo; const Placeholder: String): Boolean;
  protected
    { Protected declarations }
    procedure CreateParams(Var Params : TCreateParams); override;
    Procedure DoEnter; override;
    Procedure DoExit; override;
    Procedure KeyPress(Var Key : Char); Override;
    procedure Change; override;
  public
    { Public declarations }
    constructor Create(AOwner : Tcomponent); override;
    function GetVisibleLineCount: Integer;
    Procedure SetWarnaPerhatian;
    Procedure KembalikanWarnaBackground;
    procedure ScrollToLastLine;
    procedure ScrollToTopLine;
  published
    { Published declarations }
    Property ColorEnter : Tcolor read FColorEnter write FColorEnter;
    Property TabOnEnter : Boolean read FTabOnEnter write FTabOnEnter;
    Property BolehNull : Boolean read FBolehNull write FBolehNull;
    Property ColorWarning : Tcolor read FWarnaPerhatian write FWarnaPerhatian;
    Property Alignment : TAlignment read FAlignment write SetAlignment;
    Property DefaultEmpty : String read FDefaultEmpty write FDefaultEmpty;
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    property MaxLengthPerLine : Integer read FMaxLengthPerLine write FMaxLengthPerLine default 0;
    property PlaceHolder: String read FPlaceHolder write FPlaceHolder;
    property ScrollToLast : Boolean read FScrollToLast write FScrollToLast default False;
    property ScrollToTop : Boolean read FScrollToTop write FScrollToTop default False;
    property PrimaryKey : String read FPrimaryKey write FPrimaryKey;
    property TagObject : TObject read FTagObject write FTagObject;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKMemo]);
end;

procedure TWKMemo.Change;
var
  Column: Integer;
  Line: Integer;
  lsCurrLineText: string;
  lslast_char: string;
begin
  inherited;
  if ScrollToLast then
  begin
    ScrollToLastLine;
  end;

  if ScrollToTop then
  begin
    ScrollToTopLine;
  end;

  if FMaxLengthPerLine > 0 then
  begin

       Line := Perform(EM_LINEFROMCHAR,SelStart, 0) ;
       Column := SelStart - Perform(EM_LINEINDEX, Line, 0) ;

       lsCurrLineText := Self.Lines.Strings[Line];

       if Length(lsCurrLineText) > FMaxLengthPerLine then
       begin
         lslast_char := Copy(lsCurrLineText,Length(lsCurrLineText),1);
         Delete(lsCurrLineText,length(lsCurrLineText),1);
         Self.Lines.Strings[Line] := lsCurrLineText;

         if (MaxLength > 0) then
         begin
           if (Length(Text) < MaxLength) then
           begin
             Self.Lines.Add(lslast_char);
           end;
         end else
         begin
           Self.Lines.Add(lslast_char);
         end;
       end;

  end;

  if Trim(Self.Text)='' then
  begin
    SetCueBanner(Self,PlaceHolder);
  end;
end;

constructor TWKMemo.Create(AOwner : Tcomponent);
begin
  inherited;
  FColorEnter := $004AE3F0;
  FWarnaPerhatian := clRed;
  Alignment := taLeftJustify;
  BolehNull := True;
  Font.Size := 10;
  Font.Name :='Courier New';
  //Tag := 0;
  //ScrollToLast := True;
end;

Procedure TWKMemo.SetWarnaPerhatian;
begin
    FBackColorSebelumPerhatian := Color; //ini duluan
    Color := FWarnaPerhatian;            //baru ini
    FisPerhatianDipanggil := True;
end;

Procedure TWKMemo.KeyPress(Var Key : Char);
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
procedure TWKMemo.DoEnter;
begin
   inherited;

  FOldBackColor := Color;
  Color := FColorEnter;

end;

procedure TWKMemo.DoExit;
begin
   inherited ;

   Color := FOldBackColor;
   if FisPerhatianDipanggil then
   begin
     Color := FBackColorSebelumPerhatian;
     FisPerhatianDipanggil := False;
   end;
end;
procedure TWKMemo.CreateParams(Var Params : TCreateParams);
const
    Alignments : array [TAlignment] of DWORD =(ES_LEFT,ES_RIGHT,ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or Alignments[FAlignment];
  end;
end;

function TWKMemo.GetVisibleLineCount: Integer;
var
  DC: HDC;
  SaveFont: HFONT;
  TextMetric: TTextMetric;
  EditRect: TRect;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Self.Font.Handle);
  GetTextMetrics(DC, TextMetric);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);

  Self.Perform(EM_GETRECT, 0, LPARAM(@EditRect));
  Result := (EditRect.Bottom - EditRect.Top) div TextMetric.tmHeight;
end;

procedure TWKMemo.SetAlignment(Const Value : TAlignment);
begin
   if FAlignment <> Value then
   begin
     FAlignment := Value;
     RecreateWnd;
   end;
end;
procedure TWKMemo.KembalikanWarnaBackground;
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

procedure TWKMemo.ScrollToLastLine;
begin
  if ScrollToLast then
  begin
    SendMessage(Self.Handle, EM_LINESCROLL, 0,Self.Lines.Count);
  end;
end;

procedure TWKMemo.ScrollToTopLine;
var
  line_count: Integer;
//  top_line: Integer;
begin
  line_count := Self.Perform(EM_GETLINECOUNT,0,0)-1;
 // top_line :=   self.Perform(EM_GETFIRSTVISIBLELINE, 0, 0);
  SendMessage(Self.Handle, EM_LINESCROLL, 0,0 - line_count);
  
end;

function TWKMemo.SetCueBanner(const Edit: TMemo; const Placeholder: String):
    Boolean;
const
  EM_SETCUEBANNER = $1501;
var
  UniStr: WideString;
begin
  UniStr := Placeholder;
  SendMessage(Edit.Handle, EM_SETCUEBANNER, WParam(True),LParam(UniStr));
  Result := GetLastError() = ERROR_SUCCESS;
end;

end.
