unit WKSplitter;

interface

uses
  SysUtils, Classes, Controls, ExtCtrls;

type
  TWKSplitter = class(TSplitter)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
  published
    { Published declarations }
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('WKComponent', [TWKSplitter]);
end;

end.
