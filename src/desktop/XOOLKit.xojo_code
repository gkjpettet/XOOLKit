#tag Module
Protected Module XOOLKit
	#tag Method, Flags = &h1, Description = 506172736573206120584F4F4C20646F63756D656E7420286073602920696E746F20612064696374696F6E61727920616E642072657475726E732069742E2052616973657320616E2060584B457863657074696F6E6020696620616E79206572726F7273206F636375722E
		Protected Function Parse(s As String) As Dictionary
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
		  
		  Return GenerateJSON(Parse(s), expanded)
		  
		  Exception e As JSONException
		    Var tErrors() As XOOLKit.XKTokeniserException
		    Var pErrors() As XOOLKit.XKParserException
		    Raise New XOOLKit.XKException(tErrors, pErrors, e.Message)
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
