{ pkgs, lib, ... }:
let
  palette = [
    "#1E2122"
    "#F9F5D7"
    "#D3879C"
    "#84A599"
    "#8EC07D"
    "#FABD2F"
    "#FE811A"
    "#FB4A35"
  ];

  savedColors = lib.concatMapStringsSep "," (hex: "#FF" + (lib.removePrefix "#" hex)) palette;
in
{
  home.packages = [ pkgs.styluslabs-write ];

  xdg.configFile."styluslabs/write.xml".text = ''
    <?xml version="1.0"?>
    <map>
      <int name="panFromEdge" value="1" />
      <int name="penButtonMode" value="13" />
      <int name="showAdvPrefs" value="1" />
      <int name="showPenToolbar" value="1" />
      <int name="splitLayout" value="1" />
      <int name="thumbFirstPage" value="1" />
      <float name="pageHeight" value="1660" />
      <float name="pageWidth" value="922" />
      <string name="docFileExt" value="svgz" />
      <string name="newDocTitleFmt" value="%F" />
      <string name="savedColors" value="${savedColors}" />
      <string name="savedWidths" value="1.400,2.400,4.000,8.000" />
      <string name="toolBars2" value="docTitle,stretch,actionSave,separator,tools,separator,undoRedoBtn,separator,seltools,separator,actionShow_Bookmarks,actionShow_Clippings,actionSplitView,separator,actionOverflow_Menu" />
      <string name="toolModes" value="15 20 27 23" />
      <pen color="4278190080" width="1.60000002" wRatio="0.899999976" pressure="2" speed="0" direction="0" dash="0" gap="0" flags="272" />
      <pen color="4278190335" width="1.60000002" wRatio="0.899999976" pressure="2" speed="0" direction="0" dash="0" gap="0" flags="272" />
      <pen color="4278222592" width="1.60000002" wRatio="0.899999976" pressure="2" speed="0" direction="0" dash="0" gap="0" flags="272" />
      <pen color="4294901760" width="1.60000002" wRatio="0.899999976" pressure="2" speed="0" direction="0" dash="0" gap="0" flags="272" />
      <pen color="4278190080" width="3" wRatio="0.800000012" pressure="2" speed="0" direction="45" dash="0" gap="0" flags="336" />
      <pen color="4278190080" width="1.79999995" wRatio="0.699999988" pressure="0" speed="0.5" direction="0" dash="0" gap="0" flags="288" />
      <pen color="4278190080" width="4" wRatio="0" pressure="0" speed="0" direction="0" dash="0" gap="0" flags="512" />
      <pen color="2147450879" width="34" wRatio="0" pressure="0" speed="0" direction="0" dash="0" gap="0" flags="1025" />
    </map>
  '';
}
