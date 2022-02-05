#tag BuildAutomation
			Begin BuildStepList Linux
				Begin BuildProjectStep Build
				End
			End
			Begin BuildStepList Mac OS X
				Begin BuildProjectStep Build
				End
				Begin CopyFilesBuildStep CopyTestFilesMac
					AppliesTo = 0
					Architecture = 0
					Destination = 1
					Subdirectory = 
					FolderItem = Li4vLi4vLi4vdGVzdHMvcGFyc2UteG9vbC8=
					FolderItem = Li4vLi4vLi4vdGVzdHMvcGFyc2UtanNvbi8=
					FolderItem = Li4vLi4vLi4vcmVzb3VyY2VzL2pkL21hY09TL2pk
					FolderItem = Li4vLi4vLi4vdGVzdHMvZ2VuZXJhdGUteG9vbC8=
				End
			End
			Begin BuildStepList Windows
				Begin BuildProjectStep Build
				End
			End
#tag EndBuildAutomation
