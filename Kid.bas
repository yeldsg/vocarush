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
	Private Timer1 As Timer
	Private points As Int
End Sub

Sub Globals
	Private wordList As List
	Private currentWord As String
	Private myTTS As TTS
	
	Private ttsReady As Boolean

	' Lives
	Private lives As Int
	Private LBL_LIFE1 As Label
	Private LBL_LIFE2 As Label
	Private LBL_LIFE3 As Label

	' UI
	Private BTN_BACK As Button
	Private BTN_HINT As Button
	Private BTN_QUIT As Button
	Private BTN_TTP As Button
	Private ET_ANS As EditText
	Private LBL_TIMER As Label
	Private BTN_ENTER As Button
	Private LBL_POINTS As Label
	
	Private timerStarted As Boolean

	Private IMG_LEADERBOARD As ImageView
	Private IMG_PROFILE As ImageView
End Sub

Sub Activity_Create(FirstTime As Boolean)
	Activity.LoadLayout("laykid")
	Dim playerName As String = Level.PlayerName
	Level.PlayedMode = "Kid"

	Timer1.Initialize("Timer1", 1000)

	ttsReady = False
	myTTS.Initialize("myTTS")
	myTTS.SetLanguage("en", "US")

	wordList.Initialize
	wordList.AddAll(Array As String("Animal", "Banana", "Garden", "Pencil", "Window", "Rainbow", "Pocket", "Turtle", "Pillow", "Button"))


	ShuffleWordList ' Shuffle full word order once per game

	points = 0
	lives = 3
	UpdateLivesDisplay

	PickRandomWord
End Sub

Sub Activity_Resume
	
End Sub

Sub Activity_Pause (UserClosed As Boolean)
	Timer1.Enabled = False
End Sub

Sub myTTS_Ready (Success As Boolean)
	ttsReady = Success
	If Success Then
		myTTS.SetLanguage("en", "US")
	Else
		ToastMessageShow("TTS failed to initialize.", True)
	End If
End Sub

Private Sub BTN_TTP_Click
	If Not(myTTS.IsInitialized) Or Not(ttsReady) Then
		ToastMessageShow("TTS not ready yet.", False)
		Return
	End If

	If currentWord = Null Or currentWord.Trim = "" Then
		ToastMessageShow("No word selected.", False)
		Return
	End If

	myTTS.Speak(currentWord, False)
	StartTimer ' This will only start the timer once per word
End Sub


Private Sub BTN_QUIT_Click
	StartActivity(Main)
End Sub

Private Sub BTN_BACK_Click
	StartActivity(Level)
End Sub

Private Sub BTN_ENTER_Click
	If ET_ANS.Text.ToLowerCase.Trim = currentWord.ToLowerCase Then
		points = points + 10
		LBL_POINTS.Text = "Points: " & points
		ToastMessageShow("Correct! Points: " & points, False)
		ResetTimer
		PickRandomWord
	Else
		ToastMessageShow("Wrong Answer", False)
		ReduceLife
		' Inside BTN_ENTER_Click
		If lives <= 0 Then
			ToastMessageShow("Game Over!", False)
			EndGame

		Else
			ResetTimer
			PickRandomWord
		End If

	End If
	ET_ANS.Text = ""
End Sub

Private Sub UpdateLivesDisplay
	Select Case lives
		Case 3
			LBL_LIFE1.Text = "♥"
			LBL_LIFE2.Text = "♥"
			LBL_LIFE3.Text = "♥"
		Case 2
			LBL_LIFE1.Text = "♥"
			LBL_LIFE2.Text = "♥"
			LBL_LIFE3.Text = "♡"
		Case 1
			LBL_LIFE1.Text = "♥"
			LBL_LIFE2.Text = "♡"
			LBL_LIFE3.Text = "♡"
		Case 0
			LBL_LIFE1.Text = "♡"
			LBL_LIFE2.Text = "♡"
			LBL_LIFE3.Text = "♡"
	End Select
End Sub

Private Sub ReduceLife
	lives = lives - 1
	UpdateLivesDisplay
End Sub

Private Sub BTN_HINT_Click
	Dim hint As String
	Select Case currentWord
		Case "Animal"
			hint = "A living creature that is not a human or plant."
		Case "Banana"
			hint = "A long curved fruit with a yellow skin."
		Case "Garden"
			hint = "A plot of ground where plants such as flowers and vegetables are grown."
		Case "Pencil"
			hint = "A tool used for writing or drawing."
		Case "Window"
			hint = "An opening in a wall, typically covered with glass."
		Case "Rainbow"
			hint = "A colorful arc that appears in the sky when sunlight shines on raindrops."
		Case "Pocket"
			hint = "A small pouch sewn into clothing for carrying items."
		Case "Turtle"
			hint = "A slow-moving reptile with a shell."
		Case "Pillow"
			hint = "A soft cushion for supporting the head while sleeping."
		Case "Button"
			hint = "A small, round object used to fasten clothes."
		Case Else
			hint = "No hint available."
	End Select
	ToastMessageShow(hint, True)
End Sub


Private Sub PickRandomWord
	' Inside PickRandomWord
	If wordList.IsInitialized = False Or wordList.Size = 0 Then
		ToastMessageShow("No more words left! You finished the game!", True)
		EndGame
		Return
	End If


	currentWord = wordList.Get(0)
	wordList.RemoveAt(0)
	timerStarted = False ' Ensure timer can start for the next word
End Sub


Private Sub StartTimer
	If timerStarted = False Then
		LBL_TIMER.Text = "15"
		Timer1.Enabled = True
		timerStarted = True
	End If
End Sub


Private Sub ResetTimer
	Timer1.Enabled = False
	timerStarted = False
	LBL_TIMER.Text = "15"
End Sub


Sub Timer1_Tick
	Dim timeLeft As Int = LBL_TIMER.Text
	timeLeft = timeLeft - 1
	LBL_TIMER.Text = timeLeft

	If timeLeft <= 0 Then
		ToastMessageShow("Time's up! Life lost.", False)
		ReduceLife

		' Inside Timer1_Tick
		If lives <= 0 Then
			ToastMessageShow("Game Over!", False)
			EndGame

		Else
			ResetTimer
			PickRandomWord
		End If

	End If
End Sub

Private Sub ShuffleWordList
	Dim tempList As List
	tempList.Initialize
	tempList.AddAll(wordList)
	wordList.Clear

	Do While tempList.Size > 0
		Dim i As Int = Rnd(0, tempList.Size)
		wordList.Add(tempList.Get(i))
		tempList.RemoveAt(i)
	Loop
End Sub


Private Sub IMG_LEADERBOARD_Click
	StartActivity(Leaderboard)
End Sub

Private Sub IMG_PROFILE_Click
	StartActivity(Profile)
End Sub


'Ends the game: saves the score to the database, then shows the result.
'Stops the timer and closes this screen so the finished game cannot continue.
Private Sub EndGame
	Timer1.Enabled = False
	Level.FinalScore = points
	Database.SaveScore(Level.PlayerName, Level.PlayedMode, points)
	StartActivity(Result)
	Activity.Finish
End Sub
