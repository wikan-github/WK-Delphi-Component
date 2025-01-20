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
    destructor Destroy; override;
    { Private declarations }
  protected
    { Protected declarations }
  public
    AutoFreeTaggedObject: Boolean;
    constructor Create(AOwner: TComponent); override;

    //pisAutoFree akan otomatis free object yang di tag di constructor
    procedure setTagObject(pObject: TObject; pisAutoFree: Boolean);
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
   AutoFreeTaggedObject := False;
 // WordWrap := True;
  // TODO -cMM: TWKLabel.Create default body inserted
end;

destructor TWKLabel.Destroy;
begin
  inherited Destroy;
  if AutoFreeTaggedObject then begin
      if FTagObject <> nil then FreeAndNil(FTagObject);

  end;
end;

procedure TWKLabel.setTagObject(pObject: TObject; pisAutoFree: Boolean);
begin
   AutoFreeTaggedObject := pisAutoFree;
   TagObject := pObject;
end;

end.
