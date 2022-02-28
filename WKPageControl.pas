unit WKPageControl;

interface

uses
  SysUtils, Classes, Controls, ComCtrls;

type
  TWKPageControl = class(TPageControl)
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
  RegisterComponents('WKComponent', [TWKPageControl]);
end;

end.
