unit WKProgressBar;

interface

uses
//  SysUtils,  Controls, ComCtrls, System.Classes;

      Vcl.ComCtrls, System.SysUtils, System.Classes, Vcl.Controls,WinAPI.Messages,Vcl.StdCtrls;

type
  TWKProgressBar = class(TProgressBar)
  private
    FLicenseFeature: string;
    FCaption: string;
    FLabel : TLabel;
    procedure createLabel;
    procedure setCaption(const Value: string);
    { Private declarations }
  protected
   procedure Resize; override;
   procedure WMPaint(var Message: TWMPaint); message WM_PAINT;
    { Protected declarations }
  public
    constructor Create(AOwner: TComponent); override;
    { Public declarations }
  published
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
    property Caption: string read FCaption write setCaption;
    property LabelText: Tlabel read FLabel;
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

//  Self.OnResize :=

  createLabel;
end;


procedure TWKProgressBar.createLabel;
begin
  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.AutoSize := False;
  FLabel.Transparent := True;
  FLabel.Top :=  0;
  FLabel.Left :=  0;
  FLabel.Width := self.Width;
  FLabel.Height := self.Height;
  FLabel.Alignment := taCenter;
  FLabel.Layout := tlCenter;
end;

procedure TWKProgressBar.Resize;
begin
  inherited;
  LabelText.Width := Self.Width;
  LabelText.Height := Self.Height;
end;

procedure TWKProgressBar.setCaption(const Value: string);
begin
  FCaption := Value;
  if FLabel <> nil then FLabel.Caption := FCaption;
end;

procedure TWKProgressBar.WMPaint(var Message: TWMPaint);
//var
//  DC: HDC;
//  prevfont: HGDIOBJ;
//  prevbkmode: Integer;
//  R: TRect;
begin
  inherited;
//  if Caption <> '' then
//  begin
//    R := ClientRect;
//    DC := GetWindowDC(Handle);
//    prevbkmode := SetBkMode(DC, TRANSPARENT);
//    prevfont := SelectObject(DC, Font.Handle);
//    DrawText(DC, PChar(Caption), Length(Caption),
//      R, DT_SINGLELINE or DT_CENTER or DT_VCENTER);
//    SelectObject(DC, prevfont);
//    SetBkMode(DC, prevbkmode);
//    ReleaseDC(Handle, DC);
//  end;

end;

end.
