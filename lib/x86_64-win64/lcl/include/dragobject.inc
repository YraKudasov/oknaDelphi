{%MainUnit ../controls.pp}

{******************************************************************************
                                     TDragObject
 ******************************************************************************

 *****************************************************************************
  This file is part of the Lazarus Component Library (LCL)

  See the file COPYING.modifiedLGPL.txt, included in this distribution,
  for details about the license.
 *****************************************************************************
}

type

  { TDockImageWindow - used if widgetset supports hints with alphablend }

  TDockImageWindow = class(THintWindow)
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TDockImageWindow.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Color := clHighlight;
  Width := 100;
  Height := 100;
  AlphaBlend := True;
  AlphaBlendValue := 100;
end;

var
  DockImageWindow: TDockImageWindow;

procedure HintDockImage(Sender: TObject; AOldRect, ANewRect: TRect;
  AOperation: TDockImageOperation);
begin
  if DockImageWindow = nil then
    DockImageWindow := TDockImageWindow.Create(Application);
  DockImageWindow.BoundsRect := ANewRect;
  if AOperation = disShow then
    DockImageWindow.Show
  else if AOperation = disHide then
    DockImageWindow.Hide;
end;

{ TDragObject }

constructor TDragObject.Create(AControl : TControl);
begin
  FControl := AControl;
end;

constructor TDragObject.AutoCreate(AControl: TControl);
begin
  Create(AControl);
  FAutoCreated := True;
  FAutoFree := True;
end;

procedure TDragObject.EndDrag(Target: TObject; X, Y: Integer);
begin
  if FControl <> nil then
    FControl.DoEndDrag(Target, X, Y);
end;

function TDragObject.GetDragImages: TDragImageList;
begin
  Result := nil;
end;

function TDragObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  if Accepted then
    Result := crDrag
  else
    Result := crNoDrop;
end;

procedure TDragObject.HideDragImage;
begin
  if GetDragImages <> nil then
    GetDragImages.HideDragImage;
end;

procedure TDragObject.ShowDragImage;
begin
  if GetDragImages <> nil then
    GetDragImages.ShowDragImage;
end;

{ TDragObjectEx }

constructor TDragObjectEx.Create(AControl: TControl);
begin
  inherited Create(AControl);
  FAutoFree := True;
end;

{ TDragControlObject }

function TDragControlObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  if Accepted then
    Result := Control.DragCursor
  else
    Result := crNoDrop;
end;

function TDragControlObject.GetDragImages: TDragImageList;
begin
  Result := Control.GetDragImages;
end;

{ TDragControlObjectEx }

constructor TDragControlObjectEx.Create(AControl: TControl);
begin
  inherited Create(AControl);
  FAutoFree := True;
end;

{ TDragDockObject }

procedure TDragDockObject.AdjustDockRect(ARect: TRect);
begin
  with DockOffset do
    Types.OffsetRect(FDockRect, -X, -Y);
end;

function TDragDockObject.GetDragCursor(Accepted: Boolean; X, Y: Integer): TCursor;
begin
  Result := crDefault;
end;

procedure TDragDockObject.EndDrag(Target: TObject; X, Y: Integer);
begin
  if FControl <> nil then
    FControl.DoEndDock(Target, X, Y);
end;

procedure TDragDockObject.InitDock(APosition: TPoint);
begin
  // Determine hotspot scale for adjusting the undocked rectangle.
  // Since the undocked extent of the control doesn't change, we fix the hotspot offset.
  // Usage: OffsetRect(DockRect, FDockOffset);

  DragPos := APosition; //should have been done before
  Control.CalculateDockSizes;
  // mouse click offset from control TopLeft in screen coordinates
  with FDockRect do
  begin
    TopLeft := Control.ClientToScreen(Point(0, 0));
    Right := Left + Control.Width;
    Bottom := Top + Control.Height;
  end;
  if Control.Width > 0 then
    FDockOffset.x := Round((APosition.x - FDockRect.Left) / Control.Width * Control.UndockWidth)
  else
    FDockOffset.X := 0;
  if Control.Height > 0 then
    FDockOffset.Y := Round((APosition.y - FDockRect.Top) / Control.Height * Control.UndockHeight)
  else
    FDockOffset.Y := 0;
  FEraseDockRect := Rect(MaxInt, 0, MaxInt, 0);
end;

procedure TDragDockObject.ShowDockImage;
begin
  if HasOnDrawImage then
    OnDrawDockImage(Self, EraseDockRect, DockRect, disShow)
  else
    WidgetSet.DrawDefaultDockImage(EraseDockRect, DockRect, disShow);
  EraseDockRect := DockRect;
end;

procedure TDragDockObject.HideDockImage;
begin
  if FEraseDockRect.Left<MaxInt then
    if HasOnDrawImage then
      OnDrawDockImage(Self, EraseDockRect, DockRect, disHide)
    else
      WidgetSet.DrawDefaultDockImage(EraseDockRect, DockRect, disHide);
  FEraseDockRect := Rect(MaxInt, 0, MaxInt, 0);
end;

procedure TDragDockObject.MoveDockImage;
begin
  //Draw the form outlines when the position has changed
  if not CompareRect(@DockRect, @EraseDockRect) then
  begin
    if HasOnDrawImage then
      OnDrawDockImage(Self, EraseDockRect, DockRect, disMove)
    else
      WidgetSet.DrawDefaultDockImage(EraseDockRect, DockRect, disMove);
    EraseDockRect := DockRect;
  end;
end;

function TDragDockObject.HasOnDrawImage: boolean;
begin
  if Assigned(OnDrawDockImage) then
    exit(true);
  if WidgetSet.GetSystemMetrics(SM_LCLHasFormAlphaBlend)=0 then
    exit(false);
  OnDrawDockImage := @HintDockImage;
  Result:=true;
end;

{ TDragDockObjectEx }

constructor TDragDockObjectEx.Create(AControl: TControl);
begin
  inherited Create(AControl);
  FAutoFree := True;
end;

// included by controls.pp
