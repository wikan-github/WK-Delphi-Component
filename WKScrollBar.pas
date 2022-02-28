unit WKScrollBar;

interface

uses
  SysUtils,  Controls, StdCtrls, System.Classes;

type
  TWKScrollBar = class(TScrollBar)
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
  RegisterComponents('WKComponent', [TWKScrollBar]);
end;

constructor TWKScrollBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag := 9;
end;

end.
