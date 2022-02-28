unit WKDBGrid;

interface

uses
  SysUtils, Classes, Controls, Grids, DBGrids,Messages,Graphics,
  Dialogs,Forms,DB,Windows;

type
  TWKDBGrid = class(TDBGrid)
  private
     FLicenseFeature: string;
     FLinesPerRow: Integer;
    FShowMemoAsText: Boolean;
     procedure SetLinesPerRow (Value: Integer);
  protected
    { Protected declarations }
    procedure DrawColumnCell(const Rect: TRect; DataCol: Integer;
      Column: TColumn; State: TGridDrawState); override;
//    procedure DrawDataCell(Sender: TObject; const Rect: TRect; Field:
//    TField; State: TGridDrawState); override;
//    procedure DrawDataCell(const Rect: TRect; DataCol: Integer;
//      Column: TColumn; State: TGridDrawState); override;
    procedure  LayoutChanged; override;

  public
    { Public declarations }
    constructor Create (AOwner: TComponent); override;
     procedure MaximizeColumn(psColumName: String);
  published
     property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
     property ShowMemoAsText : Boolean read FShowMemoAsText write FShowMemoAsText;
     property LinesPerRow: Integer
      read FLinesPerRow write SetLinesPerRow default 1;

  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKDBGrid]);
end;

{ TWKDBGrid }

constructor TWKDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinesPerRow := 1;
  ShowMemoAsText := True;
  Options :=[dgTitles,dgIndicator,
             dgColumnResize,dgColLines,
             dgRowLines,dgTabs,dgRowSelect,
             dgAlwaysShowSelection,dgConfirmDelete,
             dgCancelOnExit,dgMultiSelect,
             dgTitleClick,dgTitleHotTrack];
  Tag := 9;
end;

procedure TWKDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
//  OutRect: TRect;
  F : TField;
  sTeks: string;
  lstate : TGridDrawState;
  oldbrush : TBrushStyle;
  //clr : TColor;
  //clr : TColor;
begin
  //lstate := [gdSelected];
   lstate := [gdSelected,gdFocused,gdRowSelected];
  F := Column.Field;
 // lbrush := Canvas.Brush.Style;
 //clr := Canvas.Brush.Color;

  if f <> nil then
  begin
    if (f.DataType =  ftWideString) or
       (f.DataType = ftWideMemo) or
       (f.DataType =  ftMemo) then
    begin
      if FShowMemoAsText then
      begin

          if (f.DataType =  ftWideString) or
             (f.DataType = ftWideMemo) or
             (f.DataType =  ftMemo) then
          begin
            if State <> [] then
            begin
              oldbrush := Canvas.Brush.Style;
              Canvas.Brush.Style := bsSolid;
            end;

             if (gdSelected in State)  then
              begin
                 Self.Canvas.Brush.Color := $004AE3F0;
                 Self.Canvas.Font.Color := clBlack;
              end
              else
              begin
                 Self.Canvas.Brush.Color := $00FCEBDC;
                 Self.Canvas.Font.Color := clBlack;
              end;
            Self.DefaultDrawColumnCell(Rect,DataCol,Column, State);

            sTeks := f.AsString;
            Canvas.TextRect(Rect,Rect.Left,Rect.Top,sTeks);




          end else
          begin
           // clr := Self.Canvas.Brush.Color;
          end;
        //end;
        end;

    end;
  end;





 { if FLinesPerRow = 1 then
    inherited DrawColumnCell(Rect, DataCol, Column, State)
  else
  begin
    // clear area
    Canvas.FillRect (Rect);
    // copy the rectangle
    OutRect := Rect;
    // restrict output
    InflateRect (OutRect, -2, -2);
    // output field data
    if Column.Field is TGraphicField then
    begin
      Bmp := Graphics.TBitmap.create;
      try
        Bmp.Assign (Column.Field);
        Canvas.StretchDraw (OutRect, Bmp);
      finally
        Bmp.Free;
      end;
    end
    else if (Column.Field is TMemoField) or
            (Column.Field is TWideStringField) or
            (Column.Field is TWideMemoField)
             then
    begin
      Canvas.TextOut(Rect.Left,Rect.Top,Column.Field.AsString);
//      DrawText (Canvas.Handle, PChar (Column.Field.AsString),
//        Length (Column.Field.AsString), OutRect, dt_WordBreak or dt_NoPrefix);
    end
    else // draw single line vertically centered
      DrawText (Canvas.Handle, PChar (Column.Field.DisplayText),
        Length (Column.Field.DisplayText), OutRect,
        dt_vcenter or dt_SingleLine or dt_NoPrefix);
  end;  }


end;

//procedure TWKDBGrid.DrawDataCell(Sender: TObject; const Rect: TRect;
//  Field: TField; State: TGridDrawState);
//begin
// // inherited;
//
//end;

//procedure TWKDBGrid.DrawDataCell(const Rect: TRect; DataCol: Integer;
//  Column: TColumn; State: TGridDrawState);
//var
//  Bmp: Graphics.TBitmap;
//  OutRect: TRect;
//  F : TField;
//  sTeks: string;
//begin
//  F := Column.Field;
//
//  if f <> nil then
//  begin
//    if (f.DataType =  ftWideString) or
//       (f.DataType = ftWideMemo) or
//       (f.DataType =  ftMemo) then
//    begin
//      sTeks := f.AsString;
//      Canvas.TextRect(Rect,Rect.Left,Rect.Top,sTeks);
//    end else
//    begin
//      inherited DrawColumnCell(Rect, DataCol, Column, State);
//    end;
//
//  end;
//
//
//end;

procedure TWKDBGrid.LayoutChanged;
//var  PixelsPerRow, PixelsTitle, I: Integer;
begin
  inherited LayOutChanged;
 { try
    Canvas.Font := Font;
    PixelsPerRow := Canvas.TextHeight('Wg') + 3;
    if dgRowLines in Options then
      Inc (PixelsPerRow, GridLineWidth);

    Canvas.Font := TitleFont;
    PixelsTitle := Canvas.TextHeight('Wg') + 4;
    if dgRowLines in Options then
      Inc (PixelsTitle, GridLineWidth);

    // set number of rows
    RowCount := 1 + (Height - PixelsTitle) div (PixelsPerRow * FLinesPerRow);

    // set the height of each row
    DefaultRowHeight := PixelsPerRow * FLinesPerRow;
    RowHeights [0] := PixelsTitle;
    for I := 1 to RowCount - 1 do
      RowHeights [I] := PixelsPerRow * FLinesPerRow;

    // send a WM_SIZE message to let the base component recompute
    // the visible rows in the private UpdateRowCount method
    PostMessage (Handle, WM_SIZE, 0, MakeLong(Width, Height));
  except on E: Exception do
  begin
    ShowMessage('Error pada procedure LayoutChanged : ' + E.Message );
  end;
  end;
   }
end;

procedure TWKDBGrid.MaximizeColumn(psColumName: String);
var
  i : integer;
  TotWidth : integer;
  VarWidth : integer;
  ResizableColumnCount : integer;
  AColumn : TColumn;
begin
  //total width of all columns before resize

    TotWidth := 0;
    //how to divide any extra space in the grid
    VarWidth := 0;
    //how many columns need to be auto-resized
    ResizableColumnCount := 0;

    for i := 0 to -1 + Columns.Count do
    begin
      TotWidth := TotWidth + Columns[i].Width;

      if LowerCase(Columns[i].Field.DisplayName) = LowerCase(psColumName) then
        Inc(ResizableColumnCount);
//      if Columns[i].Field.Tag <> 0 then
//        Inc(ResizableColumnCount);
    end;

    //add 1px for the column separator line
    if dgColLines in Options then
      TotWidth := TotWidth + Columns.Count;

    //add indicator column width
    if dgIndicator in Options then
      TotWidth := TotWidth + IndicatorWidth;

    //width vale "left"
    VarWidth :=  ClientWidth - TotWidth;

    //Equally distribute VarWidth
    //to all auto-resizable columns
    if ResizableColumnCount > 0 then
      VarWidth := varWidth div ResizableColumnCount;

    for i := 0 to -1 + Columns.Count do
    begin
      AColumn := Columns[i];

      if LowerCase(Columns[i].Field.DisplayName) = LowerCase(psColumName)  then
      begin
        AColumn.Width := AColumn.Width + VarWidth;
        if AColumn.Width < AColumn.Field.Tag then
          AColumn.Width := AColumn.Field.Tag;
      end;

//      if AColumn.Field.Tag <> 0 then
//      begin
//        AColumn.Width := AColumn.Width + VarWidth;
//        if AColumn.Width < AColumn.Field.Tag then
//          AColumn.Width := AColumn.Field.Tag;
//      end;
    end;

end;

procedure TWKDBGrid.SetLinesPerRow(Value: Integer);
begin
    if Value <> FLinesPerRow then
    begin
      FLinesPerRow := Value;
      LayoutChanged;
    end;

end;

end.
