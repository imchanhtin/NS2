BEGIN {  
 	rotgoi = 0;
}

{
	action 	= $1;
	time	= $2;
	from 	= $3;
	to 	= $4;
	type 	= $5; 
	pktsize = $6;
	flow_id	= $8;
	src	= $9;
	dst	= $10;
	seq_no	= $11;
	packet_id = $12;

	if (action == "d" && from == 3 && to == 4 && type == "tcp"){
		rotgoi++;
		printf("%f %d\n",time,rotgoi);	
	}
	if (action != "d" && from == 3 && to == 4 && type == "tcp"){
		printf("%f %d\n",time,rotgoi);	
	} 
}

END {
}
