PID := -1
Latest_Path := ""

Insert & S::
	If GetKeyState("Shift", "P") {
		PostMessage, 0x0112, 0xF060,,, ahk_pid %PID%
		Menu, Tray, Icon, %A_AhkPath%, 0
	} Else {
		FormatTime, output_file, , HH-mm-ss
		output_file := "F:\ABAN\Media\ASC-" output_file ".mp4"
		Latest_Path := output_file
		command := "ffmpeg -y -rtbufsize 100M -f gdigrab -framerate 70 -probesize 10M -draw_mouse 1 -i desktop -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p """ output_file """"
		Run, %command%, , Min, PID
		Menu, Tray, Icon, %SystemRoot%\system32\imageres.dll, 77
	}
	Return


