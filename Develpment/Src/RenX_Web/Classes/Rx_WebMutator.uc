class Rx_WebMutator extends Rx_Mutator;

function PreBeginPlay()
{
	super.PreBeginPlay();

    Spawn(class'Rx_WebServer'); 
}
