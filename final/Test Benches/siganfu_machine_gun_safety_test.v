`timescale 1ms / 100ns
`include "siganfu_machine_gun.v"

module siganfu_machine_gun_safety_test;
	reg target_locked = 0,
	fire_command = 0,
	firing_mode = 0,
	overheat_sensor = 0,
	is_enemy = 0,
	sysclk = 0,
	reboot = 0;

	// Outputs
	wire [2:0] current_state;
	wire  criticality_alert;
	wire  fire_trigger;

	siganfu_machine_gun uut(.target_locked(target_locked),
		.fire_command(fire_command),
		.firing_mode(firing_mode),
		.overheat_sensor(overheat_sensor),
		.is_enemy(is_enemy),
		.sysclk(sysclk),
		.reboot(reboot),
		.current_state(current_state),
		.criticality_alert(criticality_alert),
		.fire_trigger(fire_trigger)
		);

	parameter TIME_FOR_25_ROUNDS = 250;
	parameter TIME_FOR_10_ROUNDS = 100;
	parameter TIME_FOR_15_ROUNDS = 150;
	parameter TIME_FOR_RELOAD = 50;
	parameter TIME_FOR_COOLDOWN = 100;
	parameter HALF_CLOCK_CYCLE = 5;
	parameter TEST_WAIT = 30; 
	parameter REBOOT_WAIT = 3;

	initial begin
		$dumpfile("smg.vcd");
		$dumpvars;
		forever begin
			#HALF_CLOCK_CYCLE sysclk=~sysclk;
		end
	end

	initial begin
		// Reboot the system
		reboot = 1;
		is_enemy = 0; target_locked = 0; fire_command = 0; firing_mode = 0; overheat_sensor = 0; // All inputs LOW
		#REBOOT_WAIT;
		reboot = 0;

		// Test safety: it should not shoot unless all conditions satisfied

		// Test 1: Test target not locked
		is_enemy = 1; target_locked = 0; fire_command = 1; firing_mode = 0;
		#TEST_WAIT;
		firing_mode = 1;
		#TEST_WAIT;

		// Test 2: Test target not enemy
		is_enemy = 0; target_locked = 1; fire_command = 1; firing_mode = 0;
		#TEST_WAIT;
	    firing_mode = 1;
		#TEST_WAIT;

		// Test 3: Test fire command not issued
		is_enemy = 1; target_locked = 1; fire_command = 0; firing_mode = 0;
		#TEST_WAIT;
	    firing_mode = 1;
		#TEST_WAIT;

		// Test 4: Test single shooting when all conditions satisfied
		is_enemy = 1; target_locked = 1; fire_command = 1; firing_mode = 0;
		#TEST_WAIT;
		// Release the trigger to return to idle
		fire_command = 0;
		#TEST_WAIT;
		$finish;
	end
endmodule
