MIL_3_Tfile_Hdr_ 171A 171A modeler 9 52FB5030 52FCC0D0 2E siegel florent 0 0 none none 0 0 none 64693DF2 1972 0 0 0 0 0 0 2b74 2                                                                                                                                                                                                                                                                                                                                                                                                ��g�      D   H   L    �  c  V  Z  �  �  �  j  n  S  _           	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue         
            count    ���   
   ����   
      list   	���   
          
   
   super priority             ����            begsim intrpt      begsim intrpt����   ����           ����          ����          ����                        Esys_Interface	\inf_nb_train;       Esys_Interface	\inf_test;       Objid	\net_id;          int nb_train;   Ertms_Train_Pos *train_pos;              #include "stdlib.h"   #include "stdio.h"   #include "string.h"       3#define STRM (op_intrpt_type () == OPC_INTRPT_STRM)   =#define ESYS (op_intrpt_type () == OPC_INTRPT_ESYS_INTERFACE)       *#define min(X, Y)  ((X) < (Y) ? (X) : (Y))       #define MAX_NB_TRAIN 10        typedef struct _Ertms_Train_Pos{   	char name[256];   	double posx;   	double posy;   }Ertms_Train_Pos;       
   5void printTrainPos(const Ertms_Train_Pos* train_pos){   W	printf("\tPosition of %s : %f,%f\n",train_pos->name, train_pos->posx,train_pos->posy);   }       )void showNodePos(const Objid node_objid){   	double x,y;   8	op_ima_obj_attr_get_dbl (node_objid, "x position", &x);   8	op_ima_obj_attr_get_dbl (node_objid, "y position", &y);   &	printf("\tOld Position %f %f\n",x,y);   }                                          Z   �          
   init   
       J          inf_nb_train = op_id_from_name(   4	op_id_self(), OPC_OBJTYPE_ESINTERFACE, "nb_train");       inf_test = op_id_from_name(   5	op_id_self(), OPC_OBJTYPE_ESINTERFACE, "train_pos");       5net_id=op_topo_parent(op_topo_parent(op_id_self ()));   J                     
   ����   
          pr_state         �   �          
   idle   
                                       ����             pr_state        �   �          
   esys   
       J          Ztrain_pos = (Ertms_Train_Pos*) op_prg_mem_alloc (sizeof (Ertms_Train_Pos) * MAX_NB_TRAIN);       8op_esys_interface_value_get(inf_nb_train, &nb_train, 0);   5op_esys_interface_value_get(inf_test, &train_pos, 0);       "printf("Positions %d\n",nb_train);       *const int nb = min(nb_train,MAX_NB_TRAIN);   for(int i=0;i<nb;i++) {   Z	const Objid node_objid=op_id_from_name (net_id, OPC_OBJTYPE_NODE_MOB, train_pos[i].name);   	printTrainPos(train_pos+i);   	showNodePos(node_objid);   G	op_ima_obj_attr_set_dbl (node_objid, "x position", train_pos[i].posx);   G	op_ima_obj_attr_set_dbl (node_objid, "y position", train_pos[i].posy);   }       op_prg_mem_free(train_pos);       J                         ����             pr_state                     �   �      k   �   �   �          
   tr_4   
       ����          ����          
    ����   
          ����                       pr_transition              ,   �      �   �   �   �     �          
   tr_8   
       
   ESYS   
       ����          
    ����   
          ����                       pr_transition      	        Q   �        �   �   �          
   tr_9   
       ����          ����          
    ����   
          ����                       pr_transition               �   K      �   �   �   b   �   T   �   �          
   tr_11   
       
   default   
       ����          
    ����   
          ����                       pr_transition                   End-to-End Delay (seconds)          FEnd-to-end delay of packets received by the traffic sink in this node.   Traffic Sink    bucket/default total/sample mean   linear        ԲI�%��}   Traffic Received (bits)          <Traffic received (in bits) by the traffic sink in this node.   Traffic Sink   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (bits/sec)          @Traffic received (in bits/sec) by the traffic sink in this node.   Traffic Sink   bucket/default total/sum_time   linear        ԲI�%��}   Traffic Received (packets)          ?Traffic received (in packets) by the traffic sink in this node.   Traffic Sink   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (packets/sec)          CTraffic received (in packets/sec) by the traffic sink in this node.   Traffic Sink   bucket/default total/sum_time   linear        ԲI�%��}      End-to-End Delay (seconds)          GEnd-to-end delay of packets received by traffic sinks across all nodes.   Traffic Sink    bucket/default total/sample mean   linear        ԲI�%��}   Traffic Received (bits)          ATraffic received (in bits) by the traffic sinks across all nodes.   Traffic Sink   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (bits/sec)          ETraffic received (in bits/sec) by the traffic sinks across all nodes.   Traffic Sink   bucket/default total/sum_time   linear        ԲI�%��}   Traffic Received (packets)          DTraffic received (in packets) by the traffic sinks across all nodes.   Traffic Sink   bucket/default total/sum   linear        ԲI�%��}   Traffic Received (packets/sec)          HTraffic received (in packets/sec) by the traffic sinks across all nodes.   Traffic Sink   bucket/default total/sum_time   linear        ԲI�%��}                  General Process Description:    ----------------------------    zThe sink process model accepts packets from any number of sources and discards them regardless of their content or format.       ICI Interfaces:    --------------    None        Packet Formats:    ---------------    None        Statistic Wires:    ----------------    None        Process Registry:    -----------------    Not Applicable       Restrictions:    -------------    None        