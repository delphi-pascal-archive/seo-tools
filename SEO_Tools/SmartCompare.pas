unit SmartCompare;

interface

type
  TEqualityFunc=function(const x,y:Integer):Boolean;

  function SmartDist(f:TEqualityFunc;n1,n2:Integer):Double;overload;
  function SmartDist(s1,s2:string):Double;overload;

implementation

function Max3(a,b,c:Integer):Integer;
begin
  if a>b then begin
    if a>c then
      Result:=a
    else
      Result:=c;
  end else begin
    if b>c then
      Result:=b
    else
      Result:=c;
  end;
end;

function SmartDist(f:TEqualityFunc;n1,n2:Integer):Double;
var
  i,j,a,b,c:Integer;
  T:array[0..1] of PIntegerArray;
  u:Boolean;
begin
  GetMem(T[0],(n1+1)*(n2+1)*SizeOf(Integer));
  GetMem(T[1],(n1+1)*(n2+1)*SizeOf(Integer));
  for i:=0 to n1 do begin
    T[0,i]:=0;
    T[1,i]:=-1;
  end;
  for j:=0 to n2 do begin
    T[0,j*(n1+1)]:=0;
    T[1,j*(n1+1)]:=-1;
  end;
  T[1,0]:=0;
  for i:=1 to n1 do
    for j:=1 to n2 do begin
      u:=f(i-1,j-1);
      if u then
        a:=1+T[1,i-1+(j-1)*(n1+1)]
      else
        a:=T[0,i-1+(j-1)*(n1+1)];
      b:=T[0,i+(j-1)*(n1+1)];
      c:=T[0,i-1+j*(n1+1)];
      T[0,i+j*(n1+1)]:=Max3(a,b,c);
      if u then
        a:=1+T[1,i-1+(j-1)*(n1+1)]
      else
        a:=T[0,i-1+(j-1)*(n1+1)]-1;
      b:=T[0,i+(j-1)*(n1+1)]-1;
      c:=T[0,i-1+j*(n1+1)]-1;
      T[1,i+j*(n1+1)]:=Max3(a,b,c);
    end;
  Result:=(n1+n2-T[1,n1+n2*(n1+1)])/(n1+n2);
  FreeMem(T[0]);
  FreeMem(T[1]);
end;

var
  GS1,GS2:string;

function CompareStr(const x,y:Integer):Boolean;
begin
  Result:=GS1[x+1]=GS2[y+1];
end;

function SmartDist(s1,s2:string):Double;overload;
begin
  GS1:=s1;
  GS2:=s2;
  Result:=SmartDist(CompareStr,Length(s1),Length(s2));
  GS1:='';  
  GS2:='';
end;

end.
