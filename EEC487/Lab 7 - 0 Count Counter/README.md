# Lab 7 - 0 Count Counter

We got points off on this lab for this little ditty right here:

```VHDL
VARIABLE sum : unsigned(3 DOWNTO 0);
BEGIN 
sum := (others=>'0'); -- initial value
	IF (start = '1' and tick = '1' and clk = '1' and clk'event) THEN 
	FOR i IN 9 DOWNTO 0 LOOP
		IF a(i) = '0' THEN 
			sum := sum + 1;
		END IF;
	END LOOP;
END IF; 
```

Misinterpreted the lab - the point was to use the states to count the 0's in the input. Apparently that block of code makes using states at all a bit pointless.

Allegedly you'd achieve this by having a loop in the counting state that moves along the input vector that works kinda like this:

```
while(!doneCounting){

	count_switch(i);

	if(!end_of_switches){
		doneCounting = true;
		break;
	}
}
```

Instead of a for loop, which I've been told are resource heavy in VHDL.

I'm also pretty sure the "reset" state in this lab is a bit unnecessary.
