#tag Module
Protected Module XOOLKit
	#tag Method, Flags = &h0, Description = 52657475726E73206120737472696E6720726570726573656E746174696F6E206F66206074797065602E
		Function ToString(Extends type As XOOLKit.XKTokenTypes) As String
		  /// Returns a string representation of `type`.
		  
		  Select Case type
		  Case XKTokenTypes.ColorLiteral
		    Return "Color Literal"
		    
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
		    
		  Case XKTokenTypes.LCurly
		    Return "LCurly"
		    
		  Case XKTokenTypes.LSquare
		    Return "LSquare"
		    
		  Case XKTokenTypes.Number
		    Return "Number"
		    
		  Case XKTokenTypes.RCurly
		    Return "RCurly"
		    
		  Case XKTokenTypes.RSquare
		    Return "RSquare"
		    
		  Case XKTokenTypes.Undefined
		    Return "Undefined"
		    
		  Else
		    Raise New InvalidArgumentException("Unknown XOOLKit.XKTokenTypes enumeration value.")
		    
		  End Select
		End Function
	#tag EndMethod


	#tag Enum, Name = XKTokenTypes, Type = Integer, Flags = &h0
		Comma
		  Comment
		  DateTime
		  Dot
		  EOF
		  EOL
		  Equal
		  LCurly
		  LSquare
		  Number
		  RCurly
		  RSquare
		  Undefined
		ColorLiteral
	#tag EndEnum


End Module
#tag EndModule
