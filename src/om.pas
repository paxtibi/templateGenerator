unit om;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  { TProject }

  TProject = class
  private
    FendDelimiter: string;
    Fprojectname: string;
    Fsourcepath: string;
    FStartDelimiter: string;
    Ftargetpath: string;
    procedure SetendDelimiter(AValue: string);
    procedure Setprojectname(AValue: string);
    procedure Setsourcepath(AValue: string);
    procedure SetStartDelimiter(AValue: string);
    procedure Settargetpath(AValue: string);
  published
    property projectname: string read Fprojectname write Setprojectname;
    property sourcepath: string read Fsourcepath write Setsourcepath;
    property targetpath: string read Ftargetpath write Settargetpath;
    property startDelimiter: string read FStartDelimiter write SetStartDelimiter;
    property endDelimiter: string read FendDelimiter write SetendDelimiter;
  end;

implementation

{ TProject }

procedure TProject.Setprojectname(AValue: string);
begin
  if Fprojectname = AValue then
    Exit;
  Fprojectname := AValue;
end;

procedure TProject.SetendDelimiter(AValue: string);
begin
  if FendDelimiter = AValue then
    Exit;
  FendDelimiter := AValue;
end;

procedure TProject.Setsourcepath(AValue: string);
begin
  if Fsourcepath = AValue then
    Exit;
  Fsourcepath := AValue;
end;

procedure TProject.SetStartDelimiter(AValue: string);
begin
  if FStartDelimiter = AValue then
    Exit;
  FStartDelimiter := AValue;
end;

procedure TProject.Settargetpath(AValue: string);
begin
  if Ftargetpath = AValue then
    Exit;
  Ftargetpath := AValue;
end;

end.
