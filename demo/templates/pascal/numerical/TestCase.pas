unit <%type-name%>TestCase;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpcunit, testutils, testregistry, paxtypes;

type

  { T<%type-name%>Tests }

  T<%type-name%>Tests = class(TTestCase)
  private
    FGlobal: I<%type-name%>;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Creation;
    procedure AssignamentAndImplicitCast;
    procedure Addition;
    procedure ExplicitCast;
    procedure ExceptionTest;
  end;

implementation

procedure T<%type-name%>Tests.Creation;
var
  b: I<%type-name%>;
begin
  b := 110;
  AssertEquals(110, B.Value);
  b := nil;
end;

procedure T<%type-name%>Tests.AssignamentAndImplicitCast;
var
  B: I<%type-name%>;
begin
  B := 110;
  AssertEquals(110, B.Value);
end;

procedure T<%type-name%>Tests.Addition;
begin
  AssertEquals(127 + 127, I<%type-name%>(127).Value + 127);
end;

procedure T<%type-name%>Tests.ExplicitCast;
var
  B: I<%type-name%>;
begin
  B := I<%type-name%>(110);
  AssertEquals(110, B.Value);
end;

procedure T<%type-name%>Tests.ExceptionTest;
var
  n: I<%type-name%>;
  v: I<%type-name%>;
begin
  try
    v := 127;
    n := nil;
    n := v + n;
  except
    on E: Exception do
    begin
      Assert(E is ENullPointerException, 'ok');
    end;
  end;
  try
    v := nil;
    n := 127;
    n := v + n;
  except
    on E: Exception do
    begin
      Assert(E is ENullPointerException, 'ok');
    end;
  end;
end;

procedure T<%type-name%>Tests.SetUp;
begin
  FGlobal := 127;
end;

procedure T<%type-name%>Tests.TearDown;
begin
  FGlobal := nil;
end;


initialization
  RegisterTest(T<%type-name%>Tests);
end.
