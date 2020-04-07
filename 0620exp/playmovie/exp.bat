timeout /t 3000
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 180
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe

::0119_CalONOFF_5min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0119_CalONOFF_5min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 330
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0119_CalONOFF_5min_Br50_Q100' 345
timeout /t 300

::0304_HMM_UD_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G3_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G3_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G20_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G20_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G20_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G9_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G9_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G9_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G3_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G3_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_UD_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_UD_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_UD_G3_7min_Br50_Q100' 465
timeout /t 300

::0304_HMM_RL_G3_7min_Br50_Q100.avi
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.WriteLine("180"); $port.Close()"
timeout /t 40
START C:"\Program Files"\DAUM\PotPlayer\PotPlayerMini64.exe 0304_HMM_RL_G3_7min_Br50_Q100.avi
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\start.exe
timeout /t 450
psexec -u MEA -p hydrolab \\192.168.1.171 -d -l -i C:\auto\end.exe
powershell "$port= new-Object System.IO.Ports.SerialPort COM3,9600,None,8,one; $port.open(); $port.Writeline("0"); $port.Close()"
psexec -u MEA -p hydrolab \\192.168.1.171 -s "C:\auto\diode.bat" '0304_HMM_RL_G3_7min_Br50_Q100' 465
timeout /t 300
