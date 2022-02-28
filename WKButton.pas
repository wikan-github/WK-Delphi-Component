unit WKButton;

interface

uses
 Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
 Dialogs, StdCtrls;

type
  TWKButton = class(TButton)
  private
    { Private declarations }
    FMultiline: Boolean;
    FLicenseFeature: string;
    FTagObject: TObject;
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
    property TagObject : TObject read FTagObject write FTagObject;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKButton]);
end;

constructor TWKButton.Create(aOwner: TComponent);
begin
  inherited;
  FMultiline := True;
end;

procedure TWKButton.CreateParams(var params: TCreateParams);
begin
  inherited;
  if FMultiline then
    params.Style := params.Style or BS_MULTILINE;
end;

function TWKButton.GetCaption: String;
begin
  Result := Stringreplace( inherited Caption, #13, '|', [rfReplaceAll] );
end;

procedure TWKButton.SetCaption(const Value: String);
begin
  if value <> Caption then
  begin
    inherited Caption := Stringreplace( value , '|', #13, [rfReplaceAll] );
    Invalidate;
  end;
end;

procedure TWKButton.SetMultiline(const Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
    RecreateWnd;
  end;
end;
end.

