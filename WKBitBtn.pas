unit WKBitBtn;

interface

uses
     Vcl.StdCtrls,Winapi.Windows, System.SysUtils, System.Classes, Vcl.Controls,Vcl.Buttons;

type
  TWKBitBtn = class(TBitBtn)
   private
    FLicenseFeature: string;
    { Private declarations }
    FMultiline: Boolean;
    function GetCaption: String;
    procedure SetCaption(const Value: String);
    procedure SetMultiline(const Value: Boolean);
  protected
    { Protected declarations }
     procedure CreateParams(var params: TCreateParams); override;

  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
  published
     property Multiline: Boolean
    	read FMultiline write SetMultiline default True;
    property Caption: String read GetCaption write SetCaption;
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKBitBtn]);
end;

constructor TWKBitBtn.Create(aOwner: TComponent);
begin
  inherited;
  FMultiline := True;
end;

procedure TWKBitBtn.CreateParams(var params: TCreateParams);
begin
  inherited;
  if FMultiline then
    params.Style := params.Style or BS_MULTILINE;
end;

function TWKBitBtn.GetCaption: String;
begin
  Result := Stringreplace( inherited Caption, #13, '|', [rfReplaceAll] );
end;

procedure TWKBitBtn.SetCaption(const Value: String);
begin
  if value <> Caption then
  begin
    inherited Caption := Stringreplace( value , '|', #13, [rfReplaceAll] );
    Invalidate;
  end;
end;

procedure TWKBitBtn.SetMultiline(const Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    RecreateWnd;
  end;
end;
end.
