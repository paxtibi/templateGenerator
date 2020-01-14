program tmplGen;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  SysUtils,
  CustApp,
  fpjson,
  jsonscanner,
  jsonparser,
  fpjsonrtti,
  fpTemplate,
  LazUtils,
  FileUtil,
  om { you can add units after this };

type
  { TTemplateGenerator }
  TTemplateGenerator = class(TCustomApplication)
  private
    FProject: TProject;
    FJSONData: TJSONData;
    procedure ProcessFile(FileIterator: TFileIterator);
  protected
    procedure DoProduceResult(inputFile: TFilename);
    procedure DoProcessCommandLine(out target: TJSONData);
    procedure DoReadInput(out target: TJSONData);
    procedure DoReadProject(out target: TProject);
    procedure DoRun; override;
    procedure GetParam(Sender: TObject; const ParamName: string; Out AValue: string);
    procedure ReplaceTag(Sender: TObject; const TagString: string; TagParams: TStringList; Out ReplaceText: string);
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

  { TTemplateGenerator }

  procedure TTemplateGenerator.ProcessFile(FileIterator: TFileIterator);
  begin
    Self.DoProduceResult(FileIterator.FileName);
  end;


  procedure TTemplateGenerator.DoProduceResult(inputFile: TFilename);
  var
    Template: TFPTemplate;
    OutputString: string;
    FileStream: TFileStream;
    targetFileName: string;
  begin
    writeln('Load ', inputFile);
    Template := TFPTemplate.Create;
    Template.FileName := inputFile;
    Template.AllowTagParams := True;
    Template.OnGetParam := @GetParam;
    Template.OnReplaceTag := @ReplaceTag;
    Template.StartDelimiter := FProject.startDelimiter;
    Template.EndDelimiter := FProject.endDelimiter;
    OutputString := Template.GetContent;
    ForceDirectories(FProject.targetpath + DirectorySeparator);
    targetFileName := ExpandFileName(FProject.targetpath + DirectorySeparator + FJSONData.FindPath('file-prefix').Value + ExtractFileName(inputFile));
    Writeln('Write : ', targetFileName);
    FileStream := TFileStream.Create(targetFileName, fmCreate);
    FileStream.Write(OutputString[1], Length(OutputString));
    FreeAndNil(FileStream);
  end;

  procedure TTemplateGenerator.DoProcessCommandLine(out target: TJSONData);
  var
    idx, pIdx: integer;
    parameter, pkey, pvalue: string;
  begin
    target := TJSONObject.Create();
    begin
      (target as TJSONObject).Add('file-prefix', GetOptionValue('f', 'file-prefix'));
      idx := 0;
      repeat
        parameter := ParamStr(idx);
        pIdx := Pos('=', parameter);
        if pIdx > 0 then
        begin
          pkey := Copy(parameter, 1, pIdx - 1);
          pValue := Copy(parameter, pIdx + 1, length(parameter));
          Writeln('add ', pkey, ' as ', pvalue);
          (target as TJSONObject).Add(pkey, pvalue);
        end;
        inc(idx);
      until idx > ParamCount;
    end;
  end;

  procedure TTemplateGenerator.DoReadInput(out target: TJSONData);
  var
    FileStream: TFileStream;
    parser: TJSONParser;
  begin
    FileStream := TFileStream.Create(GetOptionValue('j', 'json'), fmOpenRead);
    parser := TJSONParser.Create(FileStream, [joUTF8, joStrict, joComments, joIgnoreTrailingComma]);
    target := parser.Parse;
    FreeAndNil(parser);
    FreeAndNil(FileStream);
  end;

  procedure TTemplateGenerator.DoReadProject(out target: TProject);
  var
    ds: TJSONDeStreamer;
    FileStream: TFileStream;
    jsonString: TJSONStringType;
    fileName: string;
  begin
    fileName := ExpandFileName(GetOptionValue('p', 'project'));
    FileStream := TFileStream.Create(fileName, fmOpenRead);
    SetLength(jsonString, FileStream.Size);
    FileStream.Read(jsonString[1], FileStream.Size);
    ds := TJSONDeStreamer.Create(self);
    target := TProject.Create;
    ds.JSONToObject(jsonString, target);
    FreeAndNil(ds);
  end;

  procedure TTemplateGenerator.DoRun;
  var
    ErrorMsg: string;
    sourceFolder: string;
    fs: TFileSearcher;
  begin
    ErrorMsg := CheckOptions('hp:j:f:', ['help', 'project:', 'json:', 'file-prefix:']);
    if ErrorMsg <> '' then
    begin
      ShowException(Exception.Create(ErrorMsg));
      Terminate;
      Exit;
    end;
    if HasOption('h', 'help') then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;
    if not (HasOption('p', 'project') and (HasOption('j', 'json') or HasOption('f', 'file-prefix'))) then
    begin
      WriteHelp;
      Terminate;
      Exit;
    end;
    DoReadProject(FProject);
    if hasOption('j', 'json') then
    begin
      DoReadInput(Self.FJSONData);
    end
    else
    begin
      DoProcessCommandLine(Self.FJSONData);
    end;
    if FJSONData.FindPath('targetpath') <> nil then
    begin
      FProject.targetpath := Format('%s%s%s', [FProject.targetpath, DirectorySeparator, FJSONData.FindPath('targetpath').AsString]);
    end;
    if FJSONData.FindPath('file-prefix') = nil then
    begin
      Writeln('input file missing file-prefix property: Abort generation!');
      Terminate;
      exit;
    end;
    sourceFolder := StringReplace(expandFileName(ExtractFilePath(GetOptionValue('p', 'project')) + FProject.sourcepath), DirectorySeparator + DirectorySeparator, DirectorySeparator, [rfReplaceAll]);
    FProject.sourcepath := sourceFolder;
    Writeln('Start generate ', FProject.projectname);
    Writeln('Scan folder : ', sourceFolder);
    fs := TFileSearcher.Create();
    fs.OnFileFound := @ProcessFile;
    fs.Search(FProject.sourcepath, '*.*', True, False);
    FreeAndNil(fs);
    Terminate;
  end;

  procedure TTemplateGenerator.GetParam(Sender: TObject; const ParamName: string; out AValue: string);
  begin
    AValue := ParamName;
  end;

  procedure TTemplateGenerator.ReplaceTag(Sender: TObject; const TagString: string; TagParams: TStringList; out ReplaceText: string);
  begin
    try
      ReplaceText := FJSONData.FindPath(TagString).Value;
    except
      Writeln('missing ', TagString);
      ReplaceText := TagString;
    end;
  end;

  constructor TTemplateGenerator.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TTemplateGenerator.Destroy;
  begin
    FreeAndNil(FProject);
    inherited Destroy;
  end;

  procedure TTemplateGenerator.WriteHelp;
  begin
    { add your help code here }
    writeln('Usage: ', ExeName, ' -h');
    writeln('-p (--project) template project *');
    writeln('(or   -j (--json) input data)');
    writeln('(or [key=value] [key1=value1] [key2=value2])');
  end;

var
  Application: TTemplateGenerator;

{$R *.res}

begin
  Application := TTemplateGenerator.Create(nil);
  Application.Title := 'templateGenerator';
  Application.Run;
  Application.Free;
end.
