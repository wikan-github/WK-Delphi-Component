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
    FSelectedRowColor: TColor;
    FFocusedCellColor: TColor;
    FHeaderHeight: Integer;
    FShowRowNumber: Boolean;
     procedure InitializeComponent;
     procedure SetLinesPerRow (Value: Integer);
    procedure SetHeaderHeight(const Value: Integer);
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
    property ColCount;
    property ColWidths;
    property ColAlignments;
    property CellAlignments;
//    property DefaultColWidth: Integer read FDefaultColWidth write SetDefaultColWidth default 64;
//    property DefaultColAlignment: TAlignment read FDefaultColAlignment write SetDefaultColAlignment default taLeftJustify;
//    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
//    property DefaultRowHeight: Integer read FDefaultRowHeight write SetDefaultRowHeight default 24;
//    property DrawingStyle: TGridDrawingStyle read FDrawingStyle write SetDrawingStyle default gdsThemed;
//    property EditorMode: Boolean read FEditorMode write SetEditorMode;
//    property FixedColor: TColor read FFixedColor write SetFixedColor default clBtnFace;
    property FixedCols;
    property FixedRows;
//    property GradientEndColor;
//    property GradientStartColor;
    property GridHeight;
    property GridLineWidth;
//    property GridWidth: Integer read GetGridWidth;
//    property HitTest: TPoint read FHitTest;
    property InplaceEditor;
    property LeftCol;
    property Row;
    property RowCount;

    property RowHeights;
//    property ScrollBars: System.UITypes.TScrollStyle read FScrollBars write SetScrollBars default ssBoth;
    property Selection;
//    property TabStops[Index: Longint]: Boolean read GetTabStops write SetTabStops;
    property TopRow;
    property VisibleColCount;
    property VisibleRowCount;
//    property OnFixedCellClick: TFixedCellClickEvent read FOnFixedCellClick write FOnFixedCellClick;
    (* redeclared property *)


    constructor Create (AOwner: TComponent); override;
    procedure MaximizeColumn(psColumName: String);
    procedure ColWidthsChanged; override; //redeclared parent methods
    procedure RowHeightsChanged; override; //redeclared parent methods
  published
     property SelectedRowColor : TColor read FSelectedRowColor write FSelectedRowColor; //bit yellow to orange;
     property FocusedCellColor : TColor read FFocusedCellColor write FFocusedCellColor;
     property LicenseFeature: string read FLicenseFeature write FLicenseFeature;
     property ShowMemoAsText : Boolean read FShowMemoAsText write FShowMemoAsText;
     property LinesPerRow: Integer read FLinesPerRow write SetLinesPerRow;

     //this will create row number at column index 0
     property ShowRowNumber: Boolean read FShowRowNumber write FShowRowNumber;
     property HeaderHeight: Integer read FHeaderHeight write SetHeaderHeight;
     property DefaultRowHeight;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKDBGrid]);
end;

{ TWKDBGrid }

procedure TWKDBGrid.ColWidthsChanged;
begin
  inherited ColWidthsChanged;
end;

constructor TWKDBGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  InitializeComponent;
end;

procedure TWKDBGrid.DrawColumnCell(const Rect: TRect; DataCol: Integer;
  Column: TColumn; State: TGridDrawState);
var
//  OutRect: TRect;
  F : TField;
  sTeks: string;
  lstate : TGridDrawState;
  oldbrush : TBrushStyle;
  cellColor : TColor;
  myRect : TRect;
  //clr : TColor;
begin
  myRect := Rect;
  //lstate := [gdSelected];
  lstate := [gdSelected,gdFocused,gdRowSelected];
  F := Column.Field;
 // lbrush := Canvas.Brush.Style;
 cellColor := $00FCBA61;
// clr := clBlue;

  if (gdFocused in State)  then
  begin
     //state ini akan kalah dengan gdSelected
     Self.Canvas.Brush.Color := FFocusedCellColor;
  end;
 if (gdSelected in State)  then
  begin
     //state ini aktif bila option dgRowselect = true
     Self.Canvas.Brush.Color := FSelectedRowColor;
  end else
  begin
     Self.Canvas.Brush.Color := cellColor;
  end;

  //pastikan bahwa colom pada dbgrid terhubung kedataset field
  //selalu cek bila field tidak nil
  if f <> nil then
  begin
      if FShowMemoAsText then
      begin
          if (f.DataType =  ftWideString) or
             (f.DataType = ftWideMemo) or
             (f.DataType =  ftMemo) then
          begin
            sTeks := f.AsString;
            //tambahkan margin kiri 3 pixel, margin atas 1px
            Canvas.TextRect(Rect,Rect.Left + 3,Rect.Top + 1,sTeks);
          end else
          begin
            Self.DefaultDrawColumnCell(Rect,DataCol,Column, State);
          end;
        end;
  end;

  if FShowRowNumber then
  if Column.Index = 0 then
  begin
    if self.DataSource.DataSet <> nil then
    if self.DataSource.DataSet.Active = true then
    begin
      sTeks := IntToStr(self.DataSource.DataSet.RecNo);
      Column.Alignment := TAlignment.taCenter;
//      Column.DisplayName := sTeks;
//      DrawText(Canvas.Handle, PChar(sTeks), Length(sTeks), Rect, DT_SINGLELINE or DT_RIGHT);
      //tambahkan margin kiri 3 pixel, margin atas 1px
//      Canvas.TextRect(Rect,Rect.Left + 3,Rect.Top + 1,sTeks);
      self.Canvas.TextRect(myRect, sTeks, [TTextFormats.tfCenter,TTextFormats.tfSingleLine]);
//      DrawText()
//      Canvas.te
    end;
  end;

//    if (gdSelected in State)  then
//    begin
//       Self.Canvas.Brush.Color := $004AE3F0;
//       Self.Canvas.Font.Color := clBlack;
//       Self.DefaultDrawColumnCell(Rect,DataCol,Column, State);
//    end;



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

procedure TWKDBGrid.InitializeComponent;
begin
  FLinesPerRow := 1;
  ShowMemoAsText := True;
  FSelectedRowColor := $004AE3F0; //bit yellow to orange
  FFocusedCellColor := clLime;
  FShowRowNumber := False;
  Options :=[
             dgTitles,
             dgTitleClick,
             dgColLines,
             dgRowLines,
             dgIndicator,
             dgColumnResize,
             dgRowSelect,
             dgAlwaysShowSelection,
             dgMultiSelect,
             dgTabs,
             dgCancelOnExit,
             dgConfirmDelete,
             dgTitleHotTrack
             ];
  Tag := 9;


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

    for i := 0 to Columns.Count -1 do
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

procedure TWKDBGrid.RowHeightsChanged;
begin
   inherited RowHeightsChanged;
end;

procedure TWKDBGrid.SetHeaderHeight(const Value: Integer);
begin
  FHeaderHeight := Value;
  Self.RowHeights[0] := Value;
  Self.RowHeightsChanged;
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
