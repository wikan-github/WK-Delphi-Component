unit WKSpeedButton;

interface

uses
  SysUtils, Classes, Controls, Buttons;

type
  TWKSpeedButton = class(TSpeedButton)
  private
    FLicenseFeature: string;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKSpeedButton]);
end;

end.
