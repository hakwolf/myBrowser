// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright ?2018 Salvador Diaz Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit uMiniBrowser;

{$I cef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Menus,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, System.Types, Vcl.ComCtrls, Vcl.ClipBrd,
  System.UITypes, Vcl.AppEvnts, Winapi.ActiveX, Winapi.ShlObj,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Menus,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Types, ComCtrls, ClipBrd, AppEvnts, ActiveX, ShlObj,
  {$ENDIF}
  uCEFChromium, uCEFWindowParent, uCEFInterfaces, uCEFApplication, uCEFTypes, uCEFConstants,ufmchrom,System.NetEncoding,
  System.ImageList, Vcl.ImgList, Vcl.Buttons, uCEFWinControl;

const
  CEFBROWSER_DESTROYWNDPARENT = WM_APP + $100;
  CEFBROWSER_DESTROYTAB       = WM_APP + $101;
  CEFBROWSER_INITIALIZED      = WM_APP + $102;
  CEFBROWSER_CHECKTAGGEDTABS  = WM_APP + $103;


  MINIBROWSER_SHOWDEVTOOLS    = WM_APP + $121;
  MINIBROWSER_HIDEDEVTOOLS    = WM_APP + $122;

  MINIBROWSER_COPYHTML        = WM_APP + $123;
  MINIBROWSER_SHOWRESPONSE    = WM_APP + $104;
  MINIBROWSER_COPYFRAMEIDS    = WM_APP + $105;
  MINIBROWSER_COPYFRAMENAMES  = WM_APP + $106;
  MINIBROWSER_SAVEPREFERENCES = WM_APP + $107;
  MINIBROWSER_COPYALLTEXT     = WM_APP + $108;
  MINIBROWSER_TAKESNAPSHOT    = WM_APP + $109;

  MINIBROWSER_HOMEPAGE = '';  //MINIBROWSER_HOMEPAGE = 'https://www.baidu.com';

  MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS    = MENU_ID_USER_FIRST + 1;
  MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS    = MENU_ID_USER_FIRST + 2;
  MINIBROWSER_CONTEXTMENU_COPYHTML        = MENU_ID_USER_FIRST + 3;
  MINIBROWSER_CONTEXTMENU_JSWRITEDOC      = MENU_ID_USER_FIRST + 4;
  MINIBROWSER_CONTEXTMENU_JSPRINTDOC      = MENU_ID_USER_FIRST + 5;
  MINIBROWSER_CONTEXTMENU_SHOWRESPONSE    = MENU_ID_USER_FIRST + 6;
  MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS    = MENU_ID_USER_FIRST + 7;
  MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES  = MENU_ID_USER_FIRST + 8;
  MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES = MENU_ID_USER_FIRST + 9;
  MINIBROWSER_CONTEXTMENU_COPYALLTEXT     = MENU_ID_USER_FIRST + 10;
  MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT    = MENU_ID_USER_FIRST + 11;

type
  TMainForm = class(TForm)
    NavControlPnl22: TPanel;
    CEFWindowParent1: TCEFWindowParent;
    Chromium1: TChromium;
    DevTools: TCEFWindowParent;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    ConfigPnl: TPanel;
    ConfigBtn: TButton;
    PopupMenu1: TPopupMenu;
    DevTools1: TMenuItem;
    N1: TMenuItem;
    Preferences1: TMenuItem;
    N2: TMenuItem;
    PrintinPDF1: TMenuItem;
    Print1: TMenuItem;
    N3: TMenuItem;
    Zoom1: TMenuItem;
    Inczoom1: TMenuItem;
    Deczoom1: TMenuItem;
    Resetzoom1: TMenuItem;
    SaveDialog1: TSaveDialog;
    ApplicationEvents1: TApplicationEvents;
    OpenDialog1: TOpenDialog;
    N4: TMenuItem;
    Openfile1: TMenuItem;
    Resolvehost1: TMenuItem;
    Timer1: TTimer;
    OpenfilewithaDAT1: TMenuItem;
    PageControl1: TPageControl;
    ImageListMain: TImageList;
    procedure FormShow(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure Chromium1AfterCreated(Sender: TObject;
      const browser: ICefBrowser);
   function  GetPageIndex(const aSender : TObject; var aPageIndex : integer) : boolean;
    procedure Chromium1LoadingStateChange(Sender: TObject;
      const browser: ICefBrowser; isLoading, canGoBack,
      canGoForward: Boolean);
    procedure Chromium1TitleChange(Sender: TObject;
      const browser: ICefBrowser; const title: ustring);
    procedure Chromium1AddressChange(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const url: ustring);
    procedure Chromium1BeforeContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel);
    procedure Chromium1StatusMessage(Sender: TObject;
      const browser: ICefBrowser; const value: ustring);
    procedure Chromium1TextResultAvailable(Sender: TObject;
      const aText: ustring);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure DevTools1Click(Sender: TObject);
    procedure Preferences1Click(Sender: TObject);
    procedure ConfigBtnClick(Sender: TObject);
    procedure PrintinPDF1Click(Sender: TObject);
    procedure Print1Click(Sender: TObject);
    procedure Inczoom1Click(Sender: TObject);
    procedure Deczoom1Click(Sender: TObject);
    procedure Resetzoom1Click(Sender: TObject);
    procedure Chromium1FullScreenModeChange(Sender: TObject;
      const browser: ICefBrowser; fullscreen: Boolean);
    procedure Chromium1PreKeyEvent(Sender: TObject;
      const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
      out isKeyboardShortcut, Result: Boolean);
    procedure Chromium1KeyEvent(Sender: TObject;
      const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
      out Result: Boolean);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure Openfile1Click(Sender: TObject);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1PdfPrintFinished(Sender: TObject;
      aResultOK: Boolean);
    procedure Chromium1ResourceResponse(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const response: ICefResponse;
      out Result: Boolean);
    procedure Resolvehost1Click(Sender: TObject);
    procedure Chromium1ResolvedHostAvailable(Sender: TObject;
      result: Integer; const resolvedIps: TStrings);
    procedure Timer1Timer(Sender: TObject);
    procedure Chromium1PrefsAvailable(Sender: TObject; aResultOK: Boolean);
    procedure Chromium1BeforeDownload(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const suggestedName: ustring;
      const callback: ICefBeforeDownloadCallback);
    procedure Chromium1DownloadUpdated(Sender: TObject;
      const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
      const callback: ICefDownloadItemCallback);
    procedure FormCreate(Sender: TObject);
    procedure Chromium1BeforeResourceLoad(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; const callback: ICefRequestCallback;
      out Result: TCefReturnValue);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure CloseAllBrowsers;
    procedure Chromium1BeforeClose(Sender: TObject;
      const browser: ICefBrowser);
    procedure Chromium1RenderCompMsg(var aMessage : TMessage; var aHandled: Boolean);
    procedure Chromium1LoadingProgressChange(Sender: TObject;
      const browser: ICefBrowser; const progress: Double);
    procedure OpenfilewithaDAT1Click(Sender: TObject);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure AddTabBtnClick(Sender: TObject);
    procedure RemoveTabBtnClick(Sender: TObject);
   function CreateClientHandler(var windowInfo: TCefWindowInfo;
  var client: ICefClient; const targetFrameName: string;
  const popupFeatures: TCefPopupFeatures;const targetUrl:string): boolean;
    procedure PageControl1Change(Sender: TObject);
    procedure URLCbxKeyPress(Sender: TObject; var Key: Char);
    procedure Chromium1BeforePopup(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; const targetUrl, targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      const popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var extra_info: ICefDictionaryValue; var noJavascriptAccess,
      Result: Boolean);
    procedure Chromium1Close(Sender: TObject; const browser: ICefBrowser;
      var aAction: TCefCloseBrowserAction);

  protected

    // Variables to control when can we destroy the form safely

    //FCanClose : boolean;  // Set to True in TChromium.OnBeforeClose   //modfy by qjh
  //  FClosing  : boolean;  // Set to True in the CloseQuery event.     //modfy by qjhC

    procedure AddURL(const aURL : string);

    procedure ShowDevTools(aPoint : TPoint); overload;
    procedure ShowDevTools; overload;
    procedure HideDevTools;


        procedure InspectRequest(const aRequest : ICefRequest);
           procedure InspectResponse(const aResponse : ICefResponse);



    procedure BrowserCreatedMsg(var aMessage : TMessage); message CEF_AFTERCREATED;   //modfy 1个消息

                                                                                      ///add 4个消息
    procedure BrowserDestroyWindowParentMsg(var aMessage : TMessage); message CEFBROWSER_DESTROYWNDPARENT;
    procedure BrowserDestroyTabMsg(var aMessage : TMessage); message CEFBROWSER_DESTROYTAB;
    procedure BrowserCheckTaggedTabsMsg(var aMessage : TMessage); message CEFBROWSER_CHECKTAGGEDTABS;
    procedure CEFInitializedMsg(var aMessage : TMessage); message CEFBROWSER_INITIALIZED;

    procedure ShowDevToolsMsg(var aMessage : TMessage); message MINIBROWSER_SHOWDEVTOOLS;
    procedure HideDevToolsMsg(var aMessage : TMessage); message MINIBROWSER_HIDEDEVTOOLS;
    procedure CopyAllTextMsg(var aMessage : TMessage); message MINIBROWSER_COPYALLTEXT;
    procedure CopyHTMLMsg(var aMessage : TMessage); message MINIBROWSER_COPYHTML;
    procedure CopyFramesIDsMsg(var aMessage : TMessage); message MINIBROWSER_COPYFRAMEIDS;
    procedure CopyFramesNamesMsg(var aMessage : TMessage); message MINIBROWSER_COPYFRAMENAMES;
    procedure ShowResponseMsg(var aMessage : TMessage); message MINIBROWSER_SHOWRESPONSE;////
    procedure SavePreferencesMsg(var aMessage : TMessage); message MINIBROWSER_SAVEPREFERENCES;
    procedure TakeSnapshotMsg(var aMessage : TMessage); message MINIBROWSER_TAKESNAPSHOT;
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;

  // function  SearchChromium(aPageIndex : integer; var aChromium : TChromium) : boolean;
    function SearchChromium(aPageIndex: integer;
  var TempfmChrom: TfmChrom): boolean;
   function  SearchWindowParent(aPageIndex : integer; var aWindowParent : TCEFWindowParent) : boolean;

   function AllTabSheetsAreTagged : boolean;

  public

     FClosingTab : boolean;   //
    FCanClose   : boolean;
    FClosing    : boolean;

    procedure ShowStatusText(const aText : string);

    procedure HandleKeyUp(const aMsg : TMsg; var aHandled : boolean);
    procedure HandleKeyDown(const aMsg : TMsg; var aHandled : boolean);




  end;

var
  MainForm : TMainForm;
  curChrom :TfmChrom;
  FBtnAddTab : TSpeedButton;

implementation

{$R *.dfm}

uses
  {$IFDEF DELPHI16_UP}
  System.Math,
  {$ELSE}
  Math,
  {$ENDIF}
  uPreferences, uCefStringMultimap, uCEFMiscFunctions, uSimpleTextViewer;

// Destruction steps
// =================
// 1. FormCloseQuery sets CanClose to FALSE calls TChromium.CloseBrowser which triggers the TChromium.OnClose event.
// 2. TChromium.OnClose sends a CEFBROWSER_DESTROY message to destroy CEFWindowParent1 in the main thread, which triggers the TChromium.OnBeforeClose event.
// 3. TChromium.OnBeforeClose sets FCanClose := True and sends WM_CLOSE to the form.

procedure TMainForm.BackBtnClick(Sender: TObject);
begin
 // curchrom.GoBack;
end;

procedure TMainForm.RemoveTabBtnClick(Sender: TObject);
var
  TempfmChrom : TfmChrom;
  curi :integer;
begin
  if SearchChromium(PageControl1.TabIndex, TempfmChrom) then
    begin
      curi := PageControl1.TabIndex;
      outputdebugstring('remove SearchChromium true');
      FClosingTab          := True;
     // PageControl1.Enabled := False;

      TempfmChrom.Chromium1.CloseBrowser(True);   //这一句好像没有进入Chromium1的事件，及窗体的事件
     // PageControl1.Pages[curi].Free;        //正常添加删除的这两句就够用了，上句没有进去子窗体的事件 里面就不会执行事件的内容


     // PageControl1.ActivePage
     // PageControl1.ActivePageIndex :=  curi -1;
     // SearchChromium(PageControl1.TabIndex, TempChromium);
     // curChrom :=  TempChromium;

    end;
end;

procedure TMainForm.Resetzoom1Click(Sender: TObject);
begin
  Chromium1.ResetZoomStep;
end;

procedure TMainForm.Resolvehost1Click(Sender: TObject);
var
  TempURL : string;
begin
  TempURL := inputbox('Resolve host', 'URL :', 'http://baidu.com');
  if (length(TempURL) > 0) then Chromium1.ResolveHost(TempURL);
end;

procedure TMainForm.CEFInitializedMsg(var aMessage: TMessage);
begin

      Caption           := '绿芯';    //'Tab Browser';
      cursor            := crDefault;
      if (PageControl1.PageCount = 0) then AddTabBtnClick(self);
end;

procedure TMainForm.Chromium1AddressChange(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring);
var
  TempPageIndex : integer;
begin
  if not(FClosing) and
     (PageControl1.TabIndex >= 0) and
     GetPageIndex(Sender, TempPageIndex) and
     (PageControl1.TabIndex = TempPageIndex) then
 //   URLCbx.Text := url;

  //if Chromium1.IsSameBrowser(browser) then AddURL(url);
end;

procedure TMainForm.Chromium1AfterCreated(Sender: TObject; const browser: ICefBrowser);
var
  TempPageIndex : integer;
begin
  if GetPageIndex(Sender, TempPageIndex) then
    PostMessage(Handle, CEF_AFTERCREATED, 0, TempPageIndex);

 {  if Chromium1.IsSameBrowser(browser) then
    PostMessage(Handle, CEF_AFTERCREATED, 0, 0)
   else
    SendMessage(browser.Host.WindowHandle, WM_SETICON, 1, application.Icon.Handle); // Use the same icon in the popup window }

end;

function TMainForm.GetPageIndex(const aSender : TObject; var aPageIndex : integer) : boolean;
begin
  Result     := False;
  aPageIndex := -1;

  if (aSender <> nil) and
     (aSender is TComponent) and
     (TComponent(aSender).Owner <> nil) and
     (TComponent(aSender).Owner is TTabSheet) then
    begin
      aPageIndex := TTabSheet(TComponent(aSender).Owner).PageIndex;
      Result     := True;
    end;
end;

procedure TMainForm.Chromium1BeforeClose(Sender: TObject; const browser: ICefBrowser);
var
  TempPageIndex : integer;
begin
  if GetPageIndex(Sender, TempPageIndex) then
    begin
      if FClosing then
        PostMessage(Handle, CEFBROWSER_CHECKTAGGEDTABS, 0, TempPageIndex)
       else
        PostMessage(Handle, CEFBROWSER_DESTROYTAB, 0, TempPageIndex);
    end;

 { if (Chromium1.BrowserId = 0) then // The main browser is being destroyed
    begin
      FCanClose := True;
      PostMessage(Handle, WM_CLOSE, 0, 0);
    end;   }
end;

procedure TMainForm.Chromium1BeforeContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel);
begin
 // if not(Chromium1.IsSameBrowser(browser)) then exit;

  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT,    'Take snapshot...');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYALLTEXT,     'Copy displayed text to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYHTML,        'Copy HTML to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS,    'Copy HTML frame identifiers to clipboard');
  model.AddItem(MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES,  'Copy HTML frame names to clipboard');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES, 'Save preferences as...');
  model.AddSeparator;
  model.AddItem(MINIBROWSER_CONTEXTMENU_JSWRITEDOC,      'Modify HTML document');
  model.AddItem(MINIBROWSER_CONTEXTMENU_JSPRINTDOC,      'Print using Javascript');
  model.AddItem(MINIBROWSER_CONTEXTMENU_SHOWRESPONSE,    'Show server headers');

  if DevTools.Visible then
    model.AddItem(MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS, 'Hide DevTools')
   else
    model.AddItem(MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS, 'Show DevTools');
end;

function PathToMyDocuments : string;
var
  Allocator : IMalloc;
  Path      : pchar;
  idList    : PItemIDList;
begin
  Result   := '';
  Path     := nil;
  idList   := nil;

  try
    if (SHGetMalloc(Allocator) = S_OK) then
      begin
        GetMem(Path, MAX_PATH);
        if (SHGetSpecialFolderLocation(0, CSIDL_PERSONAL, idList) = S_OK) and
           SHGetPathFromIDList(idList, Path) then
          Result := string(Path);
      end;
  finally
    if (Path   <> nil) then FreeMem(Path);
    if (idList <> nil) then Allocator.Free(idList);
  end;
end;

procedure TMainForm.Chromium1BeforeDownload(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const suggestedName: ustring;
  const callback: ICefBeforeDownloadCallback);
var
  TempMyDocuments, TempFullPath, TempName : string;
begin
  if not(Chromium1.IsSameBrowser(browser)) or
     (downloadItem = nil) or
     not(downloadItem.IsValid) then
    exit;

  TempMyDocuments := PathToMyDocuments;

  if (length(suggestedName) > 0) then
    TempName := suggestedName
   else
    TempName := 'DownloadedFile';

  if (length(TempMyDocuments) > 0) then
    TempFullPath := IncludeTrailingPathDelimiter(TempMyDocuments) + TempName
   else
    TempFullPath := TempName;

  callback.cont(TempFullPath, False);
end;



procedure TMainForm.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var extra_info: ICefDictionaryValue;
  var noJavascriptAccess, Result: Boolean);  //modf by qjh 2019 prameter change

begin   //如果这个事情什么都不写就会跟 minibrowser一样会弹出所有的窗体 allow all; block
 // Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
    //参考popu
  case targetDisposition of
    WOD_NEW_FOREGROUND_TAB,
    WOD_NEW_BACKGROUND_TAB,
    WOD_NEW_WINDOW :
    begin
    // Result := True;  // For simplicity, this demo blocks new tabs and new windows.
    // Result := not (CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures,targetUrl));
     Result :=  not (CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures,targetUrl));
    end;

    WOD_NEW_POPUP :
    begin
     //Result := not(TMainForm(Owner).CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures));
    end

    else Result := False;
  end;
end;


{procedure TMainForm.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; const popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess, Result: Boolean);
begin   //如果这个事情什么都不写就会跟 minibrowser一样会弹出所有的窗体 allow all; block
 // Result := (targetDisposition in [WOD_NEW_FOREGROUND_TAB, WOD_NEW_BACKGROUND_TAB, WOD_NEW_POPUP, WOD_NEW_WINDOW]);
    //参考popu
  case targetDisposition of
    WOD_NEW_FOREGROUND_TAB,
    WOD_NEW_BACKGROUND_TAB,
    WOD_NEW_WINDOW :
    begin
    // Result := True;  // For simplicity, this demo blocks new tabs and new windows.
    // Result := not (CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures,targetUrl));
     Result :=  (CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures,targetUrl));
    end;

    WOD_NEW_POPUP :
    begin
     //Result := not(TMainForm(Owner).CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures));
    end

    else Result := False;
  end;
end; }

function TMainForm.CreateClientHandler(var windowInfo: TCefWindowInfo;
  var client: ICefClient; const targetFrameName: string;
  const popupFeatures: TCefPopupFeatures;const targetUrl:string): boolean;
var
  TempSheet        : TTabSheet;
  TempRect : TRect;
  FPopupFeatures     : TCefPopupFeatures;
  fmChrom :TfmChrom;
  intbeg,intend :integer;
  strtemp :string;
  cururl :string;
  CloseButton : TSpeedButton;
  Rect: TRect;
    VisiblePageIndex :integer;
  i :integer;
begin


  // self.Chromium1.OnAddressChange := nil;
  PageControl1.Enabled := False;

  TempSheet             := TTabSheet.Create(PageControl1);
  TempSheet.Caption     := '新标签页';
  TempSheet.PageControl := PageControl1;

 { TempWindowParent        := TCEFWindowParent.Create(TempSheet);
  TempWindowParent.Parent := TempSheet;
  TempWindowParent.Color  := clWhite;
  TempWindowParent.Align  := alClient;

  TempChromium                 := TChromium.Create(TempSheet);
  TempChromium.OnAfterCreated  := Chromium1AfterCreated;     //   Chromium_OnAfterCreated
  TempChromium.OnAddressChange := Chromium1AddressChange;//Chromium_OnAddressChange;
  TempChromium.OnTitleChange   := Chromium1TitleChange;//Chromium_OnTitleChange;
  TempChromium.OnClose         := Chromium1Close;//Chromium_OnClose;
  TempChromium.OnBeforeClose   := Chromium1BeforeClose;//Chromium_OnBeforeClose;
  TempChromium.OnBeforePopup   := Chromium1BeforePopup;//Chromium_OnBeforePopup;

  TempChromium.OnBeforeContextMenu  := Chromium1BeforeContextMenu; }

 // TempChromium.CreateBrowser(TempWindowParent, ''); //这里不能要，不然下面创建会失败的
 // curChrom := TempChromium;

     fmChrom := TfmChrom.Create(TempSheet);

  fmChrom.Parent := TempSheet;
  fmChrom.Show;
  {if pos('?k=',targetUrl) > 0 then     //用不上
  begin
     intbeg := pos('?',targetUrl);
   intend := pos('&&',targetUrl);
   strtemp := copy(targetUrl,intbeg+1,intend- intbeg-1);
   strtemp :=  stringreplace(strtemp,'key=','',[]);
   cururl := TNetEncoding.URL.URLDecode(strtemp);
   fmChrom.openurl := cururl;
  end else begin

  end; }
  fmChrom.openurl := targetUrl;
  fmChrom.Chromium1.CreateBrowser(fmChrom.CEFWindowParent1, '');     //www.baidu.com

  PageControl1.ActivePageIndex :=  PageControl1.PageCount -1;
  CloseButton := TSpeedButton.Create(TempSheet);
  CloseButton.Parent := PageControl1;
  CloseButton.Width := 16;
  CloseButton.Height := 16;
  CloseButton.Flat := True;
  ImageLisTMain.GetBitmap(134, CloseButton.Glyph);
  // CloseButton.OnMouseDown := CloseButtonOnMouseDown;
  // CloseButton.OnMouseUp := CloseButtonOnMouseUp;
  Rect := PageControl1.TabRect(PageControl1.ActivePageIndex);
  CloseButton.Top := Rect.Top + 2;
  CloseButton.Left := Rect.Right - 19;
  CloseButton.OnClick := RemoveTabBtnClick;

     VisiblePageIndex := PageControl1.PageCount-1;
  for i:=0 to PageControl1.PageCount-1 do begin
    if not PageControl1.Pages[i].TabVisible then
      Dec(VisiblePageIndex);
  end;
  Rect := PageControl1.TabRect(VisiblePageIndex);
  FBtnAddTab.Top := Rect.Top;
  FBtnAddTab.Left := Rect.Right + 5;

  Result := false;//fmChrom.CreateClientHandler(windowInfo, client, targetFrameName, popupFeatures,targetUrl);
end;


procedure TMainForm.Chromium1BeforeResourceLoad(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const callback: ICefRequestCallback;
  out Result: TCefReturnValue);
begin
  Result := RV_CONTINUE;

  if Chromium1.IsSameBrowser(browser) and
     (frame <> nil) and
     frame.IsMain then
    InspectRequest(request);
end;

{procedure TMainForm.Chromium1Close(Sender: TObject; const browser: ICefBrowser; out Result: Boolean);
var
  TempPageIndex : integer;
begin
  if GetPageIndex(Sender, TempPageIndex) then
    PostMessage(Handle, CEFBROWSER_DESTROYWNDPARENT, 0, TempPageIndex);

  Result := true;         //modfy by 2018/11/19  Result := False;   }

  {if (browser <> nil) and (Chromium1.BrowserId = browser.Identifier) then
    begin
      PostMessage(Handle, CEF_DESTROY, 0, 0);
      Result := True;
    end
   else
    Result := False; }
//end;


procedure TMainForm.Chromium1Close(Sender: TObject; const browser: ICefBrowser;
  var aAction: TCefCloseBrowserAction);
var
  TempPageIndex : integer;
begin
  if GetPageIndex(Sender, TempPageIndex) then
    PostMessage(Handle, CEFBROWSER_DESTROYWNDPARENT, 0, TempPageIndex);

  //Result := true;         //modfy by 2018/11/19  Result := False;   }
   aAction := cbaClose     //2019/07/28 Result modfy action
                          //TCefCloseBrowserAction = (cbaClose, cbaDelay, cbaCancel);


  {if (browser <> nil) and (Chromium1.BrowserId = browser.Identifier) then
    begin
      PostMessage(Handle, CEF_DESTROY, 0, 0);
      Result := True;
    end
   else
    Result := False; }
end;

procedure TMainForm.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
var
  TempParam : WParam;
begin
  Result := False;

  if not(Chromium1.IsSameBrowser(browser)) then exit;

  case commandId of
    MINIBROWSER_CONTEXTMENU_HIDEDEVTOOLS :
      PostMessage(Handle, MINIBROWSER_HIDEDEVTOOLS, 0, 0);

    MINIBROWSER_CONTEXTMENU_SHOWDEVTOOLS :
      begin
        TempParam := ((params.XCoord and $FFFF) shl 16) or (params.YCoord and $FFFF);
        PostMessage(Handle, MINIBROWSER_SHOWDEVTOOLS, TempParam, 0);
      end;

    MINIBROWSER_CONTEXTMENU_COPYALLTEXT :
      PostMessage(Handle, MINIBROWSER_COPYALLTEXT, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYHTML :
      PostMessage(Handle, MINIBROWSER_COPYHTML, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYFRAMEIDS :
      PostMessage(Handle, MINIBROWSER_COPYFRAMEIDS, 0, 0);

    MINIBROWSER_CONTEXTMENU_COPYFRAMENAMES :
      PostMessage(Handle, MINIBROWSER_COPYFRAMENAMES, 0, 0);

    MINIBROWSER_CONTEXTMENU_SHOWRESPONSE :
      PostMessage(Handle, MINIBROWSER_SHOWRESPONSE, 0, 0);

    MINIBROWSER_CONTEXTMENU_SAVEPREFERENCES :
      PostMessage(Handle, MINIBROWSER_SAVEPREFERENCES, 0, 0);

    MINIBROWSER_CONTEXTMENU_TAKESNAPSHOT :
      PostMessage(Handle, MINIBROWSER_TAKESNAPSHOT, 0, 0);

    MINIBROWSER_CONTEXTMENU_JSWRITEDOC :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript(
          'var css = ' + chr(39) + '@page {size: A4; margin: 0;} @media print {html, body {width: 210mm; height: 297mm;}}' + chr(39) + '; ' +
          'var style = document.createElement(' + chr(39) + 'style' + chr(39) + '); ' +
          'style.type = ' + chr(39) + 'text/css' + chr(39) + '; ' +
          'style.appendChild(document.createTextNode(css)); ' +
          'document.head.appendChild(style);',
          'about:blank', 0);

    MINIBROWSER_CONTEXTMENU_JSPRINTDOC :
      if (browser <> nil) and (browser.MainFrame <> nil) then
        browser.MainFrame.ExecuteJavaScript('window.print();', 'about:blank', 0);
  end;
end;

procedure TMainForm.Chromium1DownloadUpdated(Sender: TObject;
  const browser: ICefBrowser; const downloadItem: ICefDownloadItem;
  const callback: ICefDownloadItemCallback);
var
  TempString : string;
begin
  if not(Chromium1.IsSameBrowser(browser)) then exit;

  if downloadItem.IsComplete then
    ShowStatusText(downloadItem.FullPath + ' completed')
   else
    if downloadItem.IsCanceled then
      ShowStatusText(downloadItem.FullPath + ' canceled')
     else
      if downloadItem.IsInProgress then
        begin
          if (downloadItem.PercentComplete >= 0) then
            TempString := downloadItem.FullPath + ' : ' + inttostr(downloadItem.PercentComplete) + '%'
           else
            TempString := downloadItem.FullPath + ' : ' + inttostr(downloadItem.ReceivedBytes) + ' bytes received';

          ShowStatusText(TempString);
        end;
end;

procedure TMainForm.Chromium1FullScreenModeChange(Sender: TObject;
  const browser: ICefBrowser; fullscreen: Boolean);
begin                    
  if not(Chromium1.IsSameBrowser(browser)) then exit;

  // This event is executed in a CEF thread and this can cause problems when
  // you change the 'Enabled' and 'Visible' properties from VCL components.
  // It's recommended to change the 'Enabled' and 'Visible' properties
  // in the main application thread and not in a CEF thread.
  // It's much safer to use PostMessage to send a message to the main form with
  // all this information and update those properties in the procedure handling
  // that message.

  if fullscreen then
    begin
      StatusBar1.Visible    := False;

      if (WindowState = wsMaximized) then WindowState := wsNormal;

      BorderIcons := [];
      BorderStyle := bsNone;
      WindowState := wsMaximized;
    end
   else
    begin
      BorderIcons := [biSystemMenu, biMinimize, biMaximize];
      BorderStyle := bsSizeable;
      WindowState := wsNormal;

      StatusBar1.Visible    := True;
    end;
end;

procedure TMainForm.Chromium1KeyEvent(Sender: TObject;
  const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
  out Result: Boolean);
var
  TempMsg : TMsg;
begin
  Result := False;

  if not(Chromium1.IsSameBrowser(browser)) then exit;

  if (event <> nil) and (osEvent <> nil) then
    case osEvent.Message of
      WM_KEYUP :
        begin
          TempMsg := osEvent^;

          HandleKeyUp(TempMsg, Result);
        end;

      WM_KEYDOWN :
        begin
          TempMsg := osEvent^;

          HandleKeyDown(TempMsg, Result);
        end;
    end;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
begin
  case Msg.message of
    WM_KEYUP   : HandleKeyUp(Msg, Handled);
    WM_KEYDOWN : HandleKeyDown(Msg, Handled);
  end;
end;

procedure TMainForm.HandleKeyUp(const aMsg : TMsg; var aHandled : boolean);
var
  TempMessage : TMessage;
  TempKeyMsg  : TWMKey;
begin
  TempMessage.Msg     := aMsg.message;
  TempMessage.wParam  := aMsg.wParam;
  TempMessage.lParam  := aMsg.lParam;
  TempKeyMsg          := TWMKey(TempMessage);

  if (TempKeyMsg.CharCode = VK_F12) then
    begin
      aHandled := True;

      if DevTools.Visible then
        PostMessage(Handle, MINIBROWSER_HIDEDEVTOOLS, 0, 0)
       else
        PostMessage(Handle, MINIBROWSER_SHOWDEVTOOLS, 0, 0);
    end;
end;

procedure TMainForm.HandleKeyDown(const aMsg : TMsg; var aHandled : boolean);
var
  TempMessage : TMessage;
  TempKeyMsg  : TWMKey;
begin
  TempMessage.Msg     := aMsg.message;
  TempMessage.wParam  := aMsg.wParam;
  TempMessage.lParam  := aMsg.lParam;
  TempKeyMsg          := TWMKey(TempMessage);

  if (TempKeyMsg.CharCode = VK_F12) then aHandled := True;
end;

procedure TMainForm.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  httpStatusCode: Integer);
begin
  if frame.IsMain then
    StatusBar1.Panels[1].Text := 'main frame loaded : ' + quotedstr(frame.name)
   else
    StatusBar1.Panels[1].Text := 'frame loaded : ' + quotedstr(frame.name);
end;

procedure TMainForm.Chromium1LoadingProgressChange(Sender: TObject;
  const browser: ICefBrowser; const progress: Double);
begin
  StatusBar1.Panels[0].Text := 'Loading... ' + FloatToStrF(progress * 100, ffFixed, 3, 0) + '%';
end;

procedure TMainForm.Chromium1LoadingStateChange(Sender: TObject;
  const browser: ICefBrowser; isLoading, canGoBack, canGoForward: Boolean);
begin
  if not(Chromium1.IsSameBrowser(browser)) or FClosing then exit;

  // This event is executed in a CEF thread and this can cause problems when
  // you change the 'Enabled' and 'Visible' properties from VCL components.
  // It's recommended to change the 'Enabled' and 'Visible' properties
  // in the main application thread and not in a CEF thread.
  // It's much safer to use PostMessage to send a message to the main form with
  // all this information and update those properties in the procedure handling
  // that message.


  if isLoading then
    begin
      StatusBar1.Panels[0].Text := 'Loading...';

    end
   else
    begin
      StatusBar1.Panels[0].Text := 'Finished';
    end;
end;

procedure TMainForm.Chromium1PdfPrintFinished(Sender: TObject; aResultOK: Boolean);
begin
  if aResultOK then
    showmessage('The PDF file was generated successfully')
   else
    showmessage('There was a problem generating the PDF file.');
end;

procedure TMainForm.Chromium1PrefsAvailable(Sender: TObject; aResultOK: Boolean);
begin
  if aResultOK then
    showmessage('The preferences file was generated successfully')
   else
    showmessage('There was a problem generating the preferences file.');
end;

procedure TMainForm.Chromium1PreKeyEvent(Sender: TObject;
  const browser: ICefBrowser; const event: PCefKeyEvent; osEvent: PMsg;
  out isKeyboardShortcut, Result: Boolean);
begin
  Result := False;

  if Chromium1.IsSameBrowser(browser) and
     (event <> nil) and
     (event.kind in [KEYEVENT_KEYDOWN, KEYEVENT_KEYUP]) and
     (event.windows_key_code = VK_F12) then
    isKeyboardShortcut := True;
end;

procedure TMainForm.Chromium1RenderCompMsg(var aMessage : TMessage; var aHandled: Boolean);
begin
  if not(FClosing) and (aMessage.Msg = WM_MOUSEMOVE) then
    begin
      StatusBar1.Panels[2].Text := 'x : ' + inttostr(aMessage.lParam and $FFFF);
      StatusBar1.Panels[3].Text := 'y : ' + inttostr((aMessage.lParam and $FFFF0000) shr 16);
    end;
end;

procedure TMainForm.Chromium1ResolvedHostAvailable(Sender: TObject;
  result: Integer; const resolvedIps: TStrings);
begin
  if (result = ERR_NONE) then
    showmessage('Resolved IPs : ' + resolvedIps.CommaText)
   else
    showmessage('There was a problem resolving the host.' + CRLF +
                'Error code : ' + inttostr(result));
end;

procedure TMainForm.InspectRequest(const aRequest : ICefRequest);
var
  TempHeaderMap : ICefStringMultimap;
  i, j : integer;
begin
  if (aRequest <> nil) then
    begin
    //  FRequest.Clear;

      TempHeaderMap := TCefStringMultimapOwn.Create;
      aRequest.GetHeaderMap(TempHeaderMap);

      i := 0;
      j := TempHeaderMap.Size;

      while (i < j) do
        begin
          //FRequest.Add(TempHeaderMap.Key[i] + '=' + TempHeaderMap.Value[i]);
          inc(i);
        end;
    end;
end;

procedure TMainForm.InspectResponse(const aResponse : ICefResponse);
var
  TempHeaderMap : ICefStringMultimap;
  i, j : integer;
begin
  if (aResponse <> nil) then
    begin
      //FResponse.Clear;

      TempHeaderMap := TCefStringMultimapOwn.Create;
      aResponse.GetHeaderMap(TempHeaderMap);

      i := 0;
      j := TempHeaderMap.Size;

      while (i < j) do
        begin
         // FResponse.Add(TempHeaderMap.Key[i] + '=' + TempHeaderMap.Value[i]);
          inc(i);
        end;
    end;
end;

procedure TMainForm.Chromium1ResourceResponse(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const request: ICefRequest; const response: ICefResponse;
  out Result: Boolean);
begin
  Result := False;

  if Chromium1.IsSameBrowser(browser) and
     (frame <> nil) and
     frame.IsMain then
    InspectResponse(response);
end;

procedure TMainForm.ShowStatusText(const aText : string);
begin
  if not(FClosing) then StatusBar1.Panels[1].Text := aText;
end;

procedure TMainForm.Chromium1StatusMessage(Sender: TObject;
  const browser: ICefBrowser; const value: ustring);
begin
  if Chromium1.IsSameBrowser(browser) then ShowStatusText(value);
end;

procedure TMainForm.Chromium1TextResultAvailable(Sender: TObject; const aText: ustring);
begin
  clipboard.AsText := aText;
end;

procedure TMainForm.Chromium1TitleChange(Sender: TObject;
  const browser: ICefBrowser; const title: ustring);
var
  TempPageIndex : integer;
begin
  if not(FClosing) and GetPageIndex(Sender, TempPageIndex) then
    PageControl1.Pages[TempPageIndex].Caption := title;
  {if not(Chromium1.IsSameBrowser(browser)) then exit;

  if (title <> '') then
    caption := '绿芯 - ' + title
   else
    caption := '绿芯';     }
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  //if FClosingTab then
  //  CanClose := False
 //  else
    begin
      CanClose := FCanClose;

      if not(FClosing) then
        begin
          FClosing := True;
          Visible  := False;

          CloseAllBrowsers;
        end;
    end;

     { CanClose := FCanClose;     //mdfy by qjh

  if not(FClosing) then
    begin
      FClosing := True;
      Visible  := False;
      Chromium1.CloseBrowser(True);
    end;   }
end;

procedure TMainForm.CloseAllBrowsers;
var
  i, j, k : integer;
  TempComponent : TComponent;
  TempSheet : TTabSheet;
  TempCtnue : boolean;
  TempfmChrom : TfmChrom;
begin
  k := PageControl1.PageCount;

  while (k > 0) do
    begin
     // TempSheet := PageControl1.Pages[k];

        if SearchChromium(k-1, TempfmChrom) then
      begin
       // curi := PageControl1.TabIndex;
        outputdebugstring('remove SearchChromium true');
        FClosingTab          := True;
       // PageControl1.Enabled := False;

        TempfmChrom.Chromium1.CloseBrowser(True);   //这一句好像没有进入Chromium1的事件，及窗体的事件
       // PageControl1.Pages[curi].Free;        //正常添加删除的这两句就够用了，上句没有进去子窗体的事件 里面就不会执行事件的内容


       // PageControl1.ActivePage
       // PageControl1.ActivePageIndex :=  curi -1;
       // SearchChromium(PageControl1.TabIndex, TempChromium);
       // curChrom :=  TempChromium;

      end;


    {  TempCtnue := True;
      i         := 0;
      j         := TempSheet.ComponentCount;

      while (i < j) and TempCtnue do
        begin
          TempComponent := TempSheet.Components[i];

          if (TempComponent <> nil) and (TempComponent is TChromium) then
            begin
              TChromium(TempComponent).CloseBrowser(True);
              TempCtnue := False;
            end
           else
            inc(i);
        end;  }

      dec(k);
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //FCanClose := False;       // modfy by qjh
 // FClosing  := False;       // modfy by qjh

  FClosingTab := False;
  FCanClose   := False;
  FClosing    := False;

  //FBtnAddTab.Hint := actNewQueryTab.Hint;
  //FBtnAddTab.OnClick := actNewQueryTab.OnExecute;


end;

procedure TMainForm.FormShow(Sender: TObject);
var
  VisiblePageIndex :integer;
  i :integer;
    Rect: TRect;
begin
  ShowStatusText('Initializing browser. Please wait...');

  // WebRTC's IP leaking can lowered/avoided by setting these preferences
  // To test this go to https://www.browserleaks.com/webrtc
  Chromium1.WebRTCIPHandlingPolicy := hpDisableNonProxiedUDP;
  Chromium1.WebRTCMultipleRoutes   := STATE_DISABLED;
  Chromium1.WebRTCNonproxiedUDP    := STATE_DISABLED;

  // GlobalCEFApp.GlobalContextInitialized has to be TRUE before creating any browser
  // If it's not initialized yet, we use a simple timer to create the browser later.


 /// if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) then Timer1.Enabled := True;  //modfy by qjh



  FBtnAddTab := TSpeedButton.Create(PageControl1);
  FBtnAddTab.Parent := PageControl1;
  ImageLisTMain.GetBitmap(132,FBtnAddTab.Glyph);
  FBtnAddTab.Height := PageControl1.TabRect(0).Bottom - PageControl1.TabRect(0).Top - 2;
  FBtnAddTab.Width := FBtnAddTab.Height;
  FBtnAddTab.Flat := True;

  FBtnAddTab.OnClick := AddTabBtnClick;


   if (GlobalCEFApp <> nil) and
     GlobalCEFApp.GlobalContextInitialized  then
    begin
      Caption           := '绿芯';
      cursor            := crDefault;
      if (PageControl1.PageCount = 0) then AddTabBtnClick(self);
    end;

 {  VisiblePageIndex := PageControl1.PageCount-1;
  for i:=0 to PageControl1.PageCount-1 do begin
    if not PageControl1.Pages[i].TabVisible then
      Dec(VisiblePageIndex);
  end;
  Rect := PageControl1.TabRect(VisiblePageIndex);
  FBtnAddTab.Top := Rect.Top;
  FBtnAddTab.Left := Rect.Right + 5;  }




end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(Chromium1.CreateBrowser(CEFWindowParent1, '')) and not(Chromium1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TMainForm.URLCbxKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in [#13] then
  begin

  end;

end;

procedure TMainForm.BrowserCheckTaggedTabsMsg(var aMessage: TMessage);
begin
  if (aMessage.lParam >= 0) and
     (aMessage.lParam < PageControl1.PageCount) then
    begin
      PageControl1.Pages[aMessage.lParam].Tag := 1;

      if AllTabSheetsAreTagged then
        begin
          FCanClose := True;
          PostMessage(Handle, WM_CLOSE, 0, 0);
        end;
    end;
end;

function TMainForm.AllTabSheetsAreTagged : boolean;
var
  i : integer;
begin
  Result := True;
  i      := pred(PageControl1.PageCount);

  while (i >= 0) and Result do
    if (PageControl1.Pages[i].Tag <> 1) then
      Result := False
     else
      dec(i);
end;


procedure TMainForm.BrowserCreatedMsg(var aMessage : TMessage);
var
  TempWindowParent : TCEFWindowParent;
  TempChromium     : TChromium;
  TempfmChrom :TfmChrom;
begin
  PageControl1.Enabled := True;
    if (aMessage.lParam >= 0) and
     (aMessage.lParam < PageControl1.PageCount) then
  begin
    SearchChromium(aMessage.lParam, TempfmChrom);
    curChrom :=  TempfmChrom;
    TempfmChrom.Chromium1.LoadURL(TempfmChrom.openurl);
  end;

 { if SearchWindowParent(aMessage.lParam, TempWindowParent) then
    TempWindowParent.UpdateSize;

  if SearchChromium(aMessage.lParam, TempChromium) then
  begin
    TempChromium.LoadURL(MINIBROWSER_HOMEPAGE);            //TempChromium.LoadURL(URLCbx.Items[0]);
  end;  }


 { CEFWindowParent1.UpdateSize;
  NavControlPnl.Enabled := True;
  pagecontrol1.Enabled := true;
  AddURL(MINIBROWSER_HOMEPAGE);
  Chromium1.LoadURL(MINIBROWSER_HOMEPAGE);   }
end;


function TMainForm.SearchWindowParent(aPageIndex : integer; var aWindowParent : TCEFWindowParent) : boolean;
var
  i, j : integer;
  TempControl : TControl;
  TempSheet : TTabSheet;
begin
  Result        := False;
  aWindowParent := nil;

  if (aPageIndex >= 0) and (aPageIndex < PageControl1.PageCount) then
    begin
      TempSheet := PageControl1.Pages[aPageIndex];
      i         := 0;
      j         := TempSheet.ControlCount;

      while (i < j) and not(Result) do
        begin
          TempControl := TempSheet.Controls[i];

          if (TempControl <> nil) and (TempControl is TCEFWindowParent) then
            begin
              aWindowParent := TCEFWindowParent(TempControl);
              Result        := True;
            end
           else
            inc(i);
        end;
    end;
end;


procedure TMainForm.BrowserDestroyTabMsg(var aMessage: TMessage);
var
  TempfmChrom :TfmChrom;
begin
  // CEFWindowParent1.Free;       //这个应该是原来的
 { if  SearchChromium(aMessage.lParam, TempfmChrom) then
  begin
    PostMessage(TempfmChrom.Handle, WM_CLOSE, 0, 0);    //窗体关闭时考虑这个
  end;}
  if (aMessage.lParam >= 0) and
     (aMessage.lParam < PageControl1.PageCount) then
  begin
    try   //或者说是因为调用C++库的报错？
      PageControl1.Pages[aMessage.lParam].Free;
    except

    end;
    if aMessage.lParam = 0 then
    begin
      PageControl1.ActivePageIndex :=  0;    //modfy by qjh
    end else begin
      PageControl1.ActivePageIndex :=  aMessage.lParam -1;
    end;
    SearchChromium(PageControl1.TabIndex, TempfmChrom);
    curChrom :=  TempfmChrom;
  end;

  FClosingTab          := False;
  PageControl1.Enabled := True;

  if (PageControl1.PageCount = 0) and not FClosing then
  begin
    AddTabBtnClick(self);
  end;
end;

procedure TMainForm.BrowserDestroyWindowParentMsg(var aMessage: TMessage);
var
  TempWindowParent : TCEFWindowParent;           //这个是多少tab的
  TempfmChrom :TfmChrom;
begin
  //if SearchWindowParent(aMessage.lParam, TempWindowParent) then
  if SearchChromium(PageControl1.TabIndex, TempfmChrom) then

  begin
    try
     // TempfmChrom.CEFWindowParent1.Free;
     // freeandnil(TempfmChrom);

     if (aMessage.lParam >= 0) and
         (aMessage.lParam < PageControl1.PageCount) then
      begin
        PageControl1.Pages[aMessage.lParam].Free;
        if aMessage.lParam = 0 then
        begin
          PageControl1.ActivePageIndex :=  0;    //modfy by qjh
        end else begin
          PageControl1.ActivePageIndex :=  aMessage.lParam -1;
        end;
        SearchChromium(PageControl1.TabIndex, TempfmChrom);
        curChrom :=  TempfmChrom;
      end;

      FClosingTab          := False;
      PageControl1.Enabled := True;

      if (PageControl1.PageCount = 0) then  // //modfy by qjh
      begin
        AddTabBtnClick(self);
      end;
    except
      on e:exception do
      begin
        showmessage(e.Message);
      end;

    end;
  end;

end;

procedure TMainForm.AddTabBtnClick(Sender: TObject);
var
  TempSheet        : TTabSheet;
  TempWindowParent : TCEFWindowParent;
  TempChromium     : TChromium;
  fmChrom : TfmChrom;
  CloseButton : TSpeedButton;
  Rect: TRect;
    VisiblePageIndex :integer;
  i :integer;
begin
  PageControl1.Enabled := False;

  TempSheet             := TTabSheet.Create(PageControl1);
  TempSheet.Caption     := '新标签页           ';
  TempSheet.PageControl := PageControl1;

 { TempWindowParent        := TCEFWindowParent.Create(TempSheet);
  TempWindowParent.Parent := TempSheet;
  TempWindowParent.Color  := clWhite;
  TempWindowParent.Align  := alClient;

  TempChromium                 := TChromium.Create(TempSheet);
  TempChromium.OnAfterCreated  := Chromium1AfterCreated;     //   Chromium_OnAfterCreated
  TempChromium.OnAddressChange := Chromium1AddressChange;//Chromium_OnAddressChange;
  TempChromium.OnTitleChange   := Chromium1TitleChange;//Chromium_OnTitleChange;
  TempChromium.OnClose         := Chromium1Close;//Chromium_OnClose;
  TempChromium.OnBeforeClose   := Chromium1BeforeClose;//Chromium_OnBeforeClose;
  TempChromium.OnBeforePopup   := Chromium1BeforePopup;//Chromium_OnBeforePopup;

  TempChromium.OnBeforeContextMenu  := Chromium1BeforeContextMenu;  }

  fmChrom := TfmChrom.Create(TempSheet);
  fmChrom.Parent := TempSheet;
  fmChrom.Show;
  fmChrom.openurl := '';
  fmChrom.Chromium1.CreateBrowser(fmChrom.CEFWindowParent1, '');     //www.baidu.com
  //curChrom := TempChromium;
  PageControl1.ActivePageIndex :=  PageControl1.PageCount -1;

  CloseButton := TSpeedButton.Create(TempSheet);
  CloseButton.Parent := PageControl1;
  CloseButton.Width := 16;
  CloseButton.Height := 16;
  CloseButton.Flat := True;
  ImageLisTMain.GetBitmap(134, CloseButton.Glyph);
  // CloseButton.OnMouseDown := CloseButtonOnMouseDown;
  // CloseButton.OnMouseUp := CloseButtonOnMouseUp;
  Rect := PageControl1.TabRect(PageControl1.ActivePageIndex);
  CloseButton.Top := Rect.Top + 2;
  CloseButton.Left := Rect.Right - 19;
  CloseButton.OnClick := RemoveTabBtnClick;

  if PageControl1.PageCount > 0 then
  begin
    VisiblePageIndex := PageControl1.PageCount-1;
    for i:=0 to PageControl1.PageCount-1 do begin
      if not PageControl1.Pages[i].TabVisible then
        Dec(VisiblePageIndex);
    end;
      Rect := PageControl1.TabRect(VisiblePageIndex);
    FBtnAddTab.Top := Rect.Top;
    FBtnAddTab.Left := Rect.Right + 5;
  end;


{   for PageIndex:=PageControl1.PageIndex+1 to PageControl1.PageCount-1 do begin
    VisiblePageIndex := PageIndex;
    for i:=0 to PageControlMain.PageCount-1 do begin
      if (i<=VisiblePageIndex) and (not PageControl1.Pages[i].TabVisible) then
        Dec(VisiblePageIndex);
    end;
    Rect := PageControlMain.TabRect(VisiblePageIndex);
    btn := QueryTabs[PageIndex-tabQuery.PageIndex].CloseButton;
    btn.Top := Rect.Top + 2;
    btn.Left := Rect.Right - 19;
  end;  }


end;

procedure TMainForm.AddURL(const aURL : string);
begin
 // if (URLCbx.Items.IndexOf(aURL) < 0) then URLCbx.Items.Add(aURL);

 // URLCbx.Text := aURL;
end;

procedure TMainForm.ShowDevToolsMsg(var aMessage : TMessage);
var
  TempPoint : TPoint;
begin
  TempPoint.x := (aMessage.wParam shr 16) and $FFFF;
  TempPoint.y := aMessage.wParam and $FFFF;
  ShowDevTools(TempPoint);
end;

procedure TMainForm.HideDevToolsMsg(var aMessage : TMessage);
begin
  HideDevTools;
end;

procedure TMainForm.Inczoom1Click(Sender: TObject);
begin
  Chromium1.IncZoomStep;
end;

procedure TMainForm.Openfile1Click(Sender: TObject);
begin
  OpenDialog1.Filter := 'Any file (*.*)|*.*';

  if OpenDialog1.Execute then
    begin
      // This is a quick solution to load files. The file URL should be properly encoded.
      Chromium1.LoadURL('file:///' + OpenDialog1.FileName);
    end;
end;

procedure TMainForm.OpenfilewithaDAT1Click(Sender: TObject);
var
  TempDATA : string;
  TempFile : TMemoryStream;
begin
  TempFile := nil;

  try
    try
      OpenDialog1.Filter := 'HTML files (*.html)|*.HTML;*.HTM|PDF files (*.pdf)|*.PDF';

      if OpenDialog1.Execute then
        begin
          // Use TByteStream instead of TMemoryStream if your Delphi version supports it.
          TempFile := TMemoryStream.Create;
          TempFile.LoadFromFile(OpenDialog1.FileName);

          if (OpenDialog1.FilterIndex = 0) then
            TempDATA := 'data:text/html;charset=utf-8;base64,' + CefBase64Encode(TempFile.Memory, TempFile.Size)
           else
            TempDATA := 'data:application/pdf;charset=utf-8;base64,' + CefBase64Encode(TempFile.Memory, TempFile.Size);

          Chromium1.LoadURL(TempDATA);
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TMiniBrowserFrm.OpenfilewithaDAT1Click', e) then raise;
    end;
  finally
    if (TempFile <> nil) then FreeAndNil(TempFile);
  end;
end;

procedure TMainForm.PageControl1Change(Sender: TObject);
begin
 SearchChromium(PageControl1.TabIndex, curchrom);
end;

procedure TMainForm.PopupMenu1Popup(Sender: TObject);
begin
  if DevTools.Visible then
    DevTools1.Caption := 'Hide DevTools'
   else
    DevTools1.Caption := 'Show DevTools';
end;

procedure TMainForm.Preferences1Click(Sender: TObject);
begin
  case Chromium1.ProxyScheme of
    psSOCKS4 : PreferencesFrm.ProxySchemeCb.ItemIndex := 1;
    psSOCKS5 : PreferencesFrm.ProxySchemeCb.ItemIndex := 2;
    else       PreferencesFrm.ProxySchemeCb.ItemIndex := 0;
  end;

  PreferencesFrm.ProxyTypeCbx.ItemIndex  := Chromium1.ProxyType;
  PreferencesFrm.ProxyServerEdt.Text     := Chromium1.ProxyServer;
  PreferencesFrm.ProxyPortEdt.Text       := inttostr(Chromium1.ProxyPort);
  PreferencesFrm.ProxyUsernameEdt.Text   := Chromium1.ProxyUsername;
  PreferencesFrm.ProxyPasswordEdt.Text   := Chromium1.ProxyPassword;
  PreferencesFrm.ProxyScriptURLEdt.Text  := Chromium1.ProxyScriptURL;
  PreferencesFrm.ProxyByPassListEdt.Text := Chromium1.ProxyByPassList;
  PreferencesFrm.HeaderNameEdt.Text      := Chromium1.CustomHeaderName;
  PreferencesFrm.HeaderValueEdt.Text     := Chromium1.CustomHeaderValue;

  if (PreferencesFrm.ShowModal = mrOk) then
    begin
      Chromium1.ProxyType         := PreferencesFrm.ProxyTypeCbx.ItemIndex;
      Chromium1.ProxyServer       := PreferencesFrm.ProxyServerEdt.Text;
      Chromium1.ProxyPort         := strtoint(PreferencesFrm.ProxyPortEdt.Text);
      Chromium1.ProxyUsername     := PreferencesFrm.ProxyUsernameEdt.Text;
      Chromium1.ProxyPassword     := PreferencesFrm.ProxyPasswordEdt.Text;
      Chromium1.ProxyScriptURL    := PreferencesFrm.ProxyScriptURLEdt.Text;
      Chromium1.ProxyByPassList   := PreferencesFrm.ProxyByPassListEdt.Text;
      Chromium1.CustomHeaderName  := PreferencesFrm.HeaderNameEdt.Text;
      Chromium1.CustomHeaderValue := PreferencesFrm.HeaderValueEdt.Text;

      case PreferencesFrm.ProxySchemeCb.ItemIndex of
        1  : Chromium1.ProxyScheme := psSOCKS4;
        2  : Chromium1.ProxyScheme := psSOCKS5;
        else Chromium1.ProxyScheme := psHTTP;
      end;

      Chromium1.UpdatePreferences;
    end;
end;

procedure TMainForm.Print1Click(Sender: TObject);
begin
  Chromium1.Print;
end;

procedure TMainForm.PrintinPDF1Click(Sender: TObject);
begin
  SaveDialog1.DefaultExt := 'pdf';
  SaveDialog1.Filter     := 'PDF files (*.pdf)|*.PDF';

  if SaveDialog1.Execute and (length(SaveDialog1.FileName) > 0) then
    Chromium1.PrintToPDF(SaveDialog1.FileName, Chromium1.DocumentURL, Chromium1.DocumentURL);
end;

procedure TMainForm.ConfigBtnClick(Sender: TObject);
var
  TempPoint : TPoint;
begin
  TempPoint.x := ConfigBtn.left;
  TempPoint.y := ConfigBtn.top + ConfigBtn.Height;
  TempPoint   := ConfigPnl.ClientToScreen(TempPoint);

  PopupMenu1.Popup(TempPoint.x, TempPoint.y);
end;

procedure TMainForm.CopyHTMLMsg(var aMessage : TMessage);
begin
  Chromium1.RetrieveHTML;
end;


procedure TMainForm.CopyAllTextMsg(var aMessage : TMessage);
begin
  Chromium1.RetrieveText;
end;

procedure TMainForm.CopyFramesIDsMsg(var aMessage : TMessage);
var
  i          : NativeUInt;
  TempCount  : NativeUInt;
  TempArray  : TCefFrameIdentifierArray;
  TempString : string;
begin
  TempCount := Chromium1.FrameCount;

  if Chromium1.GetFrameIdentifiers(TempCount, TempArray) then
    begin
      TempString := '';
      i          := 0;

      while (i < TempCount) do
        begin
          TempString := TempString + inttostr(TempArray[i]) + CRLF;
          inc(i);
        end;

      clipboard.AsText := TempString;
    end;
end;

procedure TMainForm.CopyFramesNamesMsg(var aMessage : TMessage);
var
  TempSL : TStringList;
begin
  try
    TempSL := TStringList.Create;

    if Chromium1.GetFrameNames(TStrings(TempSL)) then clipboard.AsText := TempSL.Text;
  finally
    FreeAndNil(TempSL);
  end;
end;

procedure TMainForm.ShowResponseMsg(var aMessage : TMessage);
begin
  SimpleTextViewerFrm.Memo1.Lines.Clear;

  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  SimpleTextViewerFrm.Memo1.Lines.Add('Request headers : ');
  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
 // if (FRequest <> nil) then SimpleTextViewerFrm.Memo1.Lines.AddStrings(FRequest);

  SimpleTextViewerFrm.Memo1.Lines.Add('');

  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
  SimpleTextViewerFrm.Memo1.Lines.Add('Response headers : ');
  SimpleTextViewerFrm.Memo1.Lines.Add('--------------------------');
//  if (FResponse <> nil) then SimpleTextViewerFrm.Memo1.Lines.AddStrings(FResponse);

  SimpleTextViewerFrm.ShowModal;
end;

procedure TMainForm.SavePreferencesMsg(var aMessage : TMessage);
begin
  SaveDialog1.DefaultExt := 'txt';
  SaveDialog1.Filter     := 'Text files (*.txt)|*.TXT';

  if SaveDialog1.Execute and (length(SaveDialog1.FileName) > 0) then
    Chromium1.SavePreferences(SaveDialog1.FileName);
end;

//function TMainForm.SearchChromium(aPageIndex: integer;
//  var aChromium: TChromium): boolean;
function TMainForm.SearchChromium(aPageIndex: integer;
  var TempfmChrom: TfmChrom): boolean;
var
  i, j : integer;
  TempComponent : TComponent;
  TempSheet : TTabSheet;
begin
  Result    := False;
  TempfmChrom := nil;

  if (aPageIndex >= 0) and (aPageIndex < PageControl1.PageCount) then
    begin
      TempSheet := PageControl1.Pages[aPageIndex];
      i         := 0;
      j         := TempSheet.ComponentCount;

      while (i < j) and not(Result) do
        begin
          TempComponent := TempSheet.Components[i];

         // if (TempComponent <> nil) and (TempComponent is TChromium) then   //TfmChrom
           if (TempComponent <> nil) and (TempComponent is TfmChrom) then
            begin
              TempfmChrom := TfmChrom(TempComponent);//      TChromium(TempComponent);
              Result    := True;
            end
           else
            inc(i);
        end;
    end;
end;

procedure TMainForm.TakeSnapshotMsg(var aMessage : TMessage);
var
  TempBitmap : TBitmap;
begin
  TempBitmap := nil;

  try
    SaveDialog1.DefaultExt := 'bmp';
    SaveDialog1.Filter     := 'Bitmap files (*.bmp)|*.BMP';

    if SaveDialog1.Execute and
       (length(SaveDialog1.FileName) > 0) and
       Chromium1.TakeSnapshot(TempBitmap) then
      TempBitmap.SaveToFile(SaveDialog1.FileName);
  finally
    if (TempBitmap <> nil) then FreeAndNil(TempBitmap);
  end;
end;

procedure TMainForm.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TMainForm.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (Chromium1 <> nil) then Chromium1.NotifyMoveOrResizeStarted;
end;

procedure TMainForm.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := True;
end;

procedure TMainForm.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;

  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

procedure TMainForm.Deczoom1Click(Sender: TObject);
begin
  Chromium1.DecZoomStep;
end;

procedure TMainForm.DevTools1Click(Sender: TObject);
begin
  if DevTools.Visible then
    HideDevTools
   else
    ShowDevTools;
end;

procedure TMainForm.ShowDevTools(aPoint : TPoint);
begin
  Splitter1.Visible := True;
  DevTools.Visible  := True;
  DevTools.Width    := Width div 4;
  Chromium1.ShowDevTools(aPoint, DevTools);
end;

procedure TMainForm.ShowDevTools;
var
  TempPoint : TPoint;
begin
  TempPoint.x := low(integer);
  TempPoint.y := low(integer);
  ShowDevTools(TempPoint);
end;

procedure TMainForm.HideDevTools;
begin
  Chromium1.CloseDevTools(DevTools);
  Splitter1.Visible := False;
  DevTools.Visible  := False;
  DevTools.Width    := 0;
end;

end.
