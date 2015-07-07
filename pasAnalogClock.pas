unit pasAnalogClock;

interface

uses Graphics, Sysutils;

type

TClockOptions = packed record
    HourWidth: Integer;
    HourColor: TColor;
    HourStyle: TPenStyle;
    MinuteWidth: Integer;
    MinuteColor: TColor;
    MinuteStyle: TPenStyle;
    SecondWidth: Integer;
    SecondColor: TColor;
    SecondStyle: TPenStyle;
 end;

procedure DrawAnalogClock(T: TDateTime; Canvas: TCanvas; R, Left, Top: Integer; Options: TClockOptions);
procedure DrawClockShield(Canvas: TCanvas; R, Left, Top, Width: Integer; Color: TColor);

implementation

procedure DrawAnalogClock(T: TDateTime; Canvas: TCanvas; R, Left, Top: Integer; Options: TClockOptions);
var
  h, m, s, x, y: Integer;
begin
  h := StrToInt(FormatDateTime('h', T));
  m := StrToInt(FormatDateTime('n', T));
  s := StrToInt(FormatDateTime('s', T));

  Canvas.MoveTo(Left + R, Top + R);
  x := Round(cos(PI * (30 * h + (m / 2) - 90) / 180) * (R - (R / 100 * 50)) + Left + R);
  y := Round(sin(PI * (30 * h + (m / 2) - 90) / 180) * (R - (R / 100 * 50)) + Top + R);
  Canvas.Pen.Width := Options.HourWidth;
  Canvas.Pen.Color := Options.HourColor;
  Canvas.Pen.Style := Options.HourStyle;
  Canvas.LineTo(x, y);

  Canvas.MoveTo(Left + R, Top + R);
  x := Round(cos(PI * (6 * m - 90) / 180) * (R - (R / 100 * 10)) + Left + R);
  y := Round(sin(PI * (6 * m - 90) / 180) * (R - (R / 100 * 10)) + Top + R);
  Canvas.Pen.Width := Options.MinuteWidth;
  Canvas.Pen.Color := Options.MinuteColor;
  Canvas.Pen.Style := Options.MinuteStyle;
  Canvas.LineTo(x, y);

  Canvas.MoveTo(Left + R, Top + R);
  x := Round(cos(PI * (6 * s - 90) / 180) * (R - (R / 100 * 10)) + Left + R);
  y := Round(sin(PI * (6 * s - 90) / 180) * (R - (R / 100 * 10)) + Top + R);
  Canvas.Pen.Width := Options.SecondWidth;
  Canvas.Pen.Color := Options.SecondColor;
  Canvas.Pen.Style := Options.SecondStyle;
  Canvas.LineTo(x, y);
end;

procedure DrawClockShield(Canvas: TCanvas; R, Left, Top, Width: Integer; Color: TColor);
var
  x1, y1, x2, y2, i: Integer;
begin
  Canvas.Pen.Width := Width;
  Canvas.Pen.Color := Color;
  i := 0;
  while i < 360 do begin
    x1 := Round(cos(PI * i / 180) * R + Left + R);
    y1 := Round(sin(PI * i / 180) * R + Top + R);
    x2 := Round(cos(PI * i / 180) * (R - (R / 100 * 7)) + Left + R);
    y2 := Round(sin(PI * i / 180) * (R - (R / 100 * 7)) + Top + R);
    Canvas.MoveTo(x1, y1);
    Canvas.LineTo(x2, y2);
    i := i + 30;
  end;
end;

end.
