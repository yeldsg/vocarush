B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Activity
Version=13.1
@EndOfDesignText@
#Region  Activity Attributes
    #FullScreen: True
    #IncludeTitle: False
#End Region

Sub Process_Globals
End Sub

Sub Globals
	Private Label1 As Label
	Private LBL_OSCORE As Label
	Private LBL_ORANKING As Label
	Private IMG_BACK As ImageView
	Private IMG_LEADERBOARD As ImageView
	Private IMG_PROFILE As ImageView
	Private IMG_SETTINGS As ImageView
	Private IMG_PPIC As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("layprofile")
	ShowProfile
End Sub

Sub Activity_Resume
	ShowProfile
End Sub

Sub Activity_Pause (UserClosed As Boolean)

End Sub

Private Sub ShowProfile
	Dim player As String = Level.PlayerName
	Label1.Text = player

	LBL_OSCORE.Text = Database.GetOverallScore(player)

	Dim rank As Int = Database.GetOverallRanking(player)
	If rank = 0 Then
		LBL_ORANKING.Text = "Unranked"
	Else
		LBL_ORANKING.Text = "#" & rank
	End If
End Sub

Private Sub IMG_BACK_Click
	Activity.Finish
End Sub

Private Sub IMG_LEADERBOARD_Click
	StartActivity(Leaderboard)
End Sub

Private Sub IMG_PROFILE_Click
	ShowProfile
End Sub
