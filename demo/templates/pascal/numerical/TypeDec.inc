type
  { I<%type-name%> }

  I<%type-name%> = interface(ISerializable)
  [GUID_<%type-name%>]
    function Getvalue: <%type-name%>;
    procedure Setvalue(AValue: <%type-name%>);
    property value : <%type-name%> read Getvalue write Setvalue;
  end;

  operator := (aValue :  <%type-name%>) :  I<%type-name%>;
  operator Explicit(aValue :  <%type-name%>) :  I<%type-name%>;
  operator Explicit(aValue :  I<%type-name%>) :  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : I<%type-name%>) :  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : <%type-name%>)  :  <%type-name%>;
  operator + (const Left : <%type-name%>;const right : I<%type-name%>)  :  <%type-name%>;
  operator + (const Left : I<%type-name%>;const right : I<%type-name%>) :  I<%type-name%>;
