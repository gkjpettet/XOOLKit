#tag Class
Protected Class ExpectedFailureTests
Inherits TestGroup
	#tag Event
		Sub Setup()
		  
		End Sub
	#tag EndEvent

	#tag Event
		Function UnhandledException(err As RuntimeException, methodName As String) As Boolean
		  #pragma unused err
		  
		  Const kMethodName As Text = "UnhandledException"
		  
		  If methodName.Length >= kMethodName.Length And methodName.Left(kMethodName.Length) = kMethodName Then
		    Assert.Pass("Exception was handled")
		    Return True
		  End If
		End Function
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub DidntFail(a As Assert, xool As String, message As String)
		  a.Failed = True
		  a.Group.CurrentTestResult.Result = TestResult.Failed
		  
		  a.Group.CurrentTestResult.Input = xool
		  a.Group.CurrentTestResult.Expected = ""
		  a.Group.CurrentTestResult.Actual = ""
		  a.Group.CurrentTestResult.Message = message
		  
		  If a.Group.StopTestOnFail Then
		    #Pragma BreakOnExceptions False
		    Raise New XojoUnitTestFailedException
		    #Pragma BreakOnExceptions Default
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example1Test()
		  ExpectFail(CurrentMethodName, "A value is required.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example2Test()
		  ExpectFail(CurrentMethodName, "Keys must be on their own line.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example3Test()
		  ExpectFail(CurrentMethodName, "Keys cannot be empty.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example4Test()
		  ExpectFail(CurrentMethodName, "Cannot redefine keys within the same dictionary.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example5Test()
		  ExpectFail(CurrentMethodName, "Cannot change the type of an already defined key.")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52756E7320612074657374207468617420697320657870656374656420746F206661696C2E
		Private Sub ExpectFail(methodName As String, message As String)
		  /// Runs a test that is expected to fail.
		  
		  // Get the number of the test to run.
		  Var testNumber As Integer = _
		  Integer.FromString(methodName.Replace("ExpectedFailureTests.Example", "").Replace("Test", ""))
		  
		  // Get the names of the files containing the input XOOL.
		  Var xoolFileName As String = testNumber.ToString + ".xool"
		  
		  // Get the input XOOL.
		  Var xool As String
		  Var xoolFile As FolderItem
		  Try
		    xoolFile = SpecialFolder.Resource("expected-failures").Child(xoolFileName)
		    Var tin As TextInputStream = TextInputStream.Open(xoolFile)
		    xool = tin.ReadAll
		    tin.Close
		  Catch e
		    Assert.Fail("Unable to load input XOOL file `" + xoolFileName + "`")
		    Return
		  End Try
		  
		  // Try to parse the XOOL. It should fail.
		  Var d As Dictionary
		  #Pragma BreakOnExceptions False
		  Try
		    d = ParseXOOL(xool)
		    DidntFail(Self.Assert, xool, message)
		  Catch e As XOOLKit.XKException
		    Var s() As String
		    For Each tokErr As XOOLKit.XKTokeniserException In e.TokeniserErrors
		      s.Add(tokErr.Message)
		    Next tokErr
		    For Each parserErr As XOOLKit.XKParserException In e.ParserErrors
		      s.Add(parserErr.Message)
		    Next parserErr
		    SuccessfullyFailed(Self.Assert, xool, String.FromArray(s, &u0A))
		  End Try
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub SuccessfullyFailed(a As Assert, xool As String, message As String)
		  /// Mark the test as passed.
		  
		  If a.Group Is Nil Or a.Group.CurrentTestResult Is Nil Then Return
		  
		  a.Failed = False
		  If a.Group.CurrentTestResult.Result <> TestResult.Failed Then
		    a.Group.CurrentTestResult.Result = TestResult.Passed
		    a.Group.CurrentTestResult.Input = xool
		    a.Group.CurrentTestResult.Actual = ""
		    a.Group.CurrentTestResult.Expected = ""
		    a.Group.CurrentTestResult.Message = message
		  End If
		  
		End Sub
	#tag EndMethod


	#tag Constant, Name = EXAMPLE_12, Type = String, Dynamic = False, Default = \"# Color testing.\n\nc1 \x3D &c123\nc2 \x3D &cABCDEF\nc3 \x3D &cABCDEF12", Scope = Private
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Duration"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Double"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="FailedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IncludeGroup"
			Visible=false
			Group="Behavior"
			InitialValue="True"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="IsRunning"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="NotImplementedCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PassedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="RunTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="SkippedTestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="StopTestOnFail"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="TestCount"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
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
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
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
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
