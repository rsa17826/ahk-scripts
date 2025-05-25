#Requires AutoHotkey v2.0
#SingleInstance Force

#Include *i <AutoThemed>

try TraySetIcon("icon.ico")
SetWorkingDir(A_ScriptDir)
#Include *i <vars>

#Include <Misc>

root := JSON.parse(f.read("./butler.jsonc"), 0, 0)

commands := []
for game in root.games {
  print(game)
  for build in game.builds {
    cmd := '"' root.exe "`" push --if-changed `"" build.path "`" `"" root.name "/" game.name ":" build.channel '"'
    if build.HasProp("ignore")
      for ignore in build.ignore {
        cmd .= " --ignore " ignore
      }
    print(cmd)

    commands.push([
      cmd,
      game.name ":" build.channel
    ])
  }
}
print(commands)
c := ''
for command in commands {
  cmd := root.pauseCommandOnComplete ? "cmd /c `"" command[1] " & pause`"" : "cmd /c `"" command[1] "`""
  if root.allAtOnce
    run(cmd, , root.cmdState)
  else
    c .= "echo UPLOADING: `"" command[2] "`"!!! & "
  c .= command[1] " & "
}
c .= "echo done"
if not root.allAtOnce
  RunWait(root.pauseCommandOnComplete ? "cmd /c `"" c " & pause`"" : "cmd /c `"" c "`"", , root.cmdState)
