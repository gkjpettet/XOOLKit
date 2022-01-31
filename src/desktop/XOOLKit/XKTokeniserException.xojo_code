#tag Class
Protected Class XKTokeniserException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(message As String, lineNumber As Integer, absPos As Integer)
		  Super.Constructor
		  
		  Self.Message = message
		  Self.LineNumber = lineNumber
		  Self.AbsolutePosition = absPos
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 54686520302D626173656420706F736974696F6E20696E2074686520736F75726365206F6620746865206572726F722E
		AbsolutePosition As Integer = 0
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 54686520312D6261736564206E756D626572206F6620746865206C696E6520746865206572726F72206F6363757273206F6E2E
		LineNumber As Integer = 1
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="ErrorNumber"
			Visible=false
			Group="Behavior"
			InitialValue="0"
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
			Name="Message"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="String"
			EditorType="MultiLineEditor"
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
