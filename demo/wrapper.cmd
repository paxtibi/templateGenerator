
FOR %%T IN (Int8,UInt8,Int16,UInt16,Int32,UInt32,Int64,UInt64,ShortInt,SmallInt,Integer,NativeInt,LongInt,Byte,Word,NativeUInt,DWord,Cardinal,LongWord,QWord,Single,Real,Double,Extended,Comp,Currency) DO CALL :execute %%T
  
goto :eof
:execute  
  ..\bin\i386-win32\tmplGen.exe -p .\configs\native-wrappers.json -f "%1" type-name=%1 targetpath=.
goto :eof

:eof

    
