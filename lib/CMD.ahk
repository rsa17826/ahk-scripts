#Requires AutoHotkey v2.0
#SingleInstance Force

; must include
SetWorkingDir(A_ScriptDir)
#Include <vars>
DetectHiddenWindows(True)
Run(A_ComSpec, , "Hide", &cmdpid)
WinWait("ahk_pid " cmdpid)
cmd.start()
class cmd {
  /**
   * doesnt return output but doesnt wait until done
   * @param cmd cmd to run
   */
  static runAsync(cmd, opts := "hide") {
    this.stop()
    run("cmd /c `"" cmd "`"", this.shell.CurrentDirectory, opts)
    this.start()
  }
  static stop() => DllCall("kernel32.dll\FreeConsole")
  static start() => DllCall("kernel32.dll\AttachConsole", "UInt", cmdpid)
  static shell := ComObject("WScript.Shell")
  static setWorkingDir(dir := A_WorkingDir) {
    this.shell.CurrentDirectory := dir
  }

  static shell.CurrentDirectory := A_WorkingDir

  /**
   * returns the result or the error
   */
  static result => this.val || this.err

  /**
   * returns the output value if one
   */
  static val => Trim(this.RunningCommand.StdOut.ReadAll(), "`r`n`t ")

  /**
   * reutrns the error if one
   */
  static err => Trim(this.RunningCommand.StdErr.ReadAll(), "`r`n`t ")

  /**
   * 
   * @param commands list of commands to run
   * @returns {typeof cmd} this
   */
  static run(commands*) => this.exec(commands*)

  /**
   * 
   * @param commands list of commands to run
   * @returns {typeof cmd} this
   */
  static exec(commands*) {
    commandString := ""
    for index, command in commands {
      if index = commands.Length {
        commandString .= command
        break
      }
      commandString .= command " && "
    }
    this.RunningCommand := this.shell.Exec(A_ComSpec " /C " commandString)
    return this.result
  }

  RunningCommand := unset

  /**
   * @param with *String* The program to use to run something with: either Program.exe format, or the full path to the executable
   * @param runFile *String* The path to the file (or link!) you want to run
   */
  static RunWith(with, runFile) => run(with ' "' runFile '"')

}
