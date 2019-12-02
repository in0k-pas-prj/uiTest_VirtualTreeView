unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, VirtualTrees;

type

  { TForm1 }

  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    TrackBar1: TTrackBar;
    TrackBar2: TTrackBar;
    VirtualStringTree1: TVirtualStringTree;
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure VirtualStringTree1GetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: String);
    procedure VirtualStringTree1PaintBackground(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; const R: TRect; var Handled: Boolean);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PaintBox1Paint(Sender: TObject);
var r:tRect;
    t:tRect;
    p:tPoint;
    InternalPaintOptions:TVTInternalPaintOptions;
begin

    InternalPaintOptions:=[poBackground,poColumnColor,poGridLines];
    case ComboBox1.ItemIndex of
        0:exclude(InternalPaintOptions,poUnbuffered);
        1:Include(InternalPaintOptions,poUnbuffered);
    end;

//    VirtualStringTree1.ini tree


    P.x:=TrackBar2.Left+TrackBar2.Width+ComboBox1.Top;
    P.y:=TrackBar1.Top+TrackBar1.Height+ComboBox1.Top;
    //
    r:=rect(0,0,VirtualStringTree1.ClientWidth,VirtualStringTree1.top-P.y-ComboBox1.Top);
    r.Offset(TrackBar1.Position,TrackBar2.Position);


    VirtualStringTree1.RootNodeCount:=3;
//    r:=rect (0,8,300,195);





    //p:=point(18,20);
    //VirtualStringTree1.PaintTree(self.Canvas,r,p,[poUnbuffered,poBackground,poColumnColor,poGridLines]);
    VirtualStringTree1.PaintTree(self.Canvas,r,p,InternalPaintOptions);

    self.Canvas.Brush.Style:=bsClear;
    self.Canvas.Pen.Color:=clRED;
    self.Canvas.Pen.Style:=psDashDotDot;
    t:=r;
    t.SetLocation(p.X,p.Y);
    t.Inflate(1,1,1,1);
    self.Canvas.Rectangle(t);
{    self.Canvas.Pen.Color:=clRED;
    self.Canvas.Line(P.X,p.Y,P.X  ,p.y+5);
    self.Canvas.Line(P.X,p.Y,P.X+5,p.y);}

  {  p:=point(328,20);
    VirtualStringTree1.PaintTree(self.Canvas,r,p,[{poUnbuffered,}poBackground,poColumnColor,poGridLines]);

    self.Canvas.Brush.Style:=bsClear;
    self.Canvas.Pen.Color:=clMaroon;
    t:=r;
    t.SetLocation(p.X,p.Y);
    t.Inflate(1,1,1,1);
    self.Canvas.Rectangle(t);
    self.Canvas.Pen.Color:=clGreen;
    self.Canvas.Line(P.X,p.Y,P.X  ,p.y+5);
    self.Canvas.Line(P.X,p.Y,P.X+5,p.y);
   }

    t:=VirtualStringTree1.BoundsRect;
    t.Inflate(1,1,1,1);
    self.Canvas.Rectangle(t);

end;


procedure TForm1.ComboBox1Change(Sender: TObject);
begin
    self.Invalidate;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    CheckBox1Change(CheckBox1);
    CheckBox2Change(CheckBox2);
end;

procedure TForm1.CheckBox1Change(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions+[toShowBackground]
    else VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions-[toShowBackground];
    self.Invalidate;
end;

procedure TForm1.CheckBox2Change(Sender: TObject);
begin
    if TCheckBox(Sender).Checked
    then VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions+[toStaticBackground]
    else VirtualStringTree1.TreeOptions.PaintOptions:=VirtualStringTree1.TreeOptions.PaintOptions-[toStaticBackground];
    self.Invalidate;
end;

procedure TForm1.FormResize(Sender: TObject);
begin
    VirtualStringTree1.BorderSpacing.Left:=ComboBox1.Left;// AnchorSide[akRight].;
    VirtualStringTree1.BorderSpacing.Right:=ComboBox1.Left+1;// AnchorSide[akRight].;
    VirtualStringTree1.BorderSpacing.Bottom:=ComboBox1.Left;// AnchorSide[akRight].;
    VirtualStringTree1.TOP:=TrackBar1.Top+TrackBar1.Height + (height- TrackBar1.Top-TrackBar1.Height) div 2;
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
    CellText:=CellText+inttostr(node^.Index);
end;

procedure TForm1.VirtualStringTree1PaintBackground(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; const R: TRect; var Handled: Boolean);
begin

end;

end.

