unit Unit1;

{$mode objfpc}{$H+}

interface

uses  windows,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, VirtualTrees;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ComboBox1: TComboBox;
    PaintBox1: TPaintBox;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    TrackBar3: TTrackBar;
    TrackBar4: TTrackBar;
    VirtualStringTree1: TVirtualStringTree;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure CheckBox3Change(Sender: TObject);
    procedure CheckBox4Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure RadioButton1Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
  private
    function  _customPAINT_:tRect;
    function _customPAINT_1(const count:integer):QWord;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
    CheckBox1Change(CheckBox1);
    CheckBox2Change(CheckBox2);
    TrackBar3.Position:=3;
end;

procedure TForm1.FormPaint(Sender: TObject);
var r:tRect;
    t:tRect;
begin
    if CheckBox4.Checked then begin
        r:=_customPAINT_;
        //
        self.Canvas.Brush.Style:=bsClear;
        self.Canvas.Pen.Color:=clRED;
        self.Canvas.Pen.Style:=psDashDotDot;
        r.Inflate(1,1,1,1);
        self.Canvas.Rectangle(r);
    end;
    //
    if VirtualStringTree1.Visible then begin
        r:=VirtualStringTree1.BoundsRect;
        r.Inflate(1,1,1,1);
        self.Canvas.Rectangle(r);
    end;
end;

//------------------------------------------------------------------------------

function TForm1._customPAINT_:tRect;
var InternalPaintOptions:TVTInternalPaintOptions;
    p:tPoint;
begin
    InternalPaintOptions:=[poBackground,poColumnColor,poGridLines];
    case ComboBox1.ItemIndex of
        0:exclude(InternalPaintOptions,poUnbuffered);
        1:Include(InternalPaintOptions,poUnbuffered);
    end;
    //
    P.x:=TrackBar2.Left+TrackBar2.Width+ComboBox1.Top;
    P.y:=TrackBar1.Top+TrackBar1.Height+ComboBox1.Top;
    //
    result:=rect(0,0,VirtualStringTree1.ClientWidth,TrackBar4.top-P.y-ComboBox1.Top);
    result.Offset(TrackBar1.Position,TrackBar2.Position);
    //
    if CheckBox4.Checked
    then VirtualStringTree1.PaintTree(self.Canvas,result,p,InternalPaintOptions);
    //
    result.SetLocation(p.X,p.Y);
end;

function TForm1._customPAINT_1(const count:integer):QWord;
var InternalPaintOptions:TVTInternalPaintOptions;
    p:tPoint;
    r:tRect;
var Bitmap:TBitmap;
    i:integer;
begin
    InternalPaintOptions:=[poBackground,poColumnColor,poGridLines];
    case ComboBox1.ItemIndex of
        0:exclude(InternalPaintOptions,poUnbuffered);
        1:Include(InternalPaintOptions,poUnbuffered);
    end;
    //
    p:=point(0,0);
    r:=rect(0,0,VirtualStringTree1.ClientWidth,TrackBar4.top-P.y-ComboBox1.Top);
    //
    Bitmap:=TBitmap.Create;
    Bitmap.PixelFormat:=pf32bit;
    Bitmap.Width:=r.Width;
    Bitmap.Height:=r.Height;
    //
    result:=GetTickCount64;
    for i:=0 to count-1 do begin
        VirtualStringTree1.PaintTree(Bitmap.Canvas,r,p,InternalPaintOptions);
    end;
    result:=GetTickCount64-result;
    //
    BitBlt(PaintBox1.Canvas.Handle,0,0,r.Width,r.Height , Bitmap.Canvas.Handle,0,0,SRCCOPY);
    Bitmap.FREE;
end;


procedure TForm1.PaintBox1Paint(Sender: TObject);
var r:tRect;
    t:tRect;
begin
    if CheckBox4.Checked then begin
        r:=_customPAINT_;
        //
        PaintBox1.Canvas.Brush.Style:=bsClear;
        PaintBox1.Canvas.Pen.Color:=clRED;
        PaintBox1.Canvas.Pen.Style:=psDashDotDot;
        r.Inflate(1,1,1,1);
        PaintBox1.Canvas.Rectangle(r);
    end;
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
end;

procedure TForm1.TrackBar3Change(Sender: TObject);
begin
    VirtualStringTree1.RootNodeCount:=tTrackBar(Sender).Position;
end;

procedure TForm1.TrackBar4Change(Sender: TObject);
begin
 //   VirtualStringTree1.Header.Columns.Count:=6;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    self.Invalidate;
end;


procedure TForm1.CheckBox1Change(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions+[toShowBackground]
    else VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions-[toShowBackground];
    self.Invalidate;
end;

procedure TForm1.Button1Click(Sender: TObject);
var i:integer;
    t:QWord;
begin
    caption:='---';
    //
    t:=GetTickCount64;
    for i:=0 to 1000 do begin
       _customPAINT_;
    end;
    t:=GetTickCount64-t;
    //
    caption:='custom PAINT '+inttostr(t);
end;

procedure TForm1.Button2Click(Sender: TObject);
var i:integer;
    t:QWord;
begin
    caption:='---';
    //
    t:=GetTickCount64;
    for i:=0 to 1000 do begin
        VirtualStringTree1.Repaint;
    end;
    t:=GetTickCount64-t;
    //
    caption:='VirtualStringTree1.Repaint '+inttostr(t);
end;

procedure TForm1.Button3Click(Sender: TObject);
var t:QWord;
begin
    caption:='---';
    t:=_customPAINT_1(1000);
    caption:='Buffered.Repaint '+inttostr(t);
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions+[toStaticBackground]
    else VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions-[toStaticBackground];
    self.Invalidate;
end;

procedure TForm1.CheckBox3Change(Sender: TObject);
begin
    VirtualStringTree1.Visible:=TCheckBox(Sender).Checked;
end;

procedure TForm1.CheckBox4Change(Sender: TObject);
begin
    self.Invalidate;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
    VirtualStringTree1.DoubleBuffered:=TRUE;

    VirtualStringTree1.BorderSpacing.Top:=ComboBox1.Left;
    VirtualStringTree1.BorderSpacing.Left:=ComboBox1.Left;
    VirtualStringTree1.BorderSpacing.Right:=ComboBox1.Left+1;
    VirtualStringTree1.BorderSpacing.Bottom:=ComboBox1.Left;
    //
    TrackBar1.Min:=-VirtualStringTree1.RangeX-32;
    TrackBar1.Max:=+VirtualStringTree1.RangeX+32;
    TrackBar1.Position:=0;
    //
    TrackBar2.Min:=-VirtualStringTree1.ClientHeight-32;
    TrackBar2.Max:=+VirtualStringTree1.ClientHeight+32;
    TrackBar2.Position:=0;
end;

procedure TForm1.VirtualStringTree1GetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
begin
    CellText:=CellText+inttostr(Column)+' '+inttostr(node^.Index);
end;

end.

