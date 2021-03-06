#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>

#include <esa.h>

#define TIME_STEP 1
#define MAX_NB_TRAIN 10

typedef struct _Ertms_Train_Pos{
	char name[256];
	double posx;
	double posy;
}Ertms_Train_Pos;

void getFictivePosition(int id, int t, Ertms_Train_Pos *train_pos) {
	sprintf(train_pos->name,"Mobile_1_%d",id);
	train_pos->posx = (double)t*1.5+20*id;
	train_pos->posy = (double)t*2+20*id;
}

int readPosition(FILE *f, Ertms_Train_Pos *train_pos) {
	int lane,segment;
	return fscanf(f, "%255s %d %d %lf %lf", train_pos->name, &lane, &segment, &(train_pos->posx), &(train_pos->posy));
}

int getTrainsPositionFromFile(FILE *f, Ertms_Train_Pos *train_pos){
	//const int nb_train = 5;
	int i;	

	
	for(i=0;i<MAX_NB_TRAIN;i++){
		//printf("read one position\n");	
		int ret=readPosition(f, train_pos+i);
		//printf("ret : %d\n",ret);
		if(ret<5) break;
	}
	
	//for(i=0;i<nb_train;i++) getFictivePosition(i+1,t,train_pos+i);

	return i;
}


int getTrainsPosition(const int t, Ertms_Train_Pos *train_pos){
	const int nb_train = 5;
	int i;	
	
	for(i=0;i<nb_train;i++) getFictivePosition(i+1,t,train_pos+i);

	return nb_train;
}


int main(int argc, char **argv)
{
	EsaT_State_Handle esa_handle;
	double old_ret_time=0.0;
	EsaT_Interface *interfaces;
	EsaT_Interface inf_nb_train;
	EsaT_Interface inf_test;
	FILE *f=fopen("/tmp/ertms","r");
	int num;
	int t = 0;
	Ertms_Train_Pos *train_pos;
	
	Esa_Main(argc, argv, ESAC_OPTS_NONE);
	Esa_Init(argc, argv, ESAC_OPTS_NONE, &esa_handle);
	Esa_Load(esa_handle, ESAC_OPTS_NONE);
	Esa_Interface_Group_Get(esa_handle, &interfaces, &num);

	inf_nb_train = interfaces[0];
	inf_test = interfaces[1];

	train_pos = (Ertms_Train_Pos *) malloc(MAX_NB_TRAIN * (sizeof(Ertms_Train_Pos)));
	
	while(1)
	{
		int status,evt_num;
		double ret_time;

		printf("Read positions !\n");

		//const int nb_train = getTrainsPosition(t, train_pos);
		const int nb_train = getTrainsPositionFromFile(f, train_pos);

		printf("Go Opnet !\n");
		fflush(stdout);

		//sleep(1);
		t+=TIME_STEP;
		Esa_Execute_Until(esa_handle, &status, t, 
			ESAC_UNTIL_INCLUSIVE, &ret_time, &evt_num);
					
		if(old_ret_time == ret_time)
		{
			printf("Simulation finished\n");
			break;
		}

		old_ret_time=ret_time;

		printf("External program %d %d %f %d %d\n",status,t,ret_time,evt_num,nb_train);
		fflush(stdout);

		Esa_Interface_Value_Set(
			esa_handle, &status, inf_test, ESAC_NOTIFY_NEVER, train_pos);

		Esa_Interface_Value_Set(
			esa_handle, &status, inf_nb_train, ESAC_NOTIFY_IMMEDIATELY, nb_train);
	}
	
	fclose(f);
	free(train_pos);

	return 0;
}



