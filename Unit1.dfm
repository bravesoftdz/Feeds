object Feeds: TFeeds
  Left = 343
  Top = 350
  BorderWidth = 10
  Caption = 'Feeds'
  ClientHeight = 634
  ClientWidth = 857
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lv: TListView
    Left = 0
    Top = 591
    Width = 857
    Height = 24
    Align = alBottom
    Columns = <
      item
        Caption = 'Title'
        MinWidth = 150
        Width = 150
      end
      item
        Caption = 'URL'
        MinWidth = 85
        Width = 85
      end
      item
        Caption = 'Description'
        MinWidth = 150
        Width = 150
      end
      item
        Caption = 'Category'
        Width = 100
      end
      item
        Caption = 'PubDate'
        Width = 200
      end>
    ColumnClick = False
    FlatScrollBars = True
    HotTrackStyles = [htHandPoint, htUnderlineHot]
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    ViewStyle = vsReport
    Visible = False
    OnSelectItem = lvSelectItem
    ExplicitTop = 41
    ExplicitWidth = 864
  end
  object DBStatusBar1: TDBStatusBar
    Left = 0
    Top = 615
    Width = 857
    Height = 19
    Panels = <>
    DataSource = DsFeeds
    ExplicitLeft = 464
    ExplicitTop = 616
    ExplicitWidth = 0
  end
  object RxDBGrid1: TRxDBGrid
    Left = 0
    Top = 154
    Width = 857
    Height = 120
    Align = alTop
    BorderStyle = bsNone
    DataSource = DsFeeds
    DrawingStyle = gdsGradient
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
  end
  object DBMemo1: TDBMemo
    Left = 0
    Top = 65
    Width = 857
    Height = 89
    Align = alTop
    DataField = 'title'
    DataSource = DsFeeds
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Verdana'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    ExplicitLeft = 8
    ExplicitTop = 97
  end
  object Panel1: TPanel
    Left = 0
    Top = 274
    Width = 857
    Height = 317
    Align = alClient
    BorderWidth = 10
    Caption = 'Panel1'
    Enabled = False
    TabOrder = 4
    ExplicitLeft = 8
    ExplicitTop = 311
    ExplicitWidth = 825
    ExplicitHeight = 257
    object WebBrowser1: TWebBrowser
      Left = 11
      Top = 11
      Width = 835
      Height = 295
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 8
      ExplicitTop = 40
      ExplicitWidth = 689
      ExplicitHeight = 217
      ControlData = {
        4C000000364700006D1600000000000000000000000000000000000000000000
        000000004C000000000000000000000001000000E0D057007335CF11AE690800
        2B2E126208000000000000004C0000000114020000000000C000000000000046
        8000000000000000000000000000000000000000000000000000000000000000
        00000000000000000100000000000000000000000000000000000000}
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 857
    Height = 65
    Align = alTop
    BorderWidth = 5
    TabOrder = 5
    object DBText1: TDBText
      Left = 11
      Top = 17
      Width = 433
      Height = 42
      DataField = 'category'
      DataSource = DsFeeds
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -32
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object DBNavigator1: TDBNavigator
      Left = 543
      Top = 6
      Width = 224
      Height = 53
      DataSource = DsFeeds
      VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
      Align = alRight
      TabOrder = 0
      ExplicitLeft = 544
      ExplicitTop = 60
      ExplicitHeight = 30
    end
    object btnRefresh: TButton
      Left = 767
      Top = 6
      Width = 84
      Height = 53
      Align = alRight
      Caption = '&Refresh'
      TabOrder = 1
      OnClick = btnRefreshClick
      ExplicitLeft = 773
    end
  end
  object XMLDoc: TXMLDocument
    Left = 80
    Top = 96
    DOMVendorDesc = 'MSXML'
  end
  object Feeds: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterScroll = FeedsAfterScroll
    Left = 455
    Top = 409
  end
  object DsFeeds: TDataSource
    DataSet = Feeds
    Left = 496
    Top = 408
  end
  object Timer1: TTimer
    Interval = 28000
    OnTimer = Timer1Timer
    Left = 296
    Top = 8
  end
  object Timer2: TTimer
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 376
    Top = 8
  end
end
