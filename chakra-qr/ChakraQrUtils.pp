unit ChakraQrUtils;

{$mode delphi}

interface

  uses

    ChakraTypes;

  function GetQrBooleanMatrix(aText: String; aErrorCorrectionLevel: Integer; aMinVersion, aMaxVersion: Integer): TJsValue;

implementation

  uses
    FpQrCodeGen, Chakra;

  function QrBufferAsBooleanMatrix(aQrCode: TQrBuffer): TJsValue;
  var
    Size: Integer;
    Border: Byte;
    X, Y: Integer;
    I: Integer;
    Row: TJsValue;
  begin

    Size := QRGetSize(aQrCode);
    Border := 4;

    Result := CreateArray(Size + Border);

    for I := 0 to Size + Border do begin
      SetArrayItem(Result, I, CreateArray(Size + Border));
    end;

    for Y := -Border to Size + Border - 1 do begin
      for X := -Border to Size + Border - 1 do begin

        if (X >= 0) and (Y >= 0) then begin
          Row := GetArrayItem(Result, X);
          SetArrayItem(Row, Y, BooleanAsJsBoolean(QrGetModule(aQrCode, X, Y)));
        end;

      end;
    end;

  end;

  function GetQrBooleanMatrix;
  var
    ErrorLevel: TQrErrorLevelCorrection;
    TempBuffer, QrCode: TQrBuffer;
  begin

    ErrorLevel := TQrErrorLevelCorrection(aErrorCorrectionLevel);

    SetLength(TempBuffer, QRBUFFER_LEN_MAX);
    SetLength(QrCode,     QRBUFFER_LEN_MAX);

    if QrEncodeText(aText, TempBuffer, QrCode, ErrorLevel, aMinVersion, aMaxVersion, mpAuto, True) then begin
      Result := QrBufferAsBooleanMatrix(QrCode);
    end else begin
      Result := Undefined;
    end;

  end;

end.