# Eingangsfilter für Hamster zum Entfernen der Kodierungen BASE64 + Quoted-Printable + UTF-8 
# in Headern und allen Text-Teilen von Mails
# -> Umwandeln eingehender Mails in reines Textformat mit dem Standard-Zeichensatz Windows-1252
# nicht darstellbare Zeichen werden zu "?"
# Ziel: Speicherplatz wird reduziert, Durchsuchbarkeit erleichtert

VarSet($MsgFile, paramstr(2)) 
# filecopy($MsgFile,HamMailPath + "Recent.sik\") # ggf. Sicherheitskopie aufheben
VarSet($Msg, ArtAlloc) 
If(ArtLoad($Msg,$MsgFile) = 0)
  Var($Inhalt,$flag)
  $flag=dekod($Msg) #### Base64 + QP + UTF-8 rekursiv dekodieren
  hdr_repl("Subject")
  hdr_repl("From")
  hdr_repl("To")
  hdr_repl("Cc")
  hdr_repl("Reply-To")
  ArtSave($Msg, $MsgFile)
endif
ArtFree($Msg)
quit

sub dekod(*$msg)
  Var($c_type,$boundary,$boundaryRegex,$Body,$Vorspann,$Inhalt,$pos_boundary)
  VarSet($Anfang,$Ende,$EndPart,$GEndPart,"")
  VarSet($flag,$flagI, 0) 
  $c_type=ArtGetHeader($msg, "Content-Type")

  if(pos("pkcs7-",lowercase($c_type))>0)
    return($flag)
  endif

  if ArtHeaderExists($Msg, "Content-Disposition")
    $Body=ArtGetHeader($Msg, "Content-Disposition")
    if $Body>""
      $Body=DecodeMIMEHeaderString($Body)
      ArtSetHeader($Msg, "Content-Disposition", $Body)
      $flag=1
    endif
  endif

  $Body=ArtGetBody($msg)
  if(!pos("multipart",lowercase($c_type)) && !pos("opendoc",lowercase($c_type)) && pos("text",lowercase($c_type))=1 || pos("application/javascript",lowercase($c_type)) || pos("application/ics",lowercase($c_type)) || pos("message/rfc822",lowercase($c_type)))
    if(lowercase(trim(ArtGetHeader($msg, "Content-Transfer-Encoding")))="base64")
      $Body=trim(DecodeBase64($Body),chr(0))
      $flag=1
    endif
    if(lowercase(trim(ArtGetHeader($msg, "Content-Transfer-Encoding")))="quoted-printable")
      $Body=DecodeQP($Body)
      ArtAddHeader($Msg, "X-Base64-converted","QP")
      $flag=1
    endif
    if(pos("utf-8",lowercase($c_type))>0 || pos("iso-10646",lowercase($c_type))>0)
      $Body=DecodeToLocalcharset($Body,"utf-8") # Windows-1252 einstellen!
      if(pos("/html",lowercase($c_type))>0)
        $Body=replace($Body,"charset=utf-8","charset=Windows-1252",,true)
        $Body=replace($Body,"charset=""utf-8","charset=""Windows-1252",,true)
        $Body=replace($Body,"&#228;","ä",true) # sonst Anzeige beim Zitieren vermurkst
        $Body=replace($Body,"&#246;","ö",true)
        $Body=replace($Body,"&#252;","ü",true)
        $Body=replace($Body,"&#223;","ß",true)
        $Body=replace($Body,"&#196;","Ä",true)
        $Body=replace($Body,"&#214;","Ö",true)
        $Body=replace($Body,"&#220;","Ü",true)
        $c_type="text/html; charset=""Windows-1252"""
        ArtAddHeader($Msg, "X-Base64-converted","UTF/HTML")
      else
        $c_type="text/plain; charset=""Windows-1252"""
        ArtAddHeader($Msg, "X-Base64-converted","UTF")
      endif
      ArtSetHeader($Msg, "Content-Type",$c_type)
      $flag=1
    endif
    if $flag=1
      ArtSetHeader($Msg, "Content-Transfer-Encoding","8bit")
      ArtSetBody($Msg,$Body)
    endif
  endif

  RE_Parse($c_type,"(?ms).*?multipart.+?boundary=\x22?(.+?)(?:\x22|$|;)",$boundary)
  if($boundary>"")
    $boundaryRegex = replace($boundary, "+", "\+", true)
    $boundaryRegex = replace($boundaryRegex, "(", "\(", true)
    $boundaryRegex = replace($boundaryRegex, ")", "\)", true)
    $boundaryRegex = replace($boundaryRegex, "?", "\?", true)
    RE_Parse($Body, "(?ms)(.*?)--" + $boundaryRegex + "(--)?$(.+)", $Vorspann,$GEndPart,$Inhalt)   # Vorspann sichern, Rest analysieren
    do
      $Ende=""     #  wenn letzter Teil, dann bleibt $Ende=""
      $pos_boundary=pos($boundary,$Inhalt)
      if($pos_boundary>0 && $pos_boundary<10000000)
        RE_Parse($Inhalt, "(?ms)(.*?)--" + $boundaryRegex + "(--)?$(.*)", $Inhalt,$EndPart, $Ende)
      endif
      if(pos("Content",$Inhalt)>0) # oder nur leeres Anhängsel?
  	    VarSet($MsgNeu, ArtAlloc($Inhalt))
  	    $flagI=dekod($MsgNeu)      
  	    if($flagI=1)
  	      $Inhalt=chr(13) + chr(10) + ArtGetText($MsgNeu) # ArtGetText schneidet CRLF am Beginn ab
          if(copy($Inhalt,len($Inhalt)-1,2)<>chr(13) + chr(10))
            $Inhalt=$Inhalt + chr(13) + chr(10)
          endif
  	      $flag=$flag || $flagI
  	    endif
  	    ArtFree($MsgNeu)
      endif
      $Anfang = $Anfang + $Inhalt
      break($Ende="")
      $Anfang = $Anfang + "--" + $boundary + $EndPart
      $Inhalt = $Ende
    loop

    if($flag=1)
      ArtSetBody($Msg,$Vorspann + "--" + $boundary + $GEndPart + $Anfang) 
    endif
  endif

  return($flag)
endsub

sub hdr_repl($myHdr)
if ArtHeaderExists($Msg, $myHdr)
  $Inhalt=ArtGetHeader($Msg, $myHdr)
  if $Inhalt>""
    Varset($Inhalt1,$Inhalt)
    $Inhalt=DecodeMIMEHeaderString($Inhalt)
    $Inhalt=replace($Inhalt,chr(13)," ",true)
    $Inhalt=replace($Inhalt,chr(10)," ",true)
    if pos("?",$Inhalt) && ($Inhalt1<>$Inhalt) && ($myHdr="From")
      # nach Decode "?" im Absender -> Codierung beibehalten
      $Inhalt=$Inhalt1
    endif
    ArtSetHeader($Msg, $myHdr, $Inhalt)
  endif
endif
endsub
