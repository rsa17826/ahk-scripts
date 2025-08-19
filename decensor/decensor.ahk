#Requires AutoHotkey v2.0
#SingleInstance off

#Include <compiledArgFixer>
#Include *i <AutoThemed>

;@Ahk2Exe-SetMainIcon icon.ico

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

; #Include *i <betterui> ; betterui

#Include *i <textfind> ; FindText, setSpeed, doClick
#Include <darkgui>

; #Include *i <CMD> ; CMD - cmd.exe - broken?
replace := "
(
fuck
fucks
pornstar
sucked
bisexual
cumdump
vagina
crap
shitload
shithole
stupidness
fuckery
retardation
horshit
smut
bitching
stupids
bumfucks
bumblefuck
fuckin
fucktard
licked
crotch
hitler
crotchless
incestuous
batshit
penis
masturbate
Goddamn
damn
enslave
slavery
socked
enslavement
murderess
molest
molestation
dicks
cockblock
scrape
perverts
cock
stupidest
boobs
stupidity
slavery
sadist
stupid
trashest
fag
bitchybitchy
erotic
cockroach
tits
murdering
bitchy
trashing
trashiest
bullshitting
cocky
cockiness
murderous
Hancock
trashy
trashcan
horny
suicide
retard
clicked
incestual
basement
rapes
thorny
virgin
murderers
murderer
murder
virgins
assholes
rapest
whore
slut
bitchest
raped
morons
amusement
cocks
incest
fingerfuck
molested
murders
trash
cockroaches
monsterfucker
intersex
Futanari
trashhero
fucked
motherfucker
bitches
bastard
fucking
hell
nasty
scum
pissed
bastards
raping
bitch
shit
bitch
bastard
fucker
bitch
scumbag
shitless
ass
badass
shit
virginity
slave
pervert
futanari
sex
futa
Impregnating
Impregnated
trashes
murderfest
Impregnate
rapey
retards
fuckk
Cunnilingus
slaves
sexual
edgefuckfests
anal
stupider
assed
Intercourse
Fallatio
Handjob
Masturbation
Masturbating
Orgy
Prostitutes
rape
enslaved
perverted
stupidly
prostitution
sexually
bullshits
shits
porn
dick
shitty
dicking
bullshit
sexuality
retardedness
Futadomworld
asshole
pussy
sexy
murdered
cocktail
trAshed
virginal
retarded
hentai
dogshit
fricking
frick
fricker
webtoon
)"
.ToLower()
.split("`n")
.map((a) {
  return [
    "(?<=[^a-z0-9@#$%^&\\*x♥]|^)" a
    .split("")
    .map((e) => "[" e "%#*♥]")
    .join(" ?") "(?=[^a-z0-9@#$%^&\\*x♥]|$)",
    a,
  ]
})
;log(combinedRegex)
;replace.push([/([a-z]+)\.([a-z]+)\.(?:([a-z]+)\.)?(?:([a-z]+)\.)?(?:([a-z]+)\.)?(?:([a-z]+)\.)?(?:([a-z]+)\.)?([a-z]+)/gi, "$1$2$3$4$5$6$7$8"])
replace.push([
  "(?<=^|[^\d\w])\*(\w+( \w+)*)\*(?=[^\w\d]|$)/g",
  "$1"
])
replace.push([
  "what( ?ever)? the duck",
  "what$1e fuck"
])
replace.push([
  "duck(ed)? up",
  "fuck$1 up"
])
replace.push([
  "R4P3",
  "rape"
])
replace.push([
  "fked",
  "fucked"
])
; replace.push(["×", "x"])
replace.push([
  "borked",
  "fucked"
])
replace.push([
  "MotherF'er(s?)",
  "motherfucker$1"
])
; replace.push(["(?<!\w)minf\*+k(s|(?:ed|er|ing)(?:s)?|)(?!\w)/gi, "mindfuck$") - broken???
replace.push([
  "(?<!\w)minf\*+ks(?!\w)",
  "mindfucks"
])
replace.push([
  "(?<!\w)asspull(?!\w)",
  "asshole"
])
replace.push([
  "\bfriggin\b",
  "fucking"
])
replace.push([
  "(?<!\w)fupping(?!\w)",
  "fucking"
])
replace.push([
  ".*░.*",
  ""
])
replace.push([
  ".*THIS IS BOB.*",
  ""
])
replace.push([
  "F\**CK",
  "fuck"
])
replace.push([
  ".*\@\#\$\&.*",
  ""
])
replace.push([
  "(?<!\w)friking?(?!\w)",
  "fucking"
])
replace.push([
  "(?<!\w)shyt(?!\w)",
  "shit"
])
replace.push([
  "(?<!\w)arse?(?!\w)",
  "ass"
])
replace.push([
  "f\*ing(?!\w)",
  "fucking"
])
replace.push([
  "motherf\*(?!\w)",
  "motherfucker"
])
replace.push([
  "b\*\*\*",
  "bitch"
])
replace.push([
  "(?<!\w)f'ing(?!\w)",
  "fucking"
])
replace.push([
  "(?<!\w)NSFW(?!\w)",
  "porn"
])
replace.push([
  "(?<=[^a-z0-9@#$%^&\*x♥]|^)[h%#*♥] ?[e%#*♥] ?[c%#*♥] ?[k%#*♥](?=[^a-z0-9@#$%^&\*x♥]|$)",
  "hell",
])
replace.push([
  "(?<!\w)prosti\*ion(?!\w)",
  "prostitution"
])
replace.push([
  "(?<!\w)Ayaponzu\*(?!\w)",
  "Ayaponzu"
])
replace.push([
  "(?<!\w)DECO\*27(?=[^\w\d]|$)",
  "DECO27"
])
replace.push([
  "(?<!\w)freakin'?(?!\w)",
  "fucking"
])
replace.push([
  "(?<!\w)(?:pron|p0rn)(?!\w)",
  "porn"
])
replace.push([
  "(?<!\w)fricking(?!\w)",
  "fucking"
])
replace.push([
  "(?<!\w)frick(?!\w)",
  "fuck"
])
replace.push([
  "(?<!\w)fricker(?!\w)",
  "fucker"
])
replaceText(text) {
  global i, replaceCounter
  for r in replace {
    ; print(r, i, replace.Length)
    newtext := text.RegExReplace('i)' r[1], r[2])
    if text != newtext {
      text := newtext
      print(text, newtext)
      replaceCounter += 1
      progress.ProgressGuiText.text := "replaced: " replaceCounter ' words'
    }
    i += 1
    progress.update(i)
    ; sleep(1)
  }
  return text
}
p := A_Args[1]
text := f.read(p).split("`n")
replaceCounter := 0
progress := progressbargui(replace.Length * text.Length)
progress.ProgressGuiText.text := "replaced: " replaceCounter ' words'
i := 0
text := text.map(replaceText).join('`n')
F.write(p, text)
ExitApp()
; faster_auto_subtitle --model medium --output_type srt --task transcribe --language en hello.mp3
class progressbargui {
  __New(total) {
    ;Check if the file already exists and if we must not overwrite it
    ;The label that updates the progressbar
    LastSize := 0
    LastSizeTick := 0
    this.lastPercentDone := 0
    ; ProgressGuiText2 := ''
    ; ProgressGuiText := ''
    ;Check if the user wants a progressbar
    ;Initialize the WinHttpRequest Object
    this.FinalSize := total
    ;Create the progressbar and the timer
    this.ProgressGui := darkgui("ToolWindow -Sysmenu Disabled AlwaysOnTop +E0x20 -Border -Caption")
    ; ProgressGui.Title := UrlToFile
    this.ProgressGui.SetFont("Bold")
    this.ProgressGuiText := this.ProgressGui.AddText("x0 w200 Center", "Downloading...")
    this.ProgressGuiText2 := this.ProgressGui.AddText("x0 w200 Center", 0 "`% Done")
    this.gocProgress := this.ProgressGui.AddProgress("x10 w180 h20")
    this.ProgressGui.Show("AutoSize NoActivate")
  }
  update(newProg) {
    ;Get the current filesize and tick
    try {
      ; CurrentSizeTick := A_TickCount
      ; ;Calculate the downloadspeed
      ; ; Speed := Round((newProg / 1024 - LastSize / 1024) / ((CurrentSizeTick - LastSizeTick) / 1000)) . " Kb/s"
      ; ;Save the current filesize and tick for the next time
      ; LastSizeTick := CurrentSizeTick
      ;Calculate percent done

      PercentDone := Floor(newProg / this.FinalSize * 100)
      if PercentDone == this.lastPercentDone
        return
      this.lastPercentDone := PercentDone
      ;Update the ProgressBar
      ; ProgressGui.Title := "Downloading " SaveFileAs " 〰" PercentDone "`%ㄱ"
      ; ProgressGuiText.text := "Downloading...  (" Speed ")"
      this.gocProgress.Value := PercentDone
      this.ProgressGuiText2.text := PercentDone "`% Done"
      ; this.ProgressGui.Show("AutoSize NoActivate")
    } catch Error as e {
      print("Error while updating progress bar. ", e, "PercentDone", PercentDone)
    }
  }
  close() {
    this.ProgressGui.close()
  }
}
