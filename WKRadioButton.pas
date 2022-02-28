unit WKRadioButton;

interface

uses

Vcl.StdCtrls,Vcl.Graphics, Winapi.Windows, Winapi.Messages, Vcl.Forms
,System.SysUtils, System.Classes, Vcl.Controls;

type
  TWKRadioButton = class(TRadioButton)
  private
    FLicenseFeature: string;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKRadioButton]);
end;

constructor TWKRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag := 9;
end;

end.
