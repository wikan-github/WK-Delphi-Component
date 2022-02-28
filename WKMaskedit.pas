unit WKMaskEdit;

interface

uses
  SysUtils, Classes, Controls, StdCtrls,Graphics, Windows, Messages, Forms,Mask;

type
  TJenisInput=(InputTeks,InputBilanganDecimal,InputBilanganGenap,InputUang);
  TMaskedText = type string;

  TWKMaskEdit = class(TCustomMaskEdit)
  private
    { Private declarations }
    FMaskState: TMaskedState;
    FOldBackColor : Tcolor;
    FColorEnter   : Tcolor;
    FTabOnEnter   : boolean;
    FBolehNull    : boolean;
    FWarnaPerhatian : Tcolor;
    FisPerhatianDipanggil : boolean;
    FBackColorSebelumPerhatian : Tcolor;
    FAlignment : TAlignment;
    FLicenseFeature: string;
    FPrimaryKey : String;
    procedure SetAlignment(Const Value : TAlignment);

    function HapusKarakter(aText :string; aKarakterDihapus :
    char): string;
  protected
    
    { Protected declarations }	
    Procedure DoEnter; override;
    Procedure DoExit; override;
	procedure CreateParams(Var Params : TCreateParams); override;
    procedure ValidateError; override ;
  public
    constructor Create(AOwner : Tcomponent); override;
    Procedure SetWarnaPerhatian;
    Procedure KembalikanWarnaBackground;
    procedure ValidateEdit; override;
    { Public declarations }
  published
    { Published declarations }
    Property Alignment : TAlignment read FAlignment write SetAlignment;
    Property ColorEnter : Tcolor read FColorEnter write FColorEnter;
    Property TabOnEnter : Boolean read FTabOnEnter write FTabOnEnter;
    Property BolehNull : Boolean read FBolehNull write FBolehNull;
    Property ColorWarning : Tcolor read FWarnaPerhatian write FWarnaPerhatian;
    Property PrimaryKey : String read FPrimaryKey write FPrimaryKey;

    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;

    property Align;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind;
    property BevelWidth;
    property BiDiMode;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property Ctl3D;
    property DoubleBuffered;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property EditMask;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentDoubleBuffered;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property TextHint;
    property Touch;
    property Visible;
    property StyleElements;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnGesture;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseActivate;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKMaskEdit]);
end;

procedure TWKMaskEdit.CreateParams(Var Params : TCreateParams);
const
    Alignments : array [TAlignment] of DWORD =(ES_LEFT,ES_RIGHT,ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or Alignments[FAlignment];
  end;
end;

constructor TWKMaskEdit.Create(AOwner : TComponent);
begin
  inherited;
  FColorEnter := $004AE3F0;
  FWarnaPerhatian := clRed;
  Alignment := taLeftJustify;
  MaxLength := 50;
  BolehNull := True;
  Tag := 9;
 // FOldBackColor := color;

end;

procedure TWKMaskEdit.DoEnter;
begin
  inherited;
  FOldBackColor := Color;
  Color := FColorEnter;
end;

Procedure TWKMaskEdit.SetWarnaPerhatian;
begin
    FBackColorSebelumPerhatian := Color; //ini duluan
    Color := FWarnaPerhatian;            //baru ini
    FisPerhatianDipanggil := True;
end;

procedure TWKMaskEdit.DoExit;
//var

//    dst: string;
//    I,L,P: Integer;
begin
   Color := FOldBackColor;
   if FisPerhatianDipanggil then
   begin
     Color := FBackColorSebelumPerhatian;
     FisPerhatianDipanggil := False;
   end;    
end;

function TWKMaskEdit.HapusKarakter(aText :string; aKarakterDihapus :
    char): string;
var
  i: Integer;
begin
  // TODO -cMM: TfrmPinjamanAnggota.HapusKarakter default body inserted
  Result :='';
  if trim(aText)='' then
  begin
    Result :='';
    exit;
  end;

  for i := 0 to length(aText) do
  begin

    if aText[i]=aKarakterDihapus then
       delete(aText,i,1);
  end;
  result := aText;

end;

procedure TWKMaskEdit.KembalikanWarnaBackground;
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

procedure TWKMaskEdit.SetAlignment(Const Value : TAlignment);
begin
   if FAlignment <> Value then
   begin
     FAlignment := Value;
     RecreateWnd;
   end;
end;

procedure TWKMaskEdit.ValidateEdit;
var
  Str: string;
  Pos: Integer;
begin
  Str := EditText;
  if IsMasked and Modified then
  begin
    if not Validate(Str, Pos) then
    begin
      if not (csDesigning in ComponentState) then
      begin
        Include(FMaskState, msReEnter);

        //SetFocus;
      end;
      SetCursor(Pos);
      ValidateError;
    end;
  end;
end;

procedure TWKMaskEdit.ValidateError;
begin
  MessageBeep(30);
 // raise EDBEditError.CreateResFmt(@SMaskEditErr, [EditMask]);
  //Application.MessageBox('Data harus valid dan lengkap','Error input data...',MB_OK + MB_ICONERROR);
end;


end.
