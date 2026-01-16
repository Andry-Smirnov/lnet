{$mode objfpc}{$H+}
program fpmake;

{$IFDEF COMPILED_BY_FPPKG}
{$IFNDEF HAS_PACKAGE_LAZMKUNIT}
{$FATAL This package depends on the lazmkunit package which is not installed}
{$ENDIF}
{$ENDIF}

uses 
  fpmkunit, 
  lazmkunit;

var
  P: TLazPackage;
  T: TTarget;

begin
  with Installer(TLazInstaller) do
    begin
      P := AddPackage('lnet') as TLazPackage;
      p.AfterInstall := @TLazInstaller(Installer).DoRegisterLazarusPackages;

      P.Version := '0.6.6-0';
      P.OSes := AllUnixOSes + [Win32, Win64];
      P.Author := 'Aleš Katona';
      P.License := 'LGPL with modification, Examples: GPL2';
      P.HomepageURL := 'http://lnet.wordpress.com/';
      P.Email := 'almindor@gmail.com';
      P.Description := 'Collection of classes and components to enable event-driven TCP or UDP networking';
{$IFDEF VER2_4_0}
      P.Options := '-Sm';
{$ELSE VER2_4_0}
      P.Options.add('-Sm');
{$ENDIF VER2_4_0}
{$IFDEF VER2_6}
      P.Options.Add('-Fisrc/sys');
{$ENDIF}
      P.SupportBuildModes := [bmOneByOne];

      P.Dependencies.Add('lazmkunit');
      P.Dependencies.Add('fcl-net');
      P.Dependencies.Add('fcl-base');
      P.Dependencies.Add('fcl-process');
{$IFDEF VER3}
      P.Dependencies.Add('openssl');
{$ENDIF}
      p.Dependencies.Add('winunits-jedi', [win32, win64]);
  //    P.NeedLibC:= true;  // true for headers that indirectly link to libc?

      T:=P.Targets.AddUnit('src/lws2tcpip.pp', AllOSes - AllUnixOSes);
      T:=P.Targets.AddUnit('src/lws2override.pp', AllOSes - AllUnixOSes);
      T:=P.Targets.AddUnit('src/lcommon.pp');
      with T.Dependencies do
        begin
        AddUnit('lws2override', AllOSes - AllUnixOSes);
        AddUnit('lws2tcpip', AllOSes - AllUnixOSes);
        AddInclude('src/sys/osunits.inc');
        end;
      T := P.Targets.AddUnit('src/levents.pp');
      with T.Dependencies do
        begin
          AddInclude('src/sys/lkqueueeventerh.inc');
          AddInclude('src/sys/lepolleventerh.inc');
          AddInclude('src/sys/lkqueueeventer.inc');
          AddInclude('src/sys/lepolleventer.inc');
        end;
      T := P.Targets.AddUnit('src/lcontrolstack.pp');
      T := P.Targets.AddUnit('src/lmimetypes.pp');
      T := P.Targets.AddUnit('src/lmimestreams.pp');
      T := P.Targets.AddUnit('src/lmimewrapper.pp');
      T := P.Targets.AddUnit('src/lprocess.pp');
      T := P.Targets.AddUnit('src/lspawnfcgi.pp');
      with T.Dependencies do
        begin
          AddInclude('src/sys/lspawnfcgiunix.inc', AllUnixOSes);
          AddInclude('src/sys/lspawnfcgiwin.inc', AllOSes - AllUnixOSes);
        end;
      T := P.Targets.AddUnit('src/lfastcgi.pp');
      T := P.Targets.AddUnit('src/lstrbuffer.pp');
      T := P.Targets.AddUnit('src/lthreadevents.pp');
      T := P.Targets.AddUnit('src/ltimer.pp');
      T := P.Targets.AddUnit('src/lwebserver.pp');
{$IFNDEF VER3}
      T := P.Targets.AddUnit('src/lopenssl.pas');
{$ELSE}
      // Archives created with fpc version 3 should also contain this file
      // to be able to compile on earlier versions.
      P.Sources.AddSrc('src/lopenssl.pas');
{$ENDIF ver3}
      T:=P.Targets.AddUnit('src/lnet.pp');
      T:=P.Targets.AddUnit('src/lnetssl.pp');
      T:=P.Targets.AddUnit('src/ltelnet.pp');
      T:=P.Targets.AddUnit('src/lftp.pp');
    with T.Dependencies do
      begin
        AddInclude('src/lcontainers.inc');
        AddInclude('src/lcontainersh.inc');
      end;
      T := P.Targets.AddUnit('src/lsmtp.pp');
      T := P.Targets.AddUnit('src/lhttp.pp');
      T := P.Targets.AddUnit('src/lhttputil.pp');
      T := P.Targets.AddUnit('src/fastcgi_base.pp');

      T := P.Targets.AddExampleProgram('examples/console/ltelnet/ltclient.pp');
      T := P.Targets.AddExampleProgram('examples/console/lftp/lftpclient.pp');
      T := P.Targets.AddExampleProgram('examples/console/lsmtp/lsmtpclient.pp');
      T := P.Targets.AddExampleProgram('examples/console/ltcp/lclient.pp');
      T := P.Targets.AddExampleProgram('examples/console/ltcp/lserver.pp');
      T := P.Targets.AddExampleProgram('examples/console/ludp/ludp.pp');
      T := P.Targets.AddExampleProgram('examples/console/lhttp/fphttpd.pp');
      T := P.Targets.AddExampleProgram('examples/console/lhttp/fpget.pp');
{$IFDEF VER3}
      P.Sources.AddExampleFiles('examples/console/lhttp/*', P.Directory, False, 'examples/console/lhttp');
      P.Sources.AddExampleFiles('examples/console/lftp/*', P.Directory, False, 'examples/console/lftp');
      P.Sources.AddExampleFiles('examples/console/lsmtp/*', P.Directory, False, 'examples/console/lsmtp');
      P.Sources.AddExampleFiles('examples/console/ltcp/*', P.Directory, False, 'examples/console/ltcp');
      P.Sources.AddExampleFiles('examples/console/ltelnet/*', P.Directory, False, 'examples/console/ltelnet');
      P.Sources.AddExampleFiles('examples/console/ludp/*', P.Directory, False, 'examples/console/ludp');
      P.Sources.AddExampleFiles('examples/visual/ftp/*', P.Directory, False, 'examples/visual/ftp');
      P.Sources.AddExampleFiles('examples/visual/http/*', P.Directory, False, 'examples/visual/http');
      P.Sources.AddExampleFiles('examples/visual/smtp/*', P.Directory, False, 'examples/visual/smtp');
      P.Sources.AddExampleFiles('examples/visual/tcpudp/*', P.Directory, False, 'examples/visual/tcpudp');
      P.Sources.AddExampleFiles('examples/visual/telnet/*', P.Directory, False, 'examples/visual/telnet');
{$ELSE}
      P.Sources.AddExampleFiles('examples/console/lhttp/*', False, 'examples/console/lhttp');
      P.Sources.AddExampleFiles('examples/console/lftp/*', False, 'examples/console/lftp');
      P.Sources.AddExampleFiles('examples/console/lsmtp/*', False, 'examples/console/lsmtp');
      P.Sources.AddExampleFiles('examples/console/ltcp/*', False, 'examples/console/ltcp');
      P.Sources.AddExampleFiles('examples/console/ltelnet/*', False, 'examples/console/ltelnet');
      P.Sources.AddExampleFiles('examples/console/ludp/*', False, 'examples/console/ludp');
      P.Sources.AddExampleFiles('examples/visual/ftp/*', False, 'examples/visual/ftp');
      P.Sources.AddExampleFiles('examples/visual/http/*', False, 'examples/visual/http');
      P.Sources.AddExampleFiles('examples/visual/smtp/*', False, 'examples/visual/smtp');
      P.Sources.AddExampleFiles('examples/visual/tcpudp/*', False, 'examples/visual/tcpudp');
      P.Sources.AddExampleFiles('examples/visual/telnet/*', False, 'examples/visual/telnet');
{$ENDIF}
      P.Sources.AddExample('examples/console/Makefile', 'examples/console');
      P.Sources.AddExample('examples/console/units/empty.txt', 'examples/console/units');

      P.Sources.AddDoc('README');
      P.Sources.AddDoc('LICENSE.examples');
      P.Sources.AddDoc('CHANGELOG');
      P.Sources.AddDoc('INSTALL');
{$IFDEF VER3}
      P.Sources.AddDocFiles('doc/*',P.Directory);
      P.Sources.AddDocFiles('doc/en/*',P.Directory, False, 'en');
{$ELSE}
      P.Sources.AddDocFiles('doc/*');
      P.Sources.AddDocFiles('doc/en/*', False, 'en');
{$ENDIF}
      P.LazPackageFiles.AddLazPackageTemplate('lazaruspackage/lnetvisual.template');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lnetcomponents.pas');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lnetvisualreg.lrs');
      P.LazPackageFiles.AddLazFile('lazaruspackage/CHANGELOG');
      P.LazPackageFiles.AddLazFile('lazaruspackage/README');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lclwineventer.inc');
      P.LazPackageFiles.AddLazFile('lazaruspackage/LICENSE');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lclgtkeventer.inc');
      P.LazPackageFiles.AddLazFile('lazaruspackage/LICENSE.ADDON');
      P.LazPackageFiles.AddLazFile('lazaruspackage/INSTALL');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lclwinceeventer.inc');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lnetvisualreg.pas');
      P.LazPackageFiles.AddLazFile('lazaruspackage/lclnet.pas');

      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLHTTPClientComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLTelnetClientComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLUdpComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLTcpComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLFtpClientComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLHTTPServerComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLSMTPClientComponent.xpm', 'icons');
      P.LazPackageFiles.AddLazFile('lazaruspackage/icons/TLSSLSessionComponent.xpm', 'icons');

      Run;
    end;
end.

