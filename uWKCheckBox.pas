unit uWKCheckBox;

interface

uses
//  SysUtils,  Controls, StdCtrls, System.Classes;
  Vcl.StdCtrls, System.SysUtils, System.Classes, Vcl.Controls;

type
  TWKCheckBox = class(TCheckBox)
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
  RegisterComponents('WKComponent', [TWKCheckBox]);
end;

constructor TWKCheckBox.Create(aOwner: TComponent);
begin
  inherited;
end;

end.
