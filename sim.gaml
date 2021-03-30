/**
* Name: NewModel
* A coronavirus simulation. 
* Author: shervin-the-prodigy
* Tags: 
*/


model CovidSimulation

/* Insert your model definition here */

global{
	int num_of_people <- 50;
	int num_of_corona <- 2;	
	
	init{
		create people number:num_of_people;
		create covid number:num_of_corona;
	}
}

species people skills:[moving]{
	bool is_infected <- false;
	int infect_range <- 5;
	
	reflex moving{
		do wander;
	}
	
	aspect base{
		draw circle(2) color: (is_infected) ? #red : #green;
	}
	
	reflex infect_people when: !empty(people at_distance infect_range){
		ask people at_distance infect_range{
			if(self.is_infected){
				myself.is_infected <- true;
			}
			else if(myself.is_infected){
				self.is_infected <- true;
			}
		}
	}
	
}

species covid skills:[moving]{
	bool is_infected <- true;
	int infect_range <- 5;
	
	reflex moving{
		do wander;
	}
	
	reflex attack when: !empty(people at_distance infect_range){
		ask people at_distance infect_range{
			if(self.is_infected){
				myself.is_infected <- true;
			}
			else if(myself.is_infected){
				self.is_infected <- true;
			}
		}
	}
	
	aspect base{
		draw circle(1) color: (is_infected) ? #red : #green;
	}
	
}

experiment my_experiment type:gui{
	parameter "number of people:" var: num_of_people; 
	parameter "number of viruses" var: num_of_corona;
	
	output{
		display my_display{
			species people aspect:base;
			species covid aspect:base;
			
		}
		display my_chart{
			chart "number of people with covid"{
				data "infected people" value: length (people where (each.is_infected = true));
			}
		}
	}
}
