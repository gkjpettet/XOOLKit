#tag Module
Protected Module XOOLKit
	#tag Method, Flags = &h0, Description = 436F6E766572747320612064696374696F6E61727920746F206120584F4F4C20646F63756D656E742E204D617920726169736520616E2060584B457863657074696F6E602E
		Function GenerateXOOL(d As Dictionary) As String
		  /// Converts a dictionary to a XOOL document. May raise an `XKException`.
		  
		  If d.KeyCount = 0 Then Return ""
		  
		  Var s() As String
		  
		  For Each entry As DictionaryEntry In d
		    // Only string keys are supported.
		    If entry.Key.Type <> variant.TypeString Then
		      Raise New XOOLKit.XKException("Dictionary keys must be strings.")
		    End If
		    
		    Var keyValue As String = entry.Key + " = "
		    
		    If entry.Value IsA Dictionary Then
		      #Pragma Warning "TODO: Handle dictionary values"
		      
		    ElseIf entry.Value Isa XOOLKit.XKSerializable Then
		      #Pragma Warning "TODO: Handle serializable objects"
		      
		    Else
		      Select Case entry.Value.Type
		      Case Variant.TypeArray
		        #Pragma Warning "TODO: Handle array values"
		        
		      Case Variant.TypeBoolean
		        keyValue = keyValue + If(entry.Value, "True", "False")
		        
		      Case Variant.TypeColor
		        #Pragma Warning "TODO"
		        
		      Case Variant.TypeDateTime
		        #Pragma Warning "TODO"
		        
		      Case Variant.TypeDouble
		        keyValue = keyValue + entry.Value.DoubleValue.ToString
		        
		      Case Variant.TypeInt32
		        keyValue = keyValue + entry.Value.Int32Value.ToString
		        
		      Case Variant.TypeInt64
		        keyValue = keyValue + entry.Value.Int64Value.ToString
		        
		      Case Variant.TypeInteger
		        keyValue = keyValue + entry.Value.IntegerValue.ToString
		        
		      Case Variant.TypeNil
		        keyValue = keyValue + "Nil"
		        
		      Case Variant.TypeString, Variant.TypeText
		        #Pragma Warning "TODO: Handle string/text values"
		        
		      Else
		        Raise New XOOLKit.XKException("Unable to serialise the value of the key `" + entry.Key + "`.")
		      End Select
		    End If
		    
		    s.Add(keyValue)
		  Next entry
		  
		  Return String.FromArray(s, &u0A)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 506172736573206120584F4F4C20646F63756D656E7420286073602920696E746F20612064696374696F6E61727920616E642072657475726E732069742E2052616973657320616E2060584B457863657074696F6E6020696620616E79206572726F7273206F636375722E
		Function ParseXOOL(s As String) As Dictionary
		  /// Parses a XOOL document (`s`) into a dictionary and returns it. 
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
		    Raise error
		  End Try
		  
		  If parser.HasErrors Then
		    Var error As New XOOLKit.XKException
		    For Each e As XOOLKit.XKParserException In parser.Errors
		      error.ParserErrors.Add(e)
		    Next e
		    Raise error
		  End If
		  
		  Return d
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


End Module
#tag EndModule
