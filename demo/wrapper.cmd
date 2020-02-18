set executable=..\bin\x86_64-win64\tmplGen.exe

FOR %%T IN (Boolean, Int8,UInt8,Int16,UInt16,Int32,UInt32,Int64,UInt64,ShortInt,SmallInt,Integer,NativeInt,LongInt,Byte,Word,NativeUInt,DWord,Cardinal,LongWord,QWord,Single,Real,Double,Extended,Comp,Currency) DO CALL :execute %%T
  
FOR %%T IN (RawByteString, String, AnsiString, WideString, UTF8String, UnicodeString) DO CALL :execute %%T
goto :eof
:execute  
  %executable% -p .\configs\native-wrappers.json -f "%1" type-name=%1 targetpath=.
goto :eof

:eof

    
