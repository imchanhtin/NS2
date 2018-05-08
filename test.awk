BEGIN {
	goi3 = 0;
	gui = 0;
	rotgoi = 0;
	tile=0;
	start_time = 0;
	count = 0;
}

{

   action = $1;

   time = $2;

   from = $3;

   to = $4;

   type = $5;

   pktsize = $6;

   flow_id = $8;

	if (from != 4 && to == 3 && action == "-" && type == "tcp"){
		goi3++;
	}
	if (to == 4 && action == "-" && type == "tcp"){
		gui++;
	}
	if ((flow_id == 2 && action == "d")||(flow_id == 1 && action == "d")||(flow_id == 3 && action == "d")){
		rotgoi++;
	}
}
END {
	tile = rotgoi*100/goi3;
	pdr  = 100 - tile;
	printf("So goi nut 3 nhan: %d\n", goi3);
	printf("So goi nut 3 gui : %d\n", gui);
	printf("So goi rot	 : %d\n",rotgoi);
	printf("Ti le cap phat (PDR): %f %\n",pdr);
	printf("Ti le rot goi	 : %f %\n", tile);
}

