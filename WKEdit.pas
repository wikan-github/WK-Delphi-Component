unit WKEdit;

interface

uses
    Vcl.StdCtrls,Vcl.Graphics, Winapi.Windows, Winapi.Messages, Vcl.Forms
    ,System.SysUtils, System.Classes, Vcl.Controls;

type
  TJenisInput=(InpTeks,InpBilDecimal,InpBilGenap,
               InpUang,InpFixedBilPositif,InpFixedBilPositifNegatif);

  TWKEdit = class(TEdit)
  private
    { Private declarations }
    FOldBackColor : Tcolor;
    FColorEnter   : Tcolor;
    FTabOnEnter   : boolean;
    FBolehNull    : boolean;
    FWarnaPerhatian : Tcolor;
    FisPerhatianDipanggil : boolean;
    FBackColorSebelumPerhatian : Tcolor;
    FJenisInput   : TJenisInput;
    FAlignment : TAlignment;
    FPrimaryKey : String;
    FDefaultEmpty :string;
    FForwardBackWardON : Boolean;
    FLicenseFeature: string;
    FPlaceHolder: String;
    FTagObject: TObject;
    procedure SetAlignment(Const Value : TAlignment);

    function HapusKarakter(aText :string; aKarakterDihapus :
    char): string;
    function SetCueBanner(const Edit: TEdit; const Placeholder: String): Boolean;
  protected

    { Protected declarations }
    Procedure DoEnter; override;
    Procedure DoExit; override;
    Procedure KeyPress(Var Key : Char); Override;
    procedure KeyUp(var Key : word;Shift: TshiftState);override;
	  procedure CreateParams(Var Params : TCreateParams); override;
    procedure Change; override;
  public
    // untuk menampung data tambahan berupa datetime.
    //karena datetostr kemudian strtodate akan memunculkan exception di delphi
    AdditionalDateTimeData : TDateTime;
    DataChanged : Boolean;
    constructor Create(AOwner : Tcomponent); override;
    Procedure SetWarnaPerhatian;
    Procedure KembalikanWarnaBackground;
    procedure DisplayPlaceHolder;
    { Public declarations }
  published
    { Published declarations }
    Property JenisInput : TJenisInput read FJenisInput write FJenisInput;
    Property Alignment : TAlignment read FAlignment write SetAlignment;
    Property ColorEnter : Tcolor read FColorEnter write FColorEnter;
    Property TabOnEnter : Boolean read FTabOnEnter write FTabOnEnter;
    Property BolehNull : Boolean read FBolehNull write FBolehNull;
    Property ColorWarning : Tcolor read FWarnaPerhatian write FWarnaPerhatian;
    Property PrimaryKey : String read FPrimaryKey write FPrimaryKey;
    Property DefaultEmpty : String read FDefaultEmpty write FDefaultEmpty;
    Property ForwardBackwardON : Boolean read FForwardBackWardON write FForwardBackWardON default False;
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    property PlaceHolder: String read FPlaceHolder write FPlaceHolder;
    property TagObject : TObject read FTagObject write FTagObject;

  end;


procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKEdit]);
end;

procedure TWKEdit.CreateParams(Var Params : TCreateParams);
const
    Alignments : array [TAlignment] of DWORD =(ES_LEFT,ES_RIGHT,ES_CENTER);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Style := Style or Alignments[FAlignment];
  end;
end;

constructor TWKEdit.Create(AOwner : TComponent);
begin
  inherited;
  FColorEnter := $004AE3F0;
  FWarnaPerhatian := clRed;
  Alignment := taLeftJustify;
 // MaxLength := 50;
  BolehNull := True;
  FJenisInput := InpTeks;
  FTabOnEnter := True;
  FForwardBackWardON := false;
  Font.Size := 10;
  Ctl3D := False;
  //Tag := 9;
end;

procedure TWKEdit.Change;
begin
  inherited;
  DataChanged := True;
  if Trim(Text)='' then
  begin
    //Text := DefaultEmpty;
    SetCueBanner(Self,FPlaceHolder);
  end;

end;

procedure TWKEdit.DisplayPlaceHolder;
begin
  SetCueBanner(Self,PlaceHolder);
end;

procedure TWKEdit.DoEnter;
begin
  inherited;
  FOldBackColor := Color;
  Color := FColorEnter;
end;

Procedure TWKEdit.SetWarnaPerhatian;
begin
    FBackColorSebelumPerhatian := Color; //ini duluan
    Color := FWarnaPerhatian;            //baru ini
    FisPerhatianDipanggil := True;
end;


Procedure TWKEdit.KeyPress(Var Key : Char);
var
//   dst : string;
//   I,L,P: Integer;
   MYForm: TCustomForm;
begin
  inherited;

          if FTabOnEnter then
          begin
           if Key = #13 then
           begin
               MYForm := GetParentForm( Self );
               if not (MYForm = nil ) then
               begin
                  // SendMessage(MYForm.Handle, WM_NEXTDLGCTL, 0, 0);
                   PostMessage(MYForm.Handle, WM_NEXTDLGCTL, 0, 0);
                  // SendMessage(Self.Handle, WM_KEYDOWN, 0, 0);
               end;
               Key := #0;
           end;
         end else
         begin
           //hilangkan saja suara beepnya
           if Key = #13 then  Key :=#0; //hilangkan suara dink donk ketika tekan enter
         end;

         case FJenisInput of
         InpTeks: begin

                  end;
         InpBilGenap : begin
                    if not(key in['0'..'9',#8,'-',FormatSettings.ThousandSeparator]) then key := #0;
//
         end;
         InpUang : begin
                 if not(key in['0'..'9',#8,FormatSettings.ThousandSeparator,FormatSettings.DecimalSeparator]) then key := #0;
//
         end;

         InpBilDecimal: begin
                          if (key in['-']) then   //cek bila ada tanda negatif
                          begin
                            if (Pos('-',Text)=0) then //cek posisi tanda minus paling depan
                            begin
                              if not(key in['0'..'9',#8,'-',FormatSettings.DecimalSeparator]) then
                                 key := #0;
                            end else key :=#0;

                          end else
                          begin
                              if not(key in['0'..'9',#8,'-',FormatSettings.DecimalSeparator]) then
                              key := #0;
                          end;
                       end;

         InpFixedBilPositif: begin

                              if not(key in['0'..'9',#8,#13]) then
                              key := #0;

                       end;

         InpFixedBilPositifNegatif: begin
                          if (key in['-']) then   //cek bila ada tanda negatif
                          begin
                            if (Pos('-',Text)=0) then //cek posisi tanda minus paling depan
                            begin
                              if not(key in['0'..'9',#8,'-']) then
                                 key := #0;
                            end else key :=#0;

                          end else
                          begin
//                              if not CharInSet(Key,['0'..'9',#8,'-']) then

                              if not(key in['0'..'9',#8,'-']) then
                              key := #0;
                          end;
                       end;
       end;


end;




procedure TWKEdit.KeyUp(Var Key : Word; Shift:TshiftState);
var
    dst: string;
    I,L,P: Integer;
   MYForm: TCustomForm;
   CtlDirection: Word;

begin
    inherited;

   if (Key = VK_UP) or (Key = VK_DOWN) then
   begin
      if FForwardBackWardON = True then
      begin
        MYForm := GetParentForm( Self );
       if Key = VK_UP then CtlDirection := 1
       else CtlDirection :=0;
       if not (MYForm = nil ) then
           SendMessage(MYForm.Handle, WM_NEXTDLGCTL, CtlDirection, 0);
      end;
   end;



   if key = VK_RETURN then
   begin


     case JenisInput of
     InpBilGenap:
        begin
           if trim(Text)='' then exit;
           dst := HapusKarakter(Text,FormatSettings.ThousandSeparator);
           L := length(dst);
           if L <= 3 then exit;
           I := 3;
              while I < L do
              begin
                P := L - I;
                Insert(FormatSettings.ThousandSeparator,dst,P+1);
                I := I + 3;
              end;
           Text := dst;
        end;

        InpUang : begin
                    if trim(Text)='' then exit;
                    dst := HapusKarakter(Text,FormatSettings.ThousandSeparator);
                    Text :=FormatCurr('##,##',StrToCurr(dst));
         end;


    end;
   end;


end;

procedure TWKEdit.DoExit;
var

    dst: string;
    I,L,P: Integer;
begin
   inherited;

   Color := FOldBackColor;
   if FisPerhatianDipanggil then
   begin
     Color := FBackColorSebelumPerhatian;
     FisPerhatianDipanggil := False;
   end;


   case JenisInput of
     InpBilGenap:
        begin
           if trim(Text)='' then exit;
           dst := HapusKarakter(Text,FormatSettings.ThousandSeparator);
           L := length(dst);
           if L <= 3 then exit;
           I := 3;
              while I < L do
              begin
                P := L - I;
                Insert(FormatSettings.ThousandSeparator,dst,P+1);
                I := I + 3;
              end;
           Text := dst;
        end;
     InpUang :
        begin
         // if not(key in['0'..'9',#8,ThousandSeparator]) then key := #0;
          if trim(Text)='' then exit;
          dst := HapusKarakter(Text,FormatSettings.ThousandSeparator);
          Text := FormatCurr('###,###.####',StrToCurr(dst));
        end;
   end;

end;

function TWKEdit.HapusKarakter(aText :string; aKarakterDihapus :
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

procedure TWKEdit.KembalikanWarnaBackground;
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

procedure TWKEdit.SetAlignment(Const Value : TAlignment);
begin
   if FAlignment <> Value then
   begin
     FAlignment := Value;
     RecreateWnd;
   end;
end;

function TWKEdit.SetCueBanner(const Edit: TEdit; const Placeholder: String):
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


