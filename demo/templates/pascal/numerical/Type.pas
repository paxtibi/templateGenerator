unit <%type-name%>Type;
interface
uses
  Classes, SysUtils;
type
  { I<%type-name%> }

  I<%type-name%> = interface
    function Getvalue: <%type-name%>;
    procedure Setvalue(AValue: <%type-name%>);
    property value : <%type-name%> read Getvalue write Setvalue;
  end;

  operator := (aValue :  <%type-name%>) res:  I<%type-name%>;
  operator Explicit(aValue :  <%type-name%>) res:  I<%type-name%>;
  operator Explicit(aValue :  I<%type-name%>) res:  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : I<%type-name%>) res:  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : <%type-name%>) res:  <%type-name%>;
  operator + (const Left : <%type-name%>;const right : I<%type-name%>) res:  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : I<%type-name%>) res:  I<%type-name%>;
                             
implementation
Uses
  paxtypes;
type
   { T<%type-name%> }

  T<%type-name%> = class(TInterfacedObject, I<%type-name%>)
  private
    function GetValue: <%type-name%>;
    procedure SetValue(AValue: <%type-name%>);
  protected
    FValue: <%type-name%>;
  public
    constructor Create(aValue: <%type-name%>);
    property Value : <%type-name%> read GetValue write SetValue;
  end;


operator := (aValue: <%type-name%>)res: I<%type-name%>;
begin
  result := T<%type-name%>.Create(aValue);
end;

operator Explicit(aValue: <%type-name%>)res: I<%type-name%>;
begin
  result := T<%type-name%>.Create(aValue);
end;

operator Explicit(aValue: I<%type-name%>)res: <%type-name%>;
begin
  result := aValue.Value;
end;

operator+(const Left: I<%type-name%>; const right: I<%type-name%>) res: <%type-name%>;
begin
  if not assigned(left) then Raise ENullPointerException.Create('Addition :Left parameter is nil');
  if not assigned(right)then Raise ENullPointerException.Create('Addition :Right parameter is nil');
  res := left.value + right.value;
end;
operator + (const Left : I<%type-name%>;const right : I<%type-name%>) res:  I<%type-name%>;
begin
  if not assigned(left) then Raise ENullPointerException.Create('Addition :Left parameter is nil');
  if not assigned(right)then Raise ENullPointerException.Create('Addition :Right parameter is nil');
  res := left.value + right.value;
end;


operator+(const Left: I<%type-name%>; const right: <%type-name%>)res: <%type-name%>;
begin
  if not assigned(left) then Raise ENullPointerException.Create('Addition :Left parameter is nil');
  res := left.value + right;
end;

operator+(const Left: <%type-name%>; const right: I<%type-name%>)res: <%type-name%>;
begin
  if not assigned(right)then Raise ENullPointerException.Create('Addition :Right parameter is nil');
  result := left+ right.value;
end;

{ T<%type-name%> }

function T<%type-name%>.GetValue: <%type-name%>;
begin
  result := FValue;
end;

procedure T<%type-name%>.SetValue(AValue: <%type-name%>);
begin
  if FValue=AValue then Exit;
  FValue:=AValue;
end;

constructor T<%type-name%>.Create(aValue: <%type-name%>);
begin
  FValue:= aValue;
end;

end.
