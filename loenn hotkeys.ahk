#Requires AutoHotkey v2.0
#SingleInstance Force
#Include *i <AutoThemed>
try TraySetIcon("D:\.ico\loenn.ico")
#Include <textfind>
#Include <winAnchor>
#Include <base>
#Include <Misc>
; SetTitleMatchMode(2)
; FindText().BindWindow(WinExist("ahk_exe Lönn.exe"), 4) ; Unbind Window using FindText().BindWindow(0)
if !WinExist("ahk_exe Lönn.exe")
  Suspend()
FindText().setStatic(["all"])
; star := "|<star>*132$8.tyT30873qvq"
#MaxThreads 2
#MaxThreadsPerHotkey 2
tabs := {
  placement: "|<placement tab>*153$62.zjzzzzzzzzkPzzzzzzzzQmzzzzzzzzrAgD7VUXkkM3/tanNaNgnQ6zPxmtatQrDg6z0iNULBnvRjrvaPxnQyqNgmtaNQnDg77ViNkrC8",
  rectangle: "|<rectangle tab>*154$59.zzzzzzzzry3zzvzzzzjwnzzrzzzzTtb3X13Uw6sHAqPTnAnBaUvZyzqtiPQBk/xsBnQq0NjrvrPathwvAangrAnNVn3Xl1iQ6sTzzzzzzzDzzzzzzzzgzzzzzzzzzXzz",
  line: "|<>*119$24.TjzzTzzzTg7VTgrBThnQThn0ThnTThnC0hnVU",
  brush: "|<brush tab>*150$33.zzzzvsDzzzTAzzzvtq5n31AniPNUCxnTQAriMPVmxntQCraP/U6y33QU",
  bucket: "|<bucket tab>*150$41.zzzyzzy3zzxzzRnzzvzyvqtlrQ87BnBhnPUvaz7iLSrByD0ixiPxCzRvAnPAmM71lrAC8",
  selection: "|<selection tab>*150$53.zzvzzzzzz3zrzzjTzwnzjzzTzzvz3QCA5lkHwqnNhvBaEvZiLvqtQwk/0jrhmtxjqzTjPZlnAgmPCnPYD3QCD5lr8",
  entities: "|<entities>*150$44.0zxvSzzrzzTrzzxz1Uc/VVTnBvSnPEBnSrhmxzQrhv0VTrBvSrz7xnCngmk3Qsi/VVU",
  triggers: "|<triggers>*150$48.0DTzzzzzvzzzzzzzvVQ71kkVvbNaNanhvjPatiLjvjPatULVvjPatjrwvjNaNaLgvjQ71krVzzzbtzzzzzvCnzzzzzwT7zzzU",
}
placements := {
  player: "|<player>*149$123.zjzzzzyTzzzzzzzzzzzzMBzzzzzrVzzzzzzsDyzxtAjzzzzwtbzzzzzzAzzzjdZVbAADbTkQAnMDta6kMAAjavBbxtyNwqPAzAaqNjUBymPZzjVnjqWPbsBmrBwDg7H0jxzaxUk3QzDiKtjVxiuvxzbwnhqAvbtxmrBwDhb7AjwvaNgtbQzDaqtbdxUwwBzr1kQ7Avbty6rABzzzjzzyTyzzzzzzzzzzzTzztzzzzzrzzzzzzzzzzzzzyTzzzzyzzzzzzzzzzzw",
  spikes: {
    left: "|<spikes left>*154$125.zzzjzzznzzszzzzzyzzzr3zvTzzzizzazzkzyxjzzorzyzzzyRzzBzyQzxvzzzfy3hr33wvy40TxwiEKkS73wnPQqrvrtgrzvtQrhaNiEvqlvZzrjr9jzrmtjPQrAwrhXkATjTUHTzjZnSqtUNxjPHjyTCzTazzT/axhnTlnAqnCgyRyRBtyQnBvPaRgC3hn33ys66QHz3kQKrC7Txzzzzzwzzzzjzzzzzzzxzvzzzzzzzzzzzzzzzzzzzzrzzzzzzzzzzzzzzzzzzz",
    right: "|<spikes right>*115$134.zzzjzzznzzzjzzzzzzrzzysTzPzzzxkRzvyzzkzyxjzzorzyzzzyRnzyzjznbzjTzzxTkRisMTbQr1UkTwwiEKkS73wnPQqrvrBaNazzT/axgnBm7SqDQjyw7PatjzrmtjPQrAwrhXkATjRqtiPzxwiPqrA3DhvORzntrBiPazzD/axhnTlnAqnAgyRvNatbDnaNbPQnBVkRiMMTrSL1iQHz3kQKrC7TxzzzzzwzzyTzxzzzzzzzzjzTzzzzzzzvDzzzzzzzzzzzzrzzzzzzzz7zzzzzzzzzzzs",
    up: "|<spikes up>*154$119.zzzjzzznzzzzzzzyzzzr3zvTzzziwzzzkzyxjzzorzyzzzyRtzzyQzxvzzzfy3hr33wvn1zxwiEKkS73wnPQqrvraNzvtQrhaNiEvqlvZzrjBvzrmtjPQrAwrhXkATjSPrzjZnSqtUNxjPHjyTCQrjzT/axhnTlnAqnCgyQvaNyQnBvPaRgC3hn33ywD1nz3kQKrC7Txzzzzzwzyzjzzzzzzzxzvzzzzzzzxzzzzzzzzzzzrzzzzzzzvzzzzzzzzzz",
    down: "|<spikes down>*153$136.zzzjzzznzzzzzzzzzzxzzzi7zqzzzzQ3zzzzzz3zvqzzzHTzvzzztrbzzzzznbzjTzzxTkRisMTbTQRakTzD/Y5g7VkzAqrBhyxwaqPAzxwiPqnAr8RvMxmzvrmtNhnzrmtjPQrAwrhXkATjT/YErDzT/axhn0nvSqbTwyRxiFbQzwwiPqrBz7AnPAmntraPaRnDnaNjPQnBVkRiMMTr0wSNrAzkw75hnVrzTzzzzzDzzzzzrzzzzzzzyzxzzzzzzzzzzzzzzzzzzzzzzrzzzzzzzzzzzzzzzzzzzzy"
  },
  touchswitch: "|<touch switch>*152$94.zzzzzzzjzzzzzzxzbz0Tzzyzz3zyrzryTzjzzzvztjzzTzTkzywRnXUzjnBcAQ40zvarAqNyTgqran87zitQrvbwCmPSzQkzyvZnTiTyMVhvxnPzviLBytzxXCrjr/rziPAnPbvbAvCPQzzywS3XiTkwniARm",
  touchgate: "|<switch gate>*150$135.zzzzzzzzTzzzzzztzzzzzzTDzVzzPzvzy7zjzzS7TzzzxtztbzzTzTz7TxzznaPzzzzi7zTaPEMsDtz31VyRy371sQ0DtynPSPAzTzBtjrbvnNaPY3zVqHPrvbvXxjQyy7StQrAkzza8PSzQzTMBs7ryPr/a1arzylbPrvbtvRjTyTvStQrwjTvbAvCPQz7PAtbniNnPaNjzzVtbQMvby31lVzS7X7QsRzzzzzzzzzzzzzzztzzzzzzQ",
  spinner: "|<spinner>*152$157.zzzzzzzzyzzzzzzzzzwzzzzzTxwzz3zzzTzTkzyzzzzzysDzzzjzSTyCzzzjzjnTzzzzzzyRnzzzrzi7zDkCEUVrvy3g71sMTCtQkUvVk0zjtrPPyPwzAqNaNgzjQiNnBat0zrxthxzhz3jPQrBmzrUrBvqrAkzvyyb6w6zwrhiPa1TvrvaxvM6PTwzTLtSvTzPqrBnTjwvxnSxhz/ryCjXgbNjrAnPataLyRyNjAqNjzzkrvksUrwC3hnQsPzizUrUvVrzzzzxzzzzzzTzzzzzznzzzrzzrzzzzwzzzzzzjzzzzzzzzzzvzzzzzzzwzzzzzzrzzzzzzzzzzxzzzk",
  dash: {
    1: "|<dash>*148$41.zzzzzXhnzkTyPPbzaTwyq7zAsEhU3yNanPEDw7Qaqkzti1BhhznByPOxzbNYqrzzCMNhc",
    2: "|<double dash>*122$125.zzzzzXhzDzzzzzzzyzzzrnzkTyPPyk7zzz0zzxzzzrbziTxyrtxzzzywzzvzzzi7zQsEhjrvgr7xxVkkS67E3ytarPTjrNgrvttjathyEDw7QiqzTinPbrnvTQr/wkzvi1RhyzQIrDjY76tUMthzrByvPxywniTTPjZnTwqxzjNpqrtxtbBywqP/aRNjzzSMPhjvvnD7w3UkrC67Tzzzzzzznzzzzzzzzzzzxk",
  },
  semisolid: "|<semisolid>*147$71.zzzzzzzTzzzyzzzzzs0zzzzxzzzzzyxzzzzvQkFkTxsC6CtqtaNaTvnAthnBnQnSzriPr/aPataxzjQriLArBnBvzStjQiNaPaNbyxnSPArUrAkTxvay71zzzzjzzzzzzzzzzzTzzzzzzyzzzyzzzzzzzz",
  heart: "|<>*157$92.zzzzzzzzyzzzzzzyTzVzzzjzjrrzzzTbzXjzzvzvxxzzzrkzty1m44CzTQAC003yzbRhjtjrqPtbS1zjvnPvzPw1iTPrkzvyyb6w6zTM46xxjyTjfwjRjrqzRjSxzXfsv9qPxxaKPnzzy6zC746zTQA6yDzzzzrzzzzzzzzzzzzzztzzzzzzzzzzzzzzwzzzzzzzzzzs",
  bubbles: {
    green: "|<green bubble>*120$108.zzzzzzzzzzyTzzzzzvtzsDzzzjzzyy7zzzzxtzvbzzzjzzwtvzzzzxkzvr7XV1VVxvz33VUx0DvaPBjjBbxvzCPBawUTsCtQjjQjxvXStQiQkzvqtQlj0jxvvS10iQqzvqtQwjTjxvvSzTiRjTvqPBgjCjwtvSRCiRzzsD7XVlVjyy7T3ViRzzzzzzzzzzyTzzzzzvU",
    red: "|<red bubble>*147$95.zzzzzzzzzzyTzzwrnzkTzzzTzzxkTztrbzaTzzyzzznaTzni7zCswQ8AADbAsQ703yNanPPnNzSNanCEDw7QiLriLyw7QiQkztqtQVj0jxti1QthznZmttSzTtnBytmxzbNgqmQmznbNYnjzz0sQACABzrCMQ7Tzzzzzzzzzzbzzzxk"
  }
}
blocks := {
  air: "|<starred air>*150$30.tzySztzyDzkzwCk0DwinUTxarkztarqzs6rjTnmrzznmrU",
  cement: "|<starred cement>*149$61.tzy7zzzzzvwzwRzzzzzxwDyTkkFsMA01zTnNaNgnS1zjvZnBmtjVzrw2ta1QrqztyzQnTiPrjwRAiNaLAzzzVkrAsPb4",
  core: "|<starred core>*150$41.tzy7zzznzlrzzz3zbwQA81zTnNnM7yziLiMTxzQj0qztytSzSzloqwnzzsQRwA",
  dirt: "|<starred dirt>*150$36.tzs7TrtzvnzrkzvvM00DvtNrUTvtPrkzvtPrqzvvPrjTvnPnzzs7PsU"
}
SaveLevel() {
  if !WinExist("ahk_exe Celeste.exe")
    return
  if WinGetTitle(WinExist("ahk_exe Lönn.exe"))[1] != "●"
    return
  SendDll("{shift up}^s")
  Sleep(1100)
}
#HotIf WinActive('ahk_exe celeste.exe')
  #SuspendExempt true
  ^f5::f22
  ^+f5::{
    SendDll("{numpad4}rz")
  }
  #SuspendExempt false
#HotIf WinActive('ahk_exe Lönn.exe')
  ^0::f24 ; loennextended hotkeys cause crashing so block creation
  ^+!LButton::{
    MouseGetPos(&x, &y, &win)
    if win != WinActive('ahk_exe Lönn.exe')
      return
    MouseGetPos(&startx, &starty)
    while (GetKeyState("LButton", "p")) {
    }
    BlockInput('on')
    MouseGetPos(&endx, &endy)
    c(tabs.line)
    ; c(blocks.air, tabs.line)
    ; sleep(100)
    click()
    ; sleep(100)
    MouseMove(endx, endy, 0)
    click("l", "d")
    mousemove(startx, starty, 0)
    Click("l", "u")
    c("|<>*129$80.tzsBzzy3zzzTzyTyzzzziTzzzzz3zjq67vq725kk0DvxbBytynbNgs7y3PrjUzhvqxT3zjqw3vr3SxULqzvxjTyxirjPxvryzPnzjPBvqTTzzjqy7sC3SxkrU",
      tabs.placement)
    mousemove(startx, starty, 0)
    click("l", "d")
    ; sleep(100)
    MouseMove(endx, endy, 0)
    ; sleep(100)
    click("l", "u")
    sleep(10)
    BlockInput("off")
  }
  ; blocks
  #SuspendExempt true
  ]::{
    suspend()
  }
  ; ~^s::{
  ;   if !WinExist("ahk_exe Celeste.exe")
  ;     return
  ;   Sleep(1000)
  ;   WinActivate("ahk_exe Celeste.exe")
  ;   Kex := "f5"
  ;   VK := Format("0x{:02X}", GetKeyVK(Kex))
  ;   SC := Format("0x{:03X}", GetKeySC(Kex))
  ;   sleep(300)
  ;   dllcall("keybd_event", "UChar", VK, "UChar", SC, "Uint", 0, "UPtr", 0)
  ;   sleep(200)
  ;   dllcall("keybd_event", "UChar", VK, "UChar", SC, "Uint", 2, "UPtr", 0)
  ;   ; Sleep(100)
  ;   ; WinActivate("ahk_exe Lönn.exe")
  ; }
  ^f5::{
    ; f23->ui up
    ; f24->del
    SaveLevel()
    WinActivate("ahk_exe Celeste.exe")
    Sleep(100)
    WinActivate("ahk_exe Celeste.exe")
    SendDll("{f5}", , 80)
    Sleep(800)
    SendDll("{Enter}{f24}", , 80)
  }
  ^+f5::{
    SaveLevel()
    WinActivate("ahk_exe Celeste.exe")
    Sleep(100)
    WinActivate("ahk_exe Celeste.exe")
    SendDll("{f5}", , 80)
    Sleep(800)
    SendDll("{numpad4}rz", , 100)
    ; SendDll("{numpad4}{Enter}{f23 2}{z 2}", , 100)
  }
  f5::{
    SaveLevel()
    WinActivate("ahk_exe Celeste.exe")
    Sleep(100)
    WinActivate("ahk_exe Celeste.exe")
    SendDll("q{f5}", , 100)
    ; SendDll("q{enter}{f24}{numpad4}{f5}", , 100)
    ; Sleep(1000)
    ; SendDll("{numpad0}", , 100)
  }
  #SuspendExempt false
  e::{
    c(blocks.air, tabs.rectangle)
  }
  1::{
    c(blocks.cement, tabs.rectangle)
  }
  2::{
    c(blocks.core, tabs.rectangle)
  }
  3::{
    c(blocks.dirt, tabs.rectangle)
  }
  ; tabs
  t::{
    c(tabs.placement)
    c(tabs.triggers)
  }
  r::{
    c(tabs.rectangle)
  }
  z::{
    c(tabs.selection)
  }
  l::{
    c(tabs.line)
  }
  b::{
    c(tabs.brush)
  }
  f::{
    c(tabs.bucket)
  }
  ; placement blocks
  h::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.semisolid)
  }
  c::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.touchswitch)
    c(placements.dash.1)
  }
  v::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.dash.2)
  }
  g::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.bubbles.green)
  }
  n::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.bubbles.red)
  }
  x::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.spinner)
  }
  i::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.touchswitch)
  }
  o::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.touchgate)
  }
  q::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.player)
  }

  w::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.spikes.up)
  }
  a::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.spikes.left)
  }
  s::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.spikes.down)
  }
  d::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.spikes.right)
  }
  m::{
    c(tabs.placement)
    c(tabs.entities)
    c(placements.heart)
  }
  c(text, tab1 := false) {
    MouseGetPos(&sx, &sy)
    ; startx := 0
    ; starty := 0
    ; if [tabs.OwnProps()*].map(e => tabs.%e%).includes(text) {
    ;   MouseGetPos(&startx, &starty)
    ;   getAnchorPos("ahk_exe Lönn.exe|913|967|956|998|br", &cx, &cy)
    ;   globalMouseMove(cx, cy)
    ;   click()
    ;   send("^{BackSpace 5}")
    ;   MouseMove(startx, starty, 0)
    ; }
    if tab1 {
      if (tryfind(text, &x, &y)) {
        DllCall("mouse_event", "uint", 0x0002 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
        DllCall("mouse_event", "uint", 0x0004 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
        ; doclick(x, y, 1, 0)
        MouseMove(sx, sy, 0)
        return true
      } else {
        if (tryfind(tab1, &x, &y)) {
          DllCall("mouse_event", "uint", 0x0002 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
          DllCall("mouse_event", "uint", 0x0004 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
          ; doclick(x, y, 1, 0)
          if (tryfind(text, &x, &y)) {
            DllCall("mouse_event", "uint", 0x0002 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
            DllCall("mouse_event", "uint", 0x0004 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
            ; doclick(x, y, 1, 0)
            MouseMove(sx, sy, 0)
            return true
          } else {
            MouseMove(sx, sy, 0)
            showfail()
            return false
          }
        }
      }
    }
    if (tryfind(text, &x, &y)) {
      DllCall("mouse_event", "uint", 0x0002 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
      DllCall("mouse_event", "uint", 0x0004 | 0x8000 | 0x001, "uint", rerange(x, 0, A_ScreenWidth, 0, 65535), "uint", rerange(y, 0, A_ScreenHeight, 0, 65535))
      MouseMove(sx, sy, 0)
      ; doclick(x, y, 1, 0)
      return true
    } else {
      ; MouseMove(startx, starty, 0)
      showfail()
      MouseMove(sx, sy, 0)
      return false
    }
  }
  showfail() {
    ToolTip("failed to find")
    SetTimer(ToolTip, -1000)
  }
  ; doclick(x, y, 1, 0) {
  ;   FindText().Click(x, y, "L")
  ;   MouseMove(startx, starty, 0)
  ; }
  ; tryfind(text, x, y) {
  ;   return FindText(x, y, 513 - 150000, 425 - 150000, 513 + 150000, 425 + 150000, 0, 0, text)
  ; }
