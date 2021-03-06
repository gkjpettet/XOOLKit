#tag Class
Protected Class ParseTests
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


	#tag Method, Flags = &h21, Description = 436F6D70617265732074776F204A534F4E2066696C657320746F20736565206966207468657920637265617465206571756976616C656E74206F626A656374732E
		Private Function CompareJSON(j1 As FolderItem, j2 As FolderItem) As Dictionary
		  /// Compares two JSON files to see if they create equivalent objects.
		  ///
		  /// Uses the open source `jd` tool:
		  /// https://github.com/josephburnett/jd#command-line-usage
		  ///
		  /// Thanks to StackOverflow: https://stackoverflow.com/a/40983522/278816
		  ///
		  /// Returns a dictionary with the following values:
		  /// "equal" : Boolean       // True if the JSON strings are considered equal.
		  /// "error" : Boolean       // True if an error occurred.
		  /// "errorMessage" : String // If an error occurred, this is the message. Otherwise set to ""
		  
		  Var data As New Dictionary
		  
		  // Sanity checks.
		  If j1 = Nil Or Not j1.Exists Then
		    data.Value("error") = "The first JSON file does not exist."
		    
		  ElseIf Not j1.IsReadable Then
		    data.Value("error") = "The first JSON file is not readable."
		    
		  ElseIf j2 = Nil Or Not j2.Exists Then
		    data.Value("error") = "The second JSON file does not exist."
		    
		  ElseIf Not j2.IsReadable Then
		    data.Value("error") = "The second JSON file is not readable."
		  End If
		  
		  // Get a reference to the `jd` tool.
		  Var jd As FolderItem = SpecialFolder.Resource("jd")
		  
		  // Compare the two files using `jd`. If there is no output then they are they same.
		  Var sh As New Shell
		  sh.ExecuteMode = Shell.ExecuteModes.Synchronous
		  sh.Execute("./" + jd.ShellPath + " " + j1.ShellPath + " " + j2.ShellPath)
		  
		  // Compare the files.
		  If sh.ExitCode <> 0 Then
		    data.Value("equal") = False
		    data.Value("error") = True
		    data.Value("errorMessage") = sh.Result
		    
		  ElseIf sh.Result = "" Then
		    data.Value("equal") = True
		    data.Value("error") = False
		    data.Value("errorMessage") = ""
		    
		  Else
		    data.Value("equal") = False
		    data.Value("error") = False
		    data.Value("errorMessage") = sh.Result
		  End If
		  
		  Return data
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example10Test()
		  // Multiline standard strings.
		  
		  Run(CurrentMethodName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example11Test()
		  // Top-level basic key-values.
		  
		  Run(CurrentMethodName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example12Test()
		  // Color testing.
		  //
		  // Example 12:
		  // ```
		  // # Color testing.
		  //
		  // c1 = &c123
		  // c2 = &cABCDEF
		  // c3 = &cABCDEF12
		  // ```
		  
		  Var d As Dictionary = ParseXOOL(EXAMPLE_12)
		  
		  Var c1 As Color = Color.FromString("&h00112233")
		  Var c2 As Color = Color.FromString("&h00ABCDEF")
		  Var c3 As Color = Color.FromString("&h12ABCDEF")
		  
		  Assert.AreEqual(d.Value("c1"), c1, "c1")
		  Assert.AreEqual(d.Value("c2"), c2, "c2")
		  Assert.AreEqual(d.Value("c3"), c3, "c3")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example13Test()
		  // Arrays.
		  
		  Run(CurrentMethodName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example14Test()
		  // Simple dictionaries.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example15Test()
		  // Inline dictionaries.
		  
		  Run(CurrentMethodName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example16Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example17Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example18Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example19Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example1Test()
		  // Empty XOOL document.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example20Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example21Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example22Test()
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example23Test()
		  // ColorGroup testing.
		  //
		  // Example 23:
		  // ```
		  // # ColorGroup testing.
		  // 
		  // red3Blue3 = &gF00 : 00F
		  // red3Blue6 = &gF00 : 0000FF
		  // red3Blue8 = &gF00 : 0000FF00
		  // 
		  // red6Blue3 = &gFF0000 : 00F
		  // red6Blue6 = &gFF0000 : 0000FF
		  // red6Blue8 = &gFF0000 : 0000FF00
		  // 
		  // red8Blue3 = &gFF000000 : 00F
		  // red8Blue6 = &gFF000000 : 0000FF
		  // red8Blue8 = &gFF000000 : 0000FF00
		  // ```
		  
		  Var d As Dictionary = ParseXOOL(EXAMPLE_23)
		  
		  Var red3Blue3 As ColorGroup = d.Value("red3Blue3")
		  Var tmpValues() As Color = red3Blue3.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red3Blue3")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red3Blue3")
		  
		  Var red3Blue6 As ColorGroup = d.Value("red3Blue6")
		  tmpValues = red3Blue6.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red3Blue6")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red3Blue6")
		  
		  Var red3Blue8 As ColorGroup = d.Value("red3Blue8")
		  tmpValues = red3Blue8.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red3Blue8")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red3Blue8")
		  
		  Var red6Blue3 As ColorGroup = d.Value("red6Blue3")
		  tmpValues = red6Blue3.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red6Blue3")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red6Blue3")
		  
		  Var red6Blue6 As ColorGroup = d.Value("red6Blue6")
		  tmpValues = red6Blue6.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red6Blue6")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red6Blue6")
		  
		  Var red6Blue8 As ColorGroup = d.Value("red6Blue8")
		  tmpValues = red6Blue8.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red6Blue8")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red6Blue8")
		  
		  Var red8Blue3 As ColorGroup = d.Value("red8Blue3")
		  tmpValues = red8Blue3.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red8Blue3")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red8Blue3")
		  
		  Var red8Blue6 As ColorGroup = d.Value("red8Blue6")
		  tmpValues = red8Blue6.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red8Blue6")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red8Blue6")
		  
		  Var red8Blue8 As ColorGroup = d.Value("red8Blue8")
		  tmpValues = red8Blue8.Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "red8Blue8")
		  Assert.AreEqual(tmpValues(1), Color.Blue, "red8Blue8")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example24Test()
		  // ColorGroup array testing.
		  //
		  // Example 24:
		  // ```
		  // # ColorGroups in arrays.
		  // 
		  // a = [&gF00 : 0F0, &g00F : FFFF0000] # redGreen, blueYellow
		  // ```
		  
		  Var d As Dictionary = ParseXOOL(EXAMPLE_24)
		  
		  Var a() As ColorGroup = d.Value("a")
		  
		  Var tmpValues() As Color = a(0).Values
		  Assert.AreEqual(tmpValues(0), Color.Red, "item 0")
		  Assert.AreEqual(tmpValues(1), Color.Green, "item 0")
		  
		  tmpValues = a(1).Values
		  Assert.AreEqual(tmpValues(0), Color.Blue, "item 1")
		  Assert.AreEqual(tmpValues(1), Color.Yellow, "item 1")
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example2Test()
		  // Single comment.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example3Test()
		  // Multiple comments.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example4Test()
		  // Single top level string key-value.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example5Test()
		  // Simple string key-value with an inline comment.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example6Test()
		  // A variety of string keys.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example7Test()
		  // Multiline raw strings.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example8Test()
		  // Comment between dictionary path and key-value pairs.
		  
		  Run(CurrentMethodName)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example9Test()
		  // String escape sequences.
		  
		  Run(CurrentMethodName)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4661696C73207468652063757272656E7420746573742E
		Private Sub FailTest(a As Assert, input As String, expectedJSON As String, actualJSON As String, data As Dictionary)
		  /// Fails the current test.
		  
		  a.Failed = True
		  a.Group.CurrentTestResult.Result = TestResult.Failed
		  
		  a.Group.CurrentTestResult.Input = input
		  a.Group.CurrentTestResult.Expected = expectedJSON
		  a.Group.CurrentTestResult.Actual = actualJSON
		  
		  If data <> Nil Then
		    a.Group.CurrentTestResult.Message = data.Lookup("errorMessage", "")
		  End If
		  
		  If a.Group.StopTestOnFail Then
		    #Pragma BreakOnExceptions False
		    Raise New XojoUnitTestFailedException
		    #Pragma BreakOnExceptions Default
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D61726B207468652074657374206173207061737365642E
		Private Sub PassTest(a As Assert, input As String, expectedJSON As String, actualJSON As String)
		  /// Mark the test as passed.
		  
		  If a.Group Is Nil Or a.Group.CurrentTestResult Is Nil Then Return
		  
		  a.Failed = False
		  If a.Group.CurrentTestResult.Result <> TestResult.Failed Then
		    a.Group.CurrentTestResult.Result = TestResult.Passed
		    a.Group.CurrentTestResult.Input = input
		    a.Group.CurrentTestResult.Actual = actualJSON
		    a.Group.CurrentTestResult.Expected = expectedJSON
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52756E7320616E2048544D4C2074657374206E616D6564205B6D6574686F644E616D655D2E
		Private Sub Run(methodName As String)
		  /// Runs a test named [methodName].
		  
		  // Get the number of the test to run.
		  Var testNumber As Integer = _
		  Integer.FromString(methodName.Replace("ParseTests.Example", "").Replace("Test", ""))
		  
		  // Get the names of the files containing the input XOOL and the corresponding JSON file.
		  Var xoolFileName As String = testNumber.ToString + ".xool"
		  Var jsonFileName As String = testNumber.ToString + ".json"
		  
		  // Get the input XOOL.
		  Var xool As String
		  Var xoolFile As FolderItem
		  Try
		    xoolFile = SpecialFolder.Resource("parse-xool").Child(xoolFileName)
		    Var tin As TextInputStream = TextInputStream.Open(xoolFile)
		    xool = tin.ReadAll
		    tin.Close
		  Catch e
		    Assert.Fail("Unable to load input XOOL file `" + xoolFileName + "`")
		    Return
		  End Try
		  
		  // Get the expected JSON file and string.
		  Var expectedJSONFile As FolderItem
		  Var expectedJSON As String
		  Try
		    expectedJSONFile = SpecialFolder.Resource("parse-json").Child(jsonFileName)
		    Var tin As TextInputStream = TextInputStream.Open(expectedJSONFile)
		    expectedJSON = tin.ReadAll
		    tin.Close
		  Catch e
		    Assert.Fail("Unable to load test result JSON file `" + jsonFileName + "`")
		    Return
		  End Try
		  
		  // Convert the XOOL to JSON.
		  Var actualJSON As String = XOOLKit.ToJSON(xool, True)
		  
		  // Write our JSON to a temp file.
		  Var actualJSONFile As FolderItem = SpecialFolder.Temporary.Child(System.Microseconds.ToString + ".json")
		  Try
		    Var tout As TextOutputStream = TextOutputStream.Create(actualJSONFile)
		    tout.Write(actualJSON)
		    tout.Close
		  Catch e
		    Assert.Fail("Unable to write XOOL JSON to temporary file.")
		    Return
		  End Try
		  
		  // Check if these two JSON files are considered equivalent.
		  Var data As Dictionary = CompareJSON(actualJSONFile, expectedJSONFile)
		  If data.Value("equal") = True Then
		    PassTest(Self.Assert, xool, expectedJSON, actualJSON)
		  Else
		    FailTest(Self.Assert, xool, expectedJSON, actualJSON, data)
		  End If
		  
		  Exception e As XOOLKit.XKException
		    Var s() As String
		    For Each tokErr As XOOLKit.XKTokeniserException In e.TokeniserErrors
		      s.Add("[line " + tokErr.LineNumber.ToString + "]: " + tokErr.Message)
		    Next tokErr
		    For Each parserErr As XOOLKit.XKParserException In e.ParserErrors
		      s.Add("[line " + parserErr.Location.LineNumber.ToString + "]: " + parserErr.Message)
		    Next parserErr
		    FailTest(Self.Assert, xool, expectedJSON, actualJSON, New Dictionary("errorMessage": String.FromArray(s, &u0A)))
		End Sub
	#tag EndMethod


	#tag Constant, Name = EXAMPLE_12, Type = String, Dynamic = False, Default = \"# Color testing.\n\nc1 \x3D &c123\nc2 \x3D &cABCDEF\nc3 \x3D &cABCDEF12", Scope = Private
	#tag EndConstant

	#tag Constant, Name = EXAMPLE_23, Type = String, Dynamic = False, Default = \"# ColorGroup testing.\n\nred3Blue3 \x3D &gF00 : 00F\nred3Blue6 \x3D &gF00 : 0000FF\nred3Blue8 \x3D &gF00 : 0000FF00\n\nred6Blue3 \x3D &gFF0000 : 00F\nred6Blue6 \x3D &gFF0000 : 0000FF\nred6Blue8 \x3D &gFF0000 : 0000FF00\n\nred8Blue3 \x3D &gFF000000 : 00F\nred8Blue6 \x3D &gFF000000 : 0000FF\nred8Blue8 \x3D &gFF000000 : 0000FF00", Scope = Private
	#tag EndConstant

	#tag Constant, Name = EXAMPLE_24, Type = String, Dynamic = False, Default = \"# ColorGroups in arrays.\n\na \x3D [&gF00 : 0F0\x2C &g00F : FFFF0000] # redGreen\x2C blueYellow", Scope = Private
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
