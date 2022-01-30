#tag Class
Protected Class XKNumberToken
Inherits XOOLKit.XKToken
	#tag Method, Flags = &h0
		Sub Constructor(tokenStart As Integer, lineNumber As Integer, value As Variant, isInteger As Boolean)
		  Super.Constructor(XKTokenTypes.Number, tokenStart, lineNumber)
		  Self.Value = value
		  Self.IsInteger = isInteger
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54727565206966207468697320697320616E20696E7465676572206C69746572616C2E2046616C73652069662069742773206120646F75626C652E
		IsInteger As Boolean = True
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 5468697320746F6B656E277320696E7465676572206F7220646F75626C652076616C75652E
		Value As Variant
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
				"0 - Comma"
				"1 - Comment"
				"2 - Dot"
				"3 - EOF"
				"4 - EOL"
				"5 - Equal"
				"6 - LCurly"
				"7 - LSquare"
				"8 - RCurly"
				"9 - RSquare"
				"10 - Undefined"
				"11 - ColorLiteral"
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
			Name="Length"
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
		#tag ViewProperty
			Name="Value"
			Visible=false
			Group="Behavior"
			InitialValue="&c000000"
			Type="Color"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
