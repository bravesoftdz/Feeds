program ADPXMLBlog;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Feeds};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFeeds, Feeds);
  Application.Run;
end.
