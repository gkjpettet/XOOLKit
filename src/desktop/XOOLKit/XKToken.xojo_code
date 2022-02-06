#tag Class
Protected Class XKToken
	#tag Method, Flags = &h0
		Sub Constructor(type As XKTokenTypes, tokenStart As Integer, lineNumber As Integer, lexeme As String = "")
		  Self.Type = type
		  Self.AbsoluteStart = tokenStart
		  Self.LineNumber = lineNumber
		  Self.Lexeme = lexeme
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 302D626173656420696E64657820696E2074686520736F7572636520636F6465206F662074686520666972737420636861726163746572206F66207468697320746F6B656E2E
		AbsoluteStart As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320286F7074696F6E616C29206C6578656D652E
		Lexeme As String
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 312D6261736564206C696E65206E756D626572206F6620746865206C61737420636861726163746572206F66207468697320746F6B656E2E
		LineNumber As Integer = 1
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320747970652E
		Type As XOOLKit.XKTokenTypes = XOOLKit.XKTokenTypes.Undefined
	#tag EndProperty


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
		#tag ViewProperty
			Name="Type"
			Visible=false
			Group="Behavior"
			InitialValue="XOOLKit.XKTokenTypes.Undefined"
			Type="XOOLKit.XKTokenTypes"
			EditorType="Enum"
			#tag EnumValues
				"0 - BooleanLiteral"
				"1 - ColorLiteral"
				"2 - Comma"
				"3 - Comment"
				"4 - DateTime"
				"5 - Dot"
				"6 - EOF"
				"7 - EOL"
				"8 - Equal"
				"9 - Identifier"
				"10 - LCurly"
				"11 - LSquare"
				"12 - NilLiteral"
				"13 - Number"
				"14 - RCurly"
				"15 - RSquare"
				"16 - StringLiteral"
				"17 - Undefined"
			#tag EndEnumValues
		#tag EndViewProperty
		#tag ViewProperty
			Name="AbsoluteStart"
			Visible=false
			Group="Behavior"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Lexeme"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="LineNumber"
			Visible=false
			Group="Behavior"
			InitialValue="1"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
