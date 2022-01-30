#tag DesktopWindow
Begin DesktopWindow WinTest
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composite       =   False
   DefaultLocation =   2
   FullScreen      =   False
   HasBackgroundColor=   False
   HasCloseButton  =   True
   HasFullScreenButton=   False
   HasMaximizeButton=   True
   HasMinimizeButton=   True
   Height          =   710
   ImplicitInstance=   True
   MacProcID       =   0
   MaximumHeight   =   32000
   MaximumWidth    =   32000
   MenuBar         =   1558415359
   MenuBarVisible  =   False
   MinimumHeight   =   64
   MinimumWidth    =   64
   Resizeable      =   True
   Title           =   "XOOL Dev Harness"
   Type            =   0
   Visible         =   True
   Width           =   1234
   Begin DesktopTextArea Input
      AllowAutoDeactivate=   True
      AllowFocusRing  =   True
      AllowSpellChecking=   True
      AllowStyledText =   True
      AllowTabs       =   False
      BackgroundColor =   &cFFFFFF
      Bold            =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Format          =   ""
      HasBorder       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      Height          =   638
      HideSelection   =   True
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LineHeight      =   0.0
      LineSpacing     =   1.0
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   True
      MaximumCharactersAllowed=   0
      Multiline       =   True
      ReadOnly        =   False
      Scope           =   0
      TabIndex        =   0
      TabPanelIndex   =   0
      TabStop         =   True
      Text            =   ""
      TextAlignment   =   0
      TextColor       =   &c000000
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      UnicodeMode     =   1
      ValidationMask  =   ""
      Visible         =   True
      Width           =   627
   End
   Begin DesktopButton ButtonTokenise
      AllowAutoDeactivate=   True
      Bold            =   False
      Cancel          =   False
      Caption         =   "Tokenise"
      Default         =   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      Height          =   20
      Index           =   -2147483648
      Italic          =   False
      Left            =   20
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   False
      LockTop         =   False
      MacButtonStyle  =   0
      Scope           =   0
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   670
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   80
   End
   Begin DesktopListBox TokensListbox
      AllowAutoDeactivate=   True
      AllowAutoHideScrollbars=   True
      AllowExpandableRows=   False
      AllowFocusRing  =   False
      AllowResizableColumns=   False
      AllowRowDragging=   False
      AllowRowReordering=   False
      Bold            =   False
      ColumnCount     =   5
      ColumnWidths    =   "60, *, 60, 60, *"
      DefaultRowHeight=   -1
      DropIndicatorVisible=   False
      Enabled         =   True
      FontName        =   "System"
      FontSize        =   0.0
      FontUnit        =   0
      GridLineStyle   =   0
      HasBorder       =   True
      HasHeader       =   True
      HasHorizontalScrollbar=   False
      HasVerticalScrollbar=   True
      HeadingIndex    =   -1
      Height          =   638
      Index           =   -2147483648
      InitialValue    =   "Line	Type	Start	Len	Lexeme"
      Italic          =   False
      Left            =   659
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      RequiresSelection=   False
      RowSelectionType=   0
      Scope           =   0
      TabIndex        =   2
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   20
      Transparent     =   False
      Underline       =   False
      Visible         =   True
      Width           =   555
      _ScrollOffset   =   0
      _ScrollWidth    =   -1
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Method, Flags = &h21, Description = 557064617465732074686520746F6B656E73206C697374626F7820776974682060746F6B656E73602E
		Private Sub UpdateTokensListbox(tokens() As XOOLKit.XKToken)
		  /// Updates the tokens listbox with `tokens`.
		  
		  TokensListbox.RemoveAllRows
		  
		  Var lexeme As String
		  For Each t As XOOLKit.XKToken In tokens
		    
		    TokensListbox.AddRow( _
		    t.LineNumber.ToString, _
		    t.Type.ToString, _
		    t.AbsoluteStart.ToString, _
		    t.Length.ToString)
		    
		    // Compute the lexeme column value.
		    Select Case t.Type
		    Case XKTokenTypes.Number
		      lexeme = XOOLKit.XKNumberToken(t).Value.StringValue
		      
		    Case XKTokenTypes.ColorLiteral
		      lexeme = XOOLKit.XKColorToken(t).MyColor.ToString
		      
		    Case XKTokenTypes.DateTime
		      lexeme = XOOLKit.XKDateTimeToken(t).Value.ToString
		      
		    Else
		      lexeme = t.Lexeme
		    End Select
		    
		    // Populate the lexeme column.
		    TokensListbox.CellTextAt(TokensListbox.LastAddedRowIndex, 4) = lexeme
		  Next t
		  
		End Sub
	#tag EndMethod


#tag EndWindowCode

#tag Events Input
	#tag Event
		Sub Opening()
		  // Disable annoying smart quotes on macOS.
		  // Thanks to Martin Tripensee:
		  // https://forum.xojo.com/t/disabling-smart-quotes-in-desktoptextarea/68200/2?u=garrypettet
		  
		  #If TargetCocoa Then
		    Declare Function NSClassFromString Lib "AppKit" (aClassName As CFStringRef) As Ptr
		    
		    Var myHandle As Ptr
		    Declare Function documentView Lib "AppKit" Selector "documentView" _
		    (obj_id As Ptr) As Ptr
		    
		    myHandle = documentView(Me.Handle)
		    
		    Declare Sub setAutomaticQuoteSubstitutionEnabled Lib "AppKit" Selector "setAutomaticQuoteSubstitutionEnabled:" _
		    (Id As Ptr, value As Boolean)
		    
		    setAutomaticQuoteSubstitutionEnabled (myHandle, False)
		  #EndIf
		End Sub
	#tag EndEvent
#tag EndEvents
#tag Events ButtonTokenise
	#tag Event
		Sub Pressed()
		  Var tokeniser As New XOOLKit.XKTokeniser
		  
		  Var tokens() As XOOLKit.XKToken
		  
		  Try
		    tokens = tokeniser.Tokenise(Input.Text)
		    UpdateTokensListbox(tokens)
		    
		  Catch e As XOOLKit.XKException
		    MessageBox("" + e.LineNumber.ToString + ", " + e.AbsolutePosition.ToString + ": " + e.Message)
		    
		  End Try
		  
		End Sub
	#tag EndEvent
#tag EndEvents
