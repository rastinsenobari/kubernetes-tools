#!/bin/bash

help(){
	echo ""
    echo "   delet all elements from an object in kubernetes"
	echo "   Try:  ./kda.sh [object] -> pod, service, etc..."
	echo ""
	echo "  Options:"
	echo "       -n  --namespace: for define namespace"
	echo ""
}


namespace="default"

# define object
if [ $# -gt 0 ] && [ $1 != "--help" ] && [ $1 != "-h" ]; then 
	object=$1
	shift
fi
#check object
if [ -z $object ]; then 
	echo "Error: You have not specified object" &&
	help && exit 1
fi

#check options
while [[ "$#" -gt 0 ]]; do
	case "$1" in
		-h|--help)
			help
			exit 0
		;;
		-n|--namespace)
			shift 
			namespace=$1
			shift
			if [ -z $namespace ]; then 
				echo "Error: You have not specified namespace" &&
				help && exit 1
			fi
		;;
		*)
			echo "Error: Unknown option $1">&2
			help
			exit 1
			;;		
	esac
done

#run the command
kubectl get "${object}" -n "${namespace}"| tail -n +2 | cut -f1 -d" " |xargs kubectl delete "$object" -n "${namespace}"