unit WKPngSpeedButton;

interface

uses
  Windows, Classes, Buttons, pngimage, WKPngFunctions,Controls,
  Messages, SysUtils, Graphics,Forms,
  Dialogs, StdCtrls;

type
  TWKPngSpeedButton = class(TSpeedButton)
  private
    FPngImage: TPngImage;
    FPngOptions: TPngOptions;
    FImageFromAction: Boolean;
    FLicenseFeature: string;
    FMultiline: Boolean;
    function PngImageStored: Boolean;
    procedure SetPngImage(const Value: TPngImage);
    procedure SetPngOptions(const Value: TPngOptions);
    procedure CreatePngGlyph;
    procedure SetMultiline(const Value: Boolean);
    function GetCaption: String;
    procedure SetCaption(const Value: String);
  protected
    procedure ActionChange(Sender: TObject; CheckDefaults: Boolean); override;
    { Protected declarations }
    procedure CreateParams(var params: TCreateParams);
    procedure Paint; override;
    procedure Loaded; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property PngImage: TPngImage read FPngImage write SetPngImage stored PngImageStored;
    property PngOptions: TPngOptions read FPngOptions write SetPngOptions default [pngBlendOnDisabled];
    property Glyph stored False;
    property NumGlyphs stored False;
    property Multiline: Boolean read FMultiline write SetMultiline default True;
    property Caption: String read GetCaption write SetCaption;
    property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
  end;

procedure Register;
implementation

uses
  ActnList, WKPngButtonFunctions;

{ TWKPngSpeedButton }

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKPngSpeedButton]);
end;

constructor TWKPngSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPngImage := TPngImage.Create;
  FPngOptions := [pngBlendOnDisabled];
  FImageFromAction := False;
end;

destructor TWKPngSpeedButton.Destroy;
begin
  FPngImage.Free;
  inherited Destroy;
end;

function TWKPngSpeedButton.GetCaption: String;
begin
  Result := Stringreplace( inherited Caption, #13, '|', [rfReplaceAll] );
end;

procedure TWKPngSpeedButton.ActionChange(Sender: TObject; CheckDefaults: Boolean);
begin
  inherited ActionChange(Sender, CheckDefaults);
  if Sender is TCustomAction then
    with TCustomAction(Sender) do begin
      //Copy image from action's imagelist
      if (PngImage.Empty or FImageFromAction) and (ActionList <> nil) and
        (ActionList.Images <> nil) and (ImageIndex >= 0) and (ImageIndex <
        ActionList.Images.Count) then begin
        CopyImageFromImageList(FPngImage, ActionList.Images, ImageIndex);
        CreatePngGlyph;
        FImageFromAction := True;
      end;
    end;
end;

procedure TWKPngSpeedButton.CreateParams(var params: TCreateParams);
begin
  inherited;
  if FMultiline then
    params.Style := params.Style or BS_MULTILINE;
end;

procedure TWKPngSpeedButton.Paint;
var
  PaintRect: TRect;
  GlyphPos, TextPos: TPoint;
begin
  inherited Paint;

  if FPngImage <> nil then begin
    //Calculate the position of the PNG glyph
    CalcButtonLayout(Canvas, FPngImage, ClientRect, FState = bsDown, Down,
      Caption, Layout, Margin, Spacing, GlyphPos, TextPos, DrawTextBiDiModeFlags(0));
    PaintRect := Bounds(GlyphPos.X, GlyphPos.Y, FPngImage.Width, FPngImage.Height);

    if Enabled then
      DrawPNG(FPngImage, Canvas, PaintRect, [])
    else
      DrawPNG(FPngImage, Canvas, PaintRect, FPngOptions);
  end;
end;

procedure TWKPngSpeedButton.Loaded;
begin
  inherited Loaded;
  CreatePngGlyph;
end;

function TWKPngSpeedButton.PngImageStored: Boolean;
begin
  Result := not FImageFromAction;
end;

procedure TWKPngSpeedButton.SetCaption(const Value: String);
begin
  if value <> Caption then
  begin
    inherited Caption := Stringreplace( value , '|', #13, [rfReplaceAll] );
    Invalidate;
  end;
end;

procedure TWKPngSpeedButton.SetMultiline(const Value: Boolean);
begin
  if FMultiline <> Value then
  begin
    FMultiline := Value;
   // Controls.RecreateWnd;
  // if  <> 0 then Perform(CM_RECREATEWND, 0, 0);
  end;
end;

procedure TWKPngSpeedButton.SetPngImage(const Value: TPngImage);
begin
  //This is all neccesary, because you can't assign a nil to a TPngImage
  if Value = nil then begin
    FPngImage.Free;
    FPngImage := TPngImage.Create;
  end
  else
    FPngImage.Assign(Value);

  //To work around the gamma-problem
  with FPngImage do
    if Header.ColorType in [COLOR_RGB, COLOR_RGBALPHA, COLOR_PALETTE] then
      Chunks.RemoveChunk(Chunks.ItemFromClass(TChunkgAMA));

  FImageFromAction := False;
  CreatePngGlyph;
  Repaint;
end;

procedure TWKPngSpeedButton.SetPngOptions(const Value: TPngOptions);
begin
  if FPngOptions <> Value then begin
    FPngOptions := Value;
    CreatePngGlyph;
    Repaint;
  end;
end;

procedure TWKPngSpeedButton.CreatePngGlyph;
var
  Bmp: TBitmap;
begin
  //Create an empty glyph, just to align the text correctly
  Bmp := TBitmap.Create;
  try
    Bmp.Width := FPngImage.Width;
    Bmp.Height := FPngImage.Height;
    Bmp.Canvas.Brush.Color := clBtnFace;
    Bmp.Canvas.FillRect(Rect(0, 0, Bmp.Width, Bmp.Height));
    Glyph.Assign(Bmp);
    NumGlyphs := 1;
  finally
    Bmp.Free;
  end;
end;

end.
