#tag Module
Protected Module XOOLKit
	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F6620616E206172726179206F66206172726179732E204D617920726169736520616E2060584B457863657074696F6E602E
		Private Function ArrayOfArraysToXOOL(values() As Variant) As String
		  /// Returns a XOOL representation of an array of arrays. May raise an `XKException`.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each v As Variant In values
		    s.Add(ArrayToXOOL(v))
		    s.Add(", ")
		  Next v
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F66206172726179206061602E204D617920726169736520612060584B457863657074696F6E602E
		Private Function ArrayToXOOL(a As Variant) As String
		  /// Returns a XOOL representation of array `a`. May raise a `XKException`.
		  ///
		  /// Assumes `a` is definitely an array.
		  
		  Select Case a.ArrayElementType
		  Case Variant.TypeArray
		    Return ArrayOfArraysToXOOL(a)
		    
		  Case Variant.TypeObject
		    #Pragma BreakOnExceptions False
		    Try
		      Return DictionaryArrayToXOOL(a)
		    Catch e1 As TypeMismatchException
		      Try
		        Return SerializableArrayToXOOL(a)
		      Catch e2 As TypeMismatchException
		        Try
		          Return ObjectArrayToXOOL(a)
		        Catch e3 As TypeMismatchException
		          Try
		            Return ArrayOfArraysToXOOL(a)
		          Catch e4 As TypeMismatchException
		            Raise New XOOLKit.XKException("Unable to serialize array.")
		          End Try
		        End Try
		      End Try
		    End Try
		    
		  Case Variant.TypeBoolean
		    Return BooleanArrayToXOOL(a)
		    
		  Case Variant.TypeColor
		    Return ColorArrayToXOOL(a)
		    
		  Case Variant.TypeDateTime
		    Return DateTimeArrayToXOOL(a)
		    
		  Case Variant.TypeDouble
		    Return DoubleArrayToXOOL(a)
		    
		  Case Variant.TypeInt32, Variant.TypeInt64
		    Return IntegerArrayToXOOL(a)
		    
		  Case Variant.TypeString, Variant.TypeText
		    Return StringArrayToXOOL(a)
		    
		  Else
		    Raise New XOOLKit.XKException("Unable to convert array to XOOL representation.")
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function BooleanArrayToXOOL(booleans() As Boolean) As String
		  // Returns a XOOL representation of a boolean array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each b As Boolean In booleans
		    s.Add(GenerateXOOL(b))
		    s.Add(", ")
		  Next b
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ColorArrayToXOOL(colors() As Color) As String
		  // Returns a XOOL representation of a color array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each c As Color In colors
		    s.Add(GenerateXOOL(c))
		    s.Add(", ")
		  Next c
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F66206063602E
		Private Function ColorToXOOL(c As Color) As String
		  /// Returns a XOOL representation of `c`.
		  ///
		  /// XOOL color format: &cRRGGBBAA
		  /// Xojo color format: &hAARRGGBB
		  
		  Var s As String = c.ToString
		  
		  Return "&c" + s.Right(6) + s.Middle(2, 2)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DateTimeArrayToXOOL(dts() As DateTime) As String
		  // Returns a XOOL representation of a DateTime array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each dt As DateTime In dts
		    s.Add(GenerateXOOL(dt))
		    s.Add(", ")
		  Next dt
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DictionaryArrayToXOOL(dicts() As Dictionary) As String
		  // Returns a XOOL representation of an array of dictionaries. May raise a `XKException`.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each d As Dictionary In dicts
		    s.Add(InlineDictionary(d))
		    s.Add(", ")
		  Next d
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F66206064602E20607061746860206973207468652066756C6C207061746820746F20746869732064696374696F6E61727920696E2074686520666F726D2060706174682E6B6579602E
		Private Function DictionaryToXOOL(d As Dictionary, path As String) As String
		  /// Returns a XOOL representation of `d`. `path` is the full path to this dictionary in the form `path.key`.
		  
		  If d.KeyCount = 0 Then Return ""
		  
		  Var s() As String
		  Var keyDict() As Pair // Key : Dictionary
		  
		  If path <> "" Then s.Add(&u0A + "[" + path + "]")
		  
		  For Each entry As DictionaryEntry In d
		    // Only string keys are supported.
		    If entry.Key.Type <> Variant.TypeString Then
		      Raise New XOOLKit.XKException("Dictionary keys must be strings.")
		    End If
		    
		    If entry.Value IsA Dictionary Then
		      If path <> "" Then
		        keyDict.Add(path + "." + entry.Key : entry.Value)
		      Else
		        keyDict.Add(entry.Key : entry.Value)
		      End If
		      
		    Else
		      s.Add(entry.Key + " = " + GenerateXOOL(entry.Value))
		    End If
		  Next entry
		  
		  For Each p As Pair In keyDict
		    s.Add(DictionaryToXOOL(p.Right, p.Left))
		  Next p
		  
		  Return String.FromArray(s, &u0A)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function DoubleArrayToXOOL(doubles() As Double) As String
		  // Returns a XOOL representation of a double array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each d As Double In doubles
		    s.Add(GenerateXOOL(d))
		    s.Add(", ")
		  Next d
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 436F6E766572747320612076616C756520746F2069747320584F4F4C20726570726573656E746174696F6E2E204F6E6C792064696374696F6E617269657320726573756C7420696E20612076616C696420584F4F4C20646F63756D656E742E204D617920726169736520616E2060584B457863657074696F6E602E
		Function GenerateXOOL(value As Variant) As String
		  /// Converts a value to its XOOL representation. Only dictionaries result in a valid XOOL document.
		  /// May raise an `XKException`.
		  
		  If value IsA Dictionary Then
		    Return DictionaryToXOOL(value, "").Trim
		    
		  ElseIf value IsA XOOLKit.XKSerializable Then
		    Return XOOLKit.XKSerializable(value).ToInlineDictionary
		    
		  ElseIf value.IsArray Then
		    Return ArrayToXOOL(value)
		    
		  Else
		    Select Case value.Type
		    Case Variant.TypeBoolean
		      Return If(value, "True", "False")
		      
		    Case Variant.TypeColor
		      Return ColorToXOOL(value)
		      
		    Case Variant.TypeDateTime
		      Return DateTime(value).SQLDateTime
		      
		    Case Variant.TypeDouble
		      Return value.DoubleValue.ToString
		      
		    Case Variant.TypeInt32
		      Return value.Int32Value.ToString
		      
		    Case Variant.TypeInt64
		      Return value.Int64Value.ToString
		      
		    Case Variant.TypeNil
		      Return "Nil"
		      
		    Case Variant.TypeString, Variant.TypeText
		      Return StringToXOOL(value)
		      
		    Else
		      Raise New XOOLKit.XKException("Unable to convert value to XOOL")
		    End Select
		  End If
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20696E6C696E652064696374696F6E61727920726570726573656E746174696F6E206F66206064602E204D617920726169736520612060584B457863657074696F6E602E
		Private Function InlineDictionary(d As Dictionary) As String
		  /// Returns a XOOL inline dictionary representation of `d`. May raise a `XKException`.
		  ///
		  /// inlineDict         → LCURLY inlineDictKeyValue* RCURLY
		  /// inlineDictKeyValue → IDENTIFIER EQUAL literal
		  /// literal            → BOOLEAN | COLOR | DATETIME | NIL | NUMBER | STRING
		  ///
		  /// Note that inline dictionaries cannot contain arrays, other dictionaries or other objects.
		  
		  Var s() As String
		  
		  s.Add("{")
		  
		  For Each entry As DictionaryEntry In d
		    // Only string keys are supported.
		    If entry.Key.Type <> Variant.TypeString Then
		      Raise New XOOLKit.XKException("Dictionary keys must be strings.")
		    End If
		    
		    Select Case entry.Value.Type
		    Case Variant.TypeBoolean, Variant.TypeColor, Variant.TypeDateTime, Variant.TypeDouble, _
		      Variant.TypeInt32, Variant.TypeInt64, Variant.TypeNil, _
		      Variant.TypeString, Variant.TypeText
		      s.Add(entry.Key.StringValue + " = " + GenerateXOOL(entry.Value))
		    Else
		      Raise New XOOLKit.XKException("Inline dictionaries can only contain literal values.")
		    End Select
		    
		  Next entry
		  
		  s.Add("}")
		  
		  Return String.FromArray(s, "")
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function IntegerArrayToXOOL(ints() As Integer) As String
		  // Returns a XOOL representation of an integer array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each i As Integer In ints
		    s.Add(GenerateXOOL(i))
		    s.Add(", ")
		  Next i
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E7320547275652069662060736020697320612076616C696420584F4F4C20636F6C6F72206C69746572616C2E
		Protected Function IsColor(s As String) As Boolean
		  /// Returns True if `s` is a valid XOOL color literal.
		  
		  #Pragma BreakOnExceptions False
		  
		  Try
		    Var t As New XKColorToken(0, 0, s)
		    #Pragma Unused t
		    Return True
		  Catch e As RuntimeException
		    Return False
		  End Try
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function ObjectArrayToXOOL(objs() As Variant) As String
		  // Returns a XOOL representation of an object array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each v As Variant In objs
		    s.Add(GenerateXOOL(v))
		    s.Add(", ")
		  Next v
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573206120584F4F4C20646F63756D656E7420696E746F20612064696374696F6E61727920616E642072657475726E732069742E2052616973657320616E2060584B457863657074696F6E6020696620616E79206572726F7273206F636375722E
		Function ParseXOOL(s As String) As Dictionary
		  /// Parses a XOOL document into a dictionary and returns it. 
		  /// Raises an `XKException` if any errors occur.
		  
		  Var tokeniser As New XOOLKit.XKTokeniser
		  Var tokens() As XOOLKit.XKToken
		  Var parser As New XOOLKit.XKParser
		  
		  Var d As Dictionary
		  Try
		    tokens = tokeniser.Tokenise(s)
		    d = parser.Parse(tokens)
		    
		  Catch e As XOOLKit.XKTokeniserException
		    Var error As New XOOLKit.XKException
		    error.TokeniserErrors.Add(e)
		    #Pragma BreakOnExceptions False
		    Raise error
		  End Try
		  
		  If parser.HasErrors Then
		    Var error As New XOOLKit.XKException
		    For Each e As XOOLKit.XKParserException In parser.Errors
		      error.ParserErrors.Add(e)
		    Next e
		    #Pragma BreakOnExceptions False
		    Raise error
		  End If
		  
		  Return d
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F6620616E206172726179206F662073657269616C697A61626C65206F626A656374732E204D617920726169736520616E2060584B457863657074696F6E602E
		Private Function SerializableArrayToXOOL(objs() As XOOLKit.XKSerializable) As String
		  /// Returns a XOOL representation of an array of serializable objects. May raise an `XKException`.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each obj As XOOLKit.XKSerializable In objs
		    s.Add(obj.ToInlineDictionary)
		    s.Add(", ")
		  Next obj
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function StringArrayToXOOL(strings() As String) As String
		  // Returns a XOOL representation of a string array.
		  
		  Var s() As String
		  
		  s.Add("[")
		  
		  For Each item As String In strings
		    s.Add(GenerateXOOL(item))
		    s.Add(", ")
		  Next item
		  
		  Call s.Pop
		  
		  s.Add("]")
		  
		  Return String.FromArray(s, "")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21, Description = 52657475726E73206120584F4F4C20726570726573656E746174696F6E206F66206073602E
		Private Function StringToXOOL(s As String) As String
		  /// Returns a XOOL representation of `s`.
		  
		  // Paranoia. Ensure we work on a copy.
		  Var result As String = s
		  
		  result = result.ReplaceLineEndings(&u0A)
		  result = result.ReplaceAll("\", "\\")
		  result = result.ReplaceAll("""", "\""")
		  result = result.ReplaceAll(&u0A, "\n")
		  result = result.ReplaceAll(&u08, "\b")
		  result = result.ReplaceAll(&u1B, "\e")
		  result = result.ReplaceAll(&u09, "\t")
		  
		  Return """" + result + """"
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 436F6E76657274732074686520636F6E74656E7473206F66206120584F4F4C20646F63756D656E7420286073602920746F204A534F4E2E2052616973657320616E2060584B457863657074696F6E6020696620616E79206572726F7273206F636375722E
		Protected Function ToJSON(s As String, expanded As Boolean = False) As String
		  /// Converts the contents of a XOOL document (`s`) to JSON. Raises an `XKException` if any errors occur.
		  
		  Return GenerateJSON(ParseXOOL(s), expanded)
		  
		  Exception e As JSONException
		    Raise New XOOLKit.XKException(e.Message)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206074797065602E
		Function ToString(Extends type As XOOLKit.XKTokenTypes) As String
		  /// Returns a string representation of `type`.
		  
		  Select Case type
		  Case XKTokenTypes.ColorLiteral
		    Return "Color Literal"
		    
		  Case XKTokenTypes.BooleanLiteral
		    Return "Boolean"
		    
		  Case XKTokenTypes.Comma
		    Return "Comma"
		    
		  Case XKTokenTypes.Comment
		    Return "Comment"
		    
		  Case XKTokenTypes.DateTime
		    Return "DateTime"
		    
		  Case XKTokenTypes.Dot
		    Return "Dot"
		    
		  Case XKTokenTypes.EOF
		    Return "EOF"
		    
		  Case XKTokenTypes.EOL
		    Return "EOL"
		    
		  Case XKTokenTypes.Equal
		    Return "Equal"
		    
		  Case XKTokenTypes.Identifier
		    Return "Identifier"
		    
		  Case XKTokenTypes.LCurly
		    Return "LCurly"
		    
		  Case XKTokenTypes.LSquare
		    Return "LSquare"
		    
		  Case XKTokenTypes.NilLiteral
		    Return "Nil"
		    
		  Case XKTokenTypes.Number
		    Return "Number"
		    
		  Case XKTokenTypes.RCurly
		    Return "RCurly"
		    
		  Case XKTokenTypes.RSquare
		    Return "RSquare"
		    
		  Case XKTokenTypes.StringLiteral
		    Return "String Literal"
		    
		  Case XKTokenTypes.Undefined
		    Return "Undefined"
		    
		  Else
		    Raise New InvalidArgumentException("Unknown XOOLKit.XKTokenTypes enumeration value.")
		    
		  End Select
		End Function
	#tag EndMethod

	#tag Method, Flags = &h1, Description = 52657475726E73207468652063757272656E742076657273696F6E20696E2074686520666F726D617420604D414A4F522E4D494E4F522E5041544348602E
		Protected Function Version() As String
		  /// Returns the current version in the format `MAJOR.MINOR.PATCH`.
		  
		  Return VERSION_MAJOR.ToString + "." + VERSION_MINOR.ToString + "." + VERSION_PATCH.ToString
		End Function
	#tag EndMethod


	#tag Constant, Name = VERSION_MAJOR, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_MINOR, Type = Double, Dynamic = False, Default = \"0", Scope = Protected
	#tag EndConstant

	#tag Constant, Name = VERSION_PATCH, Type = Double, Dynamic = False, Default = \"1", Scope = Protected
	#tag EndConstant


	#tag Enum, Name = XKTokenTypes, Type = Integer, Flags = &h0
		BooleanLiteral
		  ColorLiteral
		  Comma
		  Comment
		  DateTime
		  Dot
		  EOF
		  EOL
		  Equal
		  Identifier
		  LCurly
		  LSquare
		  NilLiteral
		  Number
		  RCurly
		  RSquare
		  StringLiteral
		Undefined
	#tag EndEnum


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
