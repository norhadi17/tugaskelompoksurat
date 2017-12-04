unit hadi2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, frxClass, frxPreview, frxDBSet, frxExportPDF, StdCtrls, ExtCtrls,ShellAPI;

type
  Tlelang2 = class(TForm)
    pnl1: TPanel;
    pnl2: TPanel;
    btn1: TButton;
    frxPDFExport1: TfrxPDFExport;
    frxrprt1: TfrxReport;
    frxdbdtst1: TfrxDBDataset;
    frxprvw1: TfrxPreview;
    procedure btn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frxrprt1BeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure DelFilesFrom(Directory, Filemask : string; DelSubDirs : Boolean);
function waktu: string;
  end;

var
  lelang2: Tlelang2;

implementation

uses
  Unit1, dm, hadi1;

{$R *.dfm}

procedure Tlelang2.btn1Click(Sender: TObject);
var namapdf:string;
var PDFku: TfrxCustomExportFilter;
lokasihapus : string;
begin
with DataModule1.z_hadi1 do
begin
    if asalScan = 0 then
  begin
  namapdf := lelang.Edt1.Text+'-'+lelang.Edt2.Text+'-'+waktu+ ' -Surat-lelang.pdf';
  PDFku := TfrxCustomExportFilter(frxPDFExport1);
  PDFku.ShowDialog := False;
  PDFku.FileName := ExtractFilePath(Application.ExeName)+'\jPDF\'+namapdf;
  frxrprt1.PrepareReport(false);
  frxrprt1.Export(PDFku);
  lelang.lbl5.Caption := namapdf;
  end;

  DataModule1.tabelhadi.Clear;
  lokasihapus := (ExtractFilePath(Application.ExeName)+'\Gambar_scan\');
  DelFilesFrom(lokasihapus, '*.*', False);
  namapdf := 'Surat Lelang'+lelang.Edt1.Text+lelang.Edt2.Text+'.pdf';
  DataModule1.z_hadi1.Active:=True;
  DataModule1.z_hadi1.Append;
  DataModule1.z_hadi1.FieldByName('nama_file').AsString := namapdf;
  DataModule1.z_hadi1.Post;
  lelang2.Close;
end;
end;
procedure Tlelang2.DelFilesFrom(Directory, Filemask: string;
  DelSubDirs: Boolean);
var Sourcelst : string;
  FOS : TSHFileOpStruct;
begin
  FillChar(FOS, SizeOf(FOS), 0);
  FOS.Wnd := Application.MainForm.Handle;
  FOS.wFunc := FO_DELETE;
  Sourcelst := Directory+'\'+Filemask+#0;
  FOS.pFrom := PChar(Sourcelst);
  if not DelSubDirs then
  FOS.fFlags := FOS.fFlags or FOF_FILESONLY;
  FOS.fFlags := FOS.fFlags or FOF_NOCONFIRMATION;
  SHFileOperation(FOS);
end;

function Tlelang2.waktu: string;
var tgl : TDateTime;
begin
 tgl :=now();
Result:= FormatDateTime('yyyy', tgl);
end;

procedure Tlelang2.FormShow(Sender: TObject);
begin
  frxrprt1.LoadFromFile(ExtractFilePath(Application.ExeName)+'PreviewScanPdfhadi.fr3');
  frxrprt1.FileName:=ExtractFilePath(Application.ExeName)+'PreviewScanPdfhadi.fr3';
  frxrprt1.ShowReport();
  end;

procedure Tlelang2.frxrprt1BeforePrint(Sender: TfrxReportComponent);
var img : TfrxComponent;
begin
  try
    img:=frxrprt1.FindObject('Picture1');
    TfrxPictureView(img).Picture.LoadFromFile(ExtractFilePath(Application.ExeName)+
    '\jGambar\'+DataModule1.tabelhadi.FieldValues['Image']);
    except
      ShowMessage('Objek Tidak DItemukan');
    end;
end;
end.
