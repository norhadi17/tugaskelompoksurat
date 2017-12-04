unit hadi1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DelphiTwain, DBCtrls, Grids, DBGrids, jpeg, ShellAPI;

type
  Tlelang = class(TForm)
    pnl1: TPanel;
    dbgrd1: TDBGrid;
    pnl2: TPanel;
    lbl1: TLabel;
    lbl2: TLabel;
    edt1: TEdit;
    edt2: TEdit;
    btn1: TButton;
    btn2: TButton;
    lbl3: TLabel;
    edt3: TEdit;
    btn3: TButton;
    DelphiTwain1: TDelphiTwain;
    lbl4: TLabel;
    img1: TImage;
    txt1: TStaticText;
    lbl5: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure DelphiTwain1TwainAcquire(Sender: TObject;
      const Index: Integer; Image: TBitmap; var Cancel: Boolean);
    procedure btn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function NamaGambar : string;
    { Public declarations }
  end;

var
  lelang: Tlelang;
  JPGku: TJPEGImage;
  asalScan: Integer;

implementation

uses
  dm, hadi2, Unit1;

{$R *.dfm}

procedure Tlelang.btn1Click(Sender: TObject);
var
  sourceIndex : Integer;
  source : TTwainSource;
begin
  with DataModule1.tabelhadi do
  begin
  DelphiTwain1.LibraryLoaded :=True;
  DelphiTwain1.SourceManagerLoaded :=True;
  sourceIndex := DelphiTwain1.SelectSource();

  if(sourceIndex <> -1) then
  begin
    source :=DelphiTwain1.Source[sourceIndex];
    source.Loaded := True;
    source.Enabled := True;
  end;
  end;
  end;

procedure Tlelang.btn2Click(Sender: TObject);
begin
lelang2.showmodal;
end;

procedure Tlelang.DelphiTwain1TwainAcquire(Sender: TObject;
  const Index: Integer; Image: TBitmap; var Cancel: Boolean);
var Lokasi, Gambar : string;
begin
  Img1.Picture.Assign(Image);
  Cancel := True;
  Gambar := NamaGambar;
  Lokasi := ExtractFilePath(Application.ExeName)+'\jGambar\';
  JPGku := TJPEGImage.Create;
  JPGku.Assign(Img1.Picture.Bitmap);
  JPGku.SaveToFile(Lokasi+Gambar);
  JPGku.Free;
  DataModule1.tabelhadi.Append;
  DataModule1.tabelhadi['Image'] := Gambar;
  DataModule1.tabelhadi.Post;
end;

function Tlelang.NamaGambar: string;
var
  tgl, bln, thn, konversi, nom : string;
begin
  konversi := DateToStr(Now);
  tgl := Copy(konversi,1,2);
  bln := Copy(konversi,4,2);
  thn := Copy(konversi,7,2);
  nom := IntToStr(DataModule1.tabelhadi.RecordCount);
  Result := 'IMG'+tgl+bln+thn+nom+'.jpeg';
end;

procedure Tlelang.btn3Click(Sender: TObject);
begin
if DataModule1.VirtualTable1.IsEmpty then
ShowMessage('Data Kosong') else
DataModule1.VirtualTable1.Delete;
end;

end.
