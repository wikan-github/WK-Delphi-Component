unit WKPanel;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls,Vcl.ExtCtrls;

type
  TWKPanel = class(TPanel)
  private
    FLicenseFeature: string;
    FTagObject: TObject;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    property TagObject : TObject read FTagObject write FTagObject;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKPanel]);
end;

{ TWKPanel }

constructor TWKPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Tag := 9;
end;

end.
