program fsm1;

uses
  SysUtils, Crt;

type
  TState = (stNone, stMenu, stPlay, stPause, stScore, stExit);
  TStack = array of TState;
  PStack = ^TStack;

procedure Push(stack : PStack; state : TState);
var
  i : integer;
  len : integer;
begin
  len := Length(stack^) + 1;
  SetLength(stack^, len);
  i := High(stack^);
  stack^[i] := state;
  writeln('State ',state, ' inserted at ', i);
end;

procedure Pop(stack : PStack);
var
  len : integer;
begin
  len := Length(stack^) - 1;
  if len > -1 then SetLength(stack^, len);
end;

function Top(stack : PStack) : TState;
var
  i : integer;
begin
  i := High(stack^);
  if i < 0 then result := stNone else result := stack^[i];
  writeln('Index of high: ', i);
end;

function Empty(stack : PStack) : boolean;
begin
  if Length(stack^) <= 0 then result := true else result := false;
end;

function KeyPressed(inch : char; ch : char) : boolean;
begin
  if (inch = ch) then KeyPressed := true else KeyPressed := false;
end;

procedure Run;
var
  stack : TStack;
  ch : char;
  i : integer;
begin
  Push(@stack, stMenu);
  repeat
    case Top(@stack) of
    stMenu:
      begin
        ClrScr;
        writeln('Main menu');
        writeln('Press "P" to play');
        writeln('Press "S" to view High Scores');
        writeln('Press "X" to quit');
        ch := ReadKey;
        if KeyPressed(ch, 'p') then Push(@stack, stPlay);
        if KeyPressed(ch, 's') then Push(@stack, stScore);
        if KeyPressed(ch, 'x') then Push(@stack, stExit);
      end;
    stPlay:
      begin
        ClrScr;
        writeln('Game on.......');
        writeln('Press "P" to pause');
        writeln('Press "X" to exit to Main menu');
        ch := ReadKey;
        if KeyPressed(ch, 'x') then Pop(@stack);
        if KeyPressed(ch, 'p') then Push(@stack, stPause);
      end;
    stPause:
      begin
        ClrScr;
        writeln('Paused');
        writeln('Press "P" to continue playing');
        writeln('Press "S" to view High Scores');
        writeln('Press "X" to quit to Main menu');
        ch := ReadKey;
        if KeyPressed(ch, 's') then Push(@stack, stScore);
        if KeyPressed(ch, 'p') then Pop(@stack);
        if KeyPressed(ch, 'x') then
        repeat // Pop states until we reach menu
          Pop(@stack);
        until Top(@stack) = stMenu;
      end;
    stScore:
      begin
        ClrScr;
        writeln('All time high scores');
        writeln('Rickmeister                 1.000.000.003');
        writeln('Matthias                                5');
        writeln;
        writeln('Press "X" to go back');
        ch := ReadKey;
        if KeyPressed(ch, 'x') then Pop(@stack);
      end;
    stExit:
      begin
        ClrScr;
        writeln('Exit game?');
        writeln('Press "Y" to exit or "N" to keep playing');
        ch := ReadKey;
        if KeyPressed(ch, 'y') then SetLength(stack, 0);
        if KeyPressed(ch, 'n') then Pop(@stack);
      end;
    end;

    if KeyPressed(ch, 'd') then
    begin
      ClrScr;
      writeln('Stack contents from top:');
      for i:=High(stack) downto Low(stack) do writeln(stack[i]);
      ch := ReadKey;
    end;
  until Empty(@stack);
end;

begin
  Run;
end.
