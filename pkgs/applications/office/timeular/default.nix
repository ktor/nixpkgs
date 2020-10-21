{
  stdenv,
  fetchurl,
  appimageTools,
  libsecret,
  gtk3,
  gsettings-desktop-schemas
}:

let
  version = "3.6.0";
  pname = "timeular";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://s3.amazonaws.com/timeular-desktop-packages/linux/production/Timeular-${version}.AppImage";
    sha256 = "0j0qm9laqmvn48qd3cls5ad0q7cnn03dnaw3wkacvg1ybq7x2xlm";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 rec {
  inherit name src;

  profile = ''
    export XDG_DATA_DIRS=${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}:$XDG_DATA_DIRS
  '';

  extraPkgs = pkgs: with pkgs; [
    libsecret
  ];

  extraInstallCommands = ''
    mv $out/bin/{${name},${pname}}
    install -m 444 -D ${appimageContents}/timeular.desktop $out/share/applications/timeular.desktop
    install -m 444 -D ${appimageContents}/timeular.png $out/share/icons/hicolor/512x512/apps/timeular.png
    substituteInPlace $out/share/applications/timeular.desktop --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with stdenv.lib; {
    description = "Timetracking by flipping 8-sided dice";
    longDescription = ''
      The Timeular Tracker is an 8-sided dice that sits on your desk.
      Assign an activity to each side and flip to start tracking your time.
      The desktop app tell you where every minute of your day is spent.
    '';
    homepage = https://timeular.com;
    license = licenses.unfree;
    maintainers = with maintainers; [ ktor ];
    platforms = [ "x86_64-linux" ];
  };
}
