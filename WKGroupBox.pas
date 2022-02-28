unit WKGroupBox;

interface

uses
  SysUtils, Controls, StdCtrls, System.Classes;

type
  TWKGroupBox = class(TGroupBox)
  private
    FLicenseFeature: string;
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(aOwner: TComponent); override;
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKGroupBox]);
end;

constructor TWKGroupBox.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  Tag := 9;
end;

end.
