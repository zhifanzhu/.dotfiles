function dependent_run
	set pid $argv[1]
    set cmd $argv[2]
    set wait $argv[3]
	while kill -0 $pid 2> /dev/null;
		set time (date)
		echo "At $time, process is still running, sleep..."
		sleep $wait
    end
	echo "Now run command:"
	echo $cmd
	echo ""
	eval $cmd
end
