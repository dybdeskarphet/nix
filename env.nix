{
  homeSSID = null;

  borg = {
    repo = "";
    items = [ ];
  };

  screenshot = {
    dir = "~/Pictures/Screenshots";
    ocr_lang = "tur+eng";
  };
  git = {
    signing = {
      key = "";
      format = "";
      signByDefault = true;
    };
    user = {
      name = "";
      email = "";
    };
    allowedSigners = [
      "..."
    ];
  };
  syncthing = {
    # Use the settings part of syncthing module for reference, you don't need to call settings = { } inside this though, it will directly be inside settings
  };
}
