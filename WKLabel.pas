unit WKLabel;

interface

uses
  SysUtils,  Controls, StdCtrls, System.Classes;

type
  TWKLabel = class(TLabel)
  private
    FLicenseFeature: string;
    FTagObject: TObject;
    FPrimaryKey: String;
    { Private declarations }
  protected
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    Property PrimaryKey : String read FPrimaryKey write FPrimaryKey;
    property TagObject : TObject read FTagObject write FTagObject;
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKLabel]);
end;

constructor TWKLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
   AutoSize := True;
   Tag := 9;
 // WordWrap := True;
  // TODO -cMM: TWKLabel.Create default body inserted
end;

end.
