puts "\n             		  Danh gia Hieu Nang mang \n"  
puts "\n 	Danh gia do rot goi tin doi voi he thong cam bien nhiet\n"  
puts "\n                	     Hang doi: 10 \n"  

set ns [new Simulator]
$ns color 1 green
$ns color 2 purple 
$ns color 3 black 
set queuesize 10

#Open the Trace files
set file1 [open outTest30.tr w]
set winfile1 [open WinFile1 w]
set winfile2 [open WinFile2 w]
set winfile3 [open WinFile3 w]
$ns trace-all $file1

#Open the NAM trace file
set file2 [open outTest30.nam w]
$ns namtrace-all $file2

#Define a 'finish' procedure
proc finish {} {
        global ns file1 file2
        $ns flush-trace
        close $file1
        close $file2
        exec nam outTest30.nam &
	exec awk -f test.awk outTest30.tr &
	exec awk -f rotgoi.awk outTest30.tr > rotgoi30.xg &
	exec xgraph rotgoi30.xg -geometry 800X600 &
        exit 0
}

#Tao nut
set n0 [$ns node]
$n0 color "green"

set n1 [$ns node]
$n1 color "purple"

set n2 [$ns node]
$n2 color "black"

set n3 [$ns node]
$n3 color "brown"
$n3 shape box

set n4 [$ns node]
$n4 color "blue"
$n4 shape hexagon


#Tao ket noi
$ns duplex-link $n0 $n3 0.5Mb 45ms DropTail
$ns duplex-link-op $n0 $n3 color red
$ns duplex-link-op $n0 $n3 orient right-down

$ns duplex-link $n1 $n3 0.5Mb 45ms DropTail
$ns duplex-link-op $n1 $n3 color yellow
$ns duplex-link-op $n1 $n3 orient right-up
 
$ns duplex-link $n2 $n3 0.5Mb 45ms DropTail
$ns duplex-link-op $n2 $n3 color brown
$ns duplex-link-op $n2 $n3 orient right

$ns duplex-link $n3 $n4 0.5Mb 45ms DropTail
$ns duplex-link-op $n3 $n4 color black
$ns duplex-link-op $n3 $n4 orient right

#thiet lap hang doi
#kich thuoc hang doi mac dinh la 50, thiet lap chi 20
$ns queue-limit $n3 $n4 $queuesize
$ns duplex-link-op $n3 $n4 queuePos 0.5

#Thiet lap cac ket noi TCP thong qua FTP
set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
$tcp1 set class_ 1
$tcp1 set fid_ 1
set sink [new Agent/TCPSink]
$ns attach-agent $n4 $sink
$ns connect $tcp1 $sink
$tcp1 set packetSize_ 150


set tcp2 [new Agent/TCP]
$ns attach-agent $n1 $tcp2
$tcp2 set class_ 2
$tcp2 set fid_ 2
set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $sink2
$ns connect $tcp2 $sink2
$tcp2 set packetSize_ 150


set tcp3 [new Agent/TCP]
$ns attach-agent $n2 $tcp3
$tcp3 set class_ 3
$tcp3 set fid_ 3
set sink3 [new Agent/TCPSink]
$ns attach-agent $n4 $sink3
$ns connect $tcp3 $sink3
$tcp3 set packetSize_ 150


#Setup a FTP over TCP connection
set ftp1 [new Application/FTP]
set ftp2 [new Application/FTP]
set ftp3 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2
$ftp3 attach-agent $tcp3
$ftp1 set type_ FTP
$ftp1 set maxPkts_ 200
$ftp2 set type_ FTP
$ftp2 set maxPkts_ 200
$ftp3 set type_ FTP
$ftp3 set maxPkts_ 200

$ns at 0.0 "$n0 label \"DTH22 (Nhiet do)\""
$ns at 0.0 "$n1 label \"DTH22 (Do am)\""
$ns at 0.0 "$n2 label \"MQ2\""
$ns at 0.0 "$n4 label \"Server\""
$ns at 0.0 "$n3 label \"ESP8266\""

$ns at 0.01 "$ftp1 start"
$ns at 0.02 "$ftp2 start"
$ns at 0.03 "$ftp3 start"

$ns at 100.5 "$ftp1 stop"
$ns at 100.6 "$ftp2 stop"
$ns at 100.7 "$ftp3 stop"

proc plotWindow {tcpSource file} {
global ns
set time 0.1
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
set wnd [$tcpSource set window_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 0.1 "plotWindow $tcp1 $winfile1"
$ns at 0.12 "plotWindow $tcp2 $winfile2"
$ns at 0.13 "plotWindow $tcp3 $winfile3"
$ns at 101.0 "finish"

$ns run

