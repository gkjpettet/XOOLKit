#tag Class
Protected Class GenerateTests
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


	#tag Method, Flags = &h0
		Sub Example10Test()
		  // Color Groups.
		  
		  Var d As New Dictionary( _
		  "redBlue" : New ColorGroup(Color.Red, Color.Blue), _
		  "greenYellow" : New ColorGroup(Color.Green, Color.Yellow), _
		  "magentaOnly" : New ColorGroup(Color.Magenta))
		  
		  Run(CurrentMethodName, d)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example1Test()
		  // Strings.
		  
		  Var d As New Dictionary
		  d.Value("s1") = "Hello world"
		  d.Value("s2") = "Hello" + EndOfLine + "world"
		  d.Value("s3") = "A double quote: """
		  d.Value("s4") = "Backslash \"
		  d.Value("s5") = &u09 + &u08 + &u1B
		  
		  Run(CurrentMethodName, d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example2Test()
		  // Booleans.
		  
		  Run(CurrentMethodName, New Dictionary("b1" : True, "b2": False))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example3Test()
		  // Numbers.
		  
		  Var d As New Dictionary( _
		  "n1" : 1, _
		  "n2" : -10, _
		  "n3" : -3.4, _
		  "n4" : 1.5, _
		  "n5" : 2e-1)
		  
		  Run(CurrentMethodName, d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example4Test()
		  // Colors.
		  
		  Var d As New Dictionary( _
		  "red" : Color.Red, _
		  "green" : Color.Green, _
		  "blue" : Color.Blue, _
		  "pink" : Color.FromString("&h32FF84FF"))
		  
		  Run(CurrentMethodName, d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example5Test()
		  Run(CurrentMethodName, New Dictionary("value" : Nil))
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example6Test()
		  Var d As New Dictionary("d1" : New DateTime(2022, 2, 5, 17, 09, 15))
		  
		  Run(CurrentMethodName, d)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example7Test()
		  Var d As New Dictionary
		  d.Value("a1") = Array(1, 2, 3)
		  d.Value("a2") = Array("a", "b", "c")
		  d.Value("a3") = Array(True, False)
		  
		  Var a4() As Variant
		  a4.Add(Nil)
		  a4.Add(10)
		  d.Value("a4") = a4
		  
		  Run(CurrentMethodName, d)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example8Test()
		  Var contacts As New Dictionary
		  
		  Var garry As New Dictionary("name" : "Garry", "age" : 40)
		  garry.Value("school") = New Dictionary("name" : "Imperial College")
		  
		  Var fi As New Dictionary("name" : "Fiona", "age" : 39)
		  fi.Value("school") = New Dictionary("name" : "Edinburgh University")
		  
		  Var tony As New Dictionary("name" : "Tony", "age" : 50)
		  tony.Value("school") = New Dictionary("name" : "MIT")
		  
		  contacts.Value("garry") = garry
		  contacts.Value("fi") = fi
		  contacts.Value("tony") = tony
		  
		  Run(CurrentMethodName, contacts)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Example9Test()
		  Var contacts As New Dictionary
		  
		  Var garry As New SerializableContact("Garry", 40)
		  Var fi As New SerializableContact("Fiona", 39)
		  Var tony As New SerializableContact("Tony", 50)
		  
		  contacts.Value("garry") = garry
		  contacts.Value("fi") = fi
		  contacts.Value("tony") = tony
		  
		  Run(CurrentMethodName, contacts)
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4661696C73207468652063757272656E7420746573742E
		Private Sub FailTest(a As Assert, expected As String, actual As String)
		  /// Fails the current test.
		  
		  a.Failed = True
		  a.Group.CurrentTestResult.Result = TestResult.Failed
		  
		  a.Group.CurrentTestResult.Input = ""
		  a.Group.CurrentTestResult.Expected = expected
		  a.Group.CurrentTestResult.Actual = actual
		  
		  If a.Group.StopTestOnFail Then
		    #Pragma BreakOnExceptions False
		    Raise New XojoUnitTestFailedException
		    #Pragma BreakOnExceptions Default
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4765742074686520657870656374656420584F4F4C20666F722060746573744E756D626572602E204D617920726169736520616E2060494F457863657074696F6E602E
		Private Function GetExpectedXOOL(testNumber As Integer) As String
		  /// Get the expected XOOL for `testNumber`. May raise an `IOException`.
		  
		  #Pragma BreakOnExceptions False
		  
		  Var xool As String
		  Var xoolFile As FolderItem
		  
		  xoolFile = SpecialFolder.Resource("generate-xool").Child(testNumber.ToString + ".xool")
		  Var tin As TextInputStream = TextInputStream.Open(xoolFile)
		  xool = tin.ReadAll
		  tin.Close
		  
		  Return xool
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 4D61726B207468652074657374206173207061737365642E
		Private Sub PassTest(a As Assert, expected As String, actual As String)
		  /// Mark the test as passed.
		  
		  If a.Group Is Nil Or a.Group.CurrentTestResult Is Nil Then Return
		  
		  a.Failed = False
		  If a.Group.CurrentTestResult.Result <> TestResult.Failed Then
		    a.Group.CurrentTestResult.Result = TestResult.Passed
		    a.Group.CurrentTestResult.Input = ""
		    a.Group.CurrentTestResult.Actual = actual
		    a.Group.CurrentTestResult.Expected = expected
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52756E732074686520737065636966696564207465737420616761696E737420746865207061737365642076616C75652E
		Private Sub Run(methodName As String, v As Variant)
		  /// Runs the specified test against the passed value.
		  
		  // Get the number of the test to run.
		  Var testNumber As Integer = _
		  Integer.FromString(methodName.Replace("GenerateTests.Example", "").Replace("Test", ""))
		  
		  Var expected As String = GetExpectedXOOL(testNumber)
		  
		  Var actual As String = GenerateXOOL(v)
		  
		  If actual = expected Then
		    PassTest(Self.Assert, expected, actual)
		  Else
		    FailTest(Self.Assert, expected, actual)
		  End If
		  
		  Exception e
		    FailTest(Self.Assert, expected, actual)
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
