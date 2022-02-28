unit WKProgressBar;

interface

uses
//  SysUtils,  Controls, ComCtrls, System.Classes;

      Vcl.ComCtrls, System.SysUtils, System.Classes, Vcl.Controls;

type
  TWKProgressBar = class(TProgressBar)
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
  RegisterComponents('WKComponent', [TWKProgressBar]);
end;

constructor TWKProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag := 9;
end;

end.
