#tag Module
Protected Module AppimageHandler
	#tag Method, Flags = &h0
		Sub BuildImageDirectory()
		  Var binDir As Folderitem= Utils.CreateFolderStructure(_
		  App.executableLocation.Parent,App.programName+".AppDir/usr/bin/")
		  
		  App.appDirFolder= App.executableLocation.parent.child(App.programName+".AppDir")
		  
		  App.executableLocation.CopyTo(binDir)
		  App.executableLocation.Parent.Child(App.executableLocation.Name+" Libs").CopyTo(binDir)
		  If(App.executableLocation.Parent.Child(App.executableLocation.Name+" Resources").Exists) Then
		    App.executableLocation.Parent.Child(App.executableLocation.Name+" Resources").CopyTo(binDir)
		  End
		  
		  // Create .desktop file for inner program
		  Var desktopContents As String="[Desktop Entry]" + EndOfLine +_
		  "Name=" + App.programName + EndOfLine +_
		  "Exec=" + App.programName + EndOfLine +_
		  "Type=Application" + EndOfLine +_
		  "Terminal=" + App.programTerminal.ToString.Lowercase + EndOfLine +_
		  "Icon=" + App.programIcon.Name.Replace(".png","") + EndOfLine +_
		  "Categories=" + App.programCategory + EndOfLine
		  // System.DebugLog(App.appDirFolder.Child(App.programName+".desktop").NativePath)
		  Utils.WriteFile(App.appDirFolder.Child(App.programName+".desktop"), desktopContents, True)
		  
		  // Create script to open inner program
		  Var runScript As String="#!/bin/sh" + EndOfLine +_
		  "HERE=""$(dirname ""$(readlink -f ""${0}"")"")""" + EndOfLine +_
		  "EXEC=""${HERE}/usr/bin/" + App.programName + """" + EndOfLine +_
		  "exec ""${EXEC}"""
		  // System.DebugLog(App.appDirFolder.Child("AppRun").NativePath)
		  App.resourcesFolder.Child("AppRun").CopyTo(App.appDirFolder)
		  Utils.WriteFile(App.appDirFolder.Child("AppRun"), runScript, True)
		  
		  // Copy Icon to appDir
		  If(App.programIcon.Parent.NativePath<>App.appDirFolder.NativePath) Then
		    App.programIcon.CopyTo(App.appDirFolder)
		  End
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CheckForImage()
		  If(SpecialFolder.CurrentWorkingDirectory.Child(App.programName+"-x86_64.AppImage").exists) Then
		    Utils.ErrorHandler(1,"Success!","The AppImage seems to be created! Please validate before distributing.")
		  Else
		    Utils.ErrorHandler(3,"Something Failed...","The AppImage was not found in user home.")
		  End
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub CreateAppImage()
		  System.DebugLog("ARCH="+ App.programArchitecture +_
		  " """ + App.resourcesFolder.Child("appimagetool.AppImage").NativePath + """ " +_
		  """" + App.appDirFolder.NativePath + """")
		  
		  Utils.ShellCommand("ARCH="+ App.programArchitecture +_
		  " """ + App.resourcesFolder.Child("appimagetool.AppImage").NativePath + """ " +_
		  """" + App.appDirFolder.NativePath + """")
		  
		  
		  
		End Sub
	#tag EndMethod


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
