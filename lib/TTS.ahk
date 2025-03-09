#Requires Autohotkey v2.0
#SingleInstance force
#Include <base>
; Persistent

class TTS {
  static SpVoice := ComObject("SAPI.SpVoice")
  ; static done := 1

  /**
   * says text
   * @param text text to say
   * @param {Integer} speed speed
   * @param {Integer} vol volume
   * @param {Integer} pitch pitch
   * @param {Integer} async return instantly instead of waiting fot the text to be done speeking
   */
  static say(text, speed := 4, vol := 100, pitch := 0, async := 1) {
    async := async ? 0x1 : 0x2
    this.stop()
    this.SpVoice.rate := speed
    text := "<rate absspeed='" . speed .
      "'/><volume level='" . vol .
      "'/><pitch absmiddle='" . pitch .
      "'/>" .
      text
      .replace("&", "&amp;")
      .replace("<", "&lt;")
      .replace(">", "&gt;")

    ; this.done := 0

    this.SpVoice.Speak(text, async)

    ; this.done := 1

  }

  /**
   * stops speech
   */
  static stop() {
    this.SpVoice.Speak("")
  }

  /**
   * resumes speech
   */
  static play() {
    this.SpVoice.Resume()
  }

  /**
   * resumes speech
   */
  static resume() {
    this.SpVoice.Resume()
  }

  /**
   * pauses speech
   */
  static pause() {
    this.SpVoice.Pause()
  }
}

; class TTS {
;   GetAudioOutputs() {
;     AudioOutputList := []
;     Loop SpVoice.GetAudioOutputs.Count {
;       Description := SpVoice.GetAudioOutputs.Item(A_Index - 1).GetDescription
;       AudioOutputList.Push(Description)
;     }
;     Return AudioOutputList
;   }
;   GetCurrentAudioOutput() {
;     Return SpVoice.AudioOutput.GetDescription
;   }
;   SetCurrentAudioOutput(AudioOutputDescription) {
;     If (this.GetCurrentAudioOutput() != AudioOutputDescription) {
;       Loop SpVoice.GetAudioOutputs.Count {
;         AudioOutputObject := SpVoice.GetAudioOutputs.Item(A_Index - 1)
;         Description := AudioOutputObject.GetDescription
;         If (Description == AudioOutputDescription) {
;           SpVoice.AudioOutput := AudioOutputObject
;           Break
;         }
;       }
;     }
;   }
;   GetAudioVoices() {
;     AudioVoiceList := []
;     Loop SpVoice.GetVoices.Count {
;       Description := SpVoice.GetVoices.Item(A_Index - 1).GetDescription
;       AudioVoiceList.Push(Description)
;     }
;     Return AudioVoiceList
;   }
;   GetCurrentAudioVoice() {
;     Return SpVoice.Voice.GetDescription
;   }
;   SetCurrentAudioVoice(AudioVoiceDescription) {
;     If (this.GetCurrentAudioVoice() != AudioVoiceDescription) {
;       Loop SpVoice.GetVoices.Count {
;         VoiceObject := SpVoice.GetVoices.Item(A_Index - 1)
;         Description := VoiceObject.GetDescription
;         If (Description == AudioVoiceDescription) {
;           SpVoice.Voice := VoiceObject
;           Break
;         }
;       }
;     }
;   }
;   PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch) {
;     Return "<rate absspeed='" . AudioRate .
;       "'/><volume level='" . AudioVolume .
;       "'/><pitch absmiddle='" . AudioPitch .
;       "'/>" .
;       TextContent
;       .replace("&", "&amp;")
;       .replace("<", "&lt;")
;       .replace(">", "&gt;")
;   }
;   PrepareAudioText(TextContent) {
;     Return "<?xml version='1.0' encoding='ISO-8859-1'?><speak version='1.0' xml:lang='en-US'><audio src='" .
;     TextContent
;       .replace("&", "&amp;")
;       .replace("<", "&lt;")
;       .replace(">", "&gt;") .
;       "'></audio></speak>"
;   }
;   say(TextContent, AudioRate, AudioVolume, AudioPitch) {
;     SpVoice.Speak("",  0x2)
;     If (FileExist(TextContent) && RegExMatch(TextContent, "i)\.wav$")) {
;       TextContent := this.PrepareAudioText(TextContent)
;     }
;     Else {
;       TextContent := this.PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch)
;     }
;     Try {
;       SpVoice.Speak(TextContent,  0x2)
;     }
;     Catch {
;       SpVoice.Speak("error parsing text",  0x2)
;     }
;   }
;   SpeakToFile(TextContent, AudioRate, AudioVolume, AudioPitch, OutputFile) {
;     OriginalOutputStream := SpVoice.AudioOutputStream
;     OriginalOutputFormat := SpVoice.AllowAudioOutputFormatChangesOnNextSet
;     SpVoice.AllowAudioOutputFormatChangesOnNextSet := 1
;     SpStream := ComObject("SAPI.SpFileStream")
;     SpStream.Open(OutputFile, 3)
;     SpVoice.AudioOutputStream := SpStream
;     TextContent := this.PrepareSpeechText(TextContent, AudioRate, AudioVolume, AudioPitch)
;     SpVoice.Speak(TextContent, 0x0)
;     SpStream.Close()
;     SpVoice.AudioOutputStream := OriginalOutputStream
;     SpVoice.AllowAudioOutputFormatChangesOnNextSet := OriginalOutputFormat
;   }
; }
; CacheDir := "_cache"
; WatcherExeName := "AHKTTSWatcher.exe"
; TTSInstance := TTS()
; ; DirCreate(CacheDir)
; TTSInstance.
; FileWatcherArg := "`"" . WatcherExeName . "`" " "`"" . CacheDir . "/bridge.txt`""
; while WinExist("ahk_exe " WatcherExeName)
;   WinClose("ahk_exe " WatcherExeName)
; WinWaitClose("ahk_exe " WatcherExeName)
; Run(FileWatcherArg, , "Hide", &FileWatcherPID)
; SendAudioTextToWatcher(TTSInstance.GetAudioOutputs()[1],
;   TTSInstance.GetAudioVoices()[1],
;   "<AudioText>"
;   .replace("&", "&amp;")
;   .replace("<", "&lt;")
;   .replace(">", "&gt;"),
;   3,
;   100,
;   0)

; SendAudioTextToWatcher(AudioOutput, AudioVoice, AudioText, AudioRate, AudioVolume, AudioPitch) {
;   global CacheDir, TTSInstance
;   DeleteOldSpeechGlob := CacheDir . "\*.wav"
;   if FileExist(DeleteOldSpeechGlob)
;     FileDelete(DeleteOldSpeechGlob)
;   SpeechPath := CacheDir . "/" . A_Now . ".wav"
;   TTSInstance.SetCurrentAudioVoice(AudioVoice)
;   TTSInstance.SpeakToFile(AudioText, AudioRate, AudioVolume, AudioPitch, SpeechPath)
;   AudioText := SpeechPath
;   AudioVolume := "1" ;media duck
;   FilePointer := FileOpen(CacheDir . "/bridge.txt", "w")
;   If (FileExist(AudioText)) {
;     FilePointer.WriteLine(AudioOutput)
;     FilePointer.WriteLine(AudioText)
;     FilePointer.WriteLine(AudioVolume)
;   }
;   FilePointer.Close()
; }
