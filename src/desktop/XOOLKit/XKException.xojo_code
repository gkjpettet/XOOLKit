#tag Class
Protected Class XKException
Inherits RuntimeException
	#tag Method, Flags = &h0
		Sub Constructor(tokeniserErrors() As XOOLKit.XKTokeniserException, parserErrors() As XOOLKit.XKParserException)
		  // Calling the overridden superclass constructor.
		  Super.Constructor
		  
		  Self.TokeniserErrors = tokeniserErrors
		  Self.ParserErrors = parserErrors
		  
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0, Description = 416E7920706172736572206572726F72732074686174206F636375727265642E
		ParserErrors() As XOOLKit.XKParserException
	#tag EndProperty

	#tag Property, Flags = &h0, Description = 416E7920746F6B656E69736572206572726F722074686174206F636375727265642E
		TokeniserErrors() As XOOLKit.XKTokeniserException
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
