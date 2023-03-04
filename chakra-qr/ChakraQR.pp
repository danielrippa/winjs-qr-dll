unit ChakraQR;

{$mode delphi}

interface

  uses
    ChakraTypes;

  function GetJsValue: TJsValue;

implementation

  uses
    Chakra, ChakraUtils, ChakraQrUtils, SysUtils;

  function QrEncode(Args: PJsValue; ArgCount: Word): TJsValue;
  var
    aText: String;
    aErrorCorrectionLevel: Integer;
    aMinVersion, aMaxVersion: Integer;
  begin
    CheckParams('qrEncode', Args, ArgCount, [jsString], 1);

    aText := JsStringAsString(Args^);

    aErrorCorrectionLevel := 0;
    aMinVersion := 1;
    aMaxVersion := 40;

    Result := GetQrBooleanMatrix(aText, aErrorCorrectionLevel, aMinVersion, aMaxVersion);
  end;

  function GetJsValue;
  begin

    Result := CreateObject;

    SetFunction(Result, 'qrEncode', QrEncode);
  end;

end.