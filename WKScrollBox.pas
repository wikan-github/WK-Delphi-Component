unit WKScrollBox;

interface

uses
  SysUtils,  Controls, Forms, System.Classes;

type
  TWKScrollBox = class(TScrollBox)
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
  RegisterComponents('WKComponent', [TWKScrollBox]);
end;

constructor TWKScrollBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag := 9;
end;

end.
