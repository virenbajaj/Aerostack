#!/bin/bash

NUMID_DRONE=$1
NETWORK_ROSCORE=$2
DRONE_IP=$3
DRONE_WCHANNEL=$4
# http://stackoverflow.com/questions/6482377/bash-shell-script-check-input-argument
if [ -z $NETWORK_ROSCORE ] # Check if NETWORK_ROSCORE is NULL
  then
  	#Argument 2 is empty
	. ${DRONE_STACK}/setup.sh
    	OPEN_ROSCORE=1
  else
    	. ${DRONE_STACK}/setup.sh $2
fi
if [ -z $NUMID_DRONE ] # Check if NUMID_DRONE is NULL
  then
  	#Argument 1 empty
    	echo "-Setting droneId = 0"
    	NUMID_DRONE=0
  else
    	echo "-Setting droneId = $0"
fi
if [ -z $DRONE_IP ] # Check if NUMID_DRONE is NULL
  then
  	#Argument 3 is empty
    	echo "-Setting droneIp = 192.168.0.40"
    	DRONE_IP=192.168.0.10
  else
    	echo "-Setting droneIp = $3"
fi
if [ -z $DRONE_WCHANNEL ] # Check if NUMID_DRONE is NULL
  then
  	#Argument 4 is empty
    	echo "-Setting droneChannel = 6"
    	DRONE_WCHANNEL=6
  else
    	echo "-Setting droneChannel = $4"
fi


#{
#echo ./set_IP_Ch.sh $DRONE_IP $DRONE_WCHANNEL
#echo exit
#} | telnet 192.168.1.1
#	--tab --title "Ardrone_Autonomy"	--command "bash -c \"
#roslaunch ./ardrone_launch/ardrone_indoors.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_ip:=$DRONE_IP;
#						exec bash\""  \

  

#gnome-terminal  --full-screen  \
gnome-terminal  \
	--tab --title "Pelican Node"	--command "bash -c \"
roslaunch  ${DRONE_STACK}/launchers/pelican_launchers/launch_files/asctec_driver_node.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} owner_mac:=84:A6:C8:4E:DE:3C;
						exec bash\""  \
	--tab --title "Driver Pelican"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/driverPelicanROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "PX4flow"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/px4flow.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "PX4flow Interface"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/driver_px4flow_interface_ROSModule_okto.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "Lider Lite"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/laser_altimeter.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "Drone Midlevel Controller"	--command "bash -c \"
roslaunch droneMidLevelAutopilotROSModule droneMidLevelAutopilotROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "Drone State Estimator"	--command "bash -c \"
roslaunch droneEKFStateEstimatorROSModule droneEKFStateEstimatorROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "Drone Trajectory Controller"	--command "bash -c \"
roslaunch droneTrajectoryControllerROSModule droneTrajectoryControllerROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} drone_estimated_pose_topic_name:=ArucoSlam_EstimatedPose drone_estimated_speeds_topic_name:=ArucoSlam_EstimatedSpeeds;
						exec bash\""  \
	--tab --title "Ueye Camera"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/ueye_cvg_cam.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} camera_id_num:=3 camera_name_str:="front" config_file:="small_camera_RGB24_HUB.ini";
						exec bash\""  \
	--tab --title "ArucoEye" --command "bash -c \"
roslaunch droneArucoEyeROSModule droneArucoEyeROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} camera_calibration_file:="front.yaml" drone_image_topic_name:="camera/front/image_raw" camera_number:="0";
						exec bash\""  \
	--tab --title "Visual Marker Localizer" --command "bash -c \"
roslaunch droneVisualMarkersLocalizerROSModule droneVisualMarkersLocalizerROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\"" \
	--tab --title "Obstacle Processor" --command "bash -c \"
roslaunch droneObstacleProcessorVisualMarksROSModule droneObstacleProcessor2dVisualMarksROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""   \
	--tab --title "Obstacle Distance Calculator" --command "bash -c \"
roslaunch droneObstacleDistanceCalculatorROSModule droneObstacleDistanceCalculationROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} drone_pose_topic_name:=ArucoSlam_EstimatedPose;
						exec bash\""   \
	--tab --title "Trajectory Planner" --command "bash -c \"
roslaunch droneTrajectoryPlannerROSModule droneTrajectoryPlanner2dROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} drone_pose_topic_name:=ArucoSlam_EstimatedPose;
						exec bash\""  \
	--tab --title "Yaw Commander" --command "bash -c \"
roslaunch droneYawCommanderROSModule droneYawCommanderROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} drone_pose_topic_name:=ArucoSlam_EstimatedPose;
						exec bash\""  \
	--tab --title "sound_play" --command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/sound_play.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "DroneSpeechModule" --command "bash -c \"
roslaunch droneSpeechROSModule droneSpeechROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} voice:=voice_el_diphone;
						exec bash\""  \
	--tab --title "DroneSoundModule" --command "bash -c \"
roslaunch droneSoundROSModule droneSoundROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "DroneCommunicationManager" --command "bash -c \"
roslaunch droneCommunicationManagerROSModule droneCommunicationManagerROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "DroneSupervisor"	--command "bash -c \"
roslaunch performance_monitor performance_monitor.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\"" \
	--tab --title "DroneManagerofActions" --command "bash -c \"
roslaunch droneManagerOfActionsROSModule droneManagerOfActionsROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\""  \
	--tab --title "DroneMissionScheduler" --command "bash -c \"
roslaunch droneMissionScheduleProcessorROSModule droneMissionSheduleProcessorROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK} drone_Estimated_Pose_Topic_Name:=ArucoSlam_EstimatedPose mission_config_file:=missionSchedule.xml;
						exec bash\"" &
						

gnome-terminal  \
	--tab --title "DroneInterface"	--command "bash -c \"
roslaunch ${DRONE_STACK}/launchers/pelican_launchers/launch_files/droneInterface_jp_ROSModule.launch --wait drone_id_namespace:=drone$NUMID_DRONE drone_id_int:=$NUMID_DRONE my_stack_directory:=${DRONE_STACK};
						exec bash\"" &


# rosrun ardrone_autonomy ardrone_driver;
# gnome-terminal  --window --full-screen  \ # window part opens an unused tab

#						env sleep 13s ;
#						rosrun parrotController parrotController _droneId:=1; 
# ./ardrone_launchfiles/ardrone_indoors.launch
# ./+ardrone_launchfiles/ardrone_indoors_maclock.launch
