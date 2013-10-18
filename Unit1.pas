unit Unit1;

{
Article:

Reading and manipulating XML files with Delphi

http://delphi.about.com/library/weekly/aa072903a.htm

Learn how to read and manipulate XML documents with Delphi using
the TXMLDocument component. Let's see how to extract the most
current "In The Spotlight" blog entries from the About Delphi Programming (this site).


..............................................
Zarko Gajic, BSCS
About Guide to Delphi Programming
http://delphi.about.com
email: delphi.guide@about.com
free newsletter: http://delphi.about.com/library/blnewsletter.htm
forum: http://forums.about.com/ab-delphi/start/
..............................................
}


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xmldom, XMLIntf,  XMLDoc, msxmldom, ComCtrls,
  StdCtrls, ExtCtrls, OleCtrls, SHDocVw, ActiveX, DB, DBClient, Grids, DBGrids,
  DBStatusBar, RXDBCtrl, DBCtrls, RXClock ;

type
  TFeeds = class(TForm)
    XMLDoc: TXMLDocument;
    Feeds: TClientDataSet;
    DsFeeds: TDataSource;
    lv: TListView;
    DBStatusBar1: TDBStatusBar;
    RxDBGrid1: TRxDBGrid;
    DBMemo1: TDBMemo;
    Panel1: TPanel;
    WebBrowser1: TWebBrowser;
    Panel2: TPanel;
    DBNavigator1: TDBNavigator;
    btnRefresh: TButton;
    DBText1: TDBText;
    Timer1: TTimer;
    Timer2: TTimer;
    procedure Memo1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
    procedure FeedsAfterScroll(DataSet: TDataSet);
    procedure RxClock1Alarm(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure CriaDataSet;
    function LoadFeeds(sUrl : String) : Boolean;
  end;

var
  Feeds: TFeeds;
  const
  ADPXMLBLOG = 'http://g1.globo.com/dynamo/brasil/rss2.xml';

implementation
{$R *.dfm}

uses ExtActns; //to be able to iuse TDownLoadURL


procedure TFeeds.btnRefreshClick(Sender: TObject);
begin
  LoadFeeds(ADPXMLBLOG);
end;

procedure TFeeds.CriaDataSet;
begin
  Feeds.Close;
  Feeds.FieldDefs.Clear;
  Feeds.FieldDefs.Add('idFeeds',ftInteger);
   Feeds.FieldDefs.Add('pubDate',ftString, 30);
  Feeds.FieldDefs.Add('category',ftString, 30);
  Feeds.FieldDefs.Add('title',ftString, 255);
  Feeds.FieldDefs.Add('link',ftString, 255);
  Feeds.FieldDefs.Add('description',ftString, 1024);

  with  Feeds do
  Begin
    CreateDataSet;

    FieldByName('idFeeds').DisplayLabel := 'ID Feeds';
    FieldByName('idFeeds').Alignment := taCenter;

    FieldByName('pubDate').DisplayLabel := 'Data Publicação';
    FieldByName('pubDate').Alignment := taCenter;

    FieldByName('category').DisplayLabel := 'Categoria';
    FieldByName('category').Alignment := taLeftJustify;

    FieldByName('title').DisplayLabel := 'Titulo';
    FieldByName('title').Alignment := taLeftJustify;

    FieldByName('link').DisplayLabel := 'Link';
    FieldByName('link').Alignment := taLeftJustify;


  End;
end;



procedure WBLoadHTML(WebBrowser: TWebBrowser; HTMLCode: string) ;
var
   sl: TStringList;
   ms: TMemoryStream;
begin
   WebBrowser.Navigate('about:blank') ;
   while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

   if Assigned(WebBrowser.Document) then
   begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
   end;
end;


function DownloadURLFile(const ADPXMLBLOG, ADPLocalFile : TFileName) : boolean;
begin
  Result:=True;

  with TDownLoadURL.Create(nil) do
  try
    URL:=ADPXMLBLOG;
    Filename:=ADPLocalFile;
    try
      ExecuteTarget(nil);
    except
      Result:=False;
    end;
  finally
    Free;
  end;
end;

procedure TFeeds.FeedsAfterScroll(DataSet: TDataSet);
begin
   WBLoadHTML(WebBrowser1,Feeds.FieldByName('description').AsString) ;
   Caption :=  'Feeds '+Feeds.FieldByName('category').AsString + ' -> '+Feeds.FieldByName('pubDate').AsString
end;

procedure TFeeds.FormCreate(Sender: TObject);
var
  sHTML : string;
begin
  sHTML := '<a>GOTO</a>' +
           '<b>About Delphi Programming</b>';
  WBLoadHTML(WebBrowser1,sHTML) ;
  CriaDataSet;

  btnRefresh.Click;
  Feeds.First;
end;

function TFeeds.LoadFeeds(sUrl: String): Boolean;

var
  ADPLocalFile : TFileName;

  StartItemNode : IXMLNode;
  ANode : IXMLNode;
  STitle, sDesc, sLink, sCategory, sPubDate : widestring;

  id : Integer;

begin
  id := 1;

  ADPLocalFile := IncludeTrailingPathDelimiter(ExtractFilePath(Application.ExeName)) + FormatDateTime('HH-MM-SS',Now)+'.xml';  //'temp.adpheadlines.xml';
  Screen.Cursor:=crHourglass;
  try
    if not DownloadURLFile(sUrl, ADPLocalFile)  then
    begin
      Screen.Cursor:=crDefault;
      Raise Exception.CreateFmt('Unable to connect to the Internet, make sure you are connected!',[]);
      Exit;
    end;

    if not FileExists(ADPLocalFile) then
    begin
      Screen.Cursor:=crDefault;
      raise exception.Create('Can''t locate the *headlines* file?!');
      Exit;
    end;

    lv.Clear;

    XMLDoc.FileName := ADPLocalFile;
    XMLDoc.Active:=True;


    StartItemNode:=XMLDoc.DocumentElement.ChildNodes.First.ChildNodes.FindNode('item');
    ANode := StartItemNode;




      // Limpamos todos os registro da tabela
    Feeds.DisableControls;
    Feeds.FieldDefs.Clear;
    Feeds.EmptyDataSet;
    repeat

      STitle := ANode.ChildNodes['title'].Text;
      sLink := ANode.ChildNodes['link'].Text;
      sDesc := ANode.ChildNodes['description'].Text;
      sCategory := ANode.ChildNodes['category'].Text;
      sPubDate := ANode.ChildNodes['pubDate'].Text;

      Feeds.Append; // Inserimos dados
      Feeds.FieldByName('idFeeds').AsInteger := id;
      Feeds.FieldByName('pubDate').AsString := sPubDate;
      Feeds.FieldByName('category').AsString := sCategory;
      Feeds.FieldByName('title').AsString := STitle;
      Feeds.FieldByName('link').AsString := sLink;
      Feeds.FieldByName('description').AsString := sDesc;

      Feeds.Post;
      inc(id);

      //add to list view
      with LV.Items.Add do
      begin
        Caption := STitle;
        SubItems.Add(sLink);
        SubItems.Add(sDesc);
        SubItems.Add(Scategory);
        SubItems.Add(spubDate);
      end;
      ANode := ANode.NextSibling;
    until ANode = nil;
    Feeds.Open;
    Feeds.EnableControls;

    WBLoadHTML(WebBrowser1,sDesc) ;
  finally
    DeleteFile(ADPLocalFile);
    Screen.Cursor:=crDefault;
    Feeds.First;
  end;

end;

procedure TFeeds.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
//   WBLoadHTML(WebBrowser1,lv.Items[Item.Index].Caption) ;

end;

procedure TFeeds.Memo1Click(Sender: TObject);
begin
  Beep;
end;






procedure TFeeds.RxClock1Alarm(Sender: TObject);
begin
  btnRefresh.Click;
end;

procedure TFeeds.Timer1Timer(Sender: TObject);
Begin
  LoadFeeds(ADPXMLBLOG);
end;

procedure TFeeds.Timer2Timer(Sender: TObject);
begin
   if Feeds.State = dsBrowse then
     Feeds.Locate('idFeeds',Random(40),[])
end;

end.
