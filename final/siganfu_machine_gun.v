`timescale 1ms / 100ns

module siganfu_machine_gun (
	input sysclk, // done
	input reboot, // done
	input target_locked, 
	input is_enemy,
	input fire_command,
	input firing_mode, // 0 single, 1 auto
	input overheat_sensor,
	output reg [2:0] current_state,
	output reg criticality_alert,
	output reg fire_trigger
);

    reg [2:0] next_st;

	parameter s0 = 3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b011, s4 = 3'b100, s5 = 3'b101;
	integer number_of_bullets,number_of_magazines;


	always @(posedge sysclk or reboot) begin
		if(reboot) begin
			current_state <= s0;
			number_of_bullets = 25;
			number_of_magazines = 3;
			criticality_alert = 1'b0;
			fire_trigger = 1'b0;
			shooted = 1'b0;
		end else
			current_state <= next_st;
	end

	integer shooted;

	always @(current_state or target_locked or is_enemy or fire_command or fire_command or overheat_sensor or sysclk) begin

		case(current_state)
			s0: 
				begin
					if(is_enemy && target_locked && fire_command) begin
						if (firing_mode)
							next_st = s2;
						else
							next_st = s1;
					end else
						next_st = s0;
				end
			s1:
				begin
					if(overheat_sensor)
						next_st = s4;
					else if(number_of_bullets) begin

						if(fire_command) begin
							if (is_enemy & target_locked & (~shooted)) begin
								number_of_bullets = number_of_bullets - 1;
								fire_trigger = 1'b1; #5 
								fire_trigger = 1'b0;
								shooted = 1;
							end
							next_st = 1;
						end 
						else begin
							shooted = 1'b0;
							next_st = s0; 	
						end
					end else begin
						shooted = 1'b0;
						if (number_of_magazines)
							next_st = s3;
						else
							next_st = s5;
					end
					
				end
			s2:
			begin
				if(overheat_sensor)
					next_st = s4;
				else begin
					// if we have any bullet
					if(number_of_bullets) begin
						if(is_enemy & target_locked & fire_command)begin
							number_of_bullets = number_of_bullets - 1;
							fire_trigger = 1'b1; #5 
							fire_trigger = 1'b0;

							if(number_of_bullets)
								next_st = s2;
							else begin
								if(number_of_magazines)
									next_st = s3;
								else
									next_st = s5;
							end

						end else
							next_st = s0;
					end else begin //if we are out of bullets
							// if we have any magazine
							if(number_of_magazines)
								next_st = s3; // go to RELOAD
							else // if we have no magazine left
								next_st = s5;// go to DOWNFALL
					end
				end
			end
			s3:
			begin

				#40

				number_of_bullets = 25;
				number_of_magazines = number_of_magazines - 1;
				if (!number_of_magazines)
					criticality_alert = 1;
				
				#10

				if(is_enemy && target_locked && fire_command) begin
					if(firing_mode)
						next_st = s2;
					else 
						next_st = s1;
				end else
					next_st = s0;
				
				#0;

			end
			s4:
			begin
				#100

				if(number_of_bullets) begin
					if(is_enemy && target_locked && fire_command) begin
						if(firing_mode)
							next_st = s2;
						else
							next_st = s1;
					end else
						next_st = s0;
				end else begin
					if(number_of_magazines)
						next_st = s3;
					else 
						next_st = s5;
				end

				#0;
			end
			s5:
			begin
				if(reboot)
					next_st = s0;
				else
					next_st = s5;
			end
			default:  next_st = current_state;
		endcase
	end	
endmodule
